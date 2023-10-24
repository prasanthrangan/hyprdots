#!/usr/bin/env sh

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
dstDir="$HOME/.config/dunst"

# regen conf

cat $dstDir/dunst.conf $dstDir/Wall-Dcol.conf > $dstDir/dunstrc
killall dunst
dunst &

