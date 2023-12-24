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

