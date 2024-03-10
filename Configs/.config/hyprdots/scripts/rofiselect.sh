#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themeselect.rasi"
RofiStyle="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/styles"
RofiAssets="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/assets"
Rofilaunch="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config.rasi"


# scale for monitor x res
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 18 / monitor_scale ))


# set rofi override
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="listview{columns:4;} element{orientation:vertical;border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;} element-text{enabled:false;}"


# launch rofi menu
RofiSel=$( ls ${RofiStyle}/style_*.rasi | awk -F '/' '{print $NF}' | cut -d '.' -f 1 | while read rstyle
do
    echo -en "$rstyle\x00icon\x1f${RofiAssets}/${rstyle}.png\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)


# apply rofi style
if [ ! -z $RofiSel ] ; then
    cp "${RofiStyle}/${RofiSel}.rasi" "${Rofilaunch}"
    dunstify "t1" -a " ${RofiSel} applied..." -i "$RofiAssets/$RofiSel.png" -r 91190 -t 2200
fi

