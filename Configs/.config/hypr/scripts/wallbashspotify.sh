#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
scol="$HOME/.config/spicetify/Themes/Sleek/color.ini"
dcol="$HOME/.config/spicetify/Themes/Sleek/Wall-Dcol.ini"

# regen conf

if pkg_installed spotify && pkg_installed spicetify-cli && [ `spicetify config | awk '{if ($1=="color_scheme") print $2}'` == "Wallbash" ] ; then

        if pgrep -x spotify > /dev/null ; then
            pkill -x spicetify
            spicetify -s -q watch &
        fi

        sed 's/#//g' $dcol > $scol
fi

