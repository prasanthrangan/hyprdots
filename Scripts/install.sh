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
    if nvidia_detect; then
        cat /usr/lib/modules/*/pkgbase | while read krnl; do
            echo "${krnl}-headers" >>install_pkg.lst
        done
        IFS=$' ' read -r -d '' -a nvga < <(lspci -k | grep -E "(VGA|3D)" | grep -i nvidia | awk -F ':' '{print $NF}' | tr -d '[]()' && printf '\0')
        for nvcode in "${nvga[@]}"; do
            awk -F '|' -v nvc="${nvcode}" '{if ($3 == nvc) {split(FILENAME,driver,"/"); print driver[length(driver)],"\nnvidia-utils"}}' .nvidia/nvidia*dkms >>install_pkg.lst
        done
        echo -e "\033[0;32m[GPU]\033[0m: detected // ${nvga[@]}"
    else
        echo "nvidia card not detected, skipping nvidia drivers..."
    fi

#########################################################

        nvidia_pkg=(
          nvidia-dkms
          nvidia-settings
          nvidia-utils
          libva
          libva-nvidia-driver-git
        )
        
        ## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
        # Determine the directory where the script is located
        SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        
        # Change the working directory to the parent directory of the script
        PARENT_DIR="$SCRIPT_DIR/.."
        cd "$PARENT_DIR" || exit 1
        
        source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"
        
        # Install additional Nvidia packages
        printf "${YELLOW} Installing addition Nvidia packages...\n"
        for krnl in $(cat /usr/lib/modules/*/pkgbase); do
          for NVIDIA in "${krnl}-headers" "${nvidia_pkg[@]}"; do
            install_package "$NVIDIA" 2>&1 | tee -a "$LOG"
          done
        done
        
        # Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
        if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
          echo "Nvidia modules already included in /etc/mkinitcpio.conf" 2>&1 | tee -a "$LOG"
        else
          sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf 2>&1 | tee -a "$LOG"
          echo "Nvidia modules added in /etc/mkinitcpio.conf"
        fi
        
        sudo mkinitcpio -P 2>&1 | tee -a "$LOG"
        printf "\n\n\n"
        
        # Additional Nvidia steps
        NVEA="/etc/modprobe.d/nvidia.conf"
        if [ -f "$NVEA" ]; then
          printf "${OK} Seems like nvidia-drm modeset=1 is already added in your system..moving on.\n"
          printf "\n"
        else
          printf "\n"
          printf "${YELLOW} Adding options to $NVEA..."
          sudo echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf 2>&1 | tee -a "$LOG"
          printf "\n"
        fi
        
        # Blacklist nouveau
            if [[ -z $blacklist_nouveau ]]; then
              read -n1 -rep "${CAT} Would you like to blacklist nouveau? (y/n)" blacklist_nouveau
            fi
        echo
        if [[ $blacklist_nouveau =~ ^[Yy]$ ]]; then
          NOUVEAU="/etc/modprobe.d/nouveau.conf"
          if [ -f "$NOUVEAU" ]; then
            printf "${OK} Seems like nouveau is already blacklisted..moving on.\n"
          else
            printf "\n"
            echo "blacklist nouveau" | sudo tee -a "$NOUVEAU" 2>&1 | tee -a "$LOG"
            printf "${NOTE} has been added to $NOUVEAU.\n"
            printf "\n"
        
            # To completely blacklist nouveau (See wiki.archlinux.org/title/Kernel_module#Blacklisting 6.1)
            if [ -f "/etc/modprobe.d/blacklist.conf" ]; then
              echo "install nouveau /bin/true" | sudo tee -a "/etc/modprobe.d/blacklist.conf" 2>&1 | tee -a "$LOG"
            else
              echo "install nouveau /bin/true" | sudo tee "/etc/modprobe.d/blacklist.conf" 2>&1 | tee -a "$LOG"
            fi
          fi
        else
          printf "${NOTE} Skipping nouveau blacklisting.\n" 2>&1 | tee -a "$LOG"
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

