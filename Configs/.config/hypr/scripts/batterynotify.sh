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
fn_notify () { # Send notification
    notify-send -t 5000 $1 -u $2 "$3" "$4" # Call the notify-send command with the provided arguments \$1 is the flags \$2 is the urgency \$3 is the title \$4 is the message
}
fn_percentage () {
                    if [[ "$battery_percentage" -ge "$unplug_charger_threshold" ]] && (( (battery_percentage - last_notified_percentage) >= 1 )); then
                        fn_notify  "-r 10" "CRITICAL" "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger."
                        last_notified_percentage=$battery_percentage
                    elif [[ "$battery_percentage" -le "$battery_critical_threshold" ]]; then
                        count=$(( countdown > 60 ? countdown : 60 )) # reset count
                        while [ $count -gt 0 ] && [[ $battery_status == "Discharging"* ]]; do
for battery in /sys/class/power_supply/BAT*; do  battery_status=$(< "$battery/status") ; done
if [[ $battery_status != "Discharging" ]] ; then break ; fi
                            fn_notify "-r 10" "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will $action in $((count/60)):$((count%60)) ."
                            count=$((count-1))
                            sleep 1
                            #battery_status="Charging"
                        done
                        [ $count -eq 0 ] && fn_action
                    elif [[ "$battery_percentage" -le "$battery_low_threshold" ]] && (( (last_notified_percentage - battery_percentage) >= 1 )); then
                        fn_notify  "-r 10" "CRITICAL" "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
                        last_notified_percentage=$battery_percentage
                    fi
}
fn_action () {
count=$(( countdown > 60 ? countdown : 60 )) # reset count
nohup systemctl $action
}
fn_status () { # Handle the power supply status
for battery in /sys/class/power_supply/BAT*; do  battery_status=$(< "$battery/status")  battery_percentage=$(< "$battery/capacity")
#echo $battery_status $battery_percentage
case "$battery_status" in         # Handle the power supply status
                "Discharging")
                    if [[ "$prev_status" == "Charging" ]]; then
                        prev_status=$battery_status
                        urgency=$([[ $battery_percentage -le "$battery_low_threshold" ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify   "-r 10" "$urgency" "Charger Plug OUT" "Battery is at $battery_percentage%."
                    fi
                    fn_percentage 
                    ;;
                "Charging")                     
                    if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Not"* ]]; then
                        prev_status=$battery_status
                        count=$(( countdown > 60 ? countdown : 60 )) # reset count
                        urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify  "-r 10" "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    fn_percentage 
                    ;;
                "Full")
                    fn_notify  "-r 10" "CRITICAL" "Battery Full" "Please unplug your Charger"                    
                    ;;
                "Not charging"|"Not Charging"|"Not")
                    if [[ ! -f "/tmp/hyprdots.batterynotify.status.$battery_status-$$" ]]; then
                    touch "/tmp/hyprdots.batterynotify.status.$battery_status-$$"
                    count=$(( countdown > 60 ? countdown : 60 )) # reset count                    
                    echo "Status: '==>> "$battery_status" <<==' Device Reports Not Charging!,This may be device Specific errors.Please copy this line and raise an issue to the Github Repo.Also run 'ls /tmp/hyprdots.batterynotify' to see the list of lock files.*"
                    fn_notify  "-r 10" "CRITICAL" "Charger Plug In" "Battery is at $battery_percentage%."
                    else
                    if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Charging" ]]; then
                        prev_status=$battery_status
                        count=$(( countdown > 60 ? countdown : 60 )) # reset count
                        urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify  "-r 10" "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    fi    
                    fn_percentage                    
                    ;;                                       
                    "*")
                    if [[ ! -f "/tmp/hyprdots.batterynotify.status.fallback.$battery_status-$$" ]]; then
                    echo "Status: '==>> "$battery_status" <<==' Script on Fallback mode,Unknown power supply status.Please copy this line and raise an issue to the Github Repo.Also run 'ls /tmp/hyprdots.batterynotify' to see the list of lock files.*"
                    touch "/tmp/hyprdots.batterynotify.status.fallback.$battery_status-$$"
                    fi     
                    fn_percentage 
                    ;;
            esac
        done
}
main() { # Main function
    if is_laptop; then
        fn_status  # initiate the function
        last_notified_percentage=$battery_percentage
        prev_status=$battery_status
        dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',path='$(upower -e | grep battery)'" 2> /dev/null | while read -r battery_status_change; do fn_status  ; done
    fi
}
main