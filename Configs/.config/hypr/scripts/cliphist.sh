#!/usr/bin/env sh
roconf="~/.config/rofi/clipboard.rasi"

case $1 in
    c)  cliphist list | rofi -dmenu -theme-str 'entry { placeholder: "Copy...";}' -config $roconf | cliphist decode | wl-copy
        ;; 
    d)  cliphist list | rofi -dmenu -theme-str 'entry { placeholder: "Delete...";}' -config $roconf | cliphist delete
        ;;
    w)  if [ `echo -e "Yes\nNo" | rofi -dmenu -theme-str 'entry { placeholder: "Clear Clipboard History?";}' -config $roconf` == "Yes" ] ; then
            cliphist wipe
        fi
        ;;
    t)  echo ""
        echo "󰅇 clipboard history"
        ;;
    *)  echo "cliphist.sh [action]"
        echo "c :  cliphist list and copy selected"
        echo "d :  cliphist list and delete selected"
        echo "w :  cliphist wipe database"
        echo "t :  display tooltip"
        ;;
esac

