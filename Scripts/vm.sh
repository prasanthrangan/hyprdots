#!/bin/bash
#  _  ____     ____  __  
# | |/ /\ \   / /  \/  | 
# | ' /  \ \ / /| |\/| | 
# | . \   \ V / | |  | | 
# |_|\_\   \_/  |_|  |_| 
#                        
# by 5ouls3edge (2024)
# ----------------------------------------------------- 
# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------
read -p "Do you want to start virtual machine setup? (Enter 'y' for yes, 'n' for no): " s
echo "STARTING THE INSTALLATION KVM/QEMU/VIRT MANAGER..."
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
# Prompt user for their username
read -p "Enter your username: " username

# Uncomment and update user configuration in qemu.conf
if grep -q "^#user = " /etc/libvirt/qemu.conf; then
    sudo sed -i "s/^#\(user = .*\)/\1/" /etc/libvirt/qemu.conf
fi

# Add or update user configuration in qemu.conf
if grep -q "^user = " /etc/libvirt/qemu.conf; then
    sudo sed -i "s/^user = .*/user = \"$username\"/" /etc/libvirt/qemu.conf
else
    echo "user = \"$username\"" | sudo tee -a /etc/libvirt/qemu.conf
fi

# Uncomment and update group configuration in qemu.conf
if grep -q "^#group = " /etc/libvirt/qemu.conf; then
    sudo sed -i "s/^#\(group = .*\)/\1/" /etc/libvirt/qemu.conf
fi

# Add or update group configuration in qemu.conf
if grep -q "^group = " /etc/libvirt/qemu.conf; then
    sudo sed -i "s/^group = .*/group = \"$username\"/" /etc/libvirt/qemu.conf
else
    echo "group = \"$username\"" | sudo tee -a /etc/libvirt/qemu.conf
fi

# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
sudo systemctl restart libvirtd
# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
sudo virsh net-autostart default
echo "Please restart your system with reboot."
