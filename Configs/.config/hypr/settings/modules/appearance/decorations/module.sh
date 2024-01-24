#!/bin/bash
_getHeader "$name" "$author"

sel=""
_getConfSelector decoration.conf decorations
_getConfEditor decoration.conf $sel decorations
setsid $HOME/dotfiles/waybar/launch.sh 1>/dev/null 2>&1 &
_reloadModule