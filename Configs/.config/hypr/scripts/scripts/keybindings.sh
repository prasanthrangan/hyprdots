#!/bin/bash
#  _              _     _           _ _                  
# | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___  
# | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __| 
# |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \ 
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/ 
#           |___/                             |___/      
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Get keybindings location based on variation
# ----------------------------------------------------- 
config_file=$(cat ~/dotfiles/hypr/conf/keybinding.conf)
config_file=${config_file/source = ~/}
config_file=${config_file/source=~/}

# ----------------------------------------------------- 
# Path to keybindings config file
# ----------------------------------------------------- 
config_file="/home/$USER$config_file"
echo "Reading from: $config_file"

# ----------------------------------------------------- 
# Parse keybindings
# ----------------------------------------------------- 
keybinds=$(grep -oP '(?<=bind = ).*' $config_file)
keybinds=$(echo "$keybinds" | sed 's/$mainMod/SUPER/g'|  sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')

# ----------------------------------------------------- 
# Show keybindings in rofi
# ----------------------------------------------------- 
rofi -dmenu -i -replace -p "Keybinds" -config ~/dotfiles/rofi/config-compact.rasi <<< "$keybinds"