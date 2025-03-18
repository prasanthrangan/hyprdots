#!/usr/bin/env sh

# Check if the script is already running
pgrep -cf "${0##*/}" | grep -qv 1 && echo "An instance of the script is already running..." && exit 1

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh

# Check if SwayOSD is installed
use_swayosd=false
if command -v swayosd-client >/dev/null 2>&1 && pgrep -x swayosd-server >/dev/null; then
    use_swayosd=true
fi

print_error()
{
cat << EOF
    $(basename ${0}) <action> [step] [mode]
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]

    Example:
        $(basename ${0}) i 10    # Increase brightness by 10%
        $(basename ${0}) d       # Decrease brightness by default step (5%)
        $(basename ${0}) i 5 -q  # Increase brightness by 5% quietly
EOF
}
notify="${waybar_brightness_notification:-true}"  # Default: notifications are enabled
action=""     # Will store 'increase' or 'decrease'
step=5        # Default step value

# Parse all arguments
for arg in "$@"; do
    case $arg in
        i|-i)   
            [ -n "$action" ] && 
                { 
                    echo -e "\033[38;2;255;0;0mOne or more actions are provided\033[0m"; 
                    print_error; 
                    exit 1; 
                }                       # Prevent multiple actions
            action="increase" ;;        # Increase brightness
        d|-d)  
            [ -n "$action" ] && 
                { 
                    echo -e "\033[38;2;255;0;0mOne or more actions are provided\033[0m"; 
                    print_error; 
                    exit 1; 
                }                       # Prevent multiple actions
            action="decrease" ;;        # Decrease brightness
        q|-q)  
            notify=false ;;             # Disabling notification
        [0-9]*)  
            if ! echo "$arg" | grep -Eq '^[0-9]+$'; then
                print_error
                exit 1
            fi
            step=$arg ;;                # Step value
        *)      
            print_error && exit 1 ;;    # Invalid input
    esac
done

if [ -z "$action" ]; then               # If actions are missing with mode/value
    echo -e "\033[38;2;255;0;0mActions are not provided\033[0m"
    print_error
    exit 1
fi

send_notification() {
    brightness=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
    brightinfo=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')
    angle="$(((($brightness + 2) / 5) * 5))"
    ico="$HOME/.config/dunst/icons/vol/vol-${angle}.svg"
    bar=$(seq -s "." $(($brightness / 15)) | sed 's/[0-9]//g')
    notify-send -a "t2" -r 91190 -t 800 -i "${ico}" "${brightness}${bar}" "${brightinfo}"
}

get_brightness() {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}


case $action in
increase) # increase the backlight
    if [[ $(get_brightness) -lt 10 ]] ; then
        # increase the backlight by 1% if less than 10%
        step=1
    fi

    $use_swayosd && swayosd-client --brightness raise "$step" && exit 0
    brightnessctl set +${step}%
    [ "$notify" = true ] && send_notification ;;
decrease) # decrease the backlight

    if [[ $(get_brightness) -le 10 ]] ; then
        # decrease the backlight by 1% if less than 10%
        step=1
    fi

    if [[ $(get_brightness) -le 1 ]]; then
        brightnessctl set ${step}%
        $use_swayosd && exit 0
    else
        $use_swayosd && swayosd-client --brightness lower "$step" && exit 0
        brightnessctl set ${step}%-
    fi

    [ "$notify" = true ] && send_notification ;;
esac
