#!/usr/bin/env sh

# set variables

scrDir="$(dirname "$(realpath "$0")")"
source $scrDir/globalcontrol.sh
# dstDir="${confDir}/swaync"

# regen conf

export hypr_border
# envsubst < "${dstDir}/swaync." > "${dstDir}/swaync.con" #? for what reason
# envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/swaync.con" #? for what reason
killall swaync
swaync-client -rs
swaync-client -R
swaync &
