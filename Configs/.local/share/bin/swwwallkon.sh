#!/usr/bin/env sh


# Set variables

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/globalcontrol.sh"
scrName="$(basename "$0")"
wallPath="${confDir}/swww"
kmenuPath="$HOME/.local/share/kio/servicemenus"
kmenuDesk="${kmenuPath}/hydewallpaper.desktop"
readarray -t theme_ctl < <(cut -d '|' -f 2 "$themeCtl")
themeAction=$(echo "${theme_ctl[*]}" | sed 's/ /;/g')


# Evaluate options

while getopts "t:w:" option ; do
    case $option in

        t ) # Set theme
            if echo "${theme_ctl[*]}" | grep -qw "$OPTARG" ; then
                setTheme="$OPTARG"
            else
                echo "Error: '$OPTARG' theme not available..."
                exit 1
            fi
            ;;

        w ) # Set wallpaper
            if [ -f "$OPTARG" ] && file --mime-type "$OPTARG" | grep -q 'image/' ; then
                setWall="$OPTARG"
            else
                echo "Error: '$OPTARG' is not an image file..."
                exit 1
            fi
            ;;

        * ) # Refresh menu
            unset setTheme
            unset setWall
            ;;

    esac
done


# Regenerate desktop

if [ ! -z "${setTheme}" ] && [ ! -z "${setWall}" ] ; then

    thmWall=$(basename "${setWall}")
    xWall="${wallPath}/${setTheme}/${thmWall}"
    cp "${setWall}" "${xWall}"
    awk -F '|' -v thm="${setTheme}" -v wal="${xWall}" '{OFS=FS} {if($2==thm)$NF=wal;print$0}' "${themeCtl}" > "${scrDir}/tmp" && mv "${scrDir}/tmp" "${themeCtl}"
    ${scrDir}/themeswitch.sh -s "${setTheme}"

else

    echo -e "[Desktop Entry]\nType=Service\nMimeType=image/png;image/jpeg;image/jpg;image/gif\nActions=Menu-Refresh;${themeAction}\nX-KDE-Submenu=Set As Wallpaper...\n\n[Desktop Action Menu-Refresh]\nName=.: Refresh List :.\nExec=${scrDir}/${scrName}" > "${kmenuDesk}"
    for thm in "${theme_ctl[@]}" ; do
        echo -e "\n[Desktop Action ${thm}]\nName=${thm}\nExec=${scrDir}/${scrName} -t ${thm} -w %u" >> "${kmenuDesk}"
    done

fi

