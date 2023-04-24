#!/bin/bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

#--------------------------------#
# import variables and functions #
#--------------------------------#
source global_fn.sh

#----------------------#
# prepare package list #
#----------------------#
cat custom_hypr.lst custom_main.lst custom_zsh.lst > install_pkg.lst


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


#-------------------------------#
# install packages from my list #
#-------------------------------#
./install_pkg.sh install_pkg.lst
#./install_pkg.sh custom_app.lst
#./install_fpk.sh


#-------------------------------------#
# cheanup other xdg-* packages if any #
#-------------------------------------#
#if pkg_installed xdg-desktop-portal-kde
#then
#    sudo pacman -Rnsdd xdg-desktop-portal-kde
#fi
#
#if pkg_installed xdg-desktop-portal-gnome
#then
#    sudo pacman -Rns xdg-desktop-portal-gnome
#fi
#
#if pkg_installed xdg-desktop-portal-wlr
#then
#    sudo pacman -Rns xdg-desktop-portal-wlr
#fi


#---------------------------#
# restore my custom configs #
#---------------------------#
./restore_fnt.sh
./restore_cfg.sh
./restore_sgz.sh
#./restore_app.sh


#------------------------#
# enable system services #
#------------------------#
service_ctl NetworkManager
service_ctl bluetooth
service_ctl sddm

