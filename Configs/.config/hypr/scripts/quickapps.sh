#!/usr/bin/env sh

# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
roconf="~/.config/rofi/quickapps.rasi"

if [ $# -ge 1 ] ; then
    dockWidth=$(( (70 * $#) - $# ))
else
    echo "usage: ./quickapps.sh <app1> <app2> ... <app[n]>"
    exit 1
fi


# set position

x_mon=$( cat /sys/class/drm/*/modes | head -1  ) 
y_mon=$( echo $x_mon | cut -d 'x' -f 2 )
x_mon=$( echo $x_mon | cut -d 'x' -f 1 )

x_cur=$(hyprctl cursorpos | sed 's/ //g')
y_cur=$( echo $x_cur | cut -d ',' -f 2 )
x_cur=$( echo $x_cur | cut -d ',' -f 1 )

if [ ${x_cur} -le $(( x_mon/3 )) ] ; then
    x_rofi="west"
    x_offset="x-offset: 20px;"
elif [ ${x_cur} -ge $(( x_mon/3*2 )) ] ; then
    x_rofi="east"
    x_offset="x-offset: -20px;"
else
    unset x_rofi
fi

if [ ${y_cur} -le $(( y_mon/3 )) ] ; then
    y_rofi="north"
    y_offset="y-offset: 20px;"
elif [ ${y_cur} -ge $(( y_mon/3*2 )) ] ; then
    y_rofi="south"
    y_offset="y-offset: -20px;"
else
    unset y_rofi
fi

if [ ! -z $x_rofi ] || [ ! -z $y_rofi ] ; then
    pos="window {location: $y_rofi $x_rofi; $x_offset $y_offset}"
fi


# read hypr theme border

wind_border=$(( hypr_border * 3/2 ))
elem_border=`[ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border`
r_override="window{width:$dockWidth;border-radius:${wind_border}px;} listview{columns:$#;} element{border-radius:${elem_border}px;}"


# launch rofi menu

RofiSel=$( for qapp in "$@"
do
    Lkp=`grep "$qapp" /usr/share/applications/* | grep 'Exec=' | awk -F ':' '{print $1}' | head -1`
    Ico=`grep 'Icon=' $Lkp | awk -F '=' '{print $2}' | head -1`
    echo -en "${qapp}\x00icon\x1f${Ico}\n"
done | rofi -no-fixed-num-lines -dmenu -theme-str "${r_override}" -theme-str "${pos}" -config $roconf)

$RofiSel &

