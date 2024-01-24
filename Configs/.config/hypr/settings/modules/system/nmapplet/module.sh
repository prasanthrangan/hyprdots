#!/bin/bash
_getHeader "$name" "$author"

echo "Enable or disable the network manager applet (nw-applet) in the Systray."
echo "(nw-applet must be installed on your system)"
echo "IMPORTANT: Please reboot your system after a change."
echo 
# Define File
targetFile1="$HOME/dotfiles/hypr/conf/autostart.conf"
settingsFile="$HOME/dotfiles/.settings/waybar_nmapplet"

# Define Markers
startMarker="START NM APPLET"
endMarker="END NM APPLET"

# Select Value
customvalue=$(gum choose "Enable" "Disable")

if [ ! -z $customvalue ]; then
    if [ "$customvalue" == "Enable" ] ;then
        customtext="exec-once = nm-applet"
    else
        customtext="# exec-once = nm-applet"
    fi
    
    _replaceInFile $startMarker $endMarker $customtext $targetFile1
    _writeSettings $settingsFile $customtext
    
    # Reload Waybar
    _goBack
else 
    echo "ERROR: Define a value."
    sleep 2
    _goBack    
fi
