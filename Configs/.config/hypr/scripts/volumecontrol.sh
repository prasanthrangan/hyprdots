#!/usr/bin/env sh

tagVol="notifyvol"

function notify_vol
{
    vol=`pamixer --get-volume | cat`
    #bar=$(seq -s "─" $(($vol / 5)) | sed 's/[0-9]//g')
    #dunstify "${vol}%" "$bar" -a "Volume" -r 91190

    sink=`pamixer --get-default-sink | tail -1 | rev | cut -d '"' -f -2 | rev | sed 's/"//'`
    mute=`pamixer --get-mute | cat`

    angle="$(( (($vol+2)/5) * 5 ))"
    ico="~/.config/dunst/iconvol/vol-${angle}.svg"

    if [ "$mute" == true ] ; then
        dunstify "Muted" -i $ico -a "$sink" -u low -r 91190 -t 800

    elif [ $vol -ne 0 ] ; then
        dunstify -i $ico -a "$sink" -u low -h string:x-dunst-stack-tag:$tagVol \
        -h int:value:"$vol" "Volume: ${vol}%" -r 91190 -t 800

    else
        dunstify -i $ico "Volume: ${vol}%" -a "$sink" -u low -r 91190 -t 800
    fi
}
#muted mic function
function toggle_mic_mute {
    # Get the name of the microphone source
    mic_source=$(pamixer --list-sources | grep -v '^Sources:$' | grep -v 'Monitor of ' | head -n 1 | awk '{print $1}')

    # Toggle mute for the microphone source
    pamixer --source "$mic_source" --toggle-mute

    # Check the new mute state
    is_muted=$(pamixer --source "$mic_source" --get-mute)

    # Send notification using Dunst
      if [ "$is_muted" == "true" ]; then
    dunstify -i "~/.config/dunst/mic/muted-mic.svg" -a "Notify" -u low -h string:x-dunst-stack-tag:$tagMute \
    "Microphone Muted" -r 91191 -t 800
    else
    dunstify -i "~/.config/dunst/mic/unmuted-mic.svg" -a "Notify" -u low -h string:x-dunst-stack-tag:$tagMute \
    "Microphone Unmuted" -r 91191 -t 800
    fi
}
case $1 in
    i) pamixer -i 5
        notify_vol
    ;;
    d) pamixer -d 5
        notify_vol
    ;;
    m) pamixer -t
        notify_vol
    ;;
    mutemic)
        toggle_mic_mute
    ;;
    *) echo "volumecontrol.sh [action]"
        echo "i -- increase volume [+5]"
        echo "d -- decrease volume [-5]"
        echo "m -- mute [x]"
    ;;
esac
