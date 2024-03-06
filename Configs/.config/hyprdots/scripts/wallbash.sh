#!/bin/bash
#|---/ /+---------------------------------------------+---/ /|#
#|--/ /-| Script to generate color palette from image |--/ /-|#
#|-/ /--| Prasanth Rangan                             |-/ /--|#
#|/ /---+---------------------------------------------+/ /---|#


#// set variables

cacheDir="$HOME/.cache/hyprdots"
wallbashImg="${1}"
wallbashColors=4
wallbashAccent=4
wallbashFuzz=70
cacheImg=$(basename "${wallbashImg}")
cacheThm=$(dirname "${wallbashImg}" | awk -F '/' '{print $NF}')
wallbashRaw="${cacheDir}/${cacheThm}/${cacheImg}.mpc"
wallbashOut="${cacheDir}/${cacheThm}/${cacheImg}.dcol"


#// primary color modulations for default profile

pryDarkBri=116
pryDarkSat=110
pryDarkHue=88
pryLightBri=100
pryLightSat=100
pryLightHue=114


#// text color modulations for default profile

txtDarkBri=119
txtDarkSat=0
txtDarkHue=100
txtLightBri=21
txtLightSat=0
txtLightHue=100


#// accent color modulations for default profile

acnDarkBri=120
acnDarkSat=111
acnDarkHue=92
acnLightBri=100
acnLightSat=101
acnLightHue=109


#// input image validation

if [ -z "${wallbashImg}" ] || [ ! -f "${wallbashImg}" ] ; then
    echo "Error: Input file not found!"
    exit 1
fi

magick -ping "${wallbashImg}" -format "%t" info: &> /dev/null
if [ $? -ne 0 ] ; then
    echo "Error: Unsuppoted image format ${wallbashImg}"
    exit 1
fi

echo "wallbash default profile :: Colors ${wallbashColors} :: Accents ${wallbashAccent} :: Fuzzy ${wallbashFuzz} :: \"${wallbashOut}\""
mkdir -p "${cacheDir}/${cacheThm}"
rm -f "${wallbashRaw}" "${wallbashOut}"


#// define functions

rgb_negative() {
    local inCol=$1
    local r=${inCol:0:2}
    local g=${inCol:2:2}
    local b=${inCol:4:2}
    local r16=$((16#$r))
    local g16=$((16#$g))
    local b16=$((16#$b))
    r=$(printf "%02X" $((255 - $r16)))
    g=$(printf "%02X" $((255 - $g16)))
    b=$(printf "%02X" $((255 - $b16)))
    echo "${r}${g}${b}"
}

fx_brightness() {
    local inCol="${1}"
    local fxb=$(magick "${inCol}" -colorspace gray -format "%[fx:mean]" info:)
    if awk -v fxb="${fxb}" 'BEGIN {exit !(fxb < 0.5)}' ; then
        return 0 #// echo ":: ${fxb} :: dark :: ${inCol}"
    else
        return 1 #// echo ":: ${fxb} :: light :: ${inCol}"
    fi
}


#// quantize raw primary colors

magick -quiet -regard-warnings "${wallbashImg}"[0] -alpha off +repage "${wallbashRaw}"
readarray -t dcolRaw <<< $(magick "${wallbashRaw}" -depth 8 -fuzz ${wallbashFuzz}% +dither -colors ${wallbashColors} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t "," | awk -F '#' 'length($NF) == 6 {print $NF}')
[ ${#dcolRaw[*]} -lt ${wallbashColors} ] && echo -e "WARNING :: distinct colors ${#dcolRaw[*]} is less than ${wallbashColors} palette color..."


#// sort colors based on image brightness

if fx_brightness "${wallbashRaw}" ; then
    argSort=""
else
    argSort="-r"
fi

dcol=($(echo  -e "${dcolRaw[@]:0:$wallbashColors}" | tr ' ' '\n' | sort ${argSort}))


#// loop for derived colors

for (( i=0; i<${wallbashColors}; i++ )) ; do


    #// generate missing primary colors

    if [ -z "${dcol[i]}" ] ; then
    
        if fx_brightness "xc:#${dcol[i - 1]}" ; then
            modBri=$pryDarkBri
            modSat=$pryDarkSat
            modHue=$pryDarkHue
        else
            modBri=$pryLightBri
            modSat=$pryLightSat
            modHue=$pryLightHue
        fi

        echo -e "dcol_pry$((i + 1)) :: regen missing color"
        dcol[i]=$(magick xc:"#${dcol[i - 1]}" -depth 8 -normalize -modulate ${modBri},${modSat},${modHue} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t "," | awk -F '#' 'length($NF) == 6 {print $NF}')

    fi

    echo "dcol_pry$((i + 1))=\"${dcol[i]}\"" >> "${wallbashOut}"


    #// generate primary text colors

    xcol=$(rgb_negative ${dcol[i]})

    if fx_brightness "xc:#${dcol[i]}" ; then
        modBri=$txtDarkBri
        modSat=$txtDarkSat
        modHue=$txtDarkHue
    else
        modBri=$txtLightBri
        modSat=$txtLightSat
        modHue=$txtLightHue
    fi

    tcol=$(magick xc:"#${xcol}" -depth 8 -normalize -modulate ${modBri},${modSat},${modHue} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t "," | awk -F '#' 'length($NF) == 6 {print $NF}')
    echo "dcol_txt$((i + 1))=\"${tcol}\"" >> "${wallbashOut}"


    #// generate accent colors

    xcol="#${dcol[i]}"

    for (( j=1; j<=${wallbashAccent}; j++ )) ; do

        if fx_brightness "xc:#${dcol[i]}" ; then
            modBri=$acnDarkBri
            modSat=$acnDarkSat
            modHue=$acnDarkHue
        else
            modBri=$acnLightBri
            modSat=$acnLightSat
            modHue=$acnLightHue
        fi

        acnt=$(magick xc:"${xcol}" -depth 8 -normalize -modulate ${modBri},${modSat},${modHue} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t "," | awk -F '#' 'length($NF) == 6 {print $NF}')
        xcol="#${acnt}"
        echo "dcol_$((i + 1))xa${j}=\"${acnt}\"" >> "${wallbashOut}"

    done

done

