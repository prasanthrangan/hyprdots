#!/bin/bash

# Function to get current resolution
get_current_resolution() {
  hyprctl monitors all | awk '/^Monitor eDP-1/,/^$/' | awk '/[0-9]+x[0-9]+@[0-9.]+/ {print $1; exit}'
}

# Function to set resolution
set_resolution() {
  hyprctl keyword monitor "eDP-1,$1"
}

# Get the current resolution
current_resolution=$(get_current_resolution)

# Define the two resolution states
resolution_1="1920x1200@60.00000"
resolution_2="2560x1600@165.01900"

# Switch resolution based on current state
if [ "$current_resolution" = "$resolution_1" ]; then
  set_resolution "preferred,0x0,auto"
  echo "Resolution set to $resolution_2"
elif [ "$current_resolution" = "$resolution_2" ]; then
  set_resolution "$resolution_1,0x0,1.2"
  echo "Resolution set to $resolution_1"
else
  echo "Current resolution: $current_resolution"
  echo "Switching to $resolution_1"
  set_resolution "$resolution_1,0x0,1.2"
fi

# Wait for the changes to take effect
echo "Waiting for changes to take effect..."
sleep 2

# Display current monitor information
echo "Current monitor information:"
hyprctl monitors all | awk '/^Monitor eDP-1/,/^$/'
