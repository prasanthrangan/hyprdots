#!/bin/bash
_getHeader "$name" "$author"

echo "Define the date format for the clock module. Default: {:%Y-%m-%d}"
# Define File
targetFile="$HOME/dotfiles/waybar/modules.json"
settingsFile="$HOME/dotfiles/.settings/waybar_date"

# Define Markers
startMarker="\/\/ START CLOCK FORMAT"
endMarker="\/\/ END CLOCK FORMAT"

# Define Replacement Template
customtemplate="\"format-alt\": \"VALUE\""

# Select Value
customvalue=$(gum input --placeholder="Define the date format")

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
