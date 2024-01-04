#!/usr/bin/env sh

yad --width=800 --height=600 \
--center \
--title="Keybindings" \
--no-buttons \
--list \
--column=Key: \
--column=Description: \
"=" "SUPER KEY" \
" + Q / Alt + F4" "Close active window" \
" + L" "Lock screen" \
"Ctrl + Shift + Escape" "Open system monitor" \
"Ctrl + Escape" "Toggle waybar" \
" + Backspace" "Logout menu" \
" + Del" "Quit hyprland session logout w/out confirmation" \
" + W" "Toggle window on focus to float" \
"Alt + Return" "Toggle fullscreen" \
" + Z" "Monicle mode" \
" + J" "Toggle layout" \
" + G" "Toggle window group" \
" + Enter /  + T" "Launch terminal " \
" + E" "Launch file explorer " \
" + C" "Launch editor 󰨞" \
" + F" "Launch browser " \
" + Ctrl + Space" "Launch Emoji Selector (rofi)" \
" + A / ALT + Space" "Launch desktop applications (rofi) 󱓞" \
" + Tab" "Switch open applications" \
" + R" "Browse system files" \
"Fn + Mute" "Mute audio output toggle" \
"Fn + Vol+ (hold)" "Decrease volume" \
"Fn + Vol- (hold)" "Increase volume" \
" + V" "Clipboard history" \
"PrintScreen" "screenshot all screen" \
" + P" "screenshot active window" \
" + Alt + P" "screenshot focused monitor" \
" + RightClick (drag)" "resize the window" \
" + LeftClick (drag)" "change the window position" \
" + MouseScroll / PageUp/PageDown" "cycle through workspaces" \
" + Shift + [←→↑↓] (hold)" "resizewindows" \
" + [0-9]" "switch workspaces 1-10" \
" + Ctrl + [←→]" "switch workspaces" \
" + Shift + [0-9]" "move active window to workspace [1-10]" \
" + Alt + [0-9]" "move active window to workspace [1-10] (silently)" \
" + Shift + S" "move window to special workspace" \
" + Alt + S" "move window to special workspace (silently)" \
" + S" "toogle to special workspace" \
" + Alt + G" "disable hypr effects for gamemode" \
" + Alt + [←→]" "change wallpaper" \
" + Alt + [↑↓]" "change waybar mode" \
" + Alt + D" "toggle theme <//> wall based colors" \
" + Shift + T" "theme select menu" \
" + Shift + W" "wallpaper select menu" \
" + Shift + A" "rofi style select menu" \
" + Shift + G" "launch gamelauncher menu" \
" + K" "Change Keyboard Layout" \
" + Shift + C" "Enable native title bar for VS Code 󰨞" \
" + Alt + C" "Enable custom title bar for VS Code 󰨞" \
