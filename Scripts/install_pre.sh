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

# grub theme

./grub_theme.sh

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]
    then
    echo -e "\033[0;32m[PACMAN]\033[0m: adding extra spice to pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    #if [ $(grep -w "^\[xero_hypr\]" /etc/pacman.conf | wc -l) -eq 0 ] && [ $(grep "https://repos.xerolinux.xyz/xero_hypr/x86_64/" /etc/pacman.conf | wc -l) -eq 0 ]
    #    then
    #    echo "adding [xero_hypr] repo to pacman..."
    #    echo -e "\n[xero_hypr]\nSigLevel = Required DatabaseOptional\nServer = https://repos.xerolinux.xyz/xero_hypr/x86_64/\n\n" | sudo tee -a /etc/pacman.conf
    #fi
    sudo pacman -Syyu
    sudo pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m: pacman is already configured..."
fi
