#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
spycol="$HOME/.config/spicetify/Themes/Sleek/color.ini"

# regen conf

if pgrep -x spotify > /dev/null ; then
    pkill -x spicetify
    spicetify -s -q watch &
fi

sed -i 's/#//g' $spycol

