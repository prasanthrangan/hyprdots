#!/bin/bash
is_number_in_range() { local num=$1 local min=$2 local max=$3 ;  [[ $num =~ ^[0-9]+$ ]] && (( num >= min && num <= max )) }
# Parse command-line arguments

while (( "$#" )); do mnc=1 mxc=20 mxl=50 mxu=100 mnt=100 mxt=1000 mnu=50 mnl=20
  case "$1" in
    "--critical"|"-c")
      if is_number_in_range "$2" $mnc $mxc; then
        battery_critical_threshold=$2
        shift 2
      else
        echo "Error: $1 must be a number between $mnc - $mxc." >&2
        exit 1
      fi
;;
    "--low"|"-l")
      if is_number_in_range "$2" $mnl $mnu; then
        battery_low_threshold=$2
        shift 2
      else
        echo "Error: $1 must be a number between $mnl - $mnu." >&2
        exit 1
      fi
      ;;

    "--unplug"|"-u")
      if is_number_in_range "$2" $mnu $mxu; then
        unplug_charger_threshold=$2
        shift 2
      else
        echo "Error: $1 must be a number between $mnu $mxu." >&2
        exit 1
      fi
      ;;
    "--timer"|"-t")
      if is_number_in_range "$2" $mnt $mxt; then
        countdown=$2
        shift 2
      else
        echo "Error: $1 must be a number between $mnt - $mxt." >&2
        exit 1
      fi
      ;;

"--execute"|"-e") execute=$2 ; shift 2 ;;
    *|"--help"|"-h")
      echo "Usage: $0 [options]"
      echo "  --critical, -c    Set battery critical threshold (default: 5)"
      echo "  --low, -l         Set battery low threshold (default: 10)"
      echo "  --unplug, -u      Set unplug charger threshold (default: 100)"
      echo "  --timer, -t       Set countdown timer (default: 120)"
      echo "  --execute, -e     Set action to execute (default: suspend)"
      echo "  --help, -h        Show this help message"
      exit 0
      ;;
  esac
done

# Rest of your script




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
                        count=$(( timer > 120 ? timer : 120 )) # reset countstatus
                        while [ $count -gt 0 ] && [[ $battery_status == "Discharging"* ]]; do
                        for battery in /sys/class/power_supply/BAT*; do  battery_status=$(< "$battery/status") ; done
                        if [[ $battery_status != "Discharging" ]] ; then break ; fi
                            fn_notify "-r 10" "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will execute $execute in $((count/60)):$((count%60)) ."
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
count=$(( timer > 120 ? timer : 120 )) # reset count
nohup systemctl $execute
}
fn_status () { # Handle the power supply status
for battery in /sys/class/power_supply/BAT*; do  battery_status=$(< "$battery/status")  battery_percentage=$(< "$battery/capacity")
#battery_status="Not Charging"
#echo $battery_status $battery_percentage
case "$battery_status" in         # Handle the power supply status
                "Discharging")
                    if [[ "$prev_status" == *"Charging"* ]]; then
                        prev_status=$battery_status
                        urgency=$([[ $battery_percentage -le "$battery_low_threshold" ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify   "-r 10" "$urgency" "Charger Plug OUT" "Battery is at $battery_percentage%."
                    fi
                    fn_percentage 
                    ;;
                "Charging")                     
                    if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Not"* ]]; then
                        prev_status=$battery_status
                        count=$(( timer > 120 ? timer : 120 )) # reset count
                        urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify  "-r 10" "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    fn_percentage 
                    ;;
                "Full")
                    fn_notify  "-r 10" "CRITICAL" "Battery Full" "Please unplug your Charger"                    
                    ;;
                "Not charging"|"Not Charging"|*"Not"*)
                    if [[ ! -f "/tmp/hyprdots.batterynotify.status.$battery_status-$$" ]]; then
                    touch "/tmp/hyprdots.batterynotify.status.$battery_status-$$"
                    count=$(( timer > 120 ? timer : 120 )) # reset count                    
                    echo "Status: '==>> "$battery_status" <<==' Device Reports Not Charging!,This may be device Specific errors.Please copy this line and raise an issue to the Github Repo.Also run 'ls /tmp/hyprdots.batterynotify' to see the list of lock files.*"
                    fn_notify  "-r 10" "CRITICAL" "Charger Plug In" "Battery is at $battery_percentage%."
                    else
                    if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Charging" ]]; then
                        prev_status=$battery_status
                        count=$(( timer > 120 ? timer : 120 )) # reset count
                        urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify  "-r 10" "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    fi    
                    fn_percentage                    
                    ;;                                       
                    *)
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
        battery_critical_threshold=${battery_critical_threshold:-5}
    unplug_charger_threshold=${unplug_charger_threshold:-100}
    battery_low_threshold=${battery_low_threshold:-10}
    timer=${timer:-120}
    execute=${execute:-"systemctl suspend"}
cat <<  EOF
Script is running... 
Check $0 --help for options. 

      Critical Battery Threshold: $battery_critical_threshold
           Low Battery Threshold: $battery_low_threshold 
        Unplug Charger Threshold: $unplug_charger_threshold  

If Battery is $battery_critical_threshold%, Device will execute $execute after $timer seconds. 

If you have Errors Please Post an issue at https://github.com/prasanthrangan/hyprdots

EOF

fn_status  # initiate the function
    last_notified_percentage=$battery_percentage
    prev_status=$battery_status
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',path='$(upower -e | grep battery)'" 2> /dev/null | while read -r battery_status_change; do fn_status  ; done
    fi
}
main