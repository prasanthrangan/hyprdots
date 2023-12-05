#!/usr/bin/env sh

# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
scol="${XDG_CONFIG_HOME:-$HOME/.config}/spicetify/Themes/Sleek/color.ini"
dcol="${XDG_CONFIG_HOME:-$HOME/.config}/spicetify/Themes/Sleek/Wall-Dcol.ini"

# regen conf

if pkg_installed spotify && pkg_installed spicetify-cli ; then

    if [ "$(spicetify config | awk '{if ($1=="color_scheme") print $2}')" != "Wallbash" ] ; then
        tar -xzf ${CloneDir}/Source/arcs/Spotify_Sleek.tar.gz -C ~/.config/spicetify/Themes/
        spicetify config current_theme Sleek
        spicetify config color_scheme Wallbash
    fi

    if pgrep -x spotify > /dev/null ; then
        pkill -x spicetify
        spicetify -q watch -s &
    fi

    cp "$dcol" "$scol"
fi

