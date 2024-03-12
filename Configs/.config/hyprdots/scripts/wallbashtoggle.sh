#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
TgtScr="$ScrDir/globalcontrol.sh"

# switch WallDcol variable
if [ $EnableWallDcol -eq 1 ] ; then
    sed -i "/^EnableWallDcol/c\EnableWallDcol=0" $TgtScr
    notif=" Wallbash disabled..."
else
    sed -i "/^EnableWallDcol/c\EnableWallDcol=1" $TgtScr
    notif=" Wallbash enabled..."
fi

# reset the colors
find "${WallbashDir}" -type f -name "*.dcol"  | while read hdr
do
    appexe=$(awk -F '|' 'NR==1 {print $2}' "${hdr}")
    if [ ! -z "$appexe" ] ; then
        eval "${appexe}"
    fi
done

notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" "${notif}"

