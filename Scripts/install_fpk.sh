#!/bin/bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install flatpaks (user) |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

source global_fn.sh

if ! pkg_installed flatpak
    then
    sudo pacman -S flatpak
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flats=""

while read fpk
do
    flats=`echo ${flats} ${fpk}`
done < custom_flat.lst

flatpak install --user flathub ${flats}

