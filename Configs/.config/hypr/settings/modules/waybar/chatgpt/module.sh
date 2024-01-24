#!/bin/bash
_getHeader "$name" "$author"

echo "Hide or show the chatgpt icon in ML4W waybar themes."

# Define File
targetFile="$HOME/dotfiles/waybar/modules.json"
settingsFile="$HOME/dotfiles/.settings/waybar_chatgpt"

# Define Markers
startMarker="START CHATGPT TOOGLE"
endMarker="END CHATGPT TOOGLE"

# Select Value
customvalue=$(gum choose "SHOW" "HIDE" "DEFAULT")

if [ ! -z $customvalue ]; then
    if [ "$customvalue" == "SHOW" ] ;then
        customtext="        \"custom\/chatgpt\","
    elif [ "$customvalue" == "DEFAULT" ] ;then
        customtext="        \"custom\/chatgpt\","
    else
        customtext="        \/\/\"custom\/chatgpt\","
    fi
    
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
