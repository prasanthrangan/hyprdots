#!/usr/bin/env sh

██╗  ██╗██╗██╗  ██╗███╗   ██╗ ██████╗ 
██║ ██╔╝██║██║  ██║████╗  ██║██╔════╝ 
█████╔╝ ██║███████║██╔██╗ ██║██║  ███╗
██╔═██╗ ██║██╔══██║██║╚██╗██║██║   ██║
██║  ██╗██║██║  ██║██║ ╚████║╚██████╔╝
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
 


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
   
         5) # Follow mouse cursor
   
# get the current mouse cursor positionx_mon=$( cat /sys/class/drm/*/modes | head -1  ) 
x_mon=$(cat /sys/class/drm/*/modes | head -1)
y_mon=$(echo $x_mon | cut -d 'x' -f 2)
x_mon=$(echo $x_mon | cut -d 'x' -f 1)

x_subtract_percent=60   # percent to limit screen resolution for x
y_subtract_percent=77    # percent to subtract resolution for y 
x_offset=10                # will spawn on 0x0 north west on rofi
y_offset=-270               # set this if you want to determine part fo the window your cursor will be

# Define the values to subtract from x_mon and y_mon
x_subtract_value=$((x_mon * x_subtract_percent / 100))
y_subtract_value=$((y_mon * y_subtract_percent / 100))

#x_subtract_value=1800   # Replace with the desired value to subtract from x_mon
#y_subtract_value=1530   # Replace with the desired value to subtract from y_mon

# Subtract the specified values from x_mon and y_mon to calculate the maximum x and y boundaries
max_x=$((x_mon - x_subtract_value))
max_y=$((y_mon - y_subtract_value))

cursor_pos=$(hyprctl cursorpos)
cursor_x=${cursor_pos%,*}
cursor_y=${cursor_pos#*,}

# Offset where you want your cursor to spawn on rofi clipboard

# Limit the cursor_x and cursor_y values
cursor_x=$((cursor_x + x_offset))
cursor_x=$((cursor_x < min_x ? min_x : (cursor_x > max_x ? max_x : cursor_x)))

cursor_y=$((cursor_y + y_offset))
cursor_y=$((cursor_y < min_y ? min_y : (cursor_y > max_y ? max_y : cursor_y)))

# Construct the position string based on the mouse cursor's position
pos="window {location: north west; anchor: north west; x-offset: ${cursor_x}px; y-offset: ${cursor_y}px;}"

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

