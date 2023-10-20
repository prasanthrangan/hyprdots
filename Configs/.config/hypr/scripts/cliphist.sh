#!/usr/bin/env sh

ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
roconf="~/.config/rofi/clipboard.rasi"


# set position
x_offset=-15   #* Cursor spawn position on clipboard
y_offset=210   #* To point the Cursor to the 1st and 2nd latest word
#!base on $HOME/.config/rofi/clipboard.rasi 
clip_h=$(cat $HOME/.config/rofi/clipboard.rasi | awk '/window {/,/}/'  | awk '/height:/ {print $2}' | awk -F "%" '{print $1}')
clip_w=$(cat $HOME/.config/rofi/clipboard.rasi | awk '/window {/,/}/'  | awk '/width:/ {print $2}' | awk -F "%" '{print $1}')
#clip_h=55 #! Modify limits for size of the Clipboard
#clip_w=20 #! This values are transformed per cent(100)
#? Monitor resolution , scale and rotation 
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
#? Rotated monitor? 
monitor_rot=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .transform')
if [ "$monitor_rot" == "1" ] || [ "$monitor_rot" == "3" ]; then  # if rotated 270 deg
 tempmon=$x_mon
    x_mon=$y_mon
    y_mon=$tempmon
#! For rotated monitors
fi
#? Scaled monitor Size
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_mon=$((x_mon * 100 / monitor_scale ))
y_mon=$((y_mon * 100 / monitor_scale))
#? monitor position
x_pos=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .x')
y_pos=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .y')
#? cursor position
x_cur=$(hyprctl -j cursorpos | jq '.x')
y_cur=$(hyprctl -j cursorpos | jq '.y')
# Ignore position
 x_cur=$(( x_cur - x_pos))
 y_cur=$(( y_cur - y_pos))
#Limiting
# Multiply before dividing to avoid losing precision due to integer division
clip_w=$(( x_mon*clip_w/100 ))
clip_h=$(( y_mon*clip_h/100 ))
max_x=$((x_mon - clip_w - 5 )) #offset of 5 for gaps
max_y=$((y_mon - clip_h - 15 )) #offset of 15 for gaps
x_cur=$((x_cur - x_offset))
y_cur=$((y_cur - y_offset))
# 
x_cur=$(( x_cur < min_x ? min_x : ( x_cur > max_x ? max_x :  x_cur)))
y_cur=$(( y_cur < min_y ? min_y : ( y_cur > max_y ? max_y :  y_cur)))

pos="window {location: north west; x-offset: ${x_cur}px; y-offset: ${y_cur}px;}" #! I just Used the old pos function
#pos="window {location: $y_rofi $x_rofi; $x_offset $y_offset}" 

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
    *)  echo -e "cliphist.sh [action]"
        echo "c :  cliphist list and copy selected"
        echo "d :  cliphist list and delete selected"
        echo "w :  cliphist wipe database"
        exit 1
        ;;
esac

