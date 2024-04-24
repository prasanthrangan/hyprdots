#! /bin/bash

# source variables
ScrDir=$(dirname "$(realpath "$0")")
source ${ScrDir}/globalcontrol.sh

WALL="${cacheDir}/wall.set"

fn_background() {
    SL="${confDir}/hyprlock/hyprlock.png"
    mime=$(file --mime-type "${WALL}" | grep "image/png")
    cp -f "${WALL}" "${SL}"
    #? Run this in the background because converting takes time
    ([[ -z ${mime} ]] && convert "${SL}"[0] "${SL}") &
}

mpris_thumb() {
    artUrl=$(playerctl -p spotify metadata --format '{{mpris:artUrl}}')
    [ "${artUrl}" == "$(cat "${THUMB}".lnk)" ] && exit 0
    echo "${artUrl}" > "${THUMB}".lnk
    curl -Lso "${THUMB}".art "$artUrl"
    convert "${THUMB}".art -quality 50 "${THUMB}".png
    pkill -USR2 hyprlock # updates the mpris thumbnail
}
fn_mpris() {
    THUMB="${cacheDir}/landing/mpris"
    { playerctl -p spotify metadata --format '{{title}}    {{artist}}' && mpris_thumb; } || { rm -f "${THUMB}".png && exit 0; }
}

fn_cava() {

:

}

fn_"${1}"