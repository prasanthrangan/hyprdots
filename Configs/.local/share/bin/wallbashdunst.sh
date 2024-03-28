#!/usr/bin/env sh

# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
dstDir="${XDG_CONFIG_HOME:-$HOME/.config}/dunst"

# regen conf

export hypr_border
envsubst < "${dstDir}/dunst.conf" > "${dstDir}/dunstrc"
cat "${dstDir}/Wall-Dcol.conf" >> "${dstDir}/dunstrc"
killall dunst
dunst &

