#!/usr/bin/env sh

# set variables

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
dstDir="${confDir}/swaync"

# regen conf

export hypr_border
envsubst < "${dstDir}/swaync.conf" > "${dstDir}/swaync.con"
envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/swaync.con"
killall swaync.con
swaync-client -rs
swaync-client -R
swaync &
