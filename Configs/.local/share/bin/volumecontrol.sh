#!/usr/bin/env sh

scrDir=$(dirname "$(realpath "$0")")
source $scrDir/globalcontrol.sh

# define functions

print_error() {
    cat <<"EOF"
    ./volumecontrol.sh -[device] <actions>
    ...valid device are...
        i   -- input device
        o   -- output device
        p   -- player application
    ...valid actions are...
        i   -- increase volume [+5]
        d   -- decrease volume [-5]
        m   -- mute [x]
EOF
    exit 1
}

notify_vol() {
    angle="$(((($vol + 2) / 5) * 5))"
    ico="${icodir}/vol-${angle}.svg"
    bar=$(seq -s "." $(($vol / 15)) | sed 's/[0-9]//g')
    notify-send -a "t2" -r 91190 -t 800 -i "${ico}" "${vol}${bar}" "${nsink}"
}

notify_mute() {
    mute=$(pamixer "${srce}" --get-mute | cat)
    [ "${srce}" == "--default-source" ] && dvce="mic" || dvce="speaker"
    if [ "${mute}" == "true" ]; then
        notify-send -a "t2" -r 91190 -t 800 -i "${icodir}/muted-${dvce}.svg" "muted" "${nsink}"
    else
        notify-send -a "t2" -r 91190 -t 800 -i "${icodir}/unmuted-${dvce}.svg" "unmuted" "${nsink}"
    fi
}

action_pamixer() {
    pamixer "${srce}" -"${1}" "${step}"
    vol=$(pamixer "${srce}" --get-volume | cat)
}

action_playerctl() {
    [ "${1}" == "i" ] && pvl="+" || pvl="-"
    playerctl --player="${srce}" volume "0.0${step}${pvl}"
    vol=$(playerctl --player="${srce}" volume | awk '{ printf "%.0f\n", $0 * 100 }')
}

select_output() {
    if [ "$@" ]; then
        desc="$*"
        device=$(pactl list sinks | grep -C2 -F "Description: $desc" | grep Name | cut -d: -f2 | xargs)
        if pactl set-default-sink "$device"; then
            notify-send -t 2000 -r 2 -u low "Activated: $desc"
        else
            notify-send -t 2000 -r 2 -u critical "Error activating $desc"
        fi
    else
        pactl list sinks | grep -ie "Description:" | awk -F ': ' '{print $2}' | sort |
            while IFS= read -r x; do echo "$x"; done
    fi
}

# eval device option

while getopts iop:s: DeviceOpt; do
    case "${DeviceOpt}" in
    i)
        nsink=$(pamixer --list-sources | awk -F '"' 'END {print $(NF - 1)}')
        [ -z "${nsink}" ] && echo "ERROR: Input device not found..." && exit 0
        ctrl="pamixer"
        srce="--default-source"
        ;;
    o)
        nsink=$(pamixer --get-default-sink | awk -F '"' 'END{print $(NF - 1)}')
        [ -z "${nsink}" ] && echo "ERROR: Output device not found..." && exit 0
        ctrl="pamixer"
        srce=""
        ;;
    p)
        player_name="${OPTARG}"
        nsink=$(playerctl --list-all | grep -w "${player_name}")
        [ -z "${nsink}" ] && echo "ERROR: Player ${player_name} not active..." && exit 0
        ctrl="playerctl"
        srce="${player_name}"
        ;;
    s)
        default_sink="$(pamixer --get-default-sink | awk -F '"' 'END{print $(NF - 1)}')"
        export selected_sink="$(select_output "${@}" | rofi -dmenu -select "${default_sink}" -config "${confDir}/rofi/notification.rasi")"
        select_output "$selected_sink"
        exit
        ;;
    *) print_error ;;
    esac
done

# set default variables

icodir="${confDir}/dunst/icons/vol"
shift $((OPTIND - 1))
step="${2:-5}"

# execute action

case "${1}" in
i) action_${ctrl} i ;;
d) action_${ctrl} d ;;
m) "${ctrl}" "${srce}" -t && notify_mute && exit 0 ;;
*) print_error ;;
esac

notify_vol
