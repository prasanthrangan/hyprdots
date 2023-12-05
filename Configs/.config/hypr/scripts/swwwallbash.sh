#!/usr/bin/env sh

# set variables

export ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
dcoDir="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/wallbash"
input_wall="$1"
export cacheImg=$(basename "${input_wall}")

if [ -z "${input_wall}" ] || [ ! -f "${input_wall}" ] ; then
    echo "Error: Input wallpaper not found!"
    exit 1
fi


# color conversion functions

hex_conv() {
    rgb_val=$(echo "$1" | sed 's/[-srgb()%]//g ; s/,/ /g')
    red=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $1}')
    green=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $2}')
    blue=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $3}')
    printf "%02X%02X%02X\n" "$red" "$green" "$blue"
}

dark_light () {
    inCol="$1"
    red=$(printf "%d" "0x${inCol:1:2}")
    green=$(printf "%d" "0x${inCol:3:2}")
    blue=$(printf "%d" "0x${inCol:5:2}")
    brightness=$((red + green + blue))
    [ "$brightness" -lt 300 ]
}


# extract 3 dominant colors from input wall

if [ ! -f "${cacheDir}/${gtkTheme}/${cacheImg}.dcol" ] ; then
    mkdir -p "${cacheDir}/${gtkTheme}"
    dcol=(`magick "${input_wall}" -colors 3 -define histogram:unique-colors=true -format "%c" histogram:info: | awk '{print substr($3,2,6)}' | awk '{printf "%d %s\n", "0x"$1, $0}' | sort -n | awk '{print $2}'`)
    for (( i = 1; i < 3; i++ )) ; do
        [ -z "${dcol[i]}" ] && dcol[i]=${dcol[i-1]}
    done

    # generate palette based on 3 primary color

    for (( j = 0; j < 3; j++ )) ; do
        r_swatch=$(echo "#${dcol[j]}" | sed 's/#//g')
        echo "dcol_pry${j}=\"${r_swatch}\"" >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        r_swatch=$(hex_conv `convert xc:"#${dcol[j]}" -negate -format "%c" histogram:info: | awk '{print $4}'`)
        echo "dcol_txt${j}=\"${r_swatch}\"" >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        z=0

        if dark_light "#${dcol[j]}" ; then
            #echo "Generate accent colors for lighter shades..."
            for t in 30 50 70 90 ; do
                z=$(( z + 1 ))
                r_swatch=$(hex_conv `convert xc:"#${dcol[j]}" -modulate 200,"$(awk "BEGIN {print $t * 1.5}")",$(( 100 - (2*z) )) -channel RGB -evaluate multiply 1.$t -format "%c" histogram:info: | awk '{print $4}'`)
                echo "dcol_${j}xa${z}=\"${r_swatch}\"" >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
            done
        else
            #echo "Generate accent colors for darker shades..."
            for t in 15 35 55 75 ; do
                z=$(( z + 1 ))
                r_swatch=$(hex_conv `convert xc:"#${dcol[j]}" -modulate 80,"$(awk "BEGIN {print $t * 1.5}")",$(( 100 + (2*z) )) -channel RGB -evaluate multiply 1.$t -format "%c" histogram:info: | awk '{print $4}'`)
                echo "dcol_${j}xa${z}=\"${r_swatch}\"" >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
            done
        fi
    done
fi


# wallbash fn to apply colors to templates

fn_wallbash () {
    local tplt="${1}"
    eval target=$(head -1 "${tplt}" | awk -F '|' '{print $1}')
    eval appexe=$(head -1 "${tplt}" | awk -F '|' '{print $2}')
    source "${ScrDir}/globalcontrol.sh"
    source "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"

    sed '1d' "${tplt}" > "${target}"
    sed -i "s/<wallbash_pry0>/${dcol_pry0}/g
            s/<wallbash_txt0>/${dcol_txt0}/g
            s/<wallbash_0xa1>/${dcol_0xa1}/g
            s/<wallbash_0xa2>/${dcol_0xa2}/g
            s/<wallbash_0xa3>/${dcol_0xa3}/g
            s/<wallbash_0xa4>/${dcol_0xa4}/g
            s/<wallbash_pry1>/${dcol_pry1}/g
            s/<wallbash_txt1>/${dcol_txt1}/g
            s/<wallbash_1xa1>/${dcol_1xa1}/g
            s/<wallbash_1xa2>/${dcol_1xa2}/g
            s/<wallbash_1xa3>/${dcol_1xa3}/g
            s/<wallbash_1xa4>/${dcol_1xa4}/g
            s/<wallbash_pry2>/${dcol_pry2}/g
            s/<wallbash_txt2>/${dcol_txt2}/g
            s/<wallbash_2xa1>/${dcol_2xa1}/g
            s/<wallbash_2xa2>/${dcol_2xa2}/g
            s/<wallbash_2xa3>/${dcol_2xa3}/g
            s/<wallbash_2xa4>/${dcol_2xa4}/g" "${target}"

    if [ ! -z "${appexe}" ] ; then
        "${appexe}"
    fi
}

export -f fn_wallbash


# exec wallbash fn in parallel

find "$dcoDir" -type f -name "*.dcol" | parallel -j 0 fn_wallbash

