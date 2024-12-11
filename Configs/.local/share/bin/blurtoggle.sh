#!/usr/bin/env bash

# Path to config
file_path="${HOME}/.config/hypr/hyprland.conf"

# Source/unsourced windowrules-blur.conf
perl -i -pe 's|^(#\s*)?(source\s*=\s*~/.config/hypr/windowrules-blur\.conf)|$1 ? "$2" : "# $2"|e' "$file_path"
