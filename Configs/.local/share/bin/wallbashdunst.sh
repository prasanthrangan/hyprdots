#!/usr/bin/env sh

# set variables

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
dstDir="${confDir}/dunst"

# regen conf

export hypr_border
envsubst < "${dstDir}/dunst.conf" > "${dstDir}/dunstrc"
cat "${dstDir}/wallbash.conf" >> "${dstDir}/dunstrc"
killall dunst
dunst &

