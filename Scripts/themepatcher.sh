#!/bin/bash
#|---/ /+------------------------------+---/ /|#
#|--/ /-| Script to patch custom theme |--/ /-|#
#|-/ /--| kRHYME7                      |-/ /--|#
#|/ /---+------------------------------+/ /---|#


# error function
ask_help(){
cat << HELP
...Usage...
$0 "Theme-Name" "/Path/to/Configs"
$0 "Theme-Name" "https://github.com/User/Repository"
$0 "Theme-Name" "https://github.com/User/Repository/tree/branch"

Github Repositories will be cloned at $HOME/Clone-Hyprdots
Please Visit https://github.com/prasanthrangan/hyprdots for info. 
HELP

exit 1
}

if [[ -z $1 || -z $2 ]]; then ask_help ; exit 1 ; fi

# set parameters
Fav_Theme=$1
ThemeCtl="$HOME/.config/swww/wall.ctl"

if [ -d "$2" ]; then Theme_Dir="$2"
else Git_Repo=${2%/} 
    if echo "$Git_Repo" | grep -q "/tree/"; then branch=${Git_Repo#*tree/} Git_Repo=${Git_Repo%/tree/*}
    else branches=$(curl -s "https://api.github.com/repos/${Git_Repo#*://*/}/branches" | jq -r '.[].name') ; branches=($branches)
        if [[ ${#branches[@]} -le 1 ]]; then branch=${branches[0]}
        else echo "Select a Branch" 
            select branch in "${branches[@]}"; do [[ -n $branch ]] && break || echo "Invalid selection. Please try again." ;done
        fi
        
    fi
Git_Path=${Git_Repo#*://*/} Git_Owner=${Git_Path%/*} branch_dir=${branch//\//_}
Theme_Dir="$HOME/Clone-Hyprdots/$Git_Owner-$branch_dir"
    if [ -d "$Theme_Dir" ]; then echo "Directory $Theme_Dir already exists. Using existing directory."
        if cd "$Theme_Dir"; then git stash 2> /dev/null ; git pull ; git stash pop 2> /dev/null ; cd -
        else echo -e "\033[0;31mCould not navigate to $Theme_Dir. Skipping git pull.\033[0m"
        fi
    else echo "Directory $Theme_Dir does not exist. Cloning repository into new directory."
        git clone -b "$branch" --depth 1 "$Git_Repo" "$Theme_Dir"
        if [ $? -ne 0 ]; then echo "Git clone failed" ; exit 1 ; fi
    fi
fi

echo -e "\n" "Patching \033[0;31m${Fav_Theme}\033[0m theme from \033[0;34m${Theme_Dir}\033[0m" "\n"

# required theme files
config=( #!Hard Coded here to atleast Strictly meet requirements.
  ".config/hypr/themes/$Fav_Theme.conf"
  ".config/kitty/themes/$Fav_Theme.conf"
  ".config/Kvantum/$Fav_Theme/$Fav_Theme.kvconfig"
  ".config/Kvantum/$Fav_Theme/$Fav_Theme.svg"
  ".config/qt5ct/colors/$Fav_Theme.conf"
  ".config/rofi/themes/$Fav_Theme.rasi"
  ".config/swww/$Fav_Theme/"
  ".config/waybar/themes/$Fav_Theme.css"
)

# Loop through the config and check if these exist
for file in "${config[@]}"; do
    if [[ -e "$Theme_Dir/Configs/$file" ]]; then continue
    else
        echo "==> $file  does NOT EXIST in ==> $Theme_Dir!" ; exit 1
    fi
done

# extract arcs
themes=("Gtk" "Font" "Icon" "Cursor" "Code")
declare -A themes_dirs
themes_dirs["Gtk"]="$HOME/.themes"
themes_dirs["Font"]="$HOME/.local/share/fonts"
themes_dirs["Icon"]="$HOME/.icons"
themes_dirs["Cursor"]="$HOME/.icons"
themes_dirs["Code"]="$HOME/.vscode"
extensions=("tar.xz" "tar.gz")
# Loop over the themes and extensions
for theme in "${themes[@]}"; do 
 for ext in "${extensions[@]}"; do
   file="${Theme_Dir}/Source/arcs/${theme}_${Fav_Theme}.${ext}"
   clean="${Theme_Dir}/Source/arcs/${theme}_"$(echo "$Fav_Theme" | tr -d '-')".${ext}"
   if [ -f "$file" ] || [ -f "$clean" ]; then if [ -f "$clean" ]; then file=$clean ; fi
       sudo tar -xf "$file" -C "${themes_dirs[$theme]}" 
       echo "Uncompressing ${file##*/} --> ${themes_dirs[$theme]}... Success" 
       gtk_exist=true 
       break
   else if [[ "$theme" == "Gtk" ]]; then gtk_exist=false ; fi ; continue ;fi 
 done ;if [[ $gtk_exist == false ]]; then echo "Required: Gtk_${Fav_Theme} Archive not found." ; exit 1 ; fi
done
fc-cache -f

# generate restore_cfg control
cat << THEME > "${Fav_Theme}restore_cfg.lst"
Y|${HOME}/.config/hypr/themes|${Fav_Theme}.conf|hyprland
Y|${HOME}/.config/kitty/themes|${Fav_Theme}.conf|kitty
Y|${HOME}/.config/Kvantum|${Fav_Theme}|kvantum
Y|${HOME}/.config/qt5ct/colors|${Fav_Theme}.conf|qt5ct
Y|${HOME}/.config/rofi/themes|${Fav_Theme}.rasi|rofi
N|${HOME}/.config/swww|${Fav_Theme}|swww
Y|${HOME}/.config/waybar/themes|${Fav_Theme}.css|waybar
THEME

# restore configs with theme override
./restore_cfg.sh "$Fav_Theme" "$Theme_Dir/Configs"

if ! grep -q "|$Fav_Theme|" "$ThemeCtl" ; then 
wallpaper="$(ls ~/.config/swww/"$Fav_Theme"/* | sort | head -n 1)"
cat << WALL >> "$ThemeCtl"
0|$Fav_Theme|$wallpaper
WALL
    echo "$Fav_Theme appended to $ThemeCtl"
else
    echo "$Fav_Theme already exists in $ThemeCtl. Skipping..."
fi

rm "${Fav_Theme}restore_cfg.lst"
