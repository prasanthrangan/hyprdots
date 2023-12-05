#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

#--------------------------------#
# import variables and functions #
#--------------------------------#
source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi


#----------------------#
# prepare package list #
#----------------------#
cp custom_hypr.lst install_pkg.lst

if [ -f "$1" ] && [ ! -z "$1" ] ; then
    cat $1 >> install_pkg.lst
fi


#--------------------------------#
# add nvidia drivers to the list #
#--------------------------------#
if [ `lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l` -gt 0 ] ; then

    cat /usr/lib/modules/*/pkgbase | while read krnl
    do
        echo "${krnl}-headers" >> install_pkg.lst
    done

    echo -e "nvidia-dkms\nnvidia-utils" >> install_pkg.lst
    sed -i "s/^hyprland-git/hyprland-nvidia-git/g" install_pkg.lst

else
    echo "nvidia card not detected, skipping nvidia drivers..."
fi


#--------------------------------#
# install packages from the list #
#--------------------------------#
./install_pkg.sh install_pkg.lst


#---------------------------#
# restore my custom configs #
#---------------------------#
./restore_fnt.sh
./restore_cfg.sh
./restore_sgz.sh


#------------------------#
# enable system services #
#------------------------#
service_ctl NetworkManager
service_ctl bluetooth
service_ctl sddm

