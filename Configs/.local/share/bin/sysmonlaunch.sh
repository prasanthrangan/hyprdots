#!/usr/bin/env sh

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
pkgChk=("io.missioncenter.MissionCenter" "htop" "btop" "top")

for sysMon in "${!pkgChk[@]}"; do
    if [ "${sysMon}" -gt 0 ]; then
        term=$(grep ^'$term' "$HOME/.config/hypr/keybindings.conf" | cut -d '=' -f2)
    fi
    if pkg_installed "${pkgChk[sysMon]}"; then
        pkill -x "${pkgChk[sysMon]}" || ${term} "${pkgChk[sysMon]}" &
        break
    fi
done
