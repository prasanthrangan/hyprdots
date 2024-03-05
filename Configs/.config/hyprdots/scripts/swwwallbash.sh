#!/usr/bin/env sh

# set variables

export ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
wallbashImg="$1"
cacheImg=$(basename "${wallbashImg}")
cacheThm=$(dirname "${wallbashImg}" | awk -F '/' '{print $NF}')
export wallbashOut="${cacheDir}/${cacheThm}/${cacheImg}.dcol"


# validate input

if [ -z "${wallbashImg}" ] || [ ! -f "${wallbashImg}" ] ; then
    echo "Error: Input wallpaper not found!"
    exit 1
fi

magick -ping "${wallbashImg}" -format "%t" info: &> /dev/null
if [ $? -ne 0 ] ; then
    echo "Error: Unsuppoted image format ${wallbashImg}"
    exit 1
fi


# generate wallbash colors

if [ ! -f "${wallbashOut}" ] ; then
    $ScrDir/wallbash.sh "${wallbashImg}"
fi


# deploy wallbash colors

fn_wallbash () {
    local tplt="${1}"
    eval target=$(head -1 "${tplt}" | awk -F '|' '{print $1}')
    eval appexe=$(head -1 "${tplt}" | awk -F '|' '{print $2}')
    source "${ScrDir}/globalcontrol.sh"
    source "${wallbashOut}"

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
            s/<wallbash_2xa4>/${dcol_2xa4}/g
            s/<wallbash_pry3>/${dcol_pry3}/g
            s/<wallbash_txt3>/${dcol_txt3}/g
            s/<wallbash_3xa1>/${dcol_3xa1}/g
            s/<wallbash_3xa2>/${dcol_3xa2}/g
            s/<wallbash_3xa3>/${dcol_3xa3}/g
            s/<wallbash_3xa4>/${dcol_3xa4}/g" "${target}"

    if [ ! -z "${appexe}" ] ; then
        "${appexe}"
    fi
}

export -f fn_wallbash


# exec wallbash fn in parallel

find "${WallbashDir}" -type f -name "*.dcol" | parallel -j 0 fn_wallbash

