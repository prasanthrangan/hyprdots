#!bin/bash
############################################
#                                          #
# HyprWorld Install Script                 #
# by 5ouls3dge (2024)                      #
#                                          #
############################################

#!/bin/bash

PS3="Select an option: "

select main_option in "Install HyprWorld" "Install Arch Only" "Install Hyprland only" "Run Nvidia Setup" "Run Plymouth Install" "Quit"
do
    case $main_option in
        "Install HyprWorld")
            echo "Installing HyprWorld..."
            ./arch/install.sh
            ./hyprland/install.sh
            ;;
        "Install Arch Only")
            echo "Installing Arch Only..."
            ./arch/install.sh
            ;;
        "Install Hyprland only")
            echo "Installing Hyprland only..."
            ./hyprland/install.sh
            ;;
        "Run Nvidia Setup")
            echo "Running Nvidia Setup..."
            ./Config/nvidia.sh
            ;;
        "Run Plymouth Install")
            echo "Running Plymouth Install..."
            ./Config/plymouth.sh
            ;;
        "Quit")
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please select a valid option."
            ;;
    esac
done

# End of script
