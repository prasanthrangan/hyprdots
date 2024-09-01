#!/usr/bin/env bash

# Function to check for updates
check_updates() {
    # Check for official package updates
    local official_updates=$(checkupdates 2>/dev/null | wc -l)

    # Check for AUR updates
    local aur_updates=$(${aurhlpr} -Qua 2>/dev/null | wc -l)

    # Check for Flatpak updates if Flatpak is installed
    local flatpak_updates=0
    if pkg_installed flatpak; then
        flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
    fi

    echo "$official_updates $aur_updates $flatpak_updates"
}

# Function to perform system upgrade
perform_upgrade() {
    trap 'pkill -RTMIN+8 waybar' EXIT

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

    # Trigger update check if 'up' or 'upgrade' argument is passed
    if [ "$1" == "up" ] || [ "$1" == "upgrade" ]; then
        perform_upgrade
    fi

    # Check for updates
    read -r official_updates aur_updates flatpak_updates < <(check_updates)

    # Calculate total updates
    total_updates=$(( official_updates + aur_updates + flatpak_updates ))

    # Output results for Waybar
    if [ "$1" == "upgrade" ]; then
        printf "[Official] %-10s\n[AUR]      %-10s\n[Flatpak]  %-10s\n" "$official_updates" "$aur_updates" "$flatpak_updates"
        exit 0
    fi

    # Display output based on the number of available updates
    if [ $total_updates -eq 0 ]; then
        echo "{\"text\":\"\", \"tooltip\":\" Packages are up to date\"}"
    else
        local flatpak_display=""
        [ $flatpak_updates -gt 0 ] && flatpak_display="\n󰏓 Flatpak $flatpak_updates"
        echo "{\"text\":\"󰮯 $total_updates\", \"tooltip\":\"󱓽 Official $official_updates\n󱓾 AUR $aur_updates$flatpak_display\"}"
    fi
}

# Run the main function
main "$@"
