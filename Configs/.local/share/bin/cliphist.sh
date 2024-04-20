#!/usr/bin/env sh


#// set variables

scrDir=$(dirname "$(realpath "$0")")
source $scrDir/globalcontrol.sh
roconf="${confDir}/rofi/clipboard.rasi"


#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)


#// evaluate spawn position

readarray -t curPos < <(hyprctl cursorpos -j | jq -r '.x,.y')
readarray -t monRes < <(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width,.height')
readarray -t layRes < <(hyprctl -j monitors | jq -r '.[] | select(.focused==true).reserved | map(tostring) | join("\n")')

if [ "${curPos[0]}" -ge "$((${monRes[0]} / 2))" ] ; then
    x_pos="east"
    x_lay=${monRes[0]}
    x_off="-$(( ${monRes[0]} - ${curPos[0]} - ${layRes[2]} ))"
else
    x_pos="west"
    x_off="$(( ${curPos[0]} - ${layRes[0]} ))"
fi

if [ "${curPos[1]}" -ge "$((${monRes[1]} / 2))" ] ; then
    y_pos="south"
    y_off="-$(( ${monRes[1]} - ${curPos[1]} - ${layRes[3]} ))"
else
    y_pos="north"
    y_off="$(( ${curPos[1]} - ${layRes[1]} ))"
fi

pos_override="window{location:${x_pos} ${y_pos};anchor:${x_pos} ${y_pos};x-offset:${x_off}px;y-offset:${y_off}px;border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"


#// clipboard action

case "${1}" in
c|-c|--copy)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";}" -theme-str "${r_scale}" -theme-str "${pos_override}" -config "${roconf}" | cliphist decode | wl-copy
    ;;
d|-d|--delete)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";}" -theme-str "${r_scale}" -theme-str "${pos_override}" -config "${roconf}" | cliphist delete
    ;;
w|-w|--wipe)
    if [ $(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";}" -theme-str "${r_scale}" -theme-str "${pos_override}" -config "${roconf}") == "Yes" ] ; then
        cliphist wipe
    fi
    ;;
*)
    echo -e "cliphist.sh [action]"
    echo "c -c --copy    :  cliphist list and copy selected"
    echo "d -d --delete  :  cliphist list and delete selected"
    echo "w -w --wipe    :  cliphist wipe database"
    exit 1
    ;;
esac

