#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
rofThm="$HOME/.config/rofi/themes"

# regen color conf

if [ "$EnableWallDcol" -ne 1 ] ; then
    cp ${rofThm}/${gtkTheme}.rasi ${rofThm}/theme.rasi
else
    cp ${rofThm}/Wall-Dcol.rasi ${rofThm}/theme.rasi
fi

