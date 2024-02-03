set -g fish_greeting

if status is-interactive
    starship init fish | source
end

alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

