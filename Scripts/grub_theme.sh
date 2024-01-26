#!/bin/bash
#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Script to apply pre install configs |--/ /-|#
#|-/ /--| 5ouls3dge                     |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

if pkg_installed grub && [ -f /boot/grub/grub.cfg ]
then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m: grub detected..."

    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]
    then
        echo -e "\033[0;32m[BOOTLOADER]\033[0m: configuring grub..."
        sudo cp /etc/default/grub /etc/default/grub.t2.bkp
        sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

        # List of available themes
        themes=("archlinux" "legion")

        echo "Available themes:"
        for ((i=0; i<${#themes[@]}; i++))
        do
            echo "$((i+1))) ${themes[i]}"
        done

        read -p "Select a theme number (1-${#themes[@]}): " theme_choice

        case $theme_choice in
            1) selected_theme="archlinux" ;;
            2) selected_theme="legion" ;;
            *) selected_theme="archlinux" ;; # Default to archlinux if an invalid choice is made
        esac

        read -p "Apply grub theme for $selected_theme? [Y/N] : " grubtheme

        case $grubtheme in
            Y|y) echo -e "\033[0;32m[BOOTLOADER]\033[0m: Setting grub theme..."
                sudo tar -xf ${CloneDir}/Source/arcs/${selected_theme}.tar -C /usr/share/grub/themes/
                sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
                /^GRUB_GFXMODE=/c\GRUB_GFXMODE=2560x1440x32,auto
                /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${selected_theme}/theme.txt\"
                /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub ;;
            *) echo -e "\033[0;32m[BOOTLOADER]\033[0m: Skipping grub theme..." 
                sudo sed -i "s/^GRUB_THEME=/#GRUB_THEME=/g" /etc/default/grub ;;
        esac

        sudo grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo -e "\033[0;32m[BOOTLOADER]\033[0m: grub is already configured..."
    fi

else
    echo -e "\033[0;33m[WARNING]\033[0m: grub is not configured..."
fi
