#!/usr/bin/env bash

tooltip=""

monitor_count=$(xrandr --listmonitors | grep Monitors | cut -d' ' -f2)

# Iterate over each monitor
while read -r monitor; do
    # Extract required information
    id=$(echo "$monitor" | jq -r '.id')
    name=$(echo "$monitor" | jq -r '.name')
    make=$(echo "$monitor" | jq -r '.make')
    model=$(echo "$monitor" | jq -r '.model')
    width=$(echo "$monitor" | jq -r '.width')
    height=$(echo "$monitor" | jq -r '.height')
    scale=$(echo "$monitor" | jq -r '.scale')

    # Append monitor info to tooltip
    tooltip="${tooltip}Id: ${id} - Port: ${name}\nMake: ${make}\nModel: ${model}\nResolution: ${width}x${height}\nScale: ${scale}\n\n"
done < <(hyprctl monitors -j | jq -c '.[]')

# Print monitor info (json)
echo "{\"text\":\"${monitor_count}\", \"tooltip\":\"${tooltip}\"}"