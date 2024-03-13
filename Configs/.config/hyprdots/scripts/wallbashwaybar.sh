#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
waybarDir="${ConfDir}/waybar/themes"

#Override waybar css
if [ "${EnableWallDcol}" -ne 1 ] ; then
    ln -fs ${waybarDir}/${gtkTheme}.css ${waybarDir}/theme.css
else
    ln -fs ${waybarDir}/Wall-Dcol.css ${waybarDir}/theme.css
fi

# restart waybar

killall waybar
waybar > /dev/null 2>&1 &