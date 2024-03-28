#!/usr/bin/env sh

# lock instance
lockFile="/tmp/hyrpdots$(id -u)swwwallpaper.lock"
[ -e "$lockFile" ] && echo "An instance of the script is already running..." && exit 1
touch "${lockFile}"
trap 'rm -f ${lockFile}' EXIT

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
TgtScr="$ScrDir/globalcontrol.sh"

# switch WallDcol variable
case "${EnableWallDcol}" in
    0)  sed -i "/^EnableWallDcol/c\EnableWallDcol=1" "${TgtScr}"
        notif="wallbash auto"
        ;;
    1)  sed -i "/^EnableWallDcol/c\EnableWallDcol=2" "${TgtScr}"
        notif="wallbash dark mode"
        ;;
    2)  sed -i "/^EnableWallDcol/c\EnableWallDcol=3" "${TgtScr}"
        notif="wallbash light mode"
        ;;
    3)  sed -i "/^EnableWallDcol/c\EnableWallDcol=0" "${TgtScr}"
        notif="wallbash disabled"
        ;;
esac

# reset the colors
"${ScrDir}/swwwallbash.sh"
notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" "${notif}"
