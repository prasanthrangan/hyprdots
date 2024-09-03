#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')


if [ $HYPRGAMEMODE = 1 ]; then
  echo 'windowrulev2 = opacity 1.00 1.00,class:^(.*)$' > "$HOME/.config/hypr/opaque.conf"
  # Sleep needed since this change will automatically reload hyprland
	sleep 1
fi

# Waybar performance
FILE="$HOME/.config/waybar/style.css"

sed -i 's/\/\* \(.*animation:.*\) \*\//\1/g' $FILE
sed -i 's/\/\* \(.*transition:.*\) \*\//\1/g' $FILE
if [ $HYPRGAMEMODE = 1 ]; then
	sed -i 's/^\(.*animation:.*\)$/\/\* \1 \*\//g' $FILE
	sed -i 's/^\(.*transition:.*\)$/\/\* \1 \*\//g' $FILE
fi
killall waybar
waybar >/dev/null 2>&1 &

# Hyprland performance
if [ $HYPRGAMEMODE = 1 ]; then
	hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
	exit
else
	echo "" > "$HOME/.config/hypr/opaque.conf"
	hyprctl reload
fi
