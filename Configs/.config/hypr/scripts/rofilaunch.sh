#!/usr/bin/env sh

theme_file="$HOME/.config/hypr/themes/theme.conf"
rofi_conf="~/.config/rofi/config.rasi"


# rofi action

case $1 in
    d)  r_mode="drun" ;; 
    w)  r_mode="window" ;;
    f)  r_mode="filebrowser" ;;
    h)  echo -e "rofilaunch.sh [action]\nwhere action,"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode,"
        exit 0 ;;
    *)  r_mode="drun" ;;
esac


# read hypr theme border

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $theme_file | sed 's/ //g'`
wind_border=$(( hypr_border * 3 ))
elem_border=`[ $hypr_border -eq 0 ] && echo "10" || echo $(( hypr_border * 2 ))`
r_override="window {border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"


# launch rofi

rofi -show $r_mode -theme-str "${r_override}" -config "${rofi_conf}"

