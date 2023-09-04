#!/usr/bin/env sh

theme_file="$HOME/.config/hypr/themes/theme.conf"
roconf="~/.config/rofi/clipboard.rasi"


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

hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $theme_file | sed 's/ //g'`
hypr_width=`awk -F '=' '{if($1~" border_size ") print $2}' $theme_file | sed 's/ //g'`
wind_border=$(( hypr_border * 3/2 ))
elem_border=`[ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border`
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} entry {border-radius: ${elem_border}px;} element {border-radius: ${elem_border}px;}"


# read hypr font size

#fnt_size=`awk '{if($6=="monospace-font-name") print $NF}' $theme_file | sed "s/'//g"`
fnt_override=`gsettings get org.gnome.desktop.interface monospace-font-name | awk '{gsub(/'\''/,""); print $NF}'`
fnt_override="configuration {font: \"JetBrainsMono Nerd Font ${fnt_override}\";}"


# clipboard action

case $1 in
    c)  cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config $roconf | cliphist decode | wl-copy
        ;; 
    d)  cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config $roconf | cliphist delete
        ;;
    w)  if [ `echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config $roconf` == "Yes" ] ; then
            cliphist wipe
        fi
        ;;
    *)  echo -e "cliphist.sh [action]"
        echo "c :  cliphist list and copy selected"
        echo "d :  cliphist list and delete selected"
        echo "w :  cliphist wipe database"
        exit 1
        ;;
esac

