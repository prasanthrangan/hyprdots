#!/bin/bash
#|---/ /+---------------------------+---/ /|#
#|--/ /-| Script to configure shell |--/ /-|#
#|-/ /--| Prasanth Rangan           |-/ /--|#
#|/ /---+---------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

myShell="${1}"

if [ -z "${myShell}" ] ; then
    if pkg_installed zsh ; then
        myShell="zsh"
    elif pkg_installed fish ; then
        myShell="fish"
    else
        echo -e "\033[0;33m[WARNING]\033[0m no shell detected..."
        exit 0
    fi
fi

echo -e "\033[0;32m[SHELL]\033[0m detected // ${myShell}"

# add zsh plugins
if pkg_installed zsh && pkg_installed oh-my-zsh-git ; then

    # set variables
    Zsh_rc="${ZDOTDIR:-$HOME}/.zshrc"
    Zsh_Path="/usr/share/oh-my-zsh"
    Zsh_Plugins="$Zsh_Path/custom/plugins"
    Fix_Completion=""

    # generate plugins from list
    while read r_plugin
    do
        z_plugin=$(echo $r_plugin | awk -F '/' '{print $NF}')
        if [ "${r_plugin:0:4}" == "http" ] && [ ! -d $Zsh_Plugins/$z_plugin ] ; then
            sudo git clone $r_plugin $Zsh_Plugins/$z_plugin
        fi
        if [ "$z_plugin" == "zsh-completions" ] && [ `grep 'fpath+=.*plugins/zsh-completions/src' $Zsh_rc | wc -l` -eq 0 ]; then
            Fix_Completion='\nfpath+=${ZSH_CUSTOM:-${ZSH:-/usr/share/oh-my-zsh}/custom}/plugins/zsh-completions/src'
        else
            w_plugin=$(echo ${w_plugin} ${z_plugin})
        fi
    done < <(cut -d '#' -f 1 restore_zsh.lst | sed 's/ //g')

    # update plugin array in zshrc
    echo "intalling zsh plugins (${w_plugin})"
    sed -i "/^plugins=/c\plugins=($w_plugin)$Fix_Completion" $Zsh_rc
fi

# set shell
if [[ "$(grep "/${USER}:" /etc/passwd | awk -F '/' '{print $NF}')" != "${myShell}" ]] ; then
    echo -e "\033[0;32m[SHELL]\033[0m changing shell to ${myShell}..."
    chsh -s "$(which ${myShell})"
else
    echo -e "\033[0;33m[SKIP]\033[0m ${myShell} is already configured..."
fi
