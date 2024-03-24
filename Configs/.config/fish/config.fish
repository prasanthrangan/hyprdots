set -g fish_greeting

if status is-interactive
    starship init fish | source
end



#for btop
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Cleanup local orphaned packages optional
# function cleanup
#     while pacman -Qdtq
#         sudo pacman -R (pacman -Qdtq)
#     end
# end

## Useful aliases

# Replace ls with eza
alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons'  # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

alias big 'expac -H M "%m\t%n" | sort -h | nl'     # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grub-update 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias hw 'hwinfo --short'                          # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias vdir 'vdir --color=auto'
alias wget 'wget -c '
alias staccer 'QT_QPA_PLATFORM=xcb stacer'
alias remove-force 'sudo pacman -Rnsdd'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# Get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

# Recent installed packages
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

# enable this if you use grub
# alias grub-update 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Fixes "Error opening terminal: xterm-kitty" when using the default kitty term to open some programs through ssh
alias ssh='kitten ssh'

# Get fastest mirrors
alias mirror-update 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirror-age 'sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'
alias mirror-delay 'sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors-score 'sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'


# clone current shell 
function clone -d "Clone the current fish session into a new kitty window"
    set --local data
    for a in $argv
        if contains -- "$a" -h --help
            echo "Clone the current fish session into a new kitty window."
            echo
            echo "For usage instructions see: https://sw.kovidgoyal.net/kitty/shell-integration/#clone-shell"
            return
        end
        set --local ea (printf "%s" "$a" | base64)
        set --append data "a=$ea"
    end
    set --local envs
    for e in (set --export --names)
        set --append envs "$e=$$e"
    end
    set --local b64_envs (string join0 -- $envs | base64)
    set --local b64_cwd (printf "%s" "$PWD" | base64)
    set --prepend data "shell=fish" "pid=$fish_pid" "cwd=$b64_cwd" "env=$b64_envs"
    __ksi_transmit_data (string join "," -- $data) "clone"
end
