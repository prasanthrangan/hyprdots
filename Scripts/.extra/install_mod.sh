#!/usr/bin/env bash
#|---/ /+-----------------------------------------------+---/ /|#
#|--/ /-| Script to enable early loading for nvidia drm |--/ /-|#
#|-/ /--| Prasanth Rangan                               |-/ /--|#
#|/ /---+-----------------------------------------------+/ /---|#

if [ $(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l) -gt 0 ]; then
    if [ $(grep 'MODULES=' /etc/mkinitcpio.conf | grep nvidia | wc -l) -eq 0 ]; then
        sudo sed -i "/MODULES=/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf
        sudo mkinitcpio -P
        if [ $(grep 'options nvidia-drm modeset=1' /etc/modprobe.d/nvidia.conf | wc -l) -eq 0 ]; then
            echo 'options nvidia-drm modeset=1' | sudo tee -a /etc/modprobe.d/nvidia.conf
        fi
    fi
fi
