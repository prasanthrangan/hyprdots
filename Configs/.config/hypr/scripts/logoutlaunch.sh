#!/usr/bin/env sh


██╗  ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ 
██║ ██╔╝██║██║  ██║████╗  ██║██╔════╝ 
█████╔╝ ██║███████║██╔██╗ ██║██║  ███╗
██╔═██╗ ██║██╔══██║██║╚██╗██║██║   ██║
██║  ██╗██║██║  ██║██║ ╚████║╚██████╔╝
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
 

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
then
    # Kill wlogout
    pkill -x "wlogout"
    exit 0
fi

# set file variables
wLayout="$HOME/.config/wlogout/layout_$1"
wlTmplt="$HOME/.config/wlogout/style_$1.css"

if [ ! -f $wLayout ] || [ ! -f $wlTmplt ] ; then
    echo "ERROR: Style $1 not found..."
    exit 1;
fi

# detect monitor y res
res=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`
#res='1300'
# scale config layout and style
case $1 in
    1)  wlColms=6
        export mgn=$(( res * 26 / 200 ))
        export hvr=$(( res * 21 / 200 )) ;; #changes here def /100
        
    2)  wlColms=2
        export x_mgn=$(( res * 80 / 400  ))
        export y_mgn=$(( res * 25 / 400 ))
        export x_hvr=$(( res * 75 / 400 ))
        export y_hvr=$(( res * 20 / 400 )) ;; # def=/100
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

# eval config files
wlStyle=`envsubst < $wlTmplt`

# launch wlogout
wlogout -b $wlColms -c 0 -r 0 -m 0 --layout $wLayout --css <(echo "$wlStyle") --protocol layer-shell

