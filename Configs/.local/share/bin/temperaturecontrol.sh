#!/usr/bin/env sh

# # Causing bottleneck don't use
# Check if the script is already running
# if pgrep -cf "${0##*/}" | grep -qv 1; then
#     echo "An instance of the script is already running..."
#     exit 1
# fi

# Check if hyprsunset is running
HYPRSUNSET_PID=$(pgrep -x hyprsunset)
# Path to the temperature configuration file
CONFIG_FILE="$HOME/.config/hypr/hyprsunset.json"
# notification variable set to true as default with env variable
notify="${waybar_temperature_notification:-true}" 
# Default temperature if file is missing
DEFAULT_TEMP=6500
# Amount to increase/decrease per scroll
TEMP_STEP=500  
# Default action
action=""
message=""
# Minimum and max temp
MIN_TEMP=1000
MAX_TEMP=10000

# If a temperature file doesn't exist, create one with default
if [ ! -f "$CONFIG_FILE" ]; then
    echo "{\"temp\": $DEFAULT_TEMP, \"user\": 1}" > "$CONFIG_FILE"
fi

# Print generic error
print_error()
{
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

send_notification() {
    ico="$HOME/.config/dunst/icons/therm.svg"
    notify-send -a "t2" -r 91192 -t 800 -i "${ico}" "$message"
}

check_range() {
    # Clamping temperature between valid ranges
    if [ "$new_temp" -lt "$MIN_TEMP" ]; then
        new_temp=$MIN_TEMP
    elif [ "$new_temp" -gt "$MAX_TEMP" ]; then
        new_temp=$MAX_TEMP
    fi
    message="Temperature: $new_temp"
    jq ".temp = $new_temp" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    
}

# Adjust temperature based on input
for arg in "$@"; do
    case $arg in
        i|-i)   
            [ -n "$action" ] && 
                { 
                    echo -e "\033[38;2;255;0;0mOne or more actions are provided\033[0m"; 
                    print_error; 
                    exit 1; 
                }                       # Prevent multiple actions
            action="increase" ;;        # Increase temperature
        d|-d)  
            [ -n "$action" ] && 
                { 
                    echo -e "\033[38;2;255;0;0mOne or more actions are provided\033[0m"; 
                    print_error; 
                    exit 1; 
                }                       # Prevent multiple actions
            action="decrease" ;;        # Decrease temperature
        r|-r) 
            [ -n "$action" ] && 
                { 
                    echo -e "\033[38;2;255;0;0mOne or more actions are provided\033[0m"; 
                    print_error; 
                    exit 1; 
                }                       # Prevent multiple actions
            action="read" ;;            # Read temperature
        t|-t) 
            [ -n "$action" ] && 
                { 
                    echo -e "\033[38;2;255;0;0mOne or more actions are provided\033[0m"; 
                    print_error; 
                    exit 1; 
                }                       # Prevent multiple actions
            action="toggle" ;;          # Toggle mode
        q|-q)  
            notify=false ;;             # Disabling notification
        [0-9]*)
            TEMP_STEP=$arg ;;           # Taking numerical step
        *)        
            print_error && exit 1 ;;    # Invalid input
    esac
done

# Read current temperature
current_temp=$(jq '.temp' "$CONFIG_FILE")
[ -z "$current_temp" ] && current_temp=$DEFAULT_TEMP
toggle_mode=$(jq '.user' "$CONFIG_FILE")
[ -z "$toggle_mode" ] && toggle_mode=0

# If actions are missing with mode
if [ -z "$action" ]; then               
    echo -e "\033[38;2;255;0;0mActions are not provided\033[0m"
    print_error
    exit 1
fi

case $action in
    increase) # increase the temperature
        # if mode is set then update temperature value
        if [ "$toggle_mode" = "1" ]; then
            new_temp=$((current_temp + TEMP_STEP))
            check_range
        fi
        ;;
    decrease) # decrease the temperature
        # if mode is set then update temperature value
        if [ "$toggle_mode" = "1" ]; then
            new_temp=$((current_temp - TEMP_STEP)) 
            check_range
        fi
        ;;
    read) # read the temperature
        new_temp=$current_temp
        message="Temperature: $new_temp"
        ;;
    toggle) # toggle the temperature mode
        if [ "$toggle_mode" = "1" ]; then
            new_temp=$DEFAULT_TEMP
            message="Sunset mode off"
        else
            new_temp=$current_temp
            message="Temperature: $new_temp"
        fi
        new_toggle_mode=$((1 - toggle_mode))
        # Setting/Unsetting user flag
        jq ".user = $new_toggle_mode" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE" 
        ;;
esac

if [ "$toggle_mode" = "1" ]; then
    echo "{\"alt\":\"active\",\"tooltip\":\"Sunset mode active\"}"
else
    echo "{\"alt\":\"inactive\",\"tooltip\":\"Sunset mode inactive\"}"
fi

# Send notification only when quiet flag is not set
[ "$notify" = true ] && send_notification

if [ ! "$action" = "read" ]; then
    # If hyprsunset is running, kill the previous instance
    if [ -n "$HYPRSUNSET_PID" ]; then
        kill -9 $HYPRSUNSET_PID 2>/dev/null  # Used -9 for a more forceful termination
    fi

    # Start hyprsunset with the new temperature if it's not running
    if ! pgrep -x hyprsunset > /dev/null; then
        hyprsunset --temperature "$new_temp" > /dev/null &
    fi
fi