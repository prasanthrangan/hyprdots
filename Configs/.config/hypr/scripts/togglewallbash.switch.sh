#!/usr/bin/env sh

# set variables
ScrDir=`dirname $(realpath $0)`
DcoDir="$HOME/.config/hypr/wallbash"
TgtScr=$ScrDir/globalcontrol.sh
source $ScrDir/globalcontrol.sh

# switch WallDcol variable

case $1 in 
	--off)
if [ $EnableWallDcol -eq 1 ] ; then
    sed -i "/^EnableWallDcol/c\EnableWallDcol=0" $TgtScr
    dunstify $ncolor "theme" -a " Wallbash disabled..." -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200

else
#	notify-send "Wallbash Not Enabled"
	echo " Wallbash not Enabled"  

	exit 0 

fi
;;
	--on)
if [ $EnableWallDcol -eq 0 ] ; then

    sed -i "/^EnableWallDcol/c\EnableWallDcol=1" $TgtScr
    dunstify $ncolor "theme" -a " Wallbash enabled..." -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200

else
#	notify-send "Wallbash Already running"
	echo "WallBash Already enabled"
	exit 0

fi
;;

	*)
		echo '
Hatdog press --on or --off
'
;;
esac

# reset the colors
#grep -m 1 '.' $DcoDir/*.dcol | cut -d '|' -f 2 | while read wallbash
#do
#    $ScrDir/$wallbash
#done
~/.config/hypr/scripts/themeReload.sh all