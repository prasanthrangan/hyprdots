#!/bin/bash

# User Variables
battery_critical_threshold=10     #? Set  Battery  Critical Limit to suspend
battery_low_threshold=20    #? Set Battery Low Limit
unplug_charger_threshold=80   #? Set Max Battery Status Warning
countdown=300      #? Countdown timer ; if set to less than 60 defaults to 60 seconds
action="suspend" #? will be appended to systemctl $action


is_laptop() { # Check if the system is a laptop
    if grep -q "Battery" /sys/class/power_supply/BAT*/type; then
        return 0  # It's a laptop
    else
        exit 0  # It's not a laptop
    fi
}
send_notification() { # Send notification
    notify-send -t 5000 $1 -u $2 "$3" "$4" # Call the notify-send command with the provided arguments \$1 is the flags \$2 is the urgency \$3 is the title \$4 is the message
}
check_battery() {  # Check battery status
    echo $(cat "$1/status") $(< "$1/capacity")    # Read and echo the battery status and capacity
}
handle_action () {
count=$(( $countdown > 60 ? $countdown : 60 )) # reset count
nohup systemctl $action
}

# Handle the power supply status
handle_power_supply() {
for battery in /sys/class/power_supply/BAT*; do
        read -r battery_status battery_percentage <<< $(check_battery $battery)
case $battery_status in         # Handle the power supply status
                "Discharging")
                    if [[ "$prev_status" == "Charging" ]]; then
                        prev_status=$battery_status
                        urgency=$([[ $battery_percentage -le "$battery_low_threshold" ]] && echo "CRITICAL" || echo "NORMAL")
                        send_notification  "-r 10" "$urgency" "Charger Plug OUT" "Battery is at $battery_percentage%."
                    fi
                    # Check if battery is below critical threshold
                    if [[ "$battery_percentage" -le "$battery_critical_threshold" ]]; then
                        count=$(( $countdown > 60 ? $countdown : 60 ))
                        while [ $count -gt 0 ] && [[ "$(check_battery $battery)" != "Charging"* ]]; do
                            send_notification "-r 10" "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will $action in $((count/60)):$((count%60)) ."
                            count=$((count-1))
                            sleep 1
                        done
                        if [ $count -eq 0 ]; then
                             handle_action
                        fi
                    elif [[ "$battery_percentage" -le "$battery_low_threshold" ]] && (( (last_notified_percentage - battery_percentage) >= 1 )); then
                        send_notification "-r 10" "CRITICAL" "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
                        last_notified_percentage=$battery_percentage
                    fi
                    ;;
                "Charging")                     
                    if [[ "$prev_status" == "Discharging" ]]; then
                        prev_status=$battery_status
                        count=$(( $countdown > 60 ? $countdown : 60 )) # reset count
                        urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
                        send_notification "-r 10" "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    if [[ "$battery_percentage" -ge $unplug_charger_threshold ]] && (( (battery_percentage - last_notified_percentage) >= 1 )); then
                        send_notification "-r 10" "CRITICAL" "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger."
                        last_notified_percentage=$battery_percentage
                    fi
                    ;;
                "Full")
                    send_notification "-r 10" "CRITICAL" "Battery Full" "Please unplug your Charger"
                    ;;
                "Not Charging")
                    send_notification "-r 10" "CRITICAL" "Device Not Charging!" "Please Check your Charger or Device Temperature"
                    ;;                                       
                    *)
                   if [[ ! -f "/tmp/hyprdots.batterynotify.fallback.status.$battery_status-$$" ]]; then
                    echo "Status: '==>> "$battery_status" <<==' Script on Fallback mode,Unknown power supply status.Please copy this line and raise an issue to the Github Repo.Also run 'ls /tmp/hyprdots.batterynotify' to see the list of lock files.*"
                    touch "/tmp/hyprdots.batterynotify.fallback.status.$battery_status-$$"
                    fi               
                    #send_notification "-r 10" "CRITICAL" "Unknown power supply status." "Please raise an issue to the Github Repo(You will only see this once after boot)"
                    if [[ "$battery_percentage" -ge $unplug_charger_threshold ]] && (( (battery_percentage - last_notified_percentage) >= 1 )); then
                        send_notification "-r 10" "CRITICAL" "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger."
                        last_notified_percentage=$battery_percentage
                    elif [[ "$battery_percentage" -le "$battery_critical_threshold" ]]; then
                        count=$(( $countdown > 60 ? $countdown : 60 ))
                        while [ $count -gt 0 ] && [[ "$(check_battery $battery)" != "Charging"* ]]; do
                            send_notification "-r 10" "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will $action in $((count/60)):$((count%60)) ."
                            count=$((count-1))
                            sleep 1
                        done
                        [ $count -eq 0 ] && handle_action
                    elif [[ "$battery_percentage" -le "$battery_low_threshold" ]] && (( (last_notified_percentage - battery_percentage) >= 1 )); then
                        send_notification "-r 10" "CRITICAL" "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
                        last_notified_percentage=$battery_percentage
                    fi
                    ;;
            esac
        done
}
main() { # Main function
    if is_laptop; then
        handle_power_supply # initiate the function
        last_notified_percentage=$battery_percentage
        prev_status=$battery_status
        dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',path='$(upower -e | grep battery)'" 2> /dev/null | while read -r battery_status_change; do handle_power_supply ; done
    fi
}
main
