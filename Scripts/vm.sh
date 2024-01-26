#!/bin/bash
#  _  ____     ____  __  
# | |/ /\ \   / /  \/  | 
# | ' /  \ \ / /| |\/| | 
# | . \   \ V / | |  | | 
# |_|\_\   \_/  |_|  |_| 
#                        
#  
# by Stephan Raabe (2023)
# modded by 5ouls3edge (2024)
# ----------------------------------------------------- 
# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------
read -p "Do you want to start? " s
echo "START KVM/QEMU/VIRT MANAGER INSTALLATION..."
# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
sudo pacman -S virt-manager virt-viewer qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm
# ------------------------------------------------------
# Edit libvirtd.conf
# ------------------------------------------------------
if grep -q '^#unix_sock_group = "libvirt"' /etc/libvirt/libvirtd.conf; then
    sudo sed -i 's/^#\(unix_sock_group = "libvirt"\)/\1/' /etc/libvirt/libvirtd.conf
fi

if grep -q '^#unix_sock_rw_perms = "0770"' /etc/libvirt/libvirtd.conf; then
    sudo sed -i 's/^#\(unix_sock_rw_perms = "0770"\)/\1/' /etc/libvirt/libvirtd.conf
fi

sudo tee -a /etc/libvirt/libvirtd.conf <<EOF
log_filters="3:qemu 1:libvirt"
log_outputs="2:file:/var/log/libvirt/libvirtd.log"
EOF
# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
sudo usermod -a -G kvm,libvirt $(whoami)
# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
# ------------------------------------------------------
# Edit qemu.conf
# ------------------------------------------------------
echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/qemu.conf"
echo "Uncomment and add your user name to user and group."
echo 'user = "your username"'
echo 'group = "your username"'
read -p "Press any key to open qemu.conf: " c
sudo vim /etc/libvirt/qemu.conf
# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
sudo systemctl restart libvirtd
# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
sudo virsh net-autostart default
echo "Please restart your system with reboot."
