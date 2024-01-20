#!/bin/bash

# Define the file path and the string to toggle
FILE_PATH="$HOME/.config/hypr/hyprland.conf"
STRING_TO_TOGGLE='source = ~/.config/hypr/windowrules.conf'

# Check if the string exists in the file and is commented out
if grep -q "# $STRING_TO_TOGGLE" "$FILE_PATH"; then
  # If the string is commented out, uncomment it
  sed -i "s|# $STRING_TO_TOGGLE|$STRING_TO_TOGGLE|g" "$FILE_PATH"
  notif=" Blur enabled"
elif grep -q "$STRING_TO_TOGGLE" "$FILE_PATH"; then
  # If the string exists but is not commented out, comment it out
  sed -i "s|$STRING_TO_TOGGLE|# $STRING_TO_TOGGLE|g" "$FILE_PATH"
  notif=" Blur disabled"
else
  # If the string does not exist, print an error message
  echo "String not found in file."
fi

dunstify "t1" -a "$notif" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200

