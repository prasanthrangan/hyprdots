#!/usr/bin/env sh

ScrDir=$(dirname "$(realpath "$0")")
# shellcheck disable=SC1091
. "${ScrDir}/globalcontrol.sh"

print_error()
{
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

send_notification() {
    brightness=$(brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat)
    brightinfo=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')
    angle="$((((brightness + 2) / 5) * 5))"
    ico="${HOME}/.config/dunst/icons/vol/vol-${angle}.svg"
    bar=$(seq -s "." $((brightness / 15)) | sed 's/[0-9]//g')
    notify-send "t2" -i "${ico}" -a "${brightness}${bar}" "${brightinfo}" -r 91190 -t 800
}

get_brightness() {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)  # increase the backlight by 5%
    brightnessctl set +2%
     ;;
d)  # decrease the backlight by 5%
if [ "$(get_brightness)" -lt 2 ] ; then
           # avoid 0% brightness
        brightnessctl set 1%
    else
        # decrease the backlight by 5%
        brightnessctl set 2%-
    fi
     ;;
*)  # print error
    print_error ;;
esac
send_notification
