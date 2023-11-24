#!/usr/bin/env sh

yad --width=800 --height=600 \
--center \
--title="Keybindings" \
--no-buttons \
--list \
--column=Key: \
--column=Description: \
"Alt + Tab" "" \
"Alt + Shift + Tab" "" \
" + Shift + C" "" \
"====================" "====================" \
"=" "SUPER KEY" \
" + Q / Alt + F4" "Close active window" \
" + L" "Lock screen" \
"Ctrl + Shift + Escape" "Open system monitor" \
" + Backspace / X" "Logout menu" \
" + Del" "Quit hyprland session logout w/out confirmation" \
" + SPACE" "Toggle window on focus to float" \
" + F" "Toggle window on focus to fullscreen keep borders" \
" + Shift + F" "Toggle window on focus to fullscreen" \
" + J" "Toggle layout" \
" + P" "Toggle pseudotile" \
" + G" "Toggle window group" \
" + Return / T | Numpad Enter" "Launch terminal" \
" + E" "Launch file explorer" \
" + C" "Launch editor 󰨞" \
" + B" "Launch browser" \
" + D" "Launch desktop applications (rofi)" \
" + Tab" "Switch open applications" \
" + R" "Browse system files" \
" + period" "Browse emoji" \
"Fn + Mute" "Mute audio output toggle" \
"Fn + Vol+ (hold)" "Decrease volume" \
"Fn + Vol- (hold)" "Increase volume" \
" + Ctrl + Alt + S" "Open spotify" \
" + Ctrl + ↓ (hold)" "Decrease volume for spotify" \
" + Ctrl + ↑ (hold)" "Increase volume for spotify" \
" + V" "Clipboard history" \
" + Shift + A" "screenshot snip rectangular select" \
" + Shift + S / PrintScreen" "screenshot all screen" \
" + Shift + W" "screenshot active window" \
" + Shift + D" "screenshot focused monitor" \
" + Shift + X" "opens screenshot folder" \
" + RightClick (drag)" "resize the window" \
" + LeftClick (drag)" "change the window position" \
" + MouseScroll / PageUp/PageDown" "cycle through workspaces" \
" + Shift + [←→↑↓] (hold)" "resizewindows" \
" + [0-9]" "switch to workspace [0-9] Workspace 9 (opens Spotify)" \
" + backtick" "switch to workspace 10" \
" + Ctrl + [←→]" "switch to relative workspaces" \
" + Ctrl + ↓" "switch to first empty workspace" \
" + Ctrl + Alt + [←→]" "move active window between relative workspaces" \
" + Shift + [0-9]" "move active window to workspace [0-9]" \
" + Shift + backtick / backquote" "move active window to workspace 0" \
" + Shift + Ctrl + ←→↑↓" "move active window around" \
" + Alt + [0-9]" "move active window to workspace [0-9] (silently)" \
" + Alt + backtick / backquote" "move active window to workspace 10 (silently)" \
" + Ctrl + S" "move window to special workspace" \
" + S" "toogle to special workspace" \
" + Alt + G" "disable hypr effects for gamemode" \
" + Alt + [←→]" "change wallpaper" \
" + Alt + [↑↓]" "change waybar mode" \
" + Alt + D" "toggle theme <//> wall based colors" \
" + Alt + T" "theme select menu" \
" + Alt + W" "wallpaper select menu" \
" + Alt + A" "rofi style select menu" \
" + Alt + PageDown/PageUp" "turn on/off blue light filter" \

