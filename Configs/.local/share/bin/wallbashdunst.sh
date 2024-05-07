#!/usr/bin/env sh

#// Set variables

scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"
dstDir="${confDir}/dunst"

#// Regenerate config

export hypr_border
envsubst < "${dstDir}/dunst.conf" > "${dstDir}/dunstrc"
envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/dunstrc"
killall dunst
dunst &
