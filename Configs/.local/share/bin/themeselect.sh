#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/themeselect.rasi"


#// scale for monitor x res

x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')


#// set rofi override

elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))

case "${themeSelect}" in
2) # adapt to style 2
    x_monres=$(( x_monres * 14 / monitor_scale ))
    r_override="mainbox{background-color:#00000003;} listview{columns:4;} element{border-radius:${elem_border}px;background-color: @main-bg;padding:0em;} element-icon{border-radius:${icon_border}px 0px 0px ${icon_border}px;size:${x_monres}px;}"
    thmbExtn="quad" ;;
*) # default to style 1
    x_monres=$(( x_monres * 17 / monitor_scale ))
    r_override="element{border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;}"
    thmbExtn="sqre" ;;
esac


#// launch rofi menu

get_themes

rofiSel=$(for i in ${!thmList[@]} ; do
    echo -en "${thmList[i]}\x00icon\x1f${thmbDir}/$(set_hash "${thmWall[i]}").${thmbExtn}\n"
done | rofi -dmenu -theme-str "${r_override}" -config "${rofiConf}" -select "${hydeTheme}")


#// apply theme

if [ ! -z "${rofiSel}" ] ; then
    "${scrDir}/themeswitch.sh" -s "${rofiSel}"
    notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" " ${rofiSel}"
fi

