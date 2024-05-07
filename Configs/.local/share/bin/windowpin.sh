#!/usr/bin/env sh

#// Enable float

WinFloat=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
WinPinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')

if [ "$WinFloat" = "false" ] && [ "$WinPinned" = "false" ]; then
    hyprctl dispatch togglefloating active
fi

#// Toggle pin

hyprctl dispatch pin active

#// Disable float

WinFloat=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
WinPinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')

if [ "$WinFloat" = "true" ] && [ "$WinPinned" = "false" ]; then
    hyprctl dispatch togglefloating active
fi
