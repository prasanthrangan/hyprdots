#!/usr/bin/env sh

# set variables
ThemeSet="$HOME/.config/hypr/themes/theme.conf"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
RofiStyle="$HOME/.config/rofi/styles"
Rofilaunch="$HOME/.config/rofi/config.rasi"


# scale for monitor x res
x_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 1`
x_monres=$(( x_monres*18/100 ))


# set rofi override
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="listview{columns:4;} element{orientation:vertical;border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;} element-text{enabled:false;}"


# launch rofi menu
RofiSel=$( ls $RofiStyle/style_*.rasi | awk -F '/' '{print $NF}' | cut -d '.' -f 1 | while read rstyle
do
    echo -en "$rstyle\x00icon\x1f$RofiStyle/${rstyle}.png\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)


# apply rofi style
if [ ! -z $RofiSel ] ; then
    cp $RofiStyle/$RofiSel.rasi $Rofilaunch

    gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
    ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"

    if [ "${gtkMode}" == "light" ] ; then
        ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
    fi

    dunstify $ncolor "theme" -a " ${RofiSel} applied..." -i "$RofiStyle/$RofiSel.png" -r 91190 -t 2200
fi

