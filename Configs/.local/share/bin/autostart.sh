#!/usr/bin/env bash

# Directory containing the .desktop files
AUTOSTART_DIR="$HOME/.config/autostart/"
for desktop_file in "$AUTOSTART_DIR"*.desktop; do
  if [ -f "$desktop_file" ]; then
    exec_command=$(grep -E '^Exec=' "$desktop_file" | sed 's/^Exec=//')
    if [ -n "$exec_command" ]; then
      $exec_command &
    fi
  fi
done
