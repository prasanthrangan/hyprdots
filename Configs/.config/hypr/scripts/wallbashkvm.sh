#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
hypDir="$HOME/.config/hypr/themes"

# regen color conf

if [ "$EnableWallDcol" -eq 1 ] ; then
    kvantummanager --set Wall-Dcol
else
    kvantummanager --set $gtkTheme
fi

# reload dolphin

a_ws=$(hyprctl -j activeworkspace | jq '.id')
if [ "$(hyprctl -j clients | jq --arg wid "$a_ws" '.[] | select(.workspace.id == ($wid | tonumber)) | select(.class == "org.kde.dolphin") | .mapped')" == "true" ] ; then
    pkill -x dolphin
    dolphin &
fi

