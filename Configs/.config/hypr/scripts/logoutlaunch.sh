#!/usr/bin/env sh

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
then
    pkill -x "wlogout"
    exit 0
fi

# set file variables
ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
wLayout="$HOME/.config/wlogout/layout_$1"
wlTmplt="$HOME/.config/wlogout/style_$1.css"

if [ ! -f $wLayout ] || [ ! -f $wlTmplt ] ; then
    echo "ERROR: Config $1 not found..."
    exit 1;
fi

# detect monitor y res
x_mon=$( cat /sys/class/drm/*/modes | head -1  ) 
y_mon=$( echo $x_mon | cut -d 'x' -f 2 )
x_mon=$( echo $x_mon | cut -d 'x' -f 1 )

# scale config layout and style
case $1 in
    1)  wlColms=6
        export mgn=$(( y_mon * 28 / 100 ))
        export hvr=$(( y_mon * 23 / 100 )) ;;
    2)  wlColms=2
        export x_mgn=$(( x_mon * 35 / 100 ))
        export y_mgn=$(( y_mon * 25 / 100 ))
        export x_hvr=$(( x_mon * 32 / 100 ))
        export y_hvr=$(( y_mon * 20 / 100 )) ;;
esac

# scale font size
export fntSize=$(( y_mon * 2 / 100 ))

# detect gtk system theme
export BtnCol=`[ "$gtkMode" == "dark" ] && ( echo "white" ) || ( echo "black" )`
export WindBg=`[ "$gtkMode" == "dark" ] && ( echo "rgba(0,0,0,0.5)" ) || ( echo "rgba(255,255,255,0.5)" )`

if [ "$EnableWallDcol" -eq 1 ] ; then
    export wbarTheme="Wall-Dcol"
else
    export wbarTheme="${gtkTheme}"
fi

# eval hypr border radius
export active_rad=$(( hypr_border * 5 ))
export button_rad=$(( hypr_border * 8 ))

# eval config files
wlStyle=`envsubst < $wlTmplt`

# launch wlogout
wlogout -b $wlColms -c 0 -r 0 -m 0 --layout $wLayout --css <(echo "$wlStyle") --protocol layer-shell

