#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"


#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"


#// scale for monitor

x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
aspect_r=$((x_monres * 10 / y_monres ))


#// generate config

i_size=$(( aspect_r + 4 ))
elem_border=$(( hypr_border * 3 ))
r_override="element{border-radius:${elem_border}px;orientation:vertical;} listview{columns:6;spacing:5em;} element-icon{size:${i_size}em;border-radius:0em;} element-text{padding:1em;}"


#// launch rofi menu

currentWall="$(basename "$(readlink "${hydeThemeDir}/wall.set")")"
wallPathArray=("${hydeThemeDir}")
wallPathArray+=("${wallAddCustomPath[@]}")
get_hashmap "${wallPathArray[@]}"
rofiSel=$(parallel --link echo -en "\$(basename "{1}")"'\\x00icon\\x1f'"${thmbDir}"'/'"{2}"'.sqre\\n' ::: "${wallList[@]}" ::: "${wallHash[@]}" | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${currentWall}")


#// apply wallpaper

if [ ! -z "${rofiSel}" ] ; then
    for i in "${!wallPathArray[@]}" ; do
        setWall="$(find "${wallPathArray[i]}" -type f -name "${rofiSel}")"
        [ -z "${setWall}" ] || break
    done
    "${scrDir}/swwwallpaper.sh" -s "${setWall}"
    notify-send -a "t1" -i "${thmbDir}/$(set_hash "${setWall}").sqre" " ${rofiSel}"
fi

