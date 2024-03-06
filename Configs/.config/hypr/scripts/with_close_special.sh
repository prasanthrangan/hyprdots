#!/bin/bash

# close special workspace on focused monitor if one is present

active=$(hyprctl -j monitors | jq --raw-output '.[] | select(.focused==true).specialWorkspace.name | split(":") | if length > 1 then .[1] else "" end')

if [[ ${#active} -gt 0 ]]; then
    hyprctl dispatch togglespecialworkspace "$active"
fi
echo $1
hyprctl dispatch workspace "$1"
