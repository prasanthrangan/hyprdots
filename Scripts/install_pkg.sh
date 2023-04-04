#!/bin/bash
#|---/ /+---------------------------------------+---/ /|#
#|--/ /-| Script to install essential arch pkgs |--/ /-|#
#|-/ /--| Prasanth Rangan                       |-/ /--|#
#|/ /---+---------------------------------------+/ /---|#

source global_fn.sh

install_list="${1:-essential_pkg.lst}"
yay_chk=0

while read pkg
do
    if [[ ${pkg} == "yay" ]]
        then
        yay_chk=1

    elif pkg_installed ${pkg}
        then
        echo "skipping ${pkg}..."

    elif pkg_available ${pkg}
        then
        echo "queueing ${pkg} from arch repo..."
        pkg_arch=`echo $pkg_arch ${pkg}`

    elif aur_available ${pkg}
        then
        echo "queueing ${pkg} from aur..."
        pkg_aur=`echo $pkg_aur ${pkg}`

    else
        echo "error: unknown package..."
    fi
done < $install_list

if [ `echo $pkg_arch | wc -w` -gt 0 ]
then
    echo "installing $pkg_arch from arch repo..."
    sudo pacman -S $pkg_arch
fi

if [ $yay_chk -eq 1 ]
then
    ./install_yay.sh 2>&1
fi

if [ `echo $pkg_aur | wc -w` -gt 0 ]
then
    echo "installing $pkg_aur from aur..."
    yay -S $pkg_aur
fi
