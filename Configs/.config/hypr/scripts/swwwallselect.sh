#!/usr/bin/env sh

# set variables
ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
RofiConf="$HOME/.config/rofi/themeselect.rasi"
WallPath="$HOME/.config/swww/$gtkTheme"


# scale for monitor x res
x_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 1`
x_monres=$(( x_monres*17/100 ))


# set rofi override
elem_border=$(( hypr_border * 3 ))
r_override="element{border-radius:${elem_border}px;} listview{columns:6;spacing:100px;} element{padding:0px;orientation:vertical;} element-icon{size:${x_monres}px;border-radius:0px;} element-text{padding:20px;}"


# launch rofi menu
RofiSel=$( ls $WallPath | while read rfile
do
    echo -en "$rfile\x00icon\x1f${cacheDir}/${gtkTheme}/${rfile}\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)


# apply wallpaper
if [ ! -z $RofiSel ] ; then
    ${ScrDir}/swwwallpaper.sh -s $WallPath/$RofiSel
    dunstify "t1" -a " ${RofiSel}" -i "${cacheDir}/${gtkTheme}/${RofiSel}" -r 91190 -t 2200
fi

