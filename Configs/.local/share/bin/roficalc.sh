#!/usr/bin/env sh


#// set variables

scrDir=$(dirname "$(realpath "$0")")
source $scrDir/globalcontrol.sh
roconf="${confDir}/rofi/calc.rasi"


#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)


r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"

rofi -show calc -theme-str "entry { placeholder: \"Calc...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" -no-sort -no-show-match -calc-command "echo -n '{result}' | wl-copy" -automatic-save-to-history
