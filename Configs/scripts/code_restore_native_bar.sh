#!/usr/bin/env sh    
set -eu    
     
settings_path="/home/$USER/.config/Code/User/settings.json"
style="native"  
cat <<< $(jq ".\"window.titleBarStyle\" = \"$style\"" $settings_path) > $settings_path    

notify-send -a "Visual Studio Code" -i /usr/share/icons/visual-studio-code.png "Native title bar has been restored."
