#!/bin/bash

# Check if the system is a laptop
is_laptop() {
    if [ -d /sys/class/power_supply/ ]; then
        for supply in /sys/class/power_supply/*; do
            if [ -e "$supply/type" ]; then
                type=$(cat "$supply/type")
                if [ "$type" == "Battery" ]; then
                    return 0  # It's a laptop
                fi
            fi
        done
    fi
    return 1  # It's not a laptop
}

if is_laptop; then
    while true; do
        for battery in /sys/class/power_supply/BAT*; do
            battery_status=$(cat "$battery/status")
            battery_percentage=$(cat "$battery/capacity")

            if [ "$battery_status" == "Discharging" ] && [ "$battery_percentage" -le 20 ]; then
                dunstify -u CRITICAL "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
            fi

            if [ "$battery_status" == "Charging" ] && [ "$battery_percentage" -ge 80 ]; then
                dunstify -u NORMAL "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger."
            fi
        done
        sleep 300  # Sleep for 5 minutes before checking again
    done
fi

