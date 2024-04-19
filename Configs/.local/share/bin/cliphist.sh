#!/usr/bin/env sh

scrDir=$(dirname "$(realpath "$0")")
source $scrDir/globalcontrol.sh
roconf="${confDir}/rofi/clipboard.rasi"

# set position
x_offset=${clipXoffset:--15} #* Cursor spawn position on clipboard
y_offset=${clipYoffset:-210} #* To point the Cursor to the 1st and 2nd latest word

# Monitor resolution , scale and rotation
eval "$(hyprctl monitors -j | jq -r \
    ' .[] | select(.focused==true) | 
 (if (.transform | (. % 2) == 1) then
   {monWidth: (.height / .scale | floor), monHeight: (.width / .scale | floor)}
 else
   {monWidth: (.width / .scale | floor), monHeight: (.height / .scale | floor)}
 end) as $dims |
"export monName=\(.name);
export monWidth=\($dims.monWidth);
export monHeight=\($dims.monHeight);
export monXpos=\(.x | floor);
export monYpos=\(.y | floor);
"')"

# Level 1 layers  e.g namespace for  waybar, for now just waybar \\ ensures that we can get a good boundary value
# TODO Handle if we got multple waybar location
wBar=0
hBar=0
eval "$(hyprctl layers -j | jq -r --arg mon "$monName" '.[$mon].levels | .[] | .[] | select(.namespace == "waybar") | if .h < .w then "export export hBar=$((\(.h) + $hBar ))" else "export wBar=$((\(.w) + $wBar ))" end')"

#  Cursor position filtered by Monitor stats
eval "$(hyprctl cursorpos -j | jq -r \
    --argjson x_offset "$x_offset" \
    --argjson y_offset "$y_offset" \
    --argjson monXpos "$monXpos" \
    --argjson monYpos "$monYpos" \
    '"
export curXpos=\(.x - $monXpos - $x_offset )
export curYpos=\(.y - $monYpos - $y_offset)
"')"

# TODO Dynamically follow the rofi scaling if .rasi changes
# Limit board location to monitor
wBoard=${wBoard:-300}
hBoard=${hBoard:-550}
xBound=$((monWidth - wBoard - wBar))
yBound=$((monHeight - hBoard - hBar))
curXpos=$((curXpos - x_offset))
curYpos=$((curYpos - y_offset))

curXpos=$((curXpos < 0 ? 0 : (curXpos > xBound ? xBound : curXpos)))
curYpos=$((curYpos < 0 ? 0 : (curYpos > yBound ? yBound : curYpos)))

# position override
pos="window {location: north west; x-offset: ${curXpos}px; y-offset: ${curYpos}px;}"

# read hypr theme border
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} entry {border-radius: ${elem_border}px;} element {border-radius: ${elem_border}px;}"

# read hypr font size
fnt_override=$(gsettings get org.gnome.desktop.interface monospace-font-name | awk '{gsub(/'\''/,""); print $NF}')
fnt_override="configuration {font: \"JetBrainsMono Nerd Font ${fnt_override}\";}"

# clipboard action
case $1 in
c)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config $roconf | cliphist decode | wl-copy
    ;;
d)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config $roconf | cliphist delete
    ;;
w)
    if [ $(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config $roconf) == "Yes" ]; then
        cliphist wipe
    fi
    ;;
*)
    echo -e "cliphist.sh [action]"
    echo "c :  cliphist list and copy selected"
    echo "d :  cliphist list and delete selected"
    echo "w :  cliphist wipe database"
    exit 1
    ;;
esac
