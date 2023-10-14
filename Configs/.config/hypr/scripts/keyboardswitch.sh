#!/bin/bash

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh

hyprctl devices -j | jq -r '.keyboards[].name' | while read keyName
do
    hyprctl switchxkblayout "$keyName" next
done

keyMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="name") print $4}')
layMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="layout") print $4}')

dunstify $ncolor "brightctl" -i ~/.config/dunst/icons/keyboard.png -a "$layMain" "$keyMain" -r 91190 -t 800
