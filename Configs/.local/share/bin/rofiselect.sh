#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/themeselect.rasi"
rofiStyleDir="${confDir}/rofi/styles"
rofiAssetDir="${confDir}/rofi/assets"


#// scale for monitor x res

x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 18 / monitor_scale ))


#// set rofi override

elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="listview{columns:4;} element{orientation:vertical;border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;} element-text{enabled:false;}"


#// launch rofi menu

RofiSel=$(ls ${rofiStyleDir}/style_*.rasi | awk -F '[_.]' '{print $((NF - 1))}' | while read styleNum
do
    echo -en "${styleNum}\x00icon\x1f${rofiAssetDir}/style_${styleNum}.png\n"
done | sort -n | rofi -dmenu -theme-str "${r_override}" -config "${rofiConf}" -select "${rofiStyle}")


#// apply rofi style

if [ ! -z "${RofiSel}" ] ; then
    set_conf "rofiStyle" "${RofiSel}"
    notify-send -a "t1" -r 91190 -t 2200 -i "${rofiAssetDir}/style_${RofiSel}.png" " style ${RofiSel} applied..." 
fi

