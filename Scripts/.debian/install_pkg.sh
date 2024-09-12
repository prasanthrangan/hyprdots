#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| Matthieu Amet                          |-/ /--|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/../global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

install_git_1() {
    cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
    cmake --build build -j`nproc`
    sudo cmake --install build
}

install_git_2() {
    cmake --no-warn-unused-cli -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B build
    cmake --build build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    sudo cmake --install build
}

install_git_3() {
    make all && sudo make install
}

# Install dependencies and software
listPkg="${1:-"${scrDir}/deps.lst"}"
echo -e "\033[0;31mNote: Installing with APT in CLI is at risks, be sure you know what you do before continuing.\033[0m You can install the packages manually and go back to this script if needed."
read -p " :: Press y to continue : " aptwarning
case ${aptwarning} in
    y) ;;
    *) exit ;;
esac
while read -r pkg; do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ]; then
        continue
    fi
    if pkg_installed "${pkg}"; then
        echo -e "\033[0;33m[skip]\033[0m ${pkg} is already installed..."
    elif pkg_available "${pkg}"; then
        echo -e "\033[0;32m[o]\033[0m Installing ${pkg} from official debian repo..."
        sudo apt install -y --force-yes ${pkg} &>/dev/null
    else
        echo "Error: unknown package ${pkg}..."
    fi
done < <(cut -d '#' -f 1 "${listPkg}")

# Install git packages
listPkg="${1:-"${scrDir}/git.lst"}"
while read -r input; do
    input="${input// /}"
    if [ -z "${input}" ]; then
        continue
    fi
    prefix=$(echo "$input" | cut -d':' -f1)
    gitpkg=$(echo "$input" | cut -d':' -f2-)
    echo -e "\033[0;32m[o]\033[0m Installing ${gitpkg} from git repo..."
    pkgname=$(echo "${gitpkg}" | sed 's|.*/\([^/]*\)/\([^/]*\)\.git|\1_\2|')
    if [ ! -d "${pkgname}" ] ; then
        git clone --depth 1 --recursive ${gitpkg} ${pkgname}
    else
        cd "${pkgname}"
        git pull --depth 1 ${gitpkg}
        cd ..
    fi
    cd "${pkgname}"
    if [ "$prefix" == "1" ]; then
        install_git_1 ${pkgname}
    elif [ "$prefix" == "2" ]; then
        install_git_2 ${pkgname}
    elif [ "$prefix" == "3" ]; then
        install_git_3 ${pkgname}
    else
        echo -e "\033[0;31mUnknown installation for ${gitpkg}\033[0m"
    fi
    cd ..
done < <(cut -d '#' -f 1 "${listPkg}")
