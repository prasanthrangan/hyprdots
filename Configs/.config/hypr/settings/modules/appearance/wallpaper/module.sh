#!/bin/bash
_getHeader "$name" "$author"
setsid $HOME/dotfiles/hypr/scripts/wallpaper.sh select 1>/dev/null 2>&1 &
_goBack