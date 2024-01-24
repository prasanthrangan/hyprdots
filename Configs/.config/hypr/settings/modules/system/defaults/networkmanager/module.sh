#!/bin/bash
_getHeader "$name" "$author"

echo "Define the start command to start the networkmanager (Must be installed on your system)."
echo "(Default: nm-connection-editor)"
echo "Possible values: alacritty -e nmtui, nm-connection-editor, etc."

# Define File
targetFile="$HOME/dotfiles/.settings/networkmanager.sh"

# Current Value
echo "Current Value: $(cat $targetFile)"

# Select Value
customvalue=$(gum input --placeholder "Command to start")
if [ ! -z $customvalue ] ;then
    # Write into file
    echo "$customvalue" > $targetFile
else 
    echo "Please define a command"
    sleep 1
fi
    _goBack


