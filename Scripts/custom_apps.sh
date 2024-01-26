#!/bin/bash

lst_file="custom_apps.lst"

# Function to display the menu
display_menu() {
    echo "Menu:"
    echo "1. View apps"
    echo "2. Delete an app"
    echo "3. Add new Apps"
    echo "4. Install packages and exit"
    echo "5. Exit"
}

# Function to view items in the list across rows with numbers
view_items() {
    echo "Current items in $lst_file:"
    awk '{printf "%-3s%-10s%s", NR".", $1, (NR%4==0) ? "\n" : " "} END {if (NR%4!=0) print ""}' "$lst_file"
}

# Function to delete an item from the list
delete_item() {
    view_items
    echo -n "Enter the number of the item to delete: "
    read item_number

    item_to_delete=$(awk -v num="$item_number" 'NR==num {print $1}' "$lst_file")
    
    if [ -n "$item_to_delete" ]; then
        # Use grep to exclude the specified item and create a new file
        grep -v "^$item_to_delete$" "$lst_file" > "$lst_file.tmp"
        
        # Replace the original file with the modified file
        mv "$lst_file.tmp" "$lst_file"

        echo "Item \"$item_to_delete\" deleted."
    else
        echo "Invalid item number."
    fi
}

# Function to add new items to the list
add_items() {
    echo "Enter new items (one per line). Press Ctrl+D to finish:"
    cat >> "$lst_file"
    echo "New items added to $lst_file."
}

# Function to install packages from the list in custom_apps.lst and exit using yay
install_packages_and_exit() {
    echo "Installing apps from the list in $lst_file using yay..."
    
    # Ensure yay is installed
    if ! command -v yay &> /dev/null; then
        echo "yay is not installed. Installing yay..."
        sudo pacman -S --noconfirm yay
        if [ $? -ne 0 ]; then
            echo "Failed to install yay. Exiting."
            exit 1
        fi
    fi
    
    # Install apps listed in custom_apps.lst using yay
    yay -S --noconfirm $(< "$lst_file")

    echo "Apps installed. Exiting."
    exit 0
}


# Main loop
while true; do
    display_menu

    read -p "Enter your choice (1-5): " choice

    case $choice in
        1) view_items ;;
        2) delete_item ;;
        3) add_items ;;
        4) install_packages_and_exit ;;
        5) echo "Exiting."; break ;;
        *) echo "Invalid choice. Please enter a number between 1 and 5." ;;
    esac
done
