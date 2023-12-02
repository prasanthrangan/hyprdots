#!/bin/bash

defKeys="$HOME/.config/hypr/keybindings.conf"
usrKeys="$HOME/.config/hypr/userprefs.conf"
unbind="$HOME/.config/hypr/unbind.conf"
tempFile=$(mktemp)
backupFile=$(mktemp)

# Clear the unbind file
> $unbind

# Add the autogeneration notice
echo "#! This file is autogerated by ./unbind_keybindings.sh " >> "$unbind"
echo -e "#! If you want to unbind some keys do it inside ~/.config/hypr/userprefs.conf\n" >> "$unbind"

# Create a backup of the defKeys file
cp "$defKeys" "$backupFile"
cp "$defKeys" "$tempFile"

# Read the file and cut the part after the second comma
while IFS= read -r line
do
    # Check if the line contains "bind" followed by "="
    if echo "$line" | grep -q "bind.*="; then
        # Cut the part before the "#"
        line=$(echo "$line" | cut -d '#' -f 1)
        # Cut the part after the second comma
        line=$(echo "$line" | cut -d ',' -f 3-)
        # If the line is not empty, grep it in $defKeys
        if [[ ! -z "$line" ]]; then
            grep "$line" "$defKeys" | while IFS= read -r match
            do
                conflics=$(echo "$match" | cut -d '=' -f 2- | cut -d ',' -f 1,2)
                # If the grep command found a match, append the result to the $unbind file
                if [[ ! -z "$conflics" ]]; then
                    echo "unbind = $conflics" >> "$unbind"
                fi
            done
        fi
    # Check if the line contains "$" and "="
    elif echo "$line" | grep -q "\$.*="; then
        # Get the variable name
        varName=$(echo "$line" | cut -d '=' -f 1)
        # Get the second column value
        secondColumn=$(echo "$line" | cut -d '=' -f 2 | cut -d ',' -f 1)
        # If the variable is also in $defKeys, replace it with the second column value
        if grep -q "$varName" "$defKeys"; then
            # Use sed to replace the line in the temp file
            sed -i "s/^$varName.*$/$varName=$secondColumn/" "$tempFile"
        fi
    fi
done < "$usrKeys"

# Replace the defKeys file with the temp file
mv "$tempFile" "$defKeys"

# Ask for user confirmation to keep the changes
read -n 1 -s -r -p "[ENTER:yes ANY:no] Keep changes ?"
if [[ $REPLY != "" ]]; then
    echo "Operation cancelled by user."
    # Restore the defKeys file from the backup
    mv "$backupFile" "$defKeys"
    exit 1
fi