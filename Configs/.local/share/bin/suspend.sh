#!/bin/bash
swayidle -w \
timeout 120 ' swaylock ' \
timeout 400 ' hyprctl dispatch dpms off' \
resume ' hyprctl dispatch dpms on' \
timeout 12000 'systemctl suspend' \
before-sleep 'swaylock'
