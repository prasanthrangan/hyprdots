# Disable the default Fish greeting
set -g fish_greeting

# Initialize Starship prompt if interactive
if status is-interactive
    starship init fish | source
end

# Directory Listing Aliases with eza
alias l='eza -lh  --icons=auto'  # Long list with icons
alias ls='eza -1   --icons=auto'  # Short list with icons
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'  # Long list all with icons
alias ld='eza -lhD --icons=auto'  # Long list dirs with icons
alias lt='eza --icons=auto --tree'  # List folder as tree with icons

# Handy change directory shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Enhanced clear command
function clear --description 'Clear the screen and scrollback buffer'
    command clear
    printf '\e[3J'
end

# Display system information with Fastfetch
fastfetch

# Create directories with the mkdir -p option by default
abbr mkdir 'mkdir -p'
