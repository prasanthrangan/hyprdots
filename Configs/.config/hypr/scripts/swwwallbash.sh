#!/usr/bin/env sh

# set variables

export ScrDir=`dirname $(realpath $0)`
source $ScrDir/globalcontrol.sh
dcoDir="$HOME/.config/hypr/wallbash"
input_wall="$1"
cacheImg=$(basename "${input_wall}")

if [ -z "${input_wall}" ] || [ ! -f "${input_wall}" ] ; then
    echo "Error: Input wallpaper not found!"
    exit 1
fi


# extract dcols

if [ ! -f "${cacheDir}/${gtkTheme}/${cacheImg}.dcol" ] ; then
    magick "${input_wall}" -colors 4 -define histogram:unique-colors=true -format "%c" histogram:info: > "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
fi

declare -x x_dcol=$(mktemp)
awk '{print substr($3,1,7)}' "${cacheDir}/${gtkTheme}/${cacheImg}.dcol" | sort > "${x_dcol}"


# loop thru templates 

fn_wallbash () {
    local tplt="${1}"
    local dcol=(`cat ${x_dcol}`)
    local dcolct=$(head -1 "${tplt}" | cut -d '|' -f 1)
    eval target=$(head -1 "${tplt}" | cut -d '|' -f 2)
    eval appexe=$(head -1 "${tplt}" | cut -d '|' -f 3)

    sed '1d' "${tplt}" > "${target}"
    for (( i=0; i < dcolct; i++ )) ; do
        if [ -z "${dcol[i]}" ] ; then
            dcol[i]=${dcol[i-1]}
        fi
        sed -i "s/<dcol_${i}>/${dcol[i]}/g" "${target}"
    done

    if [ ! -z "${appexe}" ]; then
        "${appexe}"
    fi
}

export -f fn_wallbash


# Process templates in parallel

find "$dcoDir" -type f -name "*.dcol" | parallel -j 0 fn_wallbash
rm ${x_dcol}


