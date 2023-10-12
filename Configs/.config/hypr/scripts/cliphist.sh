#!/usr/bin/env sh

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
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
   
         5) # Follow mouse cursor


active_monitor=$(hyprctl monitors | awk -v RS="" -v ORS="\n\n" '/focused: yes/'| awk '/ID/{print $2} ')
res_inf=$(hyprctl monitors | awk -v RS="" -v ORS="\n\n" '/focused: yes/'| awk -F "@" '/@/ && / at /{print $1} ')
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
x_pos=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .x')
y_pos=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .y')
rot_inf=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .transform')

x_subtract_percent=60  # percent to limit screen resolution for x
y_subtract_percent=78   # workaround 

if [ "$rot_inf" = "1" ] || [ "$rot_inf" = "3" ]; then  # if rotated 270 deg
    temp=$x_mon
    x_mon=$y_mon
    y_mon=$temp
    x_subtract_percent=0      # percent to limit screen resolution for x
    y_subtract_percent=0    #workaround
fi

 x_pos_limit=$(echo $pos_inf | cut -d 'x' -f 1)
 y_pos_limit=$(echo $pos_inf | cut -d 'x' -f 2 )

cursor_pos=$(hyprctl cursorpos)
cursor_x=$(echo $cursor_pos | cut -d ',' -f 1)
cursor_y=$(echo $cursor_pos | cut -d ',' -f 2)

cursor_x=$((cursor_x - x_pos_limit))
cursor_y=$((cursor_y - y_pos_limit))

x_offset=10                # will spawn on 0x0 north west of rofi
y_offset=-260               # set this if you want to determine part fo the window your cursor will be
cursor_x=$((cursor_x + x_offset))
cursor_y=$((cursor_y + y_offset))

x_subtract_value=$((x_mon * x_subtract_percent / 100))
y_subtract_value=$((y_mon * y_subtract_percent / 100))

max_x=$((x_mon - x_subtract_value))
max_y=$((y_mon - y_subtract_value))

cursor_x=$((cursor_x < min_x ? min_x : (cursor_x > max_x ? max_x : cursor_x)))
cursor_y=$((cursor_y < min_y ? min_y : (cursor_y > max_y ? max_y : cursor_y)))

pos="window {location: north west; x-offset: ${cursor_x}px; y-offset: ${cursor_y}px;}"
    ;;
esac


# read hypr theme border

wind_border=$(( hypr_border * 3/2 ))
elem_border=`[ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border`
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} entry {border-radius: ${elem_border}px;} element {border-radius: ${elem_border}px;}"


# read hypr font size

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
        echo "5 :  follow mouse"
        exit 1
        ;;
esac

