#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
kittyDir="${XDG_CONFIG_HOME:-${HOME}/.config}/kitty"

if ! grep -q 'include themes/Wall-Dcol.conf' "${kittyDir}/kitty.conf"; then
    echo "include themes/Wall-Dcol.conf" >> "${kittyDir}/kitty.conf"
fi

#Override kitty config
if [ "${EnableWallDcol}" -ne 1 ] ; then
 sed -i '/include themes\/Wall-Dcol\.conf/ s/^/#/' "${kittyDir}/kitty.conf"
else
#  sed -i '/include themes\/Wall-Dcol\.conf/ s/^#//' "${kittyDir}/kitty.conf"
 sed -i '/include themes\/Wall-Dcol\.conf/ s/^\s*##*//' "${kittyDir}/kitty.conf"
fi

killall -SIGUSR1 kitty
