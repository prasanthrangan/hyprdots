#!/bin/bash

# define the name of the player
PLAYER="spotify"

# function to increase Spotify volume
increase_volume() {
    playerctl --player="$PLAYER" volume 0.05+
}

# function to decrease Spotify volume
decrease_volume() {
    playerctl --player="$PLAYER" volume 0.05-
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
