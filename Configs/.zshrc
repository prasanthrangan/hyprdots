# Oh-my-zsh installation path
ZSH=/usr/share/oh-my-zsh/

# Powerlevel10k theme path
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=()
source $ZSH/oh-my-zsh.sh

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    # Search for the command using apt-file
    local entries=( $(apt-file search -x "/bin/$1$" "/usr/bin/$1$") )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg=""
        for entry in "${entries[@]}" ; do
            local package_name=${entry%%:*}
            local file_path=${entry#*:}
            if [[ "$pkg" != "$package_name" ]]; then
                printf "${purple}%s${reset}\n" "$package_name"
            fi
            printf "    ${green}%s${reset}\n" "$file_path"
            pkg="$package_name"
        done
    else
        printf "No packages found for command: %s\n" "$1"
    fi
    return 127
}


function in {
    local -a inPkg=("$@")
    local -a apt_pkg=()
    local -a not_found=()

    for pkg in "${inPkg[@]}"; do
        if apt-cache show "${pkg}" &>/dev/null; then
            apt_pkg+=("${pkg}")
        else
            not_found+=("${pkg}")
        fi
    done

    if [[ ${#apt_pkg[@]} -gt 0 ]]; then
        sudo apt install "${apt_pkg[@]}"
    fi

    if [[ ${#not_found[@]} -gt 0 ]]; then
        echo "The following packages were not found in the repositories:"
        for pkg in "${not_found[@]}"; do
            echo "  - ${pkg}"
        done
    fi
}


# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias pr='apt remove --purge' # uninstall package
alias pu='apt update && sudo apt dist-upgrade' # update system/packages
alias pl='apt list --installed' # list installed package
alias ps='apt search' # list available package
alias pc='sudo apt autoremove && sudo apt clean' # remove unused packages and cache
alias vc='code' # gui code editor

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
