#!/usr/bin/env bash
#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Script to apply pre install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                     |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

# grub
if pkg_installed grub && [ -f /boot/grub/grub.cfg ]; then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m detected // grub"

    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]; then
        echo -e "\033[0;32m[BOOTLOADER]\033[0m configuring grub..."
        SUPER cp /etc/default/grub /etc/default/grub.t2.bkp
        SUPER cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

        if nvidia_detect; then
            echo -e "\033[0;32m[BOOTLOADER]\033[0m nvidia detected, adding nvidia_drm.modeset=1 to boot option..."
            gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
            SUPER sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub
        fi

        echo -e "Select grub theme:\n[1] Retroboot (dark)\n[2] Pochita (light)"
        read -p " :: Press enter to skip grub theme <or> Enter option number : " grubopt
        case ${grubopt} in
            1) grubtheme="Retroboot" ;;
            2) grubtheme="Pochita" ;;
            *) grubtheme="None" ;;
        esac

        if [ "${grubtheme}" == "None" ]; then
            echo -e "\033[0;32m[BOOTLOADER]\033[0m Skippinng grub theme..."
            SUPER sed -i "s/^GRUB_THEME=/#GRUB_THEME=/g" /etc/default/grub
        else
            echo -e "\033[0;32m[BOOTLOADER]\033[0m Setting grub theme // ${grubtheme}"
            SUPER tar -xzf ${cloneDir}/Source/arcs/Grub_${grubtheme}.tar.gz -C /usr/share/grub/themes/
            SUPER sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
            /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1280x1024x32,auto
            /^GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub
        fi

        SUPER grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo -e "\033[0;33m[SKIP]\033[0m grub is already configured..."
    fi
fi

# systemd-boot
if pkg_installed systemd && nvidia_detect && [ $(bootctl status 2> /dev/null | awk '{if ($1 == "Product:") print $2}') == "systemd-boot" ]; then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m detected // systemd-boot"

    if [ $(ls -l /boot/loader/entries/*.conf.t2.bkp 2> /dev/null | wc -l) -ne $(ls -l /boot/loader/entries/*.conf 2> /dev/null | wc -l) ]; then
        echo "nvidia detected, adding nvidia_drm.modeset=1 to boot option..."
        find /boot/loader/entries/ -type f -name "*.conf" | while read imgconf; do
            SUPER cp ${imgconf} ${imgconf}.t2.bkp
            sdopt=$(grep -w "^options" ${imgconf} | sed 's/\b quiet\b//g' | sed 's/\b splash\b//g' | sed 's/\b nvidia_drm.modeset=.\b//g')
            SUPER sed -i "/^options/c${sdopt} quiet splash nvidia_drm.modeset=1" ${imgconf}
        done
    else
        echo -e "\033[0;33m[SKIP]\033[0m systemd-boot is already configured..."
    fi
fi

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
    echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

    SUPER cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    SUPER sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    SUPER sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    SUPER pacman -Syyu
    SUPER pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi
