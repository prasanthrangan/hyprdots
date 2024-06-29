#!/bin/bash
# Check if an instance of the note application is running
if pgrep -x sticky-notes >/dev/null 2>&1; then
	# If running, close all instances using killall
	echo "Closing existing sticky notes..."
	killall sticky-notes
else
	# If not running, launch the application
	echo "Launching $note..."
	sticky-notes
fi
