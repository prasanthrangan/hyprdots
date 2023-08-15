#!/usr/bin/env sh

## set variables ##
BaseDir=`dirname $(realpath $0)`
ThemeSet="$HOME/.config/hypr/themes/theme.conf"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
RofiStyle="$HOME/.config/rofi/styles"
Rofilaunch="$HOME/.config/rofi/config.rasi"

## show and apply theme ##
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="element {border-radius: ${elem_border}px;} element-icon {border-radius: ${icon_border}px;}"

RofiSel=$( ls $RofiStyle/style_*.rasi | awk -F '/' '{print $NF}' | cut -d '.' -f 1 | while read rstyle
do
    echo -en "$rstyle\x00icon\x1f$RofiStyle/${rstyle}.png\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)

if [ ! -z $RofiSel ] ; then
    cp $RofiStyle/$RofiSel.rasi $Rofilaunch
fi

