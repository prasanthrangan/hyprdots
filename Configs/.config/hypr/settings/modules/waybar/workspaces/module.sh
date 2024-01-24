#!/bin/bash
_getHeader "$name" "$author"

# Define File
targetFile="$HOME/dotfiles/waybar/modules.json"
settingsFile="$HOME/dotfiles/.settings/waybar_workspaces"

# Define Markers
startMarker="START WORKSPACE"
endMarker="END WORKSPACES"

# Define Replacement Template
customtemplate="\"*\": VALUE"

# Select Value
customvalue=$(gum choose 5 6 7 8 9 10)
if [ ! -z $customvalue ] ;then

    # Replace in Template
    customtext="${customtemplate/VALUE/"$customvalue"}" 

    _replaceInFile $startMarker $endMarker $customtext $targetFile
    _writeSettings $settingsFile $customtext

    # Reload Waybar
    setsid $HOME/dotfiles/waybar/launch.sh 1>/dev/null 2>&1 &
    _goBack

else
    _goBack
fi
