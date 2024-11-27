#!/usr/bin/env sh

#// set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"
rofiAssetDir="${confDir}/rofi/assets"

#// set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=15
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))

#// defining 2 png files to select from
options="Style 1\x00icon\x1f${rofiAssetDir}/theme_style_1.png\nStyle 2\x00icon\x1f${rofiAssetDir}/theme_style_2.png"

#// generate config
mon_x_res=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
mon_scale=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .scale' | sed "s/\.//")
mon_x_res=$(( mon_x_res * 100 / mon_scale ))

elm_width=$(( (20 + 12 + 16 ) * rofiScale ))
max_avail=$(( mon_x_res - (4 * rofiScale) ))
col_count=$(( max_avail / elm_width ))
[[ "${col_count}" -gt 5 ]] && col_count=5
r_override="window{width:100%;} listview{columns:${col_count};} element{orientation:vertical;border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:20em;} element-text{enabled:false;}"

#// launch rofi menu 
RofiSel=$(echo -e "$options" | rofi -dmenu -theme-str "${r_override}" -config "${rofiConf}")

#// apply selected theme
if [ ! -z "${RofiSel}" ]; then
    #// extract selected style number ('Style 1' -> '1')
    selectedStyle=$(echo "${RofiSel}" | awk -F '\x00' '{print $1}' | sed 's/Style //')

    #// notify the user
    notify-send -a "t1" -r 91190 -t 2200 -i "${rofiAssetDir}/theme_style_${selectedStyle}.png" "Style ${selectedStyle} applied..."

    #// save selection in config file
    set_conf "themeSelect" "${selectedStyle}"
fi
