#!/usr/bin/env sh

# set variables
BaseDir=`dirname $(realpath $0)`
ThemeCtl="$HOME/.config/swww/wall.ctl"
CacheDir="$HOME/.config/swww/.cache"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
ThemeSet="$HOME/.config/hypr/themes/theme.conf"


# scale for monitor x res
x_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 1`
x_monres=$(( x_monres*17/100 ))


# set rofi override
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="element{border-radius:${elem_border}px;} element-icon{border-radius:${icon_border}px;size:${x_monres}px;}"


# launch rofi menu
ThemeSel=$( cat $ThemeCtl | while read line
do
    thm=`echo $line | cut -d '|' -f 2`
    wal=`echo $line | awk -F '/' '{print $NF}'`
    #echo $thm $wal
    echo -en "$thm\x00icon\x1f$CacheDir/${thm}/${wal}\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)


# apply theme
if [ ! -z $ThemeSel ] ; then
    ${BaseDir}/themeswitch.sh -s $ThemeSel
fi

