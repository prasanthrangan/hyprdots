#! /bin/bash

# source variables
ScrDir=$(dirname "$(realpath "$0")")
source ${ScrDir}/globalcontrol.sh

WALLPAPER="${cacheDir}/wall.set"

fn_background() {
    BG="${confDir}/hyprlock/hyprlock.png"
    mime=$(file --mime-type "${WALLPAPER}" | grep "image/png")
    cp -f "${WALLPAPER}" "${BG}"
    #? Run this in the background because converting takes time
    ([[ -z ${mime} ]] && convert "${BG}"[0] "${BG}") &
}

mpris_thumb() { # Generate thumbnail for mpris
    artUrl=$(playerctl -p spotify metadata --format '{{mpris:artUrl}}')
    [ "${artUrl}" == "$(cat "${THUMB}".lnk)" ] && [ -f "${THUMB}".png ] && exit 0
    echo "${artUrl}" > "${THUMB}".lnk
    curl -Lso "${THUMB}".art "$artUrl"
    convert "${THUMB}.art" -quality 50 "${THUMB}.png"
    pkill -USR2 hyprlock # updates the mpris thumbnail
}

fn_mpris() {
    THUMB="${cacheDir}/landing/mpris"
    if [ "$(playerctl -p spotify status)" != "Paused" ]; then
        playerctl -p spotify metadata --format '{{title}}    {{artist}}'  
        mpris_thumb
    else :
        rm -f "${THUMB}".png && exit 0
    fi
}

fn_cava() {

:

}

fn_"${1}"
