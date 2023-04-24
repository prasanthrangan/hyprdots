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


#---------------------------#
# restore my custom configs #
#---------------------------#
./restore_fnt.sh
./restore_cfg.sh
./restore_sgz.sh
#./restore_app.sh


#----------------------------------------#
# enable early loding for nvidia modules #
#----------------------------------------#
#if [ `lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l` -gt 0 ] ; then
#    if [ `grep 'MODULES=' /etc/mkinitcpio.conf | grep nvidia | wc -l` -eq 0 ] ; then
#        if [ `grep 'options nvidia-drm modeset=1' /etc/modprobe.d/nvidia.conf | wc -l` -eq 0 ] ; then
#            echo 'options nvidia-drm modeset=1' | sudo tee -a /etc/modprobe.d/nvidia.conf
#        fi
#        sudo sed -i "/MODULES=/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf
#        sudo mkinitcpio -P
#    fi
#fi


#------------------------#
# enable system services #
#------------------------#
service_ctl NetworkManager
service_ctl bluetooth
service_ctl sddm


