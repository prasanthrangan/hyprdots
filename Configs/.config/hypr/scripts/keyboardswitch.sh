#!/usr/bin/env sh

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh

hyprctl devices -j | jq -r '.keyboards[].name' | while read keyName
do
    hyprctl switchxkblayout "$keyName" next
done

keyMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="name") print $4}')
layMain=$(hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="active_keymap") print $4}')

dunstify "t1" -i ~/.config/dunst/icons/keyboard.svg -a "$layMain" "$keyMain" -r 91190 -t 800
