#!/usr/bin/env sh
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

# clipboard action
case $1 in
    c)  cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";} ${pos}" -config $roconf | cliphist decode | wl-copy
        ;; 
    d)  cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";} ${pos}" -config $roconf | cliphist delete
        ;;
    w)  if [ `echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";} ${pos}" -config $roconf` == "Yes" ] ; then
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

