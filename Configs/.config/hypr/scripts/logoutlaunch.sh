#!/usr/bin/env sh

# detect monitor y res
res=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`

# scale config layout and style
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

# scale font size
export fntSize=$(( res * 2 / 100 ))

# detect gtk system theme
export gtkThm=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
export csMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
export BtnCol=`[ "$csMode" == "dark" ] && ( echo "black" ) || ( echo "white" )`
export BtnBkg=`[ "$csMode" == "dark" ] && ( echo "color" ) || ( echo "bg" )`
export WindBg=`[ "$csMode" == "dark" ] && ( echo "rgba(0,0,0,0.5)" ) || ( echo "rgba(255,255,255,0.6)" )`
export wbarTheme="$HOME/.config/waybar/themes/${gtkThm}.css"

# eval hypr border radius
hyprTheme="$HOME/.config/hypr/themes/${gtkThm}.conf"
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $hyprTheme | sed 's/ //g'`
export active_rad=$(( hypr_border * 5 ))
export button_rad=$(( hypr_border * 8 ))

# set file variables
wLayout="$HOME/.config/wlogout/layout_$1"
wlTmplt="$HOME/.config/wlogout/style_$1.css"

# eval config files
wlStyle=`envsubst < $wlTmplt`

# eval padding
y_pad=$(( res * 20 / 100 ))

# launch wlogout
wlogout -b $wlColms -c 0 -r 0 -T $y_pad -B $y_pad --layout $wLayout --css <(echo "$wlStyle") --protocol layer-shell

