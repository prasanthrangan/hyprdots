#!/usr/bin/env bash

# Check release
if [ ! -f /etc/arch-release ] ; then
    exit 0
fi

# Check for updates
aur=$(yay -Qua | wc -l)
ofc=$(pacman -Qu | wc -l)

# Calculate total available updates
upd=$(( ofc + aur ))
echo "$upd"

# Show tooltip
if [ $upd -eq 0 ] ; then
    echo " Packages are up to date"
else
    echo "󱓽 Official $ofc 󱓾 AUR $aur"
fi

# Trigger upgrade
if [ "$1" == "up" ] ; then
    kitty --title systemupdate sh -c 'yay -Syu'
fi

