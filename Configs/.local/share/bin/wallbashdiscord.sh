#!/usr/bin/env bash


#// source variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
discord_col="${cacheDir}/landing/discord.css"
declare -a client_list=()


#// List more clients

client_list+=("$HOME/.config/vesktop/settings/quickCss.css")
client_list+=("$HOME/.var/app/dev.vencord.Vesktop/config/vesktop/settings/quickCss.css")
client_list+=("$HOME/.config/WebCord/Themes/theme.css")
client_list+=("$HOME/.var/app/io.github.spacingbat3.webcord/config/WebCord/Themes/theme.css")
client_list+=("$HOME/.var/app/xyz.armcord.ArmCord/config/ArmCord/themes/theme.css")


#// main loop

for client_css in "${client_list[@]}" ; do
    eval client_css="${client_css}"
    if [[ ! -d $(dirname "${client_css}") ]] ; then
        continue
    fi
    if [[ "${enableWallDcol}" -gt 0 ]] ; then
        cp "${discord_col}" "${client_css}"
    else
        > "${client_css}"
    fi
done

