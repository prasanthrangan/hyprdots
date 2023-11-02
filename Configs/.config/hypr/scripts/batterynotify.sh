#!/bin/bash
in_range() { local num=$1 local min=$2 local max=$3 ;  [[ $num =~ ^[0-9]+$ ]] && (( num >= min && num <= max )) }
mnc=5 mxc=20 mnl=20 mnu=50 mxl=50 mxu=100 mnt=60 mxt=1000 #Defaults Ranges
while (( "$#" )); do  # Parse command-line arguments and defaults  
  case "$1" in
"--critical"|"-c") if in_range "$2" $mnc $mxc; then battery_critical_threshold=$2 ; shift 2 ; else echo "Error: $1 must be a number between $mnc - $mxc." >&2 ; exit 1 ; fi;;
"--low"|"-l") if in_range "$2" $mnl $mnu; then battery_low_threshold=$2 ; shift 2 ; else echo "Error: $1 must be a number between $mnl - $mnu." >&2 ; exit 1 ; fi;;
"--unplug"|"-u") if in_range "$2" $mnu $mxu; then unplug_charger_threshold=$2 ; shift 2 ; else echo "Error: $1 must be a number between $mnu $mxu." >&2 ; exit 1 ; fi;;
"--timer"|"-t") if in_range "$2" $mnt $mxt; then timer=$2 ; shift 2 ; else echo "Error: $1 must be a number between $mnt - $mxt." >&2 ; exit 1 ; fi;;
"--execute"|"-e") execute=$2 ; shift 2 ;;
    *|"--help"|"-h")
      echo "Usage: $0 [options]"
      echo "  --critical, -c    Set battery critical threshold (default: $mnc)"
      echo "  --low, -l         Set battery low threshold (default: $mnl)"
      echo "  --unplug, -u      Set unplug charger threshold (default: $mxu)"
      echo "  --timer, -t       Set countdown timer (default: $mnt)"
      echo "  --execute, -e     Set command/script to execute if battery on critical threshold (default: systemctl suspend)"
      echo "  --help, -h        Show this help message
      Visit https://github.com/prasanthrangan/hyprdots for the Github Repo"
      exit 0
      ;;
  esac
done
is_laptop() { # Check if the system is a laptop
    if grep -q "Battery" /sys/class/power_supply/BAT*/type; then
        return 0  # It's a laptop
    else
    echo "Cannot Detect a Battery. If this seems an error please report an issue to https://github.com/prasanthrangan/hyprdots."
        exit 0  # It's not a laptop
    fi
}
fn_notify () { # Send notification
    notify-send  $1 -u $2 "$3" "$4" # Call the notify-send command with the provided arguments \$1 is the flags \$2 is the urgency \$3 is the title \$4 is the message
}
fn_percentage () {
                    if [[ "$battery_percentage" -ge "$unplug_charger_threshold" ]] &&  [[ "$battery_status" != "Discharging" ]]  && (( (battery_percentage - last_notified_percentage) >= 2 )); then
                        fn_notify  "-t 5000 -r 10" "CRITICAL" "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger!"
                        last_notified_percentage=$battery_percentage
                    elif [[ "$battery_percentage" -le "$battery_critical_threshold" ]]; then
                        count=$(( timer > $mnt ? timer :  $mnt )) # reset count
                        while [ $count -gt 0 ] && [[ $battery_status == "Discharging"* ]]; do
                        for battery in /sys/class/power_supply/BAT*; do  battery_status=$(< "$battery/status") ; done
                        if [[ $battery_status != "Discharging" ]] ; then break ; fi
                            fn_notify "-t 5000 -r 10" "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will execute $execute in $((count/60)):$((count%60)) ."
                            count=$((count-1))
                            sleep 1  
                        done
                        [ $count -eq 0 ] && fn_action
                    elif [[ "$battery_percentage" -le "$battery_low_threshold" ]] && [[ "$battery_status" == "Discharging" ]] && (( (last_notified_percentage - battery_percentage) >= 2 )); then
                        fn_notify  "-t 5000 -r 10" "CRITICAL" "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
                        last_notified_percentage=$battery_percentage
                    fi
}
fn_action () { #handles the $execute command
                  count=$(( timer > $mnt ? timer :  $mnt )) # reset count
                  nohup $execute
}
fn_status () { # Handle the power supply status
for battery in /sys/class/power_supply/BAT*; do  battery_status=$(< "$battery/status")  battery_percentage=$(< "$battery/capacity")
case "$battery_status" in         # Handle the power supply status
                "Discharging")
                    if [[ "$prev_status" == *"Charging"* ]] || [[ "$prev_status" == "Full" ]] ; then 
                        prev_status=$battery_status
                        urgency=$([[ $battery_percentage -le "$battery_low_threshold" ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify   "-t 5000 -r 10" "$urgency" "Charger Plug OUT" "Battery is at $battery_percentage%."
                    fi
                    fn_percentage 
                    ;;
                "Not"*|"Charging") # Due to modifications of some devices Not Charging after reaching 99 or limits
                    if [[ ! -f "/tmp/hyprdots.batterynotify.status.$battery_status-$$" ]] && [[ "$battery_status" == "Not"* ]] ; then 
                    touch "/tmp/hyprdots.batterynotify.status.$battery_status-$$"
                    count=$(( timer > $mnt ? timer :  $mnt )) # reset count                    
                    echo "Status: '==>> "$battery_status" <<==' Device Reports Not Charging!,This may be device Specific errors."
                    fn_notify  "-t 5000 -r 10" "CRITICAL" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Not"* ]] ; then
                        prev_status=$battery_status
                        count=$(( timer > $mnt ? timer :  $mnt )) # reset count
                        urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
                        fn_notify  "-t 5000 -r 10" "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
                    fi
                    fn_percentage 
                    ;;
                "Full") now=$(date +%s) 
                    if [[ "$prev_status" == *"harging"* ]] || ((now - lt >= 600)); then fn_notify "-t 5000 -r 10" "CRITICAL" "Battery Full" "Please unplug your Charger"
                    prev_status=$battery_status lt=$now
                    fi
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
rm -fr /tmp/hyprdots.batterynotify* # Cleaning the lock file
battery_critical_threshold=${battery_critical_threshold:-$mnc} 
unplug_charger_threshold=${unplug_charger_threshold:-$mxu}
battery_low_threshold=${battery_low_threshold:-$mnl}
timer=${timer:-$mnt}
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