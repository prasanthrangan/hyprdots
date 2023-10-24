#!/bin/bash

# Fetch the current wallpaper information using swww query
WALLPAPER_INFO=$(swww query)

# Extract the image path from the swww query output using awk
IMAGE_PATH=$(echo "$WALLPAPER_INFO" | awk -F ": image: " '{print $2}' | sort | uniq | head -n 1)

# Check if the image path is not empty
if [ -n "$IMAGE_PATH" ]; then
    # Extract the image filename without the path
    IMAGE_FILENAME=$(basename "$IMAGE_PATH")

    # Copy the image to the SDDM backgrounds directory
    sudo cp "$IMAGE_PATH" /usr/share/sddm/themes/corners/backgrounds/

    # Update the theme.conf file with the new background image path
    sudo sed -i "/^Background=/s|.*$|Background=\"backgrounds/$IMAGE_FILENAME\"|" /usr/share/sddm/themes/corners/theme.conf

    echo "Current wallpaper copied to SDDM backgrounds directory."
    echo "Updated /usr/share/sddm/themes/corners/theme.conf with the new background image."
else
    echo "Error: Unable to fetch current wallpaper information using swww query."
fi
