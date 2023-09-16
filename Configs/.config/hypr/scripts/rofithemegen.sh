#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
dcoDir="$HOME/.config/hypr/dcols"
rofThm="$HOME/.config/rofi/themes"

if [ "$EnableWallDcol" -ne 1 ] ; then
    gtk_theme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
    cp ${rofThm}/${gtk_theme}.rasi ${rofThm}/Wall-Dcol.rasi
fi

