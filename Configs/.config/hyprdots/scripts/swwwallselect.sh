#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themeselect.rasi"

ctlLine=`grep '^1|' "$ThemeCtl"`
if [ `echo $ctlLine | wc -l` -ne "1" ] ; then
    echo "ERROR : $ThemeCtl Unable to fetch theme..."
    exit 1
fi

fullPath=$(echo "$ctlLine" | awk -F '|' '{print $NF}' | sed "s+~+$HOME+")
wallPath=$(dirname "$fullPath")
if [ ! -d "${wallPath}" ] && [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/swww/${gtkTheme}" ] && [ ! -z "${gtkTheme}" ] ; then
    wallPath="${XDG_CONFIG_HOME:-$HOME/.config}/swww/${gtkTheme}"
fi


# scale for monitor x res
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 17 / monitor_scale ))


# set rofi override
elem_border=$(( hypr_border * 3 ))
r_override="element{border-radius:${elem_border}px;} listview{columns:6;spacing:100px;} element{padding:0px;orientation:vertical;} element-icon{size:${x_monres}px;border-radius:0px;} element-text{padding:20px;}"


# launch rofi menu
currentWall=`basename $fullPath`
RofiSel=$( find "${wallPath}" -maxdepth 1 -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec basename {} \; | sort | while read rfile
do
    echo -en "$rfile\x00icon\x1f${cacheDir}/${gtkTheme}/${rfile}\n"
done | rofi -dmenu -theme-str "${r_override}" -config "${RofiConf}" -select "${currentWall}")


# apply wallpaper
if [ ! -z "${RofiSel}" ] ; then
    "${ScrDir}/swwwallpaper.sh" -s "${wallPath}/${RofiSel}"
    notify-send -a "t1" -i "${cacheDir}/${gtkTheme}/${RofiSel}" " ${RofiSel}"
fi

