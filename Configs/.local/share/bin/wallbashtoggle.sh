#!/usr/bin/env sh


#// set variables

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
TgtScr="$scrDir/globalcontrol.sh"


#// switch WallDcol variable

case "${enableWallDcol}" in
    0)  sed -i "/^enableWallDcol/c\enableWallDcol=1" "${TgtScr}"
        notif="wallbash auto"
        ;;
    1)  sed -i "/^enableWallDcol/c\enableWallDcol=2" "${TgtScr}"
        notif="wallbash dark mode"
        ;;
    2)  sed -i "/^enableWallDcol/c\enableWallDcol=3" "${TgtScr}"
        notif="wallbash light mode"
        ;;
    3)  sed -i "/^enableWallDcol/c\enableWallDcol=0" "${TgtScr}"
        notif="wallbash disabled"
        ;;
esac


#// reset the colors

"${scrDir}/swwwallbash.sh" "$(readlink "${hydeThemeDir}/wall.set")"
notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" "${notif}"

