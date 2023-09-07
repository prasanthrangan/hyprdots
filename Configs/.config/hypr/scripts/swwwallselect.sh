#!/usr/bin/env sh

# set variables
ThemeSet="$HOME/.config/hypr/themes/theme.conf"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
CurTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
WallPath="$HOME/.config/swww/$CurTheme"
CacheDir="$HOME/.config/swww/.cache"


# scale for monitor x res
x_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 1`
x_monres=$(( x_monres*17/100 ))


# set rofi override
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
elem_border=$(( hypr_border * 3 ))
r_override="element{border-radius:${elem_border}px;} listview{columns:6;spacing:100px;} element{padding:0px;orientation:vertical;} element-icon{size:${x_monres}px;border-radius:0px;} element-text{padding:20px;}"


# launch rofi menu
RofiSel=$( ls $WallPath | while read rfile
do
    echo -en "$rfile\x00icon\x1f${CacheDir}/${CurTheme}/${rfile}\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)


# apply wallpaper
if [ ! -z $RofiSel ] ; then
    $HOME/.config/hypr/scripts/swwwallpaper.sh -s $WallPath/$RofiSel

    gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
    ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"

    if [ "${gtkMode}" == "light" ] ; then
        ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
    fi

    dunstify $ncolor "theme" -a " ${RofiSel}" -i "${CacheDir}/${CurTheme}/${RofiSel}" -r 91190 -t 2200
fi

