#!/usr/bin/env sh

# define functions

Wall_Update()
{
    local x_wall=$1
    local x_update=${x_wall/$HOME/"~"}
    cacheImg=`echo $x_wall | awk -F '/' '{print $NF}'`

    if [ ! -d ${cacheDir}/${curTheme} ] ; then
        mkdir -p ${cacheDir}/${curTheme}
    fi

    if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}" ] ; then
        convert -strip $x_wall -thumbnail 500x500^ -gravity center -extent 500x500 ${cacheDir}/${curTheme}/${cacheImg}
    fi

    if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.rofi" ] ; then
        #convert -strip -resize 1000 -unsharp 0x1+1.0+0 $x_wall ${cacheDir}/${curTheme}/rofi.${cacheImg}
        convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 $x_wall ${cacheDir}/${curTheme}/${cacheImg}.rofi
    fi

    if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.blur" ] ; then
        convert -strip -scale 10% -blur 0x3 -resize 100% $x_wall ${cacheDir}/${curTheme}/${cacheImg}.blur
    fi

    if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.dcol" ] ; then
        magick ${cacheDir}/${curTheme}/${cacheImg}.blur -colors 6 -define histogram:unique-colors=true -format "%c" histogram:info: > ${cacheDir}/${curTheme}/${cacheImg}.dcol
    fi

    sed -i "/^1|/c\1|${curTheme}|${x_update}" $ctlFile
    ln -fs $x_wall $wallSet
    ln -fs ${cacheDir}/${curTheme}/${cacheImg}.rofi $wallRfi
    ln -fs ${cacheDir}/${curTheme}/${cacheImg}.blur $wallBlr
    ln -fs ${cacheDir}/${curTheme}/${cacheImg}.dcol $wallDco
}

Wall_Change()
{
    local x_switch=$1

    for (( i=0 ; i<${#Wallist[@]} ; i++ ))
    do
        if [ ${Wallist[i]} == ${fullPath} ] ; then

            if [ $x_switch == 'n' ] ; then
                nextIndex=$(( (i + 1) % ${#Wallist[@]} ))
            elif [ $x_switch == 'p' ] ; then
                nextIndex=$(( i - 1 ))
            fi

            Wall_Update ${Wallist[nextIndex]}
            break
        fi
    done
}

Wall_Set()
{
    if [ -z $xtrans ] ; then
        xtrans="grow"
    fi

    swww img $wallSet \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type $xtrans \
    --transition-duration 0.7 \
    --transition-fps 60 \
    --invert-y \
    --transition-pos "$( hyprctl cursorpos )"
}

# Add a function to generate configurations for rofi
GenerateRofiConfig()
{
    local x_color=$1

    # Create rofi configuration using the provided color
    cat config.rasi | sed "s/{\$dominant_color}/$x_color/g" > $rofiConfigFile
}

# Add a function to generate configurations for waybar
GenerateWaybarConfig()
{
    local x_color=$1

    # Create waybar configuration using the provided color
    cat config.jsonc | sed "s/{\$dominant_color}/$x_color/g" > $waybarConfigFile
}

# Add a function to generate configurations for wlogout
GenerateWlogoutConfig()
{
    local x_color=$1

    # Create wlogout configuration using the provided color
    cat wlogout-theme.conf | sed "s/{\$dominant_color}/$x_color/g" > $wlogoutConfigFile
}

# Add an optional function to generate configurations for kitty
GenerateKittyConfig()
{
    local x_color=$1

    # Create kitty configuration using the provided color
    cat kitty.conf | sed "s/{\$dominant_color}/$x_color/g" > $kittyConfigFile
}

# set variables

rofiConfigFile="$HOME/.config/rofi/config.rasi"
waybarConfigFile="$HOME/.config/waybar/config.jsonc"
wlogoutStyle1="$HOME/.config/wlogout/style_1.css"
wlogoutStyle2="$HOME/.config/wlogout/style_2.css"
wlogoutConfigFile=""
kittyConfigFile="$HOME/.config/kitty/kitty.conf"
cacheDir="$HOME/.config/swww/.cache"
ctlFile="$HOME/.config/swww/wall.ctl"
wallSet="$HOME/.config/swww/wall.set"
wallBlr="$HOME/.config/swww/wall.blur"
wallRfi="$HOME/.config/swww/wall.rofi"
wallDco="$HOME/.config/swww/wall.dcol"
ctlLine=`grep '^1|' $ctlFile`

if [  `echo $ctlLine | wc -w` -ne "1" ] ; then
    echo "ERROR : $ctlFile Unable to fetch theme..."
    exit 1
fi

# Get the active wallpaper path
wallpaper_path=$(swww query | grep "wallpaper: " | awk -F ' ' '{print $2}')

# Get the dominant color of the active wallpaper
dominant_color=$(convert "$wallpaper_path" -resize 1x1 -format '%[pixel:p{0,0}]' info:-)

curTheme=`echo $ctlLine | cut -d '|' -f 2`
fullPath=`echo $ctlLine | cut -d '|' -f 3`
fullPath=`eval echo $fullPath`
wallName=`echo $fullPath | awk -F '/' '{print $NF}'`
wallPath=`echo $fullPath | sed "s/\/$wallName//g"`

if [ ! -f  $wallPath/$wallName ] ; then
    if [ -d $HOME/.config/swww/$curTheme ] ; then
        wallPath="$HOME/.config/swww/$curTheme"
        fullPath=`ls $wallPath/* | head -1`
        Wall_Update $fullPath
    else
        echo "ERROR: wallpaper $wallPath/$wallName not found..."
        exit 1
    fi
fi

Wallist=(`ls $wallPath/*`)

# evaluate options

while getopts "nps" option ; do
    case $option in
    n ) # set next wallpaper
        xtrans="grow"
        Wall_Change n ;;
    p ) # set previous wallpaper
        xtrans="outer"
        Wall_Change p ;;
    s ) # set input wallpaper
        shift $((OPTIND -1))
        if [ -f $1 ] ; then
            Wall_Update $1
        fi ;;
    * ) # invalid option
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "s : set input wallpaper"
        exit 1 ;;
    esac
done

# Determine which wlogout style to use based on some condition
if [ "$condition" == "use_style1" ]; then
    wlogoutConfigFile="$wlogoutStyle1"
elif [ "$condition" == "use_style2" ]; then
    wlogoutConfigFile="$wlogoutStyle2"
else
    # Default to a style, you can change this as needed
    wlogoutConfigFile="$wlogoutStyle1"
fi

# Generate configurations based on the dominant color
GenerateRofiConfig "$dominant_color"
GenerateWaybarConfig "$dominant_color"
GenerateWlogoutConfig "$dominant_color" "$wlogoutConfigFile"

# Optionally generate kitty configuration
# Uncomment the following line if you want to generate kitty configuration
GenerateKittyConfig "$dominant_color"

# Check swww daemon and set wall (unchanged from your script)
swww query
if [ $? -eq 1 ] ; then
    swww init
fi

Wall_Set
