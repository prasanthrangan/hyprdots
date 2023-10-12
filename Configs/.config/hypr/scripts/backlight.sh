#!/usr/bin/env bash

# Get brightness
get_backlight() {
	LIGHT=$(printf "%.0f\n" $(brightnessctl i))
	echo "${LIGHT}%"
}

# Get icons
get_icon() {
	backlight="$(brightnessctl g)"
	current="${backlight%%%}"
	if [[ ("$current" -ge "0") && ("$current" -le "52") ]]; then
		icon="$iDIR/brightness-20.png"
	elif [[ ("$current" -ge "52") && ("$current" -le "103") ]]; then
		icon="$iDIR/brightness-40.png"
	elif [[ ("$current" -ge "103") && ("$current" -le "155") ]]; then
		icon="$iDIR/brightness-60.png"
	elif [[ ("$current" -ge "155") && ("$current" -le "207") ]]; then
		icon="$iDIR/brightness-80.png"
	elif [[ ("$current" -ge "180") && ("$current" -le "255") ]]; then
		icon="$iDIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$icon" "Brightness : $(brightnessctl g)"
}

# Increase brightness
inc_backlight() {
	brightnessctl set 10%+ && get_icon && notify_user
}

# Decrease brightness
dec_backlight() {
	brightnessctl set 10%- && get_icon && notify_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	brightnessctl g
elif [[ "$1" == "--inc" ]]; then
	inc_backlight
elif [[ "$1" == "--dec" ]]; then
	dec_backlight
else
	get_backlight
fi
