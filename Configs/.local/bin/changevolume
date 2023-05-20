#!/bin/bash

function send_notification() {
	volume=$(pamixer --get-volume)
	dunstify -a "changevolume" -u low -r "9993" -h int:value:"$volume" -i "volume-$1" "Volume: ${volume}%" -t 2000
}

case $1 in
up)
	# Set the volume on (if it was muted)
	pamixer -u
	pamixer -i 5 --allow-boost
	send_notification $1
	;;
down)
	pamixer -u
	pamixer -d 5 --allow-boost
	send_notification $1
	;;
mute)
	pamixer -t
	if $(pamixer --get-mute); then
		dunstify -i volume-mute -a "changevolume" -t 2000 -r 9993 -u low "Muted"
	else
		send_notification up
	fi
	;;
esac
