#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
rofThm="$HOME/.config/rofi/themes"
dcoDir="$HOME/.config/hypr/wallbash"

# regen color conf

if [ "$EnableWallDcol" -ne 1 ] ; then
    gtk_theme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
    cp ${rofThm}/${gtk_theme}.rasi ${rofThm}/theme.rasi
else
    cp ${rofThm}/Wall-Dcol.rasi ${rofThm}/theme.rasi
fi

