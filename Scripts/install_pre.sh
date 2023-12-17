#!/bin/bash
#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Script to apply pre install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                     |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi


# grub
if pkg_installed grub
    then

    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]
        then
        echo "configuring grub..."
        sudo cp /etc/default/grub /etc/default/grub.t2.bkp
        sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

        if nvidia_detect
            then
            echo "nvidia detected, setting nvidia_drm.modeset=1 in grub..."
            gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
            sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub
        fi

        read -p "Apply grub theme? [Y/N] : " grubtheme
        case $grubtheme in
        Y|y) echo -e "Setting grub theme..."
            sudo tar -xzf ${CloneDir}/Source/arcs/Grub_Pochita.tar.gz -C /usr/share/grub/themes/
            sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
            /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1280x1024x32,auto
            /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/pochita/theme.txt\"
            /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub ;;
        *) echo -e "Skippinng grub theme..." 
            sudo sed -i "s/^GRUB_THEME=/#GRUB_THEME=/g" /etc/default/grub ;;
        esac

        sudo grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo "grub is already configured..."
    fi

else
    echo "WARNING: grub is not installed..."
fi


# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]
    then

    echo "adding extra spice to pacman..."
    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf

    #if [ $(grep -w "^\[xero_hypr\]" /etc/pacman.conf | wc -l) -eq 0 ] && [ $(grep "https://repos.xerolinux.xyz/xero_hypr/x86_64/" /etc/pacman.conf | wc -l) -eq 0 ]
    #    then
    #    echo "adding [xero_hypr] repo to pacman..."
    #    echo -e "\n[xero_hypr]\nSigLevel = Required DatabaseOptional\nServer = https://repos.xerolinux.xyz/xero_hypr/x86_64/\n\n" | sudo tee -a /etc/pacman.conf
    #fi
    sudo pacman -Syyu

else
    echo "pacman is already configured..."
fi

