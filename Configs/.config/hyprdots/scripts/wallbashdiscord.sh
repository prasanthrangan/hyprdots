#!/usr/bin/env bash

# source variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
discord_col="${cacheDir}/discord.css"
declare -a client_list=()

# List more clients
client_list+=("$HOME/.config/vesktop/settings/quickCss.css")
client_list+=("$HOME/.var/app/dev.vencord.Vesktop/config/vesktop/settings/quickCss.css")
client_list+=("$HOME/.config/WebCord/Themes/theme.css")
client_list+=("$HOME/.var/app/io.github.spacingbat3.webcord/config/WebCord/Themes/theme.css")
client_list+=("$HOME/.var/app/xyz.armcord.ArmCord/config/ArmCord/themes/theme.css")
client_list+=("$HOME/.config/ArmCord/themes/theme.css") #! Not working

# main loop
for client_css in "${client_list[@]}" ; do
    eval client_css="${client_css}"
    if [[ ! -d $(dirname "${client_css}") ]] ; then
        continue
    fi
    if [[ "${EnableWallDcol}" -eq 1 ]] ; then
        cp "${discord_col}" "${client_css}"
    else
        > "${client_css}"
    fi
done

