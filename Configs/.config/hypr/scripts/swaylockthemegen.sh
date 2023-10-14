#!/bin/bash

# set variables

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
dcol_file="$HOME/.config/hypr/wallbash/swaylock.dcol"
swaylock_config="$HOME/.config/swaylock/config"

# regen color conf
if [ "$EnableWallDcol" -ne 1 ] ; then

    cp $HOME/.config/swaylock/default.config  $swaylock_config
else
# Read the color values from the .dcol file
IFS=$'\n' read -d '' -r -a dcol_array < "$dcol_file"
## Replace the color values in the swaylock configuration file
for (( i=0; i<${#dcol_array[@]}; i++ )); do
    color=${dcol_array[i]//|/\\|}
    sed -i "s|<dcol_${i}>|${color}|g" "$swaylock_config"
done
fi

#Set new Image for Swaylock 

case $1 in --image)

currentWall=$(awk -F '|' '$1 ~ /1/ {print $3}' ~/.config/swww/wall.ctl)
sed -i "s|image=.*|image=$currentWall|" $swaylock_config
sed -i "s|image=.*|image=$currentWall|" $dcol_file

echo "New LockScreen: $currentWall "

;;
esac

