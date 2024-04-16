#!/usr/bin/env sh

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
roconf="${confDir}/rofi/clipboard.rasi"

    #? Cursor position offset when pastebin is spawned
    x_offset=15   #* Cursor spawn position on clipboard
    y_offset=210   #* To point the Cursor to the 1st and 2nd latest word

    #? Parse clipboard.rasi and fetch the width. Should consider percent
    clipWidth=$(awk '/window {/,/}/' ${roconf}  | awk '/width:/ {print $2}' | awk -F "%" '{print $1}')
    clipWidth=${clipWidth:-20} #? Default
    clpHeight=$(awk '/window {/,/}/' ${roconf}  | awk '/height:/ {print $2}' | awk -F "%" '{print $1}')
    clpHeight=${clpHeight:-$((clipWidth * 100 / 36))} #? Default

    #? Monitor resolution , scale and rotation,Do maths @ json
    eval "$(hyprctl monitors -j | jq -r \
--argjson clipWidth "$clipWidth" \
--argjson clpHeight "$clpHeight" \
' .[] | select(.focused==true) | 
 (if (.transform | (. % 2) == 1) then
   {monWidth: (.height / .scale | floor), monHeight: (.width / .scale | floor)}
 else
   {monWidth: (.width / .scale | floor), monHeight: (.height / .scale | floor)}
 end) as $dims |
"export monName=\(.name);
export monTrans=\(.transform);
export monScale=\(.scale);
export monWidth=\($dims.monWidth);
export monHeight=\($dims.monHeight);
export monXpos=\(.x | floor);
export monYpos=\(.y | floor);
export clipWidth=\(if (.transform | (. % 2) == 1) then ($dims.monHeight * $clipWidth / 100 | floor) else ($dims.monWidth * $clipWidth / 100 | floor) end);
export clpHeight=\(if (.transform | (. % 2) == 1) then ($dims.monWidth * $clpHeight / 100 | floor) else ($dims.monHeight * $clpHeight / 100 | floor) end);
"')"

    #? Level 1 layers  e.g namesapce for  waybar, for now just waybar \\ ensures that we can get a good boundary value
    wbarW=0 ; wbarH=0
    eval "$(hyprctl layers -j | jq -r --arg mon "$monName" '.[$mon].levels | .[] | .[] | select(.namespace == "waybar") | if .h < .w then "export wbarH=\(.h)" else "export wbarW=$((\(.w) + $wbarW ))" end')"

    #?  Cursor position filtered by Monitor stats
    eval "$(hyprctl cursorpos -j | jq -r \
--argjson x_offset "$x_offset" \
--argjson y_offset "$y_offset" \
--argjson monWidth "$monWidth" \
--argjson monHeight "$monHeight" \
--argjson monXpos "$monXpos" \
--argjson monYpos "$monYpos" \
--arg monTrans "$monTrans" \
'"
export curXpos=\(.x - $monXpos - $x_offset )
export curYpos=\(.y - $monYpos - $y_offset)
"')"

    #? Handles Boundary
    xBound=$((monWidth - clipWidth - wbarW )) 
    yBound=$((monHeight - clpHeight - wbarH )) 
    curXpos=$(( curXpos < 0 ? 0 : ( curXpos > xBound ? xBound :  curXpos))) 
    curYpos=$(( curYpos < 0 ? 0 : ( curYpos > yBound ? yBound :  curYpos)))

    h_override="height: ${clpHeight}px; width: ${clipWidth}px;"
    pos="window {${h_override}location: north west; x-offset: ${curXpos}px; y-offset: ${curYpos}px;}" #! I just Used the old pos function
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

