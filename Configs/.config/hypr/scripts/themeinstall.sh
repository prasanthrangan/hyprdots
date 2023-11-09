#!/bin/bash

DotsDir="$HOME/.config"
source $HOME/.config/hypr/scripts/globalcontrol.sh
imp_Dir=$1

echo "Are you using a local theme directory? [Y/N]"
read isLocal

if [[ $isLocal == "Y" || $isLocal == "y" ]]; then
    echo "Enter the local theme base directory path:"
    read localThemeBasePath
    echo "Enter the theme directory name:"
    read themeDirectoryName
    ThemeDir="$localThemeBasePath/$themeDirectoryName"
    if [ ! -d "$ThemeDir" ]; then
        echo "Error: Theme directory $ThemeDir does not exist. Exiting..."
        exit 1
    fi
else
    echo "Enter the GitHub URL for your theme:"
    read githubUrl
    echo "Enter the branch name:"
    read branchName
    git clone -b $branchName $githubUrl
    ThemeDir="$(pwd)/$themeDirectoryName"  # Set ThemeDir to the appropriate subdirectory within the cloned repository
    if [ ! -d "$ThemeDir" ]; then
        echo "Error: Theme directory $ThemeDir does not exist within the cloned repository. Exiting..."
        exit 1
    fi
fi

# Change to the directory
cd "$imp_Dir"
    ThemeDir="$(pwd)"
ThemeName="$(basename $(pwd))"

#pwd
#}


imp_Archives () {
# List of items to check

items=("import.lst" "kitty" "Kvantum" "qt5ct" "rofi" "swww" "waybar" "Arcs")

# Check if each item exists
for item in "${items[@]}"; do
    if [ ! -e "$item" ]; then
        echo "Item $item does not exist. Exiting..."
        exit 1
    fi
done

for tarfile in ./Arcs/*tar*; do
    if [ ! -e "$tarfile" ]; then
        echo "Tar file $tarfile does not exist. This is crucial for the fonts gtk themes or cursor
          Exiting..."
        exit 1
    fi
done



cat import.lst | while read lst; do
    fnt=$(echo $lst | awk -F '|' '{print $1}')
    tgt=$(echo $lst | awk -F '|' '{print $2}')
    tgt=$(eval "echo $tgt")

    if [ ! -d "${tgt}" ]; then
        mkdir -p ${tgt} || { echo "Error: Unable to create directory ${tgt}"; exit 1; }
        echo "${tgt} directory created..."
    fi

    # Check for tar.gz file and extract
    if sudo tar -xf ${ThemeDir}/Arcs/${fnt}.tar.gz -C ${tgt}/; then
        echo "Uncompressing ${fnt}.tar.gz --> ${tgt}... Success"
    # If tar.gz extraction fails, check for tar.xz file and extract
    elif sudo tar -xf ${ThemeDir}/Arcs/${fnt}.tar.xz -C ${tgt}/; then
        echo "Uncompressing ${fnt}.tar.xz --> ${tgt}... Success"
    else
        echo "Error: Unable to extract ${fnt}.tar.gz or ${fnt}.tar.xz into ${tgt}"
        exit 1
    fi

done
# Rebuild font cache
echo "Rebuilding font cache..."
fc-cache -f
}

imp_Dotfiles(){

cp -r $ThemeDir/hypr/themes/$ThemeName.conf $DotsDir/hypr/themes
cp -r $ThemeDir/kitty/themes/$ThemeName.conf $DotsDir/kitty/themes  
cp -r $ThemeDir/rofi/themes/$ThemeName.rasi $DotsDir/rofi/themes 
cp -r $ThemeDir/Kvantum/$ThemeName $DotsDir/Kvantum
cp -r $ThemeDir/qt5ct/colors/$ThemeName.conf $DotsDir/qt5ct/colors  
cp -r $ThemeDir/swww/$ThemeName $DotsDir/swww
cp -r $ThemeDir/waybar/themes/$ThemeName.css $DotsDir/waybar/themes



if ! grep -q "|$ThemeName|" $DotsDir/swww/wall.ctl; then
    echo -e "" >> $DotsDir/swww/wall.ctl
    cat $ThemeDir/swww/wall.ctl >> $DotsDir/swww/wall.ctl
    echo "$ThemeName appended to $DotsDir/swww/wall.ctl"
else
    echo "$ThemeName already exists in $DotsDir/swww/wall.ctl. Skipping..."
fi

echo "Successfully Imported Configs" 
}




create_cache(){
if ! pkg_installed imagemagick || ! pkg_installed parallel 
then
    echo "ERROR : dependency failed, imagemagick/parallel is not installed..."
    exit 0
fi

# set variables
ctlFile="$HOME/.config/swww/wall.ctl"
ctlLine=`grep '^1|' $ctlFile`
export CacheDir="$HOME/.config/swww/.cache"

# evaluate options
while getopts "fc" option ; do
    case $option in
    f ) # force remove cache
        rm -Rf ${CacheDir}
        echo "Cache dir ${CacheDir} cleared...";;
    c ) # use custom wallpaper
        shift $((OPTIND -1))
        inWall="$1"
        if [[ "${inWall}" == '~'* ]]; then
            inWall="$HOME${inWall:1}"
        fi
        if [[ -f "${inWall}" ]] ; then
            if [ `echo "$ctlLine" | wc -l` -eq "1" ] ; then
                curTheme=$(echo "$ctlLine" | cut -d '|' -f 2)
                sed -i "/^1|/c\1|${curTheme}|${inWall}" "$ctlFile"
            else
                echo "ERROR : $ctlFile Unable to fetch theme..."
                exit 1
            fi
        else
            echo "ERROR: wallpaper $1 not found..."
            exit 1
        fi ;;
    * ) # invalid option
        echo "...valid options are..."   
    	echo "./create_cache.sh -f                      # force create thumbnails (delete old cache)"
        echo "./create_cache.sh -c /path/to/wallpaper   # generate cache for custom walls"
        exit 1 ;;
    esac
done

# magick function
imagick_t2 () {
    theme="$1"
    wpFullName="$2"
    wpBaseName=$(basename "${wpFullName}")

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}" ]; then
        convert "${wpFullName}" -thumbnail 500x500^ -gravity center -extent 500x500 "${CacheDir}/${theme}/${wpBaseName}"
    fi

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}.rofi" ]; then
        convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 "${wpFullName}" "${CacheDir}/${theme}/${wpBaseName}.rofi"
    fi

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}.blur" ]; then
        convert -strip -scale 10% -blur 0x3 -resize 100% "${wpFullName}" "${CacheDir}/${theme}/${wpBaseName}.blur"
    fi

    if [ ! -f "${CacheDir}/${theme}/${wpBaseName}.dcol" ]; then
        magick "${wpFullName}" -colors 4 -define histogram:unique-colors=true -format "%c" histogram:info: > "${CacheDir}/${theme}/${wpBaseName}.dcol"
    fi
}

# create thumbnails for each theme > wallpapers
export -f imagick_t2
while read ctlLine
do
    theme=$(echo $ctlLine | cut -d '|' -f 2)
    fullPath=$(echo "$ctlLine" | cut -d '|' -f 3 | sed "s+~+$HOME+")
    wallPath=$(dirname "$fullPath")
    mkdir -p ${CacheDir}/${theme}
    mapfile -d '' wpArray < <(find "${wallPath}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)
    echo "Creating thumbnails for ${theme} [${#wpArray[@]}]"
    parallel --bar imagick_t2 ::: "${theme}" ::: "${wpArray[@]}"
done < $ctlFile

}

exp_Dotfiles(){

ThemeName="$ThemeName"
export_Dir=~/Documents/$ThemeName
mkdir -p $export_Dir/hypr/themes/
mkdir -p $export_Dir/kitty/themes/
mkdir -p $export_Dir/rofi/themes/
mkdir -p $export_Dir/Kvantum/
mkdir -p $export_Dir/qt5ct/colors/
mkdir -p $export_Dir/swww/
mkdir -p $export_Dir/waybar/themes/


if ! grep -q "|$ThemeName|" $DotsDir/swww/wall.ctl; then
    echo "$ThemeName Does Not Exist"
    exit 1
else
    
touch $export_Dir/swww/wall.ctl
cat ~/.config/swww/wall.ctl | grep "|$ThemeName|" > $export_Dir/swww/wall.ctl



cp -r $DotsDir/hypr/themes/$ThemeName.conf $export_Dir/hypr/themes
cp -r $DotsDir/kitty/themes/$ThemeName.conf $export_Dir/kitty/themes
cp -r $DotsDir/rofi/themes/$ThemeName.conf $export_Dir/rofi/themes
cp -r $DotsDir/Kvantum/$ThemeName $export_Dir/Kvantum
cp -r $DotsDir/qt5ct/colors/$ThemeName.conf $export_Dir/qt5ct/colors
cp -r $DotsDir/swww/$ThemeName $export_Dir/swww
cp -r $DotsDir/waybar/themes/$ThemeName.css $export_Dir/waybar/themes
fi



echo "This Export script is not Powerfull This only helps get the them specific dot files but wont get the icons,cursor or gtk theme."
}

#exp_Dotfiles



#echo "Installing  $ThemeName theme from $ThemeDir"

#check_import
imp_Archives
imp_Dotfiles
create_cache
 $DotsDir/hypr/scripts/themeswitch.sh -s "$ThemeName"
