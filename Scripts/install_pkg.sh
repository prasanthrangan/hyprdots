#!/bin/bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

if ! pkg_installed git
    then
    echo "installing dependency git..."
    sudo pacman -S git
fi

chk_aurh

if [ -z $aurhlpr ]
    then
    echo -e "Select aur helper:\n1) yay\n2) paru"
    read -p "Enter option number : " aurinp

    case $aurinp in
    1) aurhlpr="yay" ;;
    2) aurhlpr="paru" ;;
    *) echo -e "...Invalid option selected..."
        exit 1 ;;
    esac

    echo "installing dependency $aurhlpr..."
    ./install_aur.sh $aurhlpr 2>&1
fi

install_list="${1:-install_pkg.lst}"

while read pkg
do
    if pkg_installed ${pkg}
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
        echo "error: unknown package ${pkg}..."
    fi
done < $install_list

if [ `echo $pkg_arch | wc -w` -gt 0 ]
then
    echo "installing $pkg_arch from arch repo..."
    sudo pacman ${use_default} -S $pkg_arch
fi

if [ `echo $pkg_aur | wc -w` -gt 0 ]
then
    echo "installing $pkg_aur from aur..."
    $aurhlpr ${use_default} -S $pkg_aur
fi
