#!/usr/bin/env sh

# set variables
wLayout="$HOME/.config/wlogout/layout_$1"
wlTmplt="$HOME/.config/wlogout/style_$1.css"

# set font size
fntSize=`gsettings get org.gnome.desktop.interface font-name | sed "s/'//g" | awk '{print $2}'`
export fntSize=$(( fntSize * 2 ))

# set scaling as per monitor res
res=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`
case $1 in
    1)  wlColms=6
        export mgn=$(( res * 10 / 100 ))
        export hvr=$(( res * 5 / 100 )) ;;
    2)  wlColms=2
        export mgn=$(( res * 8 / 100 ))
        export mgn2=$(( res * 65 / 100 ))
        export hvr=$(( res * 3 / 100 ))
        export hvr2=$(( res * 60 / 100 )) ;;
    *)  echo "Error: invalid parameter passed..."
        exit 1 ;;
esac

# eval config files
wlStyle=`envsubst < $wlTmplt`

# launch wlogout
wlogout -b $wlColms -c 0 -r 0 --layout $wLayout --css <(echo "$wlStyle") --protocol layer-shell

