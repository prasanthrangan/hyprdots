# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export XDG_DATA_DIRS=~/.local/share/applications:$XDG_DATA_DIRS
#export WAYLAND_DISPLAY=wayland-1
export BROWSER=mercury-browser

#Disable or enable xwayland glamor
#export XWAYALAND_NO_GLAMOR=1

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

ZSH_THEME=(bira)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#function command_not_found_handler {
#    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
#    printf 'zsh: command not found: %s\n' "$1"
#    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
#    if (( ${#entries[@]} )) ; then
#        printf "${bright}$1${reset} may be found in the following packages:\n"
#        local pkg
#        for entry in "${entries[@]}" ; do
#            local fields=( ${(0)entry} )
#            if [[ "$pkg" != "${fields[2]}" ]] ; then
#               printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
#           fi
#           printf '    /%s\n' "${fields[4]}"
#           pkg="${fields[2]}"
#       done
#   fi
#   return 127
#}

alias in="yay -S"


#function in {
#    local pkg="$1"
#    if pacman -Si "$pkg" &>/dev/null ; then
#        sudo pacman -S "$pkg"
#    elif pacman -Qi yay &>/dev/null ; then
#        yay -S "$pkg"
#    elif pacman -Qi paru &>/dev/null ; then
#        paru -S "$pkg"
#    fi
#}


alias ls='eza --icons' # list

alias un='yay -R' # uninstall package
alias up='yay -Syu' # update system/package/aur
alias pl='pacman -Qs' # list installed package
alias pa='pacman -Ss' # list availabe package
alias pc='sudo pacman -Sc' # remove unused cache
alias po='pacman -Qtdq | sudo pacman -Rns -' # remove unused packages, also try > pacman -Qqd | pacman -Rsu --print -
alias vc='code' # gui code editor
alias fucking='sudo' # because its funny

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


#Display Pokemon
#pokemon-colorscripts --no-title -r

#Display random gifs
#kitten icat --align left $(find $HOME/.config/neofetch/gifs/ -name "*.gif" | sort -R | head -1)


#Display specs
#if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#	pfetch
#else
#        neofetch
#fi

#if [[ "$TERM" == "xterm-kitty" ]] && [ ! -n "$SSH_TTY" ]; then
#	neofetch
#else
#	pfetch
#fi


pfetch
