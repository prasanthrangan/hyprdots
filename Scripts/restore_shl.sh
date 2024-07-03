#!/usr/bin/env bash
#|---/ /+---------------------------+---/ /|#
#|--/ /-| Script to configure shell |--/ /-|#
#|-/ /--| Prasanth Rangan           |-/ /--|#
#|/ /---+---------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if chk_list "myShell" "${shlList[@]}"; then
    echo -e "\033[0;32m[SHELL]\033[0m detected // ${myShell}"
else
    echo "Error: user shell not found"
    exit 1
fi

# add zsh plugins
if pkg_installed zsh && pkg_installed oh-my-zsh-git; then

    # set variables
    Zsh_rc="${ZDOTDIR:-$HOME}/.zshrc"
    Zsh_Path="/usr/share/oh-my-zsh"
    Zsh_Plugins="$Zsh_Path/custom/plugins"
    Fix_Completion=""

    # generate plugins from list
    while read r_plugin; do
        z_plugin=$(echo "${r_plugin}" | awk -F '/' '{print $NF}')
        if [ "${r_plugin:0:4}" == "http" ] && [ ! -d "${Zsh_Plugins}/${z_plugin}" ]; then
            sudo git clone "${r_plugin}" "${Zsh_Plugins}/${z_plugin}"
        fi
        if [ "${z_plugin}" == "zsh-completions" ] && [ "$(grep 'fpath+=.*plugins/zsh-completions/src' "${Zsh_rc}" | wc -l)" -eq 0 ]; then
            Fix_Completion='\nfpath+=${ZSH_CUSTOM:-${ZSH:-/usr/share/oh-my-zsh}/custom}/plugins/zsh-completions/src'
        else
            [ -z "${z_plugin}" ] || w_plugin+=" ${z_plugin}"
        fi
    done < <(cut -d '#' -f 1 "${scrDir}/restore_zsh.lst" | sed 's/ //g')

    # update plugin array in zshrc
    echo -e "\033[0;32m[SHELL]\033[0m installing plugins (${w_plugin} )"
    sed -i "/^plugins=/c\plugins=(${w_plugin} )${Fix_Completion}" "${Zsh_rc}"
fi

# set shell
if [[ "$(grep "/${USER}:" /etc/passwd | awk -F '/' '{print $NF}')" != "${myShell}" ]]; then
    echo -e "\033[0;32m[SHELL]\033[0m changing shell to ${myShell}..."
    chsh -s "$(which "${myShell}")"
else
    echo -e "\033[0;33m[SKIP]\033[0m ${myShell} is already set as shell..."
fi
