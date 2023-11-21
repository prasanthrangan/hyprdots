#!/bin/bash 
#set -eu    
     
settings_path="/home/$USER/.config/Code/User/settings.json"

if [ "$1" == "" ];then
	echo "Empty argument. Correct usage:"
	echo "./code_style_bar.sh [ native | custom ]"
        exit
fi

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]];then
	echo "Usage"
	echo "./code_style_bar.sh [ native | custom ]"
	exit
fi

if [[ "$1" == "native" ]] || [[ "$1" == "custom" ]]; then
	style=$1
else
	echo "Improper use. Correct usage:"
	echo "./code_style_bar.sh [ native | custom ]"
	exit
fi
cat <<< $(jq ".\"window.titleBarStyle\" = \"$style\"" $settings_path) > $settings_path    

dunstify -a "Visual Studio Code" -r 3 -i /usr/share/icons/visual-studio-code.png "$style title bar has been restored."
