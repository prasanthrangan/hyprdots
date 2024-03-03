#!/bin/bash
#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Script to generate wallpaper cache |--/ /-|#
#|-/ /--| Kemipso                            |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

if ! pkg_installed imagemagick || ! pkg_installed parallel 
then
    echo "ERROR : dependency failed, imagemagick/parallel is not installed..."
    exit 0
fi

# set variables
ctlFile="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/theme.ctl"
ctlLine=`grep '^1|' $ctlFile`
export cacheDir="$HOME/.cache/hyprdots"

# evaluate options
while getopts "fc:" option ; do
    case $option in
    f ) # force remove cache
        rm -Rf ${cacheDir}
        echo "Cache dir ${cacheDir} cleared...";;
    c ) # use custom wallpaper
        inWall="$OPTARG"
        if [[ "${inWall}" == '~'* ]]; then
            inWall="$HOME${inWall:1}"
        fi
        if [[ -f "${inWall}" ]] ; then
            if [ `echo "$ctlLine" | wc -l` -eq "1" ] ; then
                curTheme=$(echo "$ctlLine" | cut -d '|' -f 2)
                awk -F '|' -v thm="${curTheme}" -v wal="${inWall}" '{OFS=FS} {if($2==thm)$NF=wal;print$0}' "${ctlFile}" > /tmp/t2 && mv /tmp/t2 "${ctlFile}"
            else
                echo "ERROR : $ctlFile Unable to fetch theme..."
                exit 1
            fi
        else
            echo "ERROR: wallpaper ${inWall} not found..."
            exit 1
        fi ;;
    * ) # invalid option
        echo "...valid options are..."   
    	echo "./create_cache.sh -f                      # force create thumbnails (delete old cache)"
        echo "./create_cache.sh -c /path/to/wallpaper   # generate cache for custom walls"
        exit 1 ;;
    esac
done

shift $((OPTIND - 1))
ctlRead=$(awk -F '|' -v thm="${1}" '{if($2==thm) print$0}' "${ctlFile}")
[ -z "${ctlRead}" ] && ctlRead=$(cat "${ctlFile}")

# magick function
hex_conv() {
    rgb_val=$(echo "$1" | sed 's/[-srgb()%]//g ; s/,/ /g')
    red=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $1}')
    green=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $2}')
    blue=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $3}')
    printf "%02X%02X%02X\n" "$red" "$green" "$blue"
}

rgb_negative() {
    local rgb_val=$1
    red=${rgb_val:0:2}
    green=${rgb_val:2:2}
    blue=${rgb_val:4:2}
    red_dec=$((16#$red))
    green_dec=$((16#$green))
    blue_dec=$((16#$blue))
    negative_red=$(printf "%02X" $((255 - $red_dec)))
    negative_green=$(printf "%02X" $((255 - $green_dec)))
    negative_blue=$(printf "%02X" $((255 - $blue_dec)))
    echo "${negative_red}${negative_green}${negative_blue}"
}

dark_light() {
    inCol="$1"
    red=$(printf "%d" "0x${inCol:1:2}")
    green=$(printf "%d" "0x${inCol:3:2}")
    blue=$(printf "%d" "0x${inCol:5:2}")
    brightness=$((red + green + blue))
    [ "$brightness" -lt 250 ]
}

imagick_t2 () {
    theme="$1"
    wpFullName="$2"
    wpBaseName=$(basename "${wpFullName}")

    if [ ! -f "${cacheDir}/${theme}/${wpBaseName}" ]; then
        convert "${wpFullName}"[0] -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${theme}/${wpBaseName}"
    fi

    if [ ! -f "${cacheDir}/${theme}/${wpBaseName}.rofi" ]; then
        convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 "${wpFullName}"[0] "${cacheDir}/${theme}/${wpBaseName}.rofi"
    fi

    if [ ! -f "${cacheDir}/${theme}/${wpBaseName}.blur" ]; then
        convert -strip -scale 10% -blur 0x3 -resize 100% "${wpFullName}"[0] "${cacheDir}/${theme}/${wpBaseName}.blur"
    fi

    if [ ! -f "${cacheDir}/${theme}/${wpBaseName}.dcol" ] ; then
        readarray -t dcol <<< $(magick "${wpFullName}"[0] -colors 3 -define histogram:unique-colors=true -format "%c" histogram:info: | sed -e 's/.*\(#[0-9A-F]\+\).*/\1/' | cut -c2-7 | sort)
        for (( i = 1; i < 3; i++ )) ; do
            [ -z "${dcol[i]}" ] && dcol[i]=${dcol[i-1]}
        done

        for (( j = 0; j < 3; j++ )) ; do
            r_swatch=$(echo "#${dcol[j]}" | sed 's/#//g')
            echo "dcol_pry${j}=\"${r_swatch}\"" >> "${cacheDir}/${theme}/${wpBaseName}.dcol"
            r_swatch=$(rgb_negative ${dcol[j]})
            echo "dcol_txt${j}=\"${r_swatch}\"" >> "${cacheDir}/${theme}/${wpBaseName}.dcol"
            z=0

            if dark_light "#${dcol[j]}" ; then
                for t in 25 45 65 85 ; do
                    z=$(( z + 1 ))
                    r_swatch=$(hex_conv `convert xc:"#${dcol[j]}" -modulate 70,"$(awk "BEGIN {print $t * 1.5}")",$(( 100 + (6*z) )) -channel RGB -evaluate multiply 3.$t -format "%c" histogram:info: | awk '{print $4}'`)
                    echo "dcol_${j}xa${z}=\"${r_swatch}\"" >> "${cacheDir}/${theme}/${wpBaseName}.dcol"
                done
            else
                for t in 20 40 60 80 ; do
                    z=$(( z + 1 ))
                    r_swatch=$(hex_conv `convert xc:"#${dcol[j]}" -modulate 100,"$(awk "BEGIN {print $t * 1.5}")",$(( 100 + (3*z) )) -channel RGB -evaluate multiply 1.$t -format "%c" histogram:info: | awk '{print $4}'`)
                    echo "dcol_${j}xa${z}=\"${r_swatch}\"" >> "${cacheDir}/${theme}/${wpBaseName}.dcol"
                done
            fi
        done
    fi
}

export -f hex_conv
export -f rgb_negative
export -f dark_light
export -f imagick_t2

# create thumbnails for each theme > wallpapers
echo "${ctlRead}" | while read ctlLine
do
    theme=$(echo $ctlLine | awk -F '|' '{print $2}')
    fullPath=$(echo "$ctlLine" | awk -F '|' '{print $NF}' | sed "s+~+$HOME+")
    wallPath=$(dirname "$fullPath")
    mkdir -p ${cacheDir}/${theme}
    mapfile -d '' wpArray < <(find "${wallPath}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)
    echo "Creating thumbnails for ${theme} [${#wpArray[@]}]"
    parallel --bar imagick_t2 ::: "${theme}" ::: "${wpArray[@]}"

if pkg_installed code ; then
    if [ ! -z "$(echo $ctlLine | awk -F '|' '{print $3}')" ] ; then
        codex=$(echo $ctlLine | awk -F '|' '{print $3}' | cut -d '~' -f 1)
        if [ $(code --list-extensions |  grep -iwc "${codex}") -eq 0 ] ; then
            code --install-extension "${codex}" 2> /dev/null || true
        fi
    fi
fi

done
