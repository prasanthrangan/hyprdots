#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/themeselect.rasi"


#// scale for monitor x res

x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 17 / monitor_scale ))


#// set rofi override

elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="element{border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;}"


#// launch rofi menu

get_themes

rofiSel=$(for i in ${!thmList[@]} ; do
    thmHash="$("${hashMech}" "${thmWall[i]}" | awk '{print $1}')"
    echo -en "${thmList[i]}\x00icon\x1f"${thmbDir}/${thmHash}.sqre"\n"
done | rofi -dmenu -theme-str "${r_override}" -config "${rofiConf}" -select "${hydeTheme}")


#// apply theme

if [ ! -z "${rofiSel}" ] ; then
    "${scrDir}/themeswitch.sh" -s "${rofiSel}"
    notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" " ${rofiSel}"
fi

