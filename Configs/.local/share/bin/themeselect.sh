#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themeselect.rasi"


# scale for monitor x res
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 17 / monitor_scale ))


# set rofi override
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="element{border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;}"


# launch rofi menu
ThemeSel=$( cat "$ThemeCtl" | while read line
do
    thm=`echo $line | cut -d '|' -f 2`
    wal=`echo $line | awk -F '/' '{print $NF}'`
    echo -en "$thm\x00icon\x1f$cacheDir/${thm}/${wal}\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf -select "${gtkTheme}")


# apply theme
if [ ! -z $ThemeSel ] ; then
    "${ScrDir}/themeswitch.sh" -s $ThemeSel
    notify-send -a "t1" -i "~/.config/dunst/icons/hyprdots.png" " ${ThemeSel}"
fi

