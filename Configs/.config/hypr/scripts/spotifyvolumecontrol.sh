#!/bin/bash

# define the name of the player
PLAYER="spotify"

# function to increase Spotify volume
increase_volume() {
    	playerctl --player="$PLAYER" volume 0.05+
	VOLUME=$(playerctl volume --player $PLAYER)
	dunstify -a Spotify -r 2 -t 1500 -i /usr/share/icons/Tela-circle-black/scalable/apps/com.spotify.Client.svg "Volume increased" "$VOLUME"
}

# function to decrease Spotify volume
decrease_volume() {
    	playerctl --player="$PLAYER" volume 0.05-
	VOLUME=$(playerctl volume --player $PLAYER)
        dunstify -a Spotify -r 2 -t 1500 -i /usr/share/icons/Tela-circle-black/scalable/apps/com.spotify.Client.svg "Volume decreased" "$VOLUME"
}

# check for the argument and perform the corresponding action
case "$1" in
    "up")
        increase_volume
        ;;
    "down")
        decrease_volume
        ;;
    *)
        exit 1
        ;;
esac
