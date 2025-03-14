#!/usr/bin/env bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to install flatpaks (user) |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

# Define the base and script directories
baseDir=$(dirname "$(realpath "$0")")
scrDir=$(dirname "$(dirname "$(realpath "$0")")")

# Source global functions
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

# Check if Flatpak is installed, and install it if not
if ! pkg_installed flatpak; then
    echo "Flatpak not found. Installing Flatpak..."
    sudo pacman -S flatpak
fi

# Add the Flathub repository if not already added
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Read and process the Flatpak list
echo "Reading Flatpak list..."
flats=$(awk -F '#' '{print $1}' "${baseDir}/custom_flat.lst" | sed 's/ //g' | grep -v '^$')

# Check if the list is empty
if [ -z "$flats" ]; then
    echo "No Flatpak applications found in the list."
    exit 1
fi

# Prepare a menu for user selection
echo "Please select the Flatpak applications you want to install:"
select flatpak in $flats "Install All" "Cancel"; do
    case $flatpak in
        "Install All")
            selected_flats="$flats"
            break
            ;;
        "Cancel")
            echo "Operation cancelled."
            exit 0
            ;;
        *)
            if [[ " $flats " == *" $flatpak "* ]]; then
                selected_flats="$flatpak"
                break
            else
                echo "Invalid selection."
                ;;
            fi
            ;;
    esac
done

# Confirm installation
echo "You have selected the following Flatpak applications for installation:"
echo "$selected_flats"
read -p "Do you want to proceed with the installation? (y/n): " confirm
if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Install selected Flatpak applications
echo "Installing Flatpak applications..."
for flat in $selected_flats; do
    flatpak install --user -y flathub $flat
done

# Remove unused Flatpak runtimes and dependencies
flatpak remove --unused

# Set Flatpak overrides for GTK themes and icons
gtkTheme=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
gtkIcon=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")

flatpak --user override --filesystem=~/.themes
flatpak --user override --filesystem=~/.icons

flatpak --user override --env=GTK_THEME=${gtkTheme}
flatpak --user override --env=ICON_THEME=${gtkIcon}

echo "Flatpak installation complete."
