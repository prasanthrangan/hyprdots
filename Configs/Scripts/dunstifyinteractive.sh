#!/bin/bash

# Display an interactive notification
dunstify -u normal -a "MyApp" "Interactive Notification" "Click the buttons below" \
    -p "<b>Button 1</b>,<b>Button 2</b>"

# Wait for user input
while true; do
    # Receive user action
    action=$(dunstify -A "Button 1,Button 2" -p "Waiting for user input")

    # Handle user action
    case "$action" in
        "Button 1")
            # User clicked Button 1
            dunstify -u low -a "MyApp" "Button 1 Clicked" "Performing action for Button 1"
            # Add your custom action here
            ;;
        "Button 2")
            # User clicked Button 2
            dunstify -u low -a "MyApp" "Button 2 Clicked" "Performing action for Button 2"
            # Add your custom action here
            ;;
        *)
            # User closed the notification
            dunstify -C
            break
            ;;
    esac
done

