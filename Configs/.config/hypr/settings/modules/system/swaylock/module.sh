#!/bin/bash
_getHeader "$name" "$author"

echo "Enable/Disable the start of Swaylock. Restart of Hyprland is required after a change."

# Define File
targetFile="$HOME/dotfiles/hypr/scripts/lockscreentime.sh"
settingsFile="$HOME/dotfiles/.settings/hypr_lockscreen"

# Define Markers
startMarker="START SWAYIDLE"
endMarker="END SWAYIDLE"

# Select Value
customvalue=$(gum choose "ENABLE" "DISABLE")

if [ ! -z $customvalue ]; then
    if [ "$customvalue" == "ENABLE" ] ;then
        customtext="# exit"
    else
        customtext="exit"
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
