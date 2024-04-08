#!/usr/bin/env bash
#|---/ /+------------------------------+---/ /|#
#|--/ /-| Script to patch custom theme |--/ /-|#
#|-/ /--| kRHYME7                      |-/ /--|#
#|/ /---+------------------------------+/ /---|#

print_prompt() {
    while (( "$#" )); do
        case "$1" in
            -r) echo -ne "\e[31m$2\e[0m"; shift 2 ;; # Red
            -g) echo -ne "\e[32m$2\e[0m"; shift 2 ;; # Green
            -y) echo -ne "\e[33m$2\e[0m"; shift 2 ;; # Yellow
            -b) echo -ne "\e[34m$2\e[0m"; shift 2 ;; # Blue
            -m) echo -ne "\e[35m$2\e[0m"; shift 2 ;; # Magenta
            -c) echo -ne "\e[36m$2\e[0m"; shift 2 ;; # Cyan
            -w) echo -ne "\e[37m$2\e[0m"; shift 2 ;; # White
            -n) echo -ne "\e[96m$2\e[0m"; shift 2 ;; # Neon
            *) echo -ne "$1"; shift ;;
        esac
    done
    echo ""
}

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh..."
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

if [[ -z $1 || -z $2 ]] ; then ask_help ; exit 1 ; fi

dcolDir="${hydeConfDir}/wallbash/Wall-Dcol"
[ ! -d "${dcolDir}" ] && print_prompt "[ERROR] " "${dcolDir} do not exist!" &&  exit 1

# set parameters
Fav_Theme="$1"

if [ -d "$2" ]; then
    Theme_Dir="$2"

else Git_Repo=${2%/}
    if echo "$Git_Repo" | grep -q "/tree/" ; then
        branch=${Git_Repo#*tree/}
        Git_Repo=${Git_Repo%/tree/*}
    else
        branches=$(curl -s "https://api.github.com/repos/${Git_Repo#*://*/}/branches" | jq -r '.[].name')
        branches=($branches)
        if [[ ${#branches[@]} -le 1 ]] ; then
            branch=${branches[0]}
        else
            echo "Select a Branch"
            select branch in "${branches[@]}" ; do
                [[ -n $branch ]] && break || echo "Invalid selection. Please try again."
            done
        fi
    fi

    Git_Path=${Git_Repo#*://*/}
    Git_Owner=${Git_Path%/*}
    branch_dir=${branch//\//_}
    Theme_Dir="${cacheDir}/themepatcher/${branch_dir}-${Git_Owner}"

    if [ -d "$Theme_Dir" ] ; then
        echo "Directory $Theme_Dir already exists. Using existing directory."
        if cd "$Theme_Dir" ; then
            git fetch --all &> /dev/null
            git reset --hard @{upstream} &> /dev/null
            cd - &> /dev/null
        else
            print_prompt -y "Could not navigate to $Theme_Dir. Skipping git pull."
        fi
    else
        echo "Directory $Theme_Dir does not exist. Cloning repository into new directory."
        git clone -b "$branch" --depth 1 "$Git_Repo" "$Theme_Dir"
        if [ $? -ne 0 ] ; then
            echo "Git clone failed"
            exit 1
        fi
    fi
fi

print_prompt "Patching" -g " --//${Fav_Theme}//-- "  "from" -b "${Theme_Dir}\n"

Fav_Theme_Dir="${Theme_Dir}/Configs/.config/hyde/themes/${Fav_Theme}"
[ ! -d "${Fav_Theme_Dir}" ] && print_prompt -r "[ERROR] " "'${Fav_Theme_Dir}'" -y " Do not Exist" && exit 1

config=$(find "${dcolDir}" -type f -name "*.dcol" | awk -v favTheme="${Fav_Theme}" -F 'Wall-Dcol/' '{gsub(/\.dcol$/, ".theme"); print ".config/hyde/themes/" favTheme "/" $2}')
restore_list=""

while IFS= read -r fchk; do
    if [[ -e "${Theme_Dir}/Configs/${fchk}" ]]; then
        print_prompt -g "[OK]"  "${fchk}"
        fbase=$(basename "${fchk}")
        fdir=$(dirname "${fchk}")
         restore_list+="Y|Y|\${HOME}/${fdir}|${fbase}|hyprland\n"
    else
        print_prompt -r "[ERROR] " "${fchk} --> do not exist in ${Theme_Dir}/Configs/"
        exit_flag=true
    fi
done <<< "$config"
readonly restore_list

# Get Wallpapers
wallpapers=$(find "${Fav_Theme_Dir}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))
{ [ -z "${wallpapers}" ] && print_prompt -r "[ERRO] " "No wallpapers found" && exit_flag=true ;} || { readonly wallpapers && print_prompt -g "[OK]" " Wallpapers\n" ;}

# overparsing 😁
readonly gtkTheme="$(awk -F"[\"']" '/^[[:space:]]*exec[[:space:]]*=[[:space:]]*gsettings[[:space:]]*set[[:space:]]*org.gnome.desktop.interface[[:space:]]*gtk-theme[[:space:]]*/ {last=$2} END {print last}' "${Fav_Theme_Dir}/hypr.theme" )"
readonly iconTheme="$(awk -F"[\"']" '/^[[:space:]]*exec[[:space:]]*=[[:space:]]*gsettings[[:space:]]*set[[:space:]]*org.gnome.desktop.interface[[:space:]]*icon-theme[[:space:]]*/ {last=$2} END {print last}' "${Fav_Theme_Dir}/hypr.theme" )"
readonly cursorTheme="$(awk -F"[\"']" '/^[[:space:]]*exec[[:space:]]*=[[:space:]]*gsettings[[:space:]]*set[[:space:]]*org.gnome.desktop.interface[[:space:]]*cursor-theme[[:space:]]*/ {last=$2} END {print last}' "${Fav_Theme_Dir}/hypr.theme" )"

{ [ -z "${gtkTheme}" ] && print_prompt -r "[ERROR] " "No gtk theme" && exit_flag=true ;} || print_prompt -g "[OK] " "Gtk:" -b " ${gtkTheme}"
{ [ -z "${iconTheme}" ] && print_prompt -y "[!!] " "No icon theme" ;} || print_prompt -g "[OK] " "Icon:" -b " ${iconTheme}"
{ [ -z "${cursorTheme}" ] && print_prompt -y "[!!] " "No cursor theme\n" ;} || print_prompt -g "[OK] " "Cursor:" -b " ${cursorTheme}\n"

# extract arcs
prefix=("Gtk" "Font" "Icon" "Cursor")
declare -A TrgtDir
TrgtDir["Gtk"]="$HOME/.themes"                                  #mandatory
TrgtDir["Font"]="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"    #optional
TrgtDir["Icon"]="$HOME/.icons"                                  #optional
TrgtDir["Cursor"]="$HOME/.icons"                                #optional
declare -A keyTheme
keyTheme["Gtk"]="${gtkTheme}"
keyTheme["Icon"]="${iconTheme}"
keyTheme["Cursor"]="${cursorTheme}"

postfx=("tar.xz" "tar.gz")
GtkFlag=0

[[ "${exit_flag}" = true ]] && exit 1 
# Loop over the themes and extensions
for pre in "${prefix[@]}" ; do

    for ext in "${postfx[@]}" ; do
        # Use a wildcard pattern to match files
        for file in "${Theme_Dir}"/*/*/"${pre}"_*."${ext}" ; do
            if [ -f "$file" ]; then
                if tar -tf "$file" | grep -Eq "${keyTheme[$pre]}" ; then
                print_prompt -g "[Extracting] "  "${file} --> ${TrgtDir[$pre]}"
                tar -xf "${file}" -C "${TrgtDir[$pre]}" && [[ "$pre" == *"Gtk"* ]] && GtkFlag=1
                fi
            fi
        done
    done
done
readonly extract

if [ ${GtkFlag} -eq 0 ] ; then
    print_prompt -r "\n[ERROR] "  "Gtk pack not found --> ${Theme_Dir}/Source/arcs/${pre}_${Fav_Theme}.${ext}"
    exit 1
fi

echo -en "${restore_list}" > "${Theme_Dir}/restore_cfg.lst"

# populate wallpaper
print_prompt -y "\n[$(echo "${wallpapers}" | wc -l)]" " Wallpapers"
Fav_Theme_Walls="$hydeConfDir/themes/${Fav_Theme}/wallpapers"
[ ! -d "${Fav_Theme_Walls}" ] && mkdir -p "${Fav_Theme_Walls}"
while IFS= read -r walls; do
# print_prompt -g "[WP]" "$walls ${Fav_Theme_Walls}"
    cp -f "$walls" "${Fav_Theme_Walls}"
done <<< "${wallpapers}"

# restore configs with theme override
print_prompt -g "\n[Restoring]" "\"${Theme_Dir}/restore_cfg.lst\" \"${Theme_Dir}/Configs\" \"${Fav_Theme}\"\n"
"${scrDir}/restore_cfg.sh" "${Theme_Dir}/restore_cfg.lst" "${Theme_Dir}/Configs" "${Fav_Theme}"

exit 0
