#!/usr/bin/env sh


# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
kvtheme=$(awk -F '=' '$1 == "theme" {print $2}' "$ConfDir/Kvantum/kvantum.kvconfig")


# regen color conf

if [ "$EnableWallDcol" -eq 1 ] ; then

    kvantummanager --set Wall-Dcol
    kvtheme="t2"
    cp ${ConfDir}/qt5ct/colors/Wall-Dcol.conf ${ConfDir}/qt6ct/colors/Wall-Dcol.conf
    sed -i "/^color_scheme_path=/c\color_scheme_path=${ConfDir}/qt5ct/colors/Wall-Dcol.conf
            /^icon_theme=/c\icon_theme=${gtkIcon}" $ConfDir/qt5ct/qt5ct.conf
    sed -i "/^color_scheme_path=/c\color_scheme_path=${ConfDir}/qt6ct/colors/Wall-Dcol.conf
            /^icon_theme=/c\icon_theme=${gtkIcon}" $ConfDir/qt6ct/qt6ct.conf

else

    kvantummanager --set "${gtkTheme}"
    sed -i "/^color_scheme_path=/c\color_scheme_path=$ConfDir/qt5ct/colors/${gtkTheme}.conf
            /^icon_theme=/c\icon_theme=${gtkIcon}" $ConfDir/qt5ct/qt5ct.conf
    sed -i "/^color_scheme_path=/c\color_scheme_path=$ConfDir/qt6ct/colors/${gtkTheme}.conf
            /^icon_theme=/c\icon_theme=${gtkIcon}" $ConfDir/qt6ct/qt6ct.conf

fi


# restart dolphin

if [ "${kvtheme}" != "${gtkTheme}" ] ; then
    a_ws=$(hyprctl -j activeworkspace | jq '.id')
    dpid=$(hyprctl -j clients | jq --arg wid "$a_ws" '.[] | select(.workspace.id == ($wid | tonumber)) | select(.class == "org.kde.dolphin") | .pid')
    if [ ! -z ${dpid} ] ; then
        hyprctl dispatch closewindow pid:${dpid}
        dolphin &
    fi
fi

