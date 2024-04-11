#!/usr/bin/env bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install flatpaks (user) |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

baseDir=$(dirname "$(realpath "$0")")
scrDir=$(dirname "$(dirname "$(realpath "$0")")")

source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if ! pkg_installed flatpak; then
    sudo pacman -S flatpak
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flats=$(awk -F '#' '{print $1}' "${baseDir}/custom_flat.lst" | sed 's/ //g' | xargs)

flatpak install --user -y flathub ${flats}
flatpak remove --unused

gtkTheme=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
gtkIcon=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")

flatpak --user override --filesystem=~/.themes
flatpak --user override --filesystem=~/.icons

flatpak --user override --env=GTK_THEME=${gtkTheme}
flatpak --user override --env=ICON_THEME=${gtkIcon}
