#!/usr/bin/env sh
set -eu

process_string="/opt/visual-stuido-code/code"
settings_path="/home/$USER/.config/Code/User/settings.json"

#if [[ `pgrep code` == "" ]]; then
#	style="custom"
#else
#	style="native"
#fi

#cat <<< $(jq ".\"window.titleBarStyle\" = \"$style\"" $settings_path) > $settings_path
code "$@"
