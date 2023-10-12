#!/usr/bin/env sh

dunstify $ncolor -a "PyWall" "Generating Color ..." -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2500

wall=$(cat ~/.cache/swww/eDP-1)

Pywall= wal -s -i $wall
waltg= wal-telegram --wal -g -r
#Geenerate pywall
$Pywall
if [ -z $Pywall ] ; then
     $waltg &
     dunstify $ncolor -a "Pywall" "Color Generated ..." -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2500
fi
