#!bin/bash
############################################
#                                          #
# HyprWorld Install Script                 #
# by 5ouls3dge (2024)                      #
#                                          #
############################################
#!/bin/bash

PS3="Select an option: "

select main_option in "Installation Options" "Run Scripts" "Create HyprWorld" "Quit"
do
    case $main_option in
        "Installation Options")
            echo "Select an installation option:"
            select install_option in "Install HyprWorld" "Install Arch Only" "Install Hyprland only" "Back to Main Menu"
            do
                case $install_option in
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
                    "Back to Main Menu")
                        break
                        ;;
                    *)
                        echo "Invalid option. Please select a valid option."
                        ;;
                esac
            done
            ;;
        "Run Scripts")
            echo "Select a script to run:"
            select script_option in "Run Nvidia Setup" "Run Plymouth Install" "Back to Main Menu"
            do
                case $script_option in
                    "Run Nvidia Setup")
                        echo "Running Nvidia Setup..."
                        ./Config/nvidia.sh
                        ;;
                    "Run Plymouth Install")
                        echo "Running Plymouth Install..."
                        ./Config/plymouth.sh
                        ;;
                    "Back to Main Menu")
                        break
                        ;;
                    *)
                        echo "Invalid option. Please select a valid option."
                        ;;
                esac
            done
            ;;
        "Create HyprWorld")
            echo "Creating HyprWorld..."
            # Add logic to create HyprWorld
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
