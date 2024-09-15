#!/usr/bin/env sh

# Set variables
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
roconf="${confDir}/rofi/clipboard.rasi"
favoritesFile="${HOME}/.cliphist_favorites"

# Set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)

# Evaluate spawn position
readarray -t curPos < <(hyprctl cursorpos -j | jq -r '.x,.y')
readarray -t monRes < <(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width,.height,.scale,.x,.y')
readarray -t offRes < <(hyprctl -j monitors | jq -r '.[] | select(.focused==true).reserved | map(tostring) | join("\n")')
monRes[2]="$(echo "${monRes[2]}" | sed "s/\.//")"
monRes[0]="$(( ${monRes[0]} * 100 / ${monRes[2]} ))"
monRes[1]="$(( ${monRes[1]} * 100 / ${monRes[2]} ))"
curPos[0]="$(( ${curPos[0]} - ${monRes[3]} ))"
curPos[1]="$(( ${curPos[1]} - ${monRes[4]} ))"

if [ "${curPos[0]}" -ge "$((${monRes[0]} / 2))" ] ; then
    x_pos="east"
    x_off="-$(( ${monRes[0]} - ${curPos[0]} - ${offRes[2]} ))"
else
    x_pos="west"
    x_off="$(( ${curPos[0]} - ${offRes[0]} ))"
fi

if [ "${curPos[1]}" -ge "$((${monRes[1]} / 2))" ] ; then
    y_pos="south"
    y_off="-$(( ${monRes[1]} - ${curPos[1]} - ${offRes[3]} ))"
else
    y_pos="north"
    y_off="$(( ${curPos[1]} - ${offRes[1]} ))"
fi

r_override="window{location:${x_pos} ${y_pos};anchor:${x_pos} ${y_pos};x-offset:${x_off}px;y-offset:${y_off}px;border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"

# Show main menu if no arguments are passed
if [ $# -eq 0 ]; then
    main_action=$(echo -e "History\nDelete\nView Favorites\nManage Favorites\nClear History" | rofi -dmenu -theme-str "entry { placeholder: \"Choose action\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
else
    main_action="History"
fi

case "${main_action}" in
"History")
    selected_item=$(cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"History...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
    if [ -n "$selected_item" ]; then
        echo "$selected_item" | cliphist decode | wl-copy
        notify-send "Copied to clipboard."
    fi
    ;;
"Delete")
    selected_item=$(cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
    if [ -n "$selected_item" ]; then
        echo "$selected_item" | cliphist delete
        notify-send "Deleted."
    fi
    ;;
"View Favorites")
    if [ -f "$favoritesFile" ] && [ -s "$favoritesFile" ]; then
        # Read each Base64 encoded favorite as a separate line
        mapfile -t favorites < "$favoritesFile"
        
        # Prepare a list of decoded single-line representations for rofi
        decoded_lines=()
        for favorite in "${favorites[@]}"; do
            decoded_favorite=$(echo "$favorite" | base64 --decode)
            # Replace newlines with spaces for rofi display
            single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
            decoded_lines+=("$single_line_favorite")
        done
        
        selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | rofi -dmenu -theme-str "entry { placeholder: \"View Favorites\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
        if [ -n "$selected_favorite" ]; then
            # Find the index of the selected favorite
            index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)
            # Use the index to get the Base64 encoded favorite
            if [ -n "$index" ]; then
                selected_encoded_favorite="${favorites[$((index - 1))]}"
                # Decode and copy the full multi-line content to clipboard
                echo "$selected_encoded_favorite" | base64 --decode | wl-copy
                notify-send "Copied to clipboard."
            else
                notify-send "Error: Selected favorite not found."
            fi
        fi
    else
        notify-send "No favorites."
    fi
    ;;
"Manage Favorites")
    manage_action=$(echo -e "Add to Favorites\nDelete from Favorites\nClear All Favorites" | rofi -dmenu -theme-str "entry { placeholder: \"Manage Favorites\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")

    case "${manage_action}" in
    "Add to Favorites")
        # Show clipboard history to add to favorites
        item=$(cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Add to Favorites...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
        if [ -n "$item" ]; then
            # Decode the item from clipboard history
            full_item=$(echo "$item" | cliphist decode)
            encoded_item=$(echo "$full_item" | base64 -w 0)
            
            # Check if the item is already in the favorites file
            if grep -Fxq "$encoded_item" "$favoritesFile"; then
                notify-send "Item is already in favorites."
            else
                # Add the encoded item to the favorites file
                echo "$encoded_item" >> "$favoritesFile"
                notify-send "Added in favorites."
            fi
        fi
        ;;
    "Delete from Favorites")
        if [ -f "$favoritesFile" ] && [ -s "$favoritesFile" ]; then
            # Read each Base64 encoded favorite as a separate line
            mapfile -t favorites < "$favoritesFile"
            
            # Prepare a list of decoded single-line representations for rofi
            decoded_lines=()
            for favorite in "${favorites[@]}"; do
                decoded_favorite=$(echo "$favorite" | base64 --decode)
                # Replace newlines with spaces for rofi display
                single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
                decoded_lines+=("$single_line_favorite")
            done
            
            selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | rofi -dmenu -theme-str "entry { placeholder: \"Remove from Favorites...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
            if [ -n "$selected_favorite" ]; then
                index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)
                if [ -n "$index" ]; then
                    selected_encoded_favorite="${favorites[$((index - 1))]}"
                    
                    # Handle case where only one item is present
                    if [ "$(wc -l < "$favoritesFile")" -eq 1 ]; then
                        # Remove the single encoded item from the file
                        > "$favoritesFile"
                    else
                        # Remove the selected encoded item from the favorites file
                        grep -vF -x "$selected_encoded_favorite" "$favoritesFile" > "${favoritesFile}.tmp" && mv "${favoritesFile}.tmp" "$favoritesFile"
                    fi
                    notify-send "Item removed from favorites."
                else
                    notify-send "Error: Selected favorite not found."
                fi
            fi
        else
            notify-send "No favorites to remove."
        fi
        ;;
    "Clear All Favorites")
        if [ -f "$favoritesFile" ] && [ -s "$favoritesFile" ]; then
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear All Favorites?\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")
            if [ "$confirm" = "Yes" ]; then
                > "$favoritesFile"
                notify-send "All favorites have been deleted."
            fi
        else
            notify-send "No favorites to delete."
        fi
        ;;
        *)
            echo "Invalid action"
            exit 1
            ;;
        esac
        ;;
"Clear History")
    if [ "$(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}")" == "Yes" ] ; then
        cliphist wipe
        notify-send "Clipboard history cleared."
    fi
    ;;
*)
    echo "Invalid action"
    exit 1
    ;;
esac