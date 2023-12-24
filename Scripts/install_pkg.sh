#!/bin/bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
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
ofs=$IFS
IFS='|'

while read -r pkg deps
do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ] ; then
        continue
    fi

    if [ ! -z "${deps}" ] ; then
        while read -r cdep
        do
            pass=$(cut -d '#' -f 1 ${install_list} | awk -F '|' -v chk="${cdep}" '{if($1 == chk) {print 1;exit}}')
            if [ -z "${pass}" ] ; then
                if pkg_installed ${cdep} ; then
                    pass=1
                else
                    break
                fi
            fi
        done < <(echo "${deps}" | xargs -n1)

        if [[ ${pass} -ne 1 ]] ; then
            echo "skipping ${pkg} due to missing (${deps}) dependency..."
            continue
        fi
    fi

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
done < <( cut -d '#' -f 1 $install_list )

IFS=${ofs}

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
