#!/bin/bash
_getHeader "$name" "$author"

echo "Define the label of the Apps Starter (Default is Apps). "

# Define File
targetFile="$HOME/dotfiles/waybar/modules.json"
settingsFile="$HOME/dotfiles/.settings/waybar_appslabel"

# Define Markers
startMarker="START APPS LABEL"
endMarker="END APPS LABEL"

# Define Replacement Template
customtemplate="\"format\": \"VALUE\","

# Select Value
customvalue=$(gum input --placeholder="Define the Apps label")

if [ ! -z $customvalue ]; then
    # Replace in Template
    customtext="${customtemplate/VALUE/"$customvalue"}" 
    _replaceInFile $startMarker $endMarker $customtext $targetFile
    _writeSettings $settingsFile $customtext

    # Reload Waybar
    setsid $HOME/dotfiles/waybar/launch.sh 1>/dev/null 2>&1 &
    _goBack
else 
    echo "ERROR: Define a value."
    sleep 2
    _goBack    
fi
