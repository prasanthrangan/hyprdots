#!/bin/bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install flatpaks (user) |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

BaseDir=`dirname "$(realpath "$0")"`
ScrDir=`dirname "$(dirname "$(realpath "$0")")"`

source $ScrDir/global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

if ! pkg_installed flatpak
    then
    sudo pacman -S flatpak
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flats=`awk -F '#' '{print $1}' $BaseDir/custom_flat.lst | sed 's/ //g' | xargs`

flatpak install --user -y flathub ${flats}
flatpak remove --unused

GtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
GtkIcon=`gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g"`

flatpak --user override --filesystem=~/.themes
flatpak --user override --filesystem=~/.icons

flatpak --user override --env=GTK_THEME=${GtkTheme}
flatpak --user override --env=ICON_THEME=${GtkIcon}
