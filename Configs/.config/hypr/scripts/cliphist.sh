#!/usr/bin/env sh

theme_file="$HOME/.config/hypr/themes/theme.conf"
roconf="~/.config/rofi/clipboard.rasi"


# set position

case $2 in
    1)  # top left
        pos="window {location: north west; anchor: north west; x-offset: 20px; y-offset: 20px;}"
        ;;
    2)  # top right
        pos="window {location: north east; anchor: north east; x-offset: -20px; y-offset: 20px;}"
        ;;
    3)  # bottom left
        pos="window {location: south east; anchor: south east; x-offset: -20px; y-offset: -20px;}"
        ;;
    4)  # bottom right
        pos="window {location: south west; anchor: south west; x-offset: 20px; y-offset: -20px;}"
        ;;
esac


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
    *)  echo -e "cliphist.sh [action] [position]\nwhere action,"
        echo "c :  cliphist list and copy selected"
        echo "d :  cliphist list and delete selected"
        echo "w :  cliphist wipe database"
        echo "where position,"
        echo "1 :  top left"
        echo "2 :  top right"
        echo "3 :  bottom right"
        echo "4 :  bottom left"
        exit 1
        ;;
esac

