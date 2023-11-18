#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
hypDir="$HOME/.config/hypr/themes"

# regen color conf

if [ "$EnableWallDcol" -eq 1 ] ; then
    cp ${hypDir}/Wall-Dcol.conf ${hypDir}/colors.conf
else
    > ${hypDir}/colors.conf
fi

