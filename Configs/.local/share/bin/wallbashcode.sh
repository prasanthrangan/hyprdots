#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
readarray -t codeConf < <(find "${confDir}" -mindepth 1 -maxdepth 1 -type d -name "Code*" | sort)
readarray -t codeVsix < <(find "$HOME" -mindepth 1 -maxdepth 1 -type d -name ".vscode*" | sort)
tmpFile="/tmp/$(id -u)$(basename ${0}).tmp"


#// install and apply ext

for i in "${!codeConf[@]}" ; do
    [ -f "${codeConf[i]}/User/settings.json" ] || continue
    extTheme="$(jq -r '.["workbench.colorTheme"]' "${codeConf[i]}/User/settings.json")"
    if [ "${extTheme}" != "wallbash" ] ; then
        [ -f "${cacheDir}/landing/Code_Wallbash.vsix" ] || curl -L -o "${cacheDir}/landing/Code_Wallbash.vsix" https://github.com/prasanthrangan/hyprdots/raw/main/Source/arcs/Code_Wallbash.vsix
        code --install-extension "${cacheDir}/landing/Code_Wallbash.vsix"
        jq '.["workbench.colorTheme"] = "wallbash"' "${codeConf[i]}/User/settings.json" > "${tmpFile}" && mv "${tmpFile}" "${codeConf[i]}/User/settings.json"
    fi
    cp "${cacheDir}/landing/wallbashcode.json" "${codeVsix[i]}/extensions/undefined_publisher.wallbash-0.0.1/themes/wallbash-color-theme.json"
done

