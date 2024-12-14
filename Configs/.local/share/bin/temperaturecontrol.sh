#!/usr/bin/env sh
#    ___            __   __          ___       ____       
#   / _ )___  __ __/ /__/ /__ ____  / _ \___  / / /__ ____
#  / _  / _ \/ // / / _  / -_) __/ / , _/ _ \/ / / -_) __/
# /____/\___/\_,_/_/\_,_/\__/_/   /_/|_|\___/_/_/\__/_/   
#
# Set directory paths and file locations
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
sunsetConf="/tmp/hyprsunset.json"

# Default temperature settings
default=6500
step=500
min=1000
max=10000

notify="${waybar_temperature_notification:-true}"

# Ensure the configuration file exists, create it if not
if [ ! -f "$sunsetConf" ]; then
    echo "{\"temp\": $default, \"user\": 0}" > "$sunsetConf"
fi

# Read current temperature and mode from the configuration file
currentTemp=$(jq '.temp' "$sunsetConf")
toggle_mode=$(jq '.user' "$sunsetConf")
[ -z "$currentTemp" ] && currentTemp=$default
[ -z "$toggle_mode" ] && toggle_mode=1

# Notification function
send_notification() {
    [ -z "$newTemp" ] && newTemp=$default
    message="Temperature: $newTemp"
    notify-send -a "t2" -r 91192 -t 800 -i "${confDir}/dunst/icons/therm.svg" "$message"
}

#keep temp in range
clamp_temp() {
    newTemp=$1
    [ "$newTemp" -lt "$min" ] && newTemp=$min
    [ "$newTemp" -gt "$max" ] && newTemp=$max
    echo "$newTemp"
}

print_error() {
    cat << EOF
    $(basename ${0}) <action> [mode]
    ...valid actions are...
        i -- <i>ncrease screen temperature [+500]
        d -- <d>ecrease screen temperature [-500]
        r -- <r>ead screen temperature
        t -- <t>oggle temperature mode (on/off)
    Example:
        $(basename ${0}) r       # Read the temperature value
        $(basename ${0}) i       # Increase temperature by 500
        $(basename ${0}) d       # Decrease temperature by 500
        $(basename ${0}) t -q    # Toggle mode quietly
EOF
}
case "$1" in
    i) action=increase ;;
    d) action=decrease ;;
    r) action=read ;;
    t) action=toggle ;;
    *) print_error; exit 1 ;;  # If the argument is invalid, show usage and exit
esac

if [ $# -ge 1 ]; then
    if [[ "$2" == *q* ]] ; then
	notify=false
    fi
fi

# Apply action based on the selected option
case $action in
    increase) 
        [ "$toggle_mode" -eq 1 ] && newTemp=$((currentTemp + step)) && newTemp=$(clamp_temp "$newTemp") && echo "{\"temp\": $newTemp, \"user\": $toggle_mode}" > "$sunsetConf"
        ;;
    decrease) 
        [ "$toggle_mode" -eq 1 ] && newTemp=$((currentTemp - step)) && newTemp=$(clamp_temp "$newTemp") && echo "{\"temp\": $newTemp, \"user\": $toggle_mode}" > "$sunsetConf"
        ;;
    read) 
        newTemp=$currentTemp
        ;;
    toggle) 
        if [ "$toggle_mode" -eq 1 ]; then
            newTemp=$default
            jq '.user = 0' "$sunsetConf" > "${sunsetConf}.tmp" && mv "${sunsetConf}.tmp" "$sunsetConf"
        else
            newTemp=$currentTemp
            jq '.user = 1' "$sunsetConf" > "${sunsetConf}.tmp" && mv "${sunsetConf}.tmp" "$sunsetConf"
        fi
        ;;
esac

[ "$notify" = true ] && send_notification

# Start hyprsunset if necessary
if [ ! "$action" = "read" ]; then
    pkill hyprsunset
    if ! pgrep -x hyprsunset > /dev/null; then
        hyprsunset --temperature "$newTemp" > /dev/null &
    fi
fi

# Print status message

echo "{\"alt\":\"$( [ "$toggle_mode" -eq 1 ] && echo 'active' || echo 'inactive' )\", \"tooltip\":\"Sunset mode $( [ "$toggle_mode" -eq 1 ] && echo 'active' || echo 'inactive' )\"}"

