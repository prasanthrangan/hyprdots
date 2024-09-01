#!/usr/bin/env bash

# Path to the cache file
CACHE_FILE="/tmp/system_update_status"

# Ensure the cache directory exists
mkdir -p "$(dirname "$CACHE_FILE")"

# Function to check for updates and cache the results
check_and_cache_updates() {
    # Check for official package updates
    local official_updates=$(checkupdates 2>/dev/null | wc -l)

    # Check for AUR updates
    local aur_updates=$(${aurhlpr} -Qua 2>/dev/null | wc -l)

    # Check for Flatpak updates if Flatpak is installed
    local flatpak_updates=0
    if pkg_installed flatpak ; then
        flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
    fi

    # Cache the results
    echo "$official_updates $aur_updates $flatpak_updates" > "$CACHE_FILE"
}

# Function to read updates from the cache file
read_cached_updates() {
    # If cache doesn't exist, create it by checking for updates
    if [ ! -f "$CACHE_FILE" ]; then
        check_and_cache_updates
    fi
    cat "$CACHE_FILE"
}

# Function to perform system upgrade
perform_upgrade() {
    check_and_cache_updates
    trap 'pkill -RTMIN+20 waybar' EXIT

    local command="
    fastfetch
    $0 upgrade
    ${aurhlpr} -Syu
    pkg_installed flatpak && flatpak update
    read -n 1 -p 'Press any key to continue...'
    "
    kitty --title systemupdate sh -c "${command}"
    exit 0
}

# Main script logic
main() {
    # Check if the script is being run on an Arch-based system
    if [ ! -f /etc/arch-release ]; then
        exit 0
    fi

    # Source global variables and functions
    local script_dir=$(dirname "$(realpath "$0")")
    source "$script_dir/globalcontrol.sh"
    get_aurhlpr
    export -f pkg_installed
    local fpk_exup="pkg_installed flatpak && flatpak update"

    # Trigger update check if 'up' or 'upgrade' argument is passed
    if [ "$1" == "up" ] || [ "$1" == "upgrade" ] ; then
        perform_upgrade
    fi

    # Read cached updates
    read -r official_updates aur_updates flatpak_updates < <(read_cached_updates)

    # Calculate total updates
    total_updates=$(( official_updates + aur_updates + flatpak_updates ))

    # Output results for Waybar
    if [ "$1" == "upgrade" ] ; then
        printf "[Official] %-10s\n[AUR]      %-10s\n[Flatpak]  %-10s\n" "$official_updates" "$aur_updates" "$flatpak_updates"
        exit 0
    fi

    # Display output based on the number of available updates
    if [ $total_updates -eq 0 ] ; then
        echo "{\"text\":\"\", \"tooltip\":\" Packages are up to date\"}"
    else
        local flatpak_display=""
        [ $flatpak_updates -gt 0 ] && flatpak_display="\n󰏓 Flatpak $flatpak_updates"
        echo "{\"text\":\"󰮯 $total_updates\", \"tooltip\":\"󱓽 Official $official_updates\n󱓾 AUR $aur_updates$flatpak_display\"}"
    fi
}

# Run the main function
main "$@"
