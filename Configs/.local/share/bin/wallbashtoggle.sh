#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
TgtScr="$scrDir/globalcontrol.sh"


#// switch WallDcol variable

case "${enableWallDcol}" in
    0)  set_conf "enableWallDcol" "1"
        notif="wallbash auto"
        ;;
    1)  set_conf "enableWallDcol" "2"
        notif="wallbash dark mode"
        ;;
    2)  set_conf "enableWallDcol" "3"
        notif="wallbash light mode"
        ;;
    3)  set_conf "enableWallDcol" "0"
        notif="wallbash disabled"
        ;;
esac


#// reset the colors

if [ ! -e "$(readlink "${hydeThemeDir}/wall.set")" ] ; then
    get_hashmap "${hydeThemeDir}"
    ln -fs "${walList[0]}" "${hydeThemeDir}/wall.set"
fi

"${scrDir}/swwwallbash.sh" "$(readlink "${hydeThemeDir}/wall.set")"
notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" "${notif}"


