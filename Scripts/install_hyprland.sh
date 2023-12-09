#!/bin/env bash
source global_fn.sh
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

hyprland_clone="$HOME/.cache/hyprdots/Hyprland-clone"

chk_aurh

if ! pkg_installed hyprland-git ; then
    $aurhlpr ${use_default} -S hyprland-git || true
    if ! pkg_installed hyprland-git ; then #? redunduncy
echo -e "\n\033[0;31mWARNING!!! READ ME!\033[0m"
cat << WARN

Hyprland installation failed! 
Please check your internet connection and consider reporting the issue to your package manager's support.
For manual installation of Hyprland, you can proceed with this installation or follow the guide at https://wiki.hyprland.org/Getting-Started/Installation/ (Press any key to exit)


Note: This process is a work around. 
Typically, it's recommended to use package managers for installations/updates as they handle the process more efficiently.

IMPORTANT: After installation with this method please be aware that you should install hyprland with your package manager if already available. 
example: "$aurhlpr -Sy hyprland-git", or run ./install.sh  again 

The script will now attempt to:
1. Manually compile and install Hyprland.
2. Check and install any missing dependencies.
3. Clone Hyprland to $hyprland_clone
4. Execute [ make all && sudo make install ]

Please ensure you have sufficient permissions, internet connection and disk space for this operation.

WARN
    echo ""
    read -n 1 -s -r -p "[ENTER/SPACE:yes ANY:no] Do you want to proceed with the installation? " key
    [[ -z "$key" ]] || exit 0

    echo -e "\nChecking dependencies..."
        dependencies=(gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus)
        missing_dependencies=()
        for dependency in "${dependencies[@]}"; do
            if ! pkg_installed $dependency; then
                missing_dependencies+=($dependency)
            fi
        done
        if [ ${#missing_dependencies[@]} -gt 0 ]; then
            echo "Missing dependencies: ${missing_dependencies[@]}"
            echo "Installing missing dependencies..."
            $aurhlpr ${use_default} -S ${missing_dependencies[@]}
        fi

        if cd "$hyprland_clone" 2>/dev/null; then
            git fetch
            if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
                echo "Changes are available in the remote repository. Pulling changes..."
                git reset --hard
                git clean -fd
                git pull
            else
                if command -v Hyprland >/dev/null; then
                    echo -e "\033[1;33mLatest version of Hyprland is already compiled and installed!\033[0m"
                    exit 0
                fi
            fi
        else
            mkdir -p "$hyprland_clone"
            git clone --recursive https://github.com/hyprwm/Hyprland "$hyprland_clone"
            cd $hyprland_clone
        fi

        echo "Compiling Directory: $(pwd)"
        make all && sudo make install
    fi
else
     echo -e "\033[0;32m[OK]\033[0m Hyprland"
fi 
