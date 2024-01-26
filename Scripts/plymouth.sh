#!/bin/bash

# Function to install packages using yay
install_packages() {
    yay -S $@
}

# Function to set Plymouth default theme
set_plymouth_theme() {
    sudo plymouth-set-default-theme $1
}

# Function to add Plymouth to HOOKS in mkinitcpio.conf
add_plymouth_to_hooks() {
    local mkinitcpio_file="/etc/mkinitcpio.conf"
    
    # Check if 'plymouth' is already in HOOKS
    if grep -q 'plymouth' $mkinitcpio_file; then
        echo "'plymouth' already present in HOOKS"
    else
        # Find 'systemd' and insert 'plymouth' next to it
        sed -i '/^HOOKS=/ s/\(.*systemd.*\)/\1 plymouth/' $mkinitcpio_file
        echo "Added 'plymouth' to HOOKS in $mkinitcpio_file"
    fi
}

# Function to prompt user for Plymouth theme
prompt_for_theme() {
    local themes=("gbrt (BIOS theme)" "arch linux" "legion" "lion" "owl")
    local theme_options=$( (IFS=,; echo "${themes[*]}") )
    
    echo "Choose a Plymouth theme:"
    select theme in $theme_options; do
        case $theme in
            "gbrt (BIOS theme)" | "arch linux" | "legion" | "optimus" | "owl")
                install_packages "plymouth" "plymouth-theme-$theme"
                set_plymouth_theme $theme
                echo "Installed and set Plymouth theme: $theme"
                break
                ;;
            *)
                echo "Invalid choice. Please select a valid theme."
                ;;
        esac
    done
}

# Function to add kernel options to /boot/loader/entries/linux.conf
add_kernel_options() {
    local linux_conf="/boot/loader/entries/linux.conf"
    local kernel_options="quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"
    
    # Check if kernel options are already present
    if grep -q "$kernel_options" $linux_conf; then
        echo "Kernel options already present in $linux_conf"
    else
        # Append kernel options to the options line
        sed -i "/^options/ s/$/ $kernel_options/" $linux_conf
        echo "Added kernel options to $linux_conf"
    fi
}

# Prompt user for Plymouth theme and install it
prompt_for_theme

# Add Plymouth to HOOKS in mkinitcpio.conf
add_plymouth_to_hooks

# Add kernel options to /boot/loader/entries/linux.conf
add_kernel_options

echo "PlymouthInstallation completed."
