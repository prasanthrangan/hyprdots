#!/bin/bash
#  ____       _   _   _                  
# / ___|  ___| |_| |_(_)_ __   __ _ ___  
# \___ \ / _ \ __| __| | '_ \ / _` / __| 
#  ___) |  __/ |_| |_| | | | | (_| \__ \ 
# |____/ \___|\__|\__|_|_| |_|\__, |___/ 
#                             |___/      
# The Hyprland Settings Script  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

clear
installFolder=$(dirname "$(pwd)")

# Source files
source .library/version.sh
source .library/library.sh

# Define global variables
modules_path="modules"
current=""
back=""
clickArr=""
confDir="conf"

# Start Application
_getModules $(pwd)/$modules_path
