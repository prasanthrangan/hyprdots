#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
kittyDir="${XDG_CONFIG_HOME:-${HOME}/.config}/kitty"

#Override kitty config
if [ "${EnableWallDcol}" -ne 1 ] ; then
 sed -i '/include themes\/Wall-Dcol\.conf/ s/^/#/' "${kittyDir}/kitty.conf"
else
 sed -i '/include themes\/Wall-Dcol\.conf/ s/^#//' "${kittyDir}/kitty.conf"
fi

killall -SIGUSR1 kitty
