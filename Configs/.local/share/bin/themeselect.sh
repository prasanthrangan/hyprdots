#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"


#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))


#// scale for monitor

x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
aspect_r=$((x_monres * 10 / y_monres ))


#// generate config

case "${themeSelect}" in
2) # adapt to style 2
    i_size=$(( aspect_r - 2 ))
    r_override="mainbox{background-color:#00000003;} listview{columns:4;} element{border-radius:${elem_border}px;background-color:@main-bg;} element-icon{size:${i_size}em;border-radius:${icon_border}px 0px 0px ${icon_border}px;}"
    thmbExtn="quad" ;;
*) # default to style 1
    i_size=$(( aspect_r + 2 ))
    r_override="element{border-radius:${elem_border}px;padding:0.5em;} listview{columns:3;} element-icon{size:${i_size}em;border-radius:${icon_border}px;}"
    thmbExtn="sqre" ;;
esac


#// launch rofi menu

get_themes

rofiSel=$(for i in ${!thmList[@]} ; do
    echo -en "${thmList[i]}\x00icon\x1f${thmbDir}/$(set_hash "${thmWall[i]}").${thmbExtn}\n"
done | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${hydeTheme}")


#// apply theme

if [ ! -z "${rofiSel}" ] ; then
    "${scrDir}/themeswitch.sh" -s "${rofiSel}"
    notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" " ${rofiSel}"
fi

