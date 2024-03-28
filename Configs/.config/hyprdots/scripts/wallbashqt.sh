#!/usr/bin/env sh


# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh


# sync qt5 and qt6 colors

cp "${ConfDir}/qt5ct/colors.conf" "${ConfDir}/qt6ct/colors.conf"


# restart dolphin

if [ "${EnableWallDcol}" -ne 0 ] ; then
    a_ws=$(hyprctl -j activeworkspace | jq '.id')
    dpid=$(hyprctl -j clients | jq --arg wid "$a_ws" '.[] | select(.workspace.id == ($wid | tonumber)) | select(.class == "org.kde.dolphin") | .pid')
    if [ ! -z ${dpid} ] ; then
        hyprctl dispatch closewindow pid:${dpid}
        dolphin &
    fi
fi

