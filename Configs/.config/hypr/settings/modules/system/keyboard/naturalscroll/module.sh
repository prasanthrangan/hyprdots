#!/bin/bash
_getHeader "$name" "$author"

echo "Enable/Disable the natural scrolling for touchpads."

# Define File
targetFile="$HOME/dotfiles/hypr/conf/keyboard.conf"
settingsFile="$HOME/dotfiles/.settings/keyboard_naturalscroll"

# Define Markers
findMarker="natural_scroll"

# Select Value
customvalue=$(gum choose "Enable" "Disable")

if [ ! -z $customvalue ]; then
    if [ "$customvalue" == "Enable" ] ;then
        customtext="        natural_scroll = true"
    else
        customtext="        natural_scroll = false"
    fi
    _replaceLineInFile "$findMarker" "$customtext" "$targetFile"
    _writeSettings "$settingsFile" "$customtext"
    echo "Keyboard settings changed."
    sleep 2
    _goBack
else 
    echo "ERROR: Define a value."
    sleep 2
    _goBack    
fi
