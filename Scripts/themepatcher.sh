#!/bin/bash
#|---/ /+------------------------------+---/ /|#
#|--/ /-| Script to patch custom theme |--/ /-|#
#|-/ /--| kRHYME7                      |-/ /--|#
#|/ /---+------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

set +e


# error function
ask_help(){
cat << HELP
...Usage...
$0 "Theme-Name" "/Path/to/Configs"
$0 "Theme-Name" "https://github.com/User/Repository"
$0 "Theme-Name" "https://github.com/User/Repository/tree/branch"
HELP
}

if [[ -z $1 || -z $2 ]]; then ask_help ; exit 1 ; fi


# set parameters
Fav_Theme="$1"

if [ -d "$2" ]; then
    Theme_Dir="$2"

else Git_Repo=${2%/}
    if echo "$Git_Repo" | grep -q "/tree/"; then
        branch=${Git_Repo#*tree/} Git_Repo=${Git_Repo%/tree/*}
    else branches=$(curl -s "https://api.github.com/repos/${Git_Repo#*://*/}/branches" | jq -r '.[].name') ; branches=($branches)
        if [[ ${#branches[@]} -le 1 ]]; then
            branch=${branches[0]}
        else echo "Select a Branch"
            select branch in "${branches[@]}"; do [[ -n $branch ]] && break || echo "Invalid selection. Please try again." ; done
        fi
    fi

    Git_Path=${Git_Repo#*://*/} Git_Owner=${Git_Path%/*} branch_dir=${branch//\//_}
    Theme_Dir="$HOME/Clone/HyprdotsPatch-$branch_dir"

    if [ -d "$Theme_Dir" ]; then
        echo "Directory $Theme_Dir already exists. Using existing directory."
        if cd "$Theme_Dir"; then
            git stash 2> /dev/null ; git pull ; git stash pop 2> /dev/null ; cd -
        else
            echo -e "\033[0;31mCould not navigate to $Theme_Dir. Skipping git pull.\033[0m"
        fi
    else
        echo "Directory $Theme_Dir does not exist. Cloning repository into new directory."
        git clone -b "$branch" --depth 1 "$Git_Repo" "$Theme_Dir"
        if [ $? -ne 0 ]; then echo "Git clone failed" ; exit 1 ; fi
    fi
fi

echo -e "\nPatching \033[0;32m--//${Fav_Theme}//--\033[0m from \033[0;34m${Theme_Dir}\033[0m\n"


# required theme files
config=( #!Hard Coded here to atleast Strictly meet requirements.
  ".config/hypr/themes/$Fav_Theme.conf"
  ".config/kitty/themes/$Fav_Theme.conf"
  ".config/Kvantum/$Fav_Theme/$Fav_Theme.kvconfig"
  ".config/Kvantum/$Fav_Theme/$Fav_Theme.svg"
  ".config/qt5ct/colors/$Fav_Theme.conf"
  ".config/qt6ct/colors/$Fav_Theme.conf"
  ".config/rofi/themes/$Fav_Theme.rasi"
  ".config/swww/$Fav_Theme/"
  ".config/waybar/themes/$Fav_Theme.css"
)


# Loop through the config and check if these exist
for fchk in "${config[@]}"; do
    if [[ -e "${Theme_Dir}/Configs/${fchk}" ]]; then
        echo -e "\033[0;32m[OK]\033[0m ${fchk}"
    else
        echo -e "\033[0;31m[ERROR]\033[0m ${fchk} --> does not exist in ${Theme_Dir}/Configs/"
        exit 1
    fi
done

mapfile -d '' Wallist < <(find ${Theme_Dir}/Configs/.config/swww/"${Fav_Theme}"/ -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)

if [ "${#Wallist[@]}" -eq 0 ] ; then
    echo -e "\033[0;31m[ERROR]\033[0m No wallpaper found in ${Theme_Dir}/Configs/.config/swww/"
    exit 1
else
    WallSet=$(basename "${Wallist[0]}")
    echo -e "\nDefault wallpaper selected : \"${WallSet}\"\n"
fi


# extract arcs
prefix=("Gtk" "Font" "Icon" "Cursor")
declare -A TrgtDir
TrgtDir["Gtk"]="$HOME/.themes"                                  #mandatory
TrgtDir["Font"]="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"    #optional
TrgtDir["Icon"]="$HOME/.icons"                                  #optional
TrgtDir["Cursor"]="$HOME/.icons"                                #optional
postfx=("tar.xz" "tar.gz")
GtkFlag=0


# Loop over the themes and extensions
for pre in "${prefix[@]}"; do
    for ext in "${postfx[@]}"; do
        if [ -f "${Theme_Dir}/Source/arcs/${pre}_${Fav_Theme}.${ext}" ] ; then
            echo -e "\033[0;32m[Extacting]\033[0m ${Theme_Dir}/Source/arcs/${pre}_${Fav_Theme}.${ext} --> ${TrgtDir[$pre]}"
            tar -xf "${Theme_Dir}/Source/arcs/${pre}_${Fav_Theme}.${ext}" -C "${TrgtDir[$pre]}" 
            if [ ${pre} == "Gtk" ] ; then
                GtkFlag=1
            fi
        fi
    done
done

if [ ${GtkFlag} -eq 0 ] ; then
    echo -e "\033[0;31m[ERROR]\033[0m Gtk pack not found --> ${Theme_Dir}/Source/arcs/${pre}_${Fav_Theme}.${ext}"
    exit 1
fi

fc-cache -f


# generate restore_cfg control
cat << THEME > "${Fav_Theme}restore_cfg.lst"
Y|Y|${HOME}/.config/hypr/themes|${Fav_Theme}.conf|hyprland
Y|Y|${HOME}/.config/kitty/themes|${Fav_Theme}.conf|kitty
Y|Y|${HOME}/.config/Kvantum|${Fav_Theme}|kvantum
Y|Y|${HOME}/.config/qt5ct/colors|${Fav_Theme}.conf|qt5ct
Y|Y|${HOME}/.config/qt6ct/colors|${Fav_Theme}.conf|qt6ct
Y|Y|${HOME}/.config/rofi/themes|${Fav_Theme}.rasi|rofi
Y|N|${HOME}/.config/swww|${Fav_Theme}|swww
Y|Y|${HOME}/.config/waybar/themes|${Fav_Theme}.css|waybar
THEME

if grep -q "^.|${Fav_Theme}|" "${ThemeCtl}" ; then
    awk -F '|' -v thm="${Fav_Theme}" -v cde="$3" '{OFS=FS} $2 == thm {$3 = cde} {print}' "${ThemeCtl}" > tmp && mv tmp "${ThemeCtl}"
else
    echo "0|${Fav_Theme}|${3}|~/.config/swww/${Fav_Theme}/${WallSet}" >> "${ThemeCtl}"
fi


# restore configs with theme override
echo -e "\033[0;32m[Restoring]\033[0m restore_cfg.sh \"${Fav_Theme}\" \"${Theme_Dir}/Configs\"\n"
./restore_cfg.sh "$Fav_Theme" "$Theme_Dir/Configs"

rm "${Fav_Theme}restore_cfg.lst"

