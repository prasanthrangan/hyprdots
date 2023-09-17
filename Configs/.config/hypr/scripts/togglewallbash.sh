#!/usr/bin/env sh

# set variables
ScrDir=`dirname $(realpath $0)`
DcoDir="$HOME/.config/hypr/wallbash"
TgtScr=$ScrDir/globalcontrol.sh
source $ScrDir/globalcontrol.sh

# switch WallDcol variable
if [ $EnableWallDcol -eq 1 ] ; then
    sed -i "/^EnableWallDcol/c\EnableWallDcol=0" $TgtScr
    dunstify $ncolor "theme" -a " Wallbash disabled..." -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200
else
    sed -i "/^EnableWallDcol/c\EnableWallDcol=1" $TgtScr
    dunstify $ncolor "theme" -a " Wallbash enabled..." -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200
fi

# reset the colors
grep -m 1 '.' $DcoDir/*.dcol | cut -d '|' -f 2 | while read wallbash
do
    $ScrDir/$wallbash
done

