#!/usr/bin/env bash
#|---/ /+------------------+---/ /|#
#|--/ /-| Global functions |--/ /-|#
#|-/ /--| Prasanth Rangan  |-/ /--|#
#|-/ /--| Matthieu Amet    |-/ /--|#
#|/ /---+------------------+/ /---|#

set -e

scrDir="$(dirname "$(realpath "$0")")"
cloneDir="$(dirname "${scrDir}")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="$HOME/.cache/hyde"
shlList=(zsh fish)

pkg_installed() {
pkg_installed() {
    local PkgIn="$1"
    # Check if the package is installed using dpkg-query
    if dpkg-query -W -f='${Status}' "${PkgIn}" 2>/dev/null | grep -q 'install ok installed'; then
        return 0
    fi
    
    # Check if the command is available
    if command -v "${PkgIn}" &> /dev/null; then
        return 0
    fi
    
    # Special case for swaylock-effects
    if [ "${PkgIn}" = "swaylock-effects" ]; then
        if command -v swaylock &> /dev/null; then
            return 0
        fi
    fi
    
    return 1
}

}

chk_list() {
    vrType="$1"
    local inList=("${@:2}")
    for pkg in "${inList[@]}"; do
        if pkg_installed "${pkg}"; then
            printf -v "${vrType}" "%s" "${pkg}"
            export "${vrType}"
            return 0
        fi
    done
    return 1
}

pkg_available() {
    local PkgIn=$1
    if apt list "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

prompt_timer() {
    set +e
    unset promptIn
    local timsec=$1
    local msg=$2
    while [[ ${timsec} -ge 0 ]]; do
        echo -ne "\r :: ${msg} (${timsec}s) : "
        read -t 1 -n 1 promptIn
        [ $? -eq 0 ] && break
        ((timsec--))
    done
    export promptIn
    echo ""
    set -e
}
