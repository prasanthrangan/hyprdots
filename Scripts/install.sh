#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

cat <<"EOF"

-----------------------------------------------------------------
        .                                                     
       / \         _       _  _                  _     _      
      /^  \      _| |_    | || |_  _ _ __ _ _ __| |___| |_ ___
     /  _  \    |_   _|   | __ | || | '_ \ '_/ _` / _ \  _(_-<
    /  | | ~\     |_|     |_||_|\_, | .__/_| \__,_\___/\__/__/
   /.-'   '-.\                  |__/|_|                       

-----------------------------------------------------------------

EOF


#--------------------------------#
# import variables and functions #
#--------------------------------#
source global_fn.sh
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi


#------------------#
# evaluate options #
#------------------#
flg_Install=0
flg_Restore=0
flg_Service=0

while getopts idrs RunStep; do
    case $RunStep in
    i)  flg_Install=1 ;;
    d)  flg_Install=1
        export use_default="--noconfirm" ;;
    r)  flg_Restore=1 ;;
    s)  flg_Service=1 ;;
    *)  echo "...valid options are..."
        echo "i : [i]nstall hyprland without configs"
        echo "d : install hyprland [d]efaults without configs --noconfirm"
        echo "r : [r]estore config files"
        echo "s : enable system [s]ervices"
        exit 1 ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    flg_Install=1
    flg_Restore=1
    flg_Service=1
fi


#--------------------#
# pre-install script #
#--------------------#
if [ $flg_Install -eq 1 ] && [ $flg_Restore -eq 1 ]; then
    cat <<"EOF"
                _         _       _ _ 
 ___ ___ ___   |_|___ ___| |_ ___| | |
| . |  _| -_|  | |   |_ -|  _| .'| | |
|  _|_| |___|  |_|_|_|___|_| |__,|_|_|
|_|                                   

EOF

    ./install_pre.sh
fi


#------------#
# installing #
#------------#
if [ $flg_Install -eq 1 ]; then
    cat <<"EOF"

 _         _       _ _ _         
|_|___ ___| |_ ___| | |_|___ ___ 
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

EOF

#----------------------#
# prepare package list #
#----------------------#
shift $((OPTIND - 1))
cust_pkg=$1
cp custom_hypr.lst install_pkg.lst

if [ -f "$cust_pkg" ] && [ ! -z "$cust_pkg" ]; then
cat $cust_pkg >>install_pkg.lst
fi

#-----------------------#
# add shell to the list #
#-----------------------#
if ! pkg_installed zsh && ! pkg_installed fish ; then
echo -e "Select shell:\n1) zsh\n2) fish"
read -p "Enter option number : " gsh

case $gsh in
1) export getShell="zsh" ;;
2) export getShell="fish" ;;
*) echo -e "...Invalid option selected..."
    exit 1 ;;
esac
echo "${getShell}" >>install_pkg.lst
fi

#--------------------------------#
# add nvidia drivers to the list #
#--------------------------------#

nvidia_pkg=(
  nvidia-dkms
  nvidia-settings
  nvidia-utils
  libva
  libva-nvidia-driver-git
)
        
hypr=(
  hyprland
)

# nvidia stuff
printf "Checking for other hyprland packages and remove if any..$(tput sgr0)\n"
if pacman -Qs hyprland > /dev/null; then
  printf "Hyprland detected. uninstalling to install Hyprland-git...$(tput sgr0)\n"
    for hyprnvi in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
    sudo pacman -R --noconfirm "$hyprnvi"
    done
fi

# Hyprland
        printf "$(tput setaf 3)[NOTE]$(tput sgr0) Installing Hyprland......\n"
   install_package "$HYPR"
   [ $? -ne 0 ] && { echo -e "\e[1A\e[K$HYPR install had failed, please check the install.log"; exit 1; }
  done

# Install additional Nvidia packages
for krnl in $(cat /usr/lib/modules/*/pkgbase); do
  for NVIDIA in "${krnl}-headers" "${nvidia_pkg[@]}"; do
    install_package "$NVIDIA"
  done
done

# Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
  echo "Nvidia modules already included in /etc/mkinitcpio.conf" 
else
  sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  echo "Nvidia modules added in /etc/mkinitcpio.conf"
fi

sudo mkinitcpio -P
printf "\n\n\n"

# Additional Nvidia steps
NVEA="/etc/modprobe.d/nvidia.conf"
if [ -f "$NVEA" ]; then
  printf "Seems like nvidia-drm modeset=1 is already added in your system..moving on.\n"
  printf "\n"
else
  printf "\n"
  printf "Adding options to $NVEA..."
  sudo echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
  printf "\n"
fi

# Blacklist nouveau
    if [[ -z $blacklist_nouveau ]]; then
      read -n1 -rep "$(tput setaf 6)[ACTION]$(tput sgr0) Would you like to blacklist nouveau? (y/n)" blacklist_nouveau
    fi
echo
if [[ $blacklist_nouveau =~ ^[Yy]$ ]]; then
  NOUVEAU="/etc/modprobe.d/nouveau.conf"
  if [ -f "$NOUVEAU" ]; then
    printf "Seems like nouveau is already blacklisted..moving on.\n"
  else
    printf "\n"
    echo "blacklist nouveau" | sudo tee -a "$NOUVEAU"
    printf "$(tput setaf 3)[NOTE]$(tput sgr0) has been added to $NOUVEAU.\n"
    printf "\n"

    # To completely blacklist nouveau (See wiki.archlinux.org/title/Kernel_module#Blacklisting 6.1)
    if [ -f "/etc/modprobe.d/blacklist.conf" ]; then
      echo "install nouveau /bin/true" | sudo tee -a "/etc/modprobe.d/blacklist.conf"
    else
      echo "install nouveau /bin/true" | sudo tee "/etc/modprobe.d/blacklist.conf"
    fi
  fi
else
  printf "$(tput setaf 3)[NOTE]$(tput sgr0) Skipping nouveau blacklisting.\n"
fi


    #--------------------------------#
    # install packages from the list #
    #--------------------------------#
    ./install_pkg.sh install_pkg.lst
    rm install_pkg.lst

fi


#---------------------------#
# restore my custom configs #
#---------------------------#
if [ $flg_Restore -eq 1 ]; then
    cat <<"EOF"

             _           _         
 ___ ___ ___| |_ ___ ___|_|___ ___ 
|  _| -_|_ -|  _| . |  _| |   | . |
|_| |___|___|_| |___|_| |_|_|_|_  |
                              |___|

EOF

    ./restore_fnt.sh
    ./restore_cfg.sh
fi


#---------------------#
# post-install script #
#---------------------#
if [ $flg_Install -eq 1 ] && [ $flg_Restore -eq 1 ]; then
    cat <<"EOF"

             _      _         _       _ _ 
 ___ ___ ___| |_   |_|___ ___| |_ ___| | |
| . | . |_ -|  _|  | |   |_ -|  _| .'| | |
|  _|___|___|_|    |_|_|_|___|_| |__,|_|_|
|_|                                       

EOF

    ./install_pst.sh
fi


#------------------------#
# enable system services #
#------------------------#
if [ $flg_Service -eq 1 ]; then
    cat <<"EOF"

                 _             
 ___ ___ ___ _ _|_|___ ___ ___ 
|_ -| -_|  _| | | |  _| -_|_ -|
|___|___|_|  \_/|_|___|___|___|

EOF

    while read service ; do
        service_ctl $service
    done < system_ctl.lst
fi

