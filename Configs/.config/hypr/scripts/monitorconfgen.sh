#!/bin/bash

# Define your setups
single="Japan Display Inc. 0x422A (eDP-1);"
home="Japan Display Inc. 0x422A (eDP-1);Acer Technologies Acer P166HQL LTYSS0034206 (DP-2 via VGA);"



# To check the current string on your monitors
current_setup=$(hyprctl monitors | grep "description" | sed 's/.*: //g' | tr '\n' ';')
echo $current_setup


# Check if the current setup matches any of the defined setups
if [ "$current_setup" == "$single" ]; then
    notify-send "Single Display"
    source_mon_conf="source = $HOME/.config/hypr/monitors/single.setup"
elif [ "$current_setup" == "$home" ]; then
    notify-send "Home Display Setup"
    source_mon_conf="source = $HOME/.config/hypr/monitors/home.setup"
else
    notify-send "No Pre Saved Config"
    wdisplays &&
    #   $HOME/Scripts/Monitor_Info 
#Get Monitor Info
monitor_info=$(hyprctl monitors | awk -F " " '/ID/ && /DP/ {ORS = "";
print "";
print "\n monitor =", $2 ;
print " , ";
getline; 
print;
print " ,";
 for(i=1;i<=12;i++){
	 getline;
	 if(i==8) print $2;
	 if(i==9) print ",transform,";
	 if(i==9) print $2;
	 };
 }' |  sed 's/at/,/')
echo "$monitor_info"
directory="$HOME/.config/hypr/monitors/"
prefix="Profile_"
suffix=".setup"

# Find the last existing file with the prefix
last_file=$(ls -1 "$directory" | grep -E "^$prefix[0-9]+${suffix}$" | sort -r | head -n 1)

if [ -n "$last_file" ]; then
  # Increment the number in the last file
  last_number=$(echo "$last_file" | sed "s/^$prefix\([0-9]\+\)${suffix}$/\1/")
  next_number=$((last_number + 1))
else
  # No existing file found, start with 1
  next_number=1
fi

# Create the new filename
new_filename="${prefix}${next_number}${suffix}"
new_filepath="${directory}${new_filename}"

# Create the file with the desired content
echo "#Khing $monitor_info" > "$new_filepath"
#notify-send "New $new_filename Saved to $new_filepath"

# Setup the Display and save to hyprland
source_mon_conf="source = $new_filepath"
echo "$source_mon_conf"  > "$HOME/.config/hypr/monitors.conf"
notify-send "${prefix}${next_number} Display Setup"

    exit 0



    # Add additional actions to be performed when there is no match
fi

# Write the configuration to the monitors.conf file
echo "$source_mon_conf" > "$HOME/.config/hypr/monitors.conf"


