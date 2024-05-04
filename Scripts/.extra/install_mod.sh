#!/usr/bin/env bash
#|---/ /+-----------------------------------------------+---/ /|#
#|--/ /-| Script to enable early loading for nvidia drm |--/ /-|#
#|-/ /--| Prasanth Rangan                               |-/ /--|#
#|/ /---+-----------------------------------------------+/ /---|#

#
#? add nvidia variables to 'modprobe'
#
modprobe_opts() {
  if [ $(grep 'options nvidia-drm modeset=1' /etc/modprobe.d/nvidia.conf | wc -l) -eq 0 ]; then
    echo 'options nvidia-drm modeset=1' | sudo tee -a /etc/modprobe.d/nvidia.conf
  fi
}

#
#? check what program generates the 'initramfs'
# mkinitcpio: in case of vanilla Arch & other distributions using it
# dracut    : in case of EndeavourOS & other distributions using it
#
if [ $(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l) -gt 0 ]; then
  if [ $(grep 'MODULES=' /etc/mkinitcpio.conf | grep nvidia | wc -l) -eq 0 ]; then
    if [ -x "$(command -v dracut)" ]; then
      if [ ! -f /etc/dracut.conf.d/nvidia.conf ]; then
        # WARN: spaces after & before the douple quotations are important & left intensionally
        echo 'force_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "' | sudo tee -a /etc/dracut.conf.d/nvidia.conf
        sudo dracut-rebuild
        modprobe_opts
      fi
    else
      sudo sed -i "/MODULES=/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf
      sudo mkinitcpio -P
      modprobe_opts
    fi
  fi
fi
