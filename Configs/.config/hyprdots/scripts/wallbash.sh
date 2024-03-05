#!/bin/bash
#|---/ /+---------------------------------------------+---/ /|#
#|--/ /-| Script to generate color palette from image |--/ /-|#
#|-/ /--| Prasanth Rangan                             |-/ /--|#
#|/ /---+---------------------------------------------+/ /---|#


# set variables

cacheDir="$HOME/.cache/hyprdots"
wallbashImg="${1}"
wallbashColors=4
wallbashAccent=4
wallbashFuzz=70
cacheImg=$(basename "${wallbashImg}")
cacheThm=$(dirname "${wallbashImg}" | awk -F '/' '{print $NF}')
wallbashRaw="${cacheDir}/${cacheThm}/${cacheImg}.mpc"
wallbashOut="${cacheDir}/${cacheThm}/${cacheImg}.dcol"


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

echo "wallbash :: Colors ${wallbashColors} :: Fuzzy ${wallbashFuzz} :: \"${wallbashOut}\""
mkdir -p "${cacheDir}/${cacheThm}"
> "${wallbashOut}"


# negative function

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


# quantize raw primary colors

magick -quiet -regard-warnings "${wallbashImg}"[0] -alpha off +repage "${wallbashRaw}"
readarray -t dcolRaw <<< $(magick "${wallbashRaw}" -depth 8 -fuzz ${wallbashFuzz}% +dither -colors ${wallbashColors} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t "," | awk -F '#' 'length($NF) == 6 {print $NF}')
dcol=($(echo  -e "${dcolRaw[@]:0:$wallbashColors}" | tr ' ' '\n' | sort))
[ ${#dcolRaw[*]} -lt ${wallbashColors} ] && echo -e "WARNING :: distinct colors ${#dcolRaw[*]} is less than ${wallbashColors} palette color..."


# reformat primary colors cache

for (( i=0; i<${wallbashColors}; i++ )) ; do
    [ -z "${dcol[i]}" ] && dcol[i]=${dcol[i-1]}
    echo "dcol_pry${i}=\"${dcol[i]}\"" >> "${wallbashOut}"
    echo "dcol_txt${i}=\"$(rgb_negative ${dcol[i]})\"" >> "${wallbashOut}"
done


# loop to generate accent colors

for (( x=1; x<=${wallbashColors}; x++ )) ; do
    modBri=$(( 100 + (x * 28) ))
    modSat=$(( 100 - (x * 7 ) ))
    modHue=$(( 100 - (x * 4 ) ))
    acntRaw=($(magick "${wallbashRaw}" -depth 8 -normalize -modulate ${modBri},${modSat},${modHue} -fuzz ${wallbashFuzz}% +dither -colors ${wallbashAccent} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t "," | awk -F '#' 'length($NF) == 6 {print $NF}'))
    acnt=($(echo "${acntRaw[@]:0:$wallbashAccent}" | tr ' ' '\n' | sort))
    [ ${#acntRaw[*]} -lt ${wallbashAccent} ] && echo -e "WARNING :: accent colors ${#acntRaw[*]} is less than ${wallbashAccent} palette color..."

    for (( j=0; j<${wallbashAccent}; j++ )) ; do
        [ -z "${acnt[j]}" ] && acnt[j]=${acnt[j-1]}
        #echo "dcol_$((x - 1))xa$((j + 1))=\"${acnt[j]}\"" >> "${wallbashOut}"
        echo "dcol_${j}xa${x}=\"${acnt[j]}\"" >> "${wallbashOut}"
    done
done

