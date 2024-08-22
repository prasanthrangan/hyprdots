#!/usr/bin/env sh

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh

monitorInfo=$( ddcutil detect )
monitors=($( echo "$monitorInfo" | grep "I2C bus:" | awk -F ': ' '{print $2}' ))
model=$( echo "$monitorInfo" | grep "Model:" | awk -F ': ' '{print $2}' | head -n 1 | xargs )

function print_error
{
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function get_brightness {
    ddcutil getvcp 10 | awk -F 'current value = ' '{print $2}' | grep -o '[0-9]\+' | head -n 1
}

function send_notification {
    brightness=$(get_brightness)
    angle=$(((($brightness + 2) / 5) * 5))
    ico="$HOME/.config/dunst/icons/vol/vol-${angle}.svg"
    
    notify-send -a "t2" -r 91190 -t 800 -i "${ico}" "Brightness ${brightness}" "${model}"
}

function set_brightness {
    for v in "${monitors[@]}" ; do
        bus=$( echo $v | awk -F '-' '{print $2}' )
        
        case $1 in
        i)
            ddcutil setvcp 10 + $2 --bus=$bus
            ;;
        d)
            ddcutil setvcp 10 - $2 --bus=$bus
            ;;
        *)
            ddcutil setvcp 10 $2 --bus=$bus
            ;;
        esac
    done
}

case $1 in
i)
    if [[ $(get_brightness) -lt 10 ]] ; then
        # increase the backlight by 1% if less than 10%
        set_brightness i 1
    else
        # increase the backlight by 5% otherwise
        set_brightness i 5
    fi
    send_notification ;;
d)
    if [[ $(get_brightness) -le 2 ]] ; then
        # avoid 0% brightness
        set_brightness s 2
    elif [[ $(get_brightness) -le 10 ]] ; then
        # decrease the backlight by 1% if less than 10%
        set_brightness d 1
    else
        # decrease the backlight by 5% otherwise
        set_brightness d 5
    fi
    send_notification ;;
s)
    if [[ $2 -le 2 ]] ; then
        # avoid 0% brightness
        set_brightness s 2
    else
        set_brightness s $2
    fi
    send_notification ;;
g)
    send_notification ;;
*)
    print_error ;;
esac
