#!/bin/bash

main_dir=~/.config/hyde
sddm_conf="/etc/sddm.conf.d/kde_settings.conf"

# Display error & exit
error_exit() {
    echo "$1" >&2
    exit 1
}

# Check if the theme directory exists
theme_name=$(awk -F'["=]' '/hydeTheme/{print $3}' "$main_dir/hyde.conf")
theme_dir="$main_dir/themes/$theme_name"
[ -d "$theme_dir" ] || error_exit "Theme directory '$theme_dir' does not exist."

# Find the current SDDM theme
[ -f "$sddm_conf" ] || error_exit "SDDM configuration file '$sddm_conf' not found."
sddm_theme=$(awk -F'=' '/^\[Theme\]/{flag=1} flag && /^Current/{print $2; exit}' "$sddm_conf" | tr -d '[:space:]')
[ -n "$sddm_theme" ] || error_exit "Unable to determine the current SDDM theme."

# Check if sddm has execution access to home directory
if ! getfacl -p "/home/$USER" | grep -q "user:sddm:x"; then
    echo "Granting SDDM execution access to /home/$USER..."
    setfacl -m u:sddm:x "/home/$USER"
fi

currentbg="$theme_dir/wall.set"
sddmbg="/usr/share/sddm/themes/$sddm_theme/backgrounds/bg.png"
sddmconf="/usr/share/sddm/themes/$sddm_theme/theme.conf"

echo "$currentbg"
echo "Copying dynamic wallpaper to SDDM background location..."
cp "$currentbg" "$sddmbg"

echo "Setting static SDDM background..."
sed -i "s|^Background=.*|Background=\"$sddmbg\"|" "$sddmconf"
