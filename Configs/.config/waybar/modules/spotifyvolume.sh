#!/bin/bash

if [ -z "$1" ]; then
	echo "Incorrect Usage."
	exit
fi

if [[ "$1" == "-i" ]];then
	playerctl volume 0.05+ --player spotify
	volume=$(playerctl volume --player spotify)
	dunstify -a Spotify -r 2 -t 1500 -i /usr/share/icons/Tela-circle-black/scalable/apps/com.spotify.Client.svg "Volume increased" "$volume"
	echo "Volume increased to $volume"
	exit
fi
if [[ "$1" == "-d" ]];then
        playerctl volume 0.05- --player spotify
        volume=$(playerctl volume --player spotify)
        dunstify -a Spotify -r 2 -t 1500 -i /usr/share/icons/Tela-circle-black/scalable/apps/com.spotify.Client.svg "Volume decreased" "$volume"
	echo "Volume decreased to $volume"
	exit
fi
if [[ "$1" == "-h" ]];then
	echo "Usage: ./spotifyvolume.sh [-i | -d]"
	echo "-i increase volume"
	echo "-d decrease volume"
	exit
fi
echo "Incorrect arguments, do -h for more info"
exit
