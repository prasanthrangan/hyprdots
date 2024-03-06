if status is-interactive
    starship init fish | source
end

# List Directory
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'


set CONDA_PATH /opt/miniconda3
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

export TERMINFO=/usr/share/terminfo
set -gx ATUIN_NOBIND "true"
atuin init fish | source

set PATH $PATH: ~/.cargo/bin

# 在 normal 和 insert 模式下绑定到 ctrl-r，你也可以在此处添加其他键位绑定
bind \cr _atuin_search
bind -M insert \cr _atuin_search

function fish_greeting
   cat ~/.config/nvim/lua/user/plugins/02.txt
end


function fish_title
  prompt_pwd
end

function set_wayland_env
 cd $HOME
 # 设置语言环境为中文
 export LANG=zh_CN.UTF-8
 # 解决QT程序缩放问题
 export QT_AUTO_SCREEN_SCALE_FACTOR=1
 # QT使用wayland和gtk
 export QT_QPA_PLATFORM="wayland;xcb"
 export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
 # 使用qt5ct软件配置QT程序外观
 export QT_QPA_PLATFORMTHEME=qt5ct

 # 一些游戏使用wayland
 export SDL_VIDEODRIVER=wayland
 # 解决java程序启动黑屏错误
 export _JAVA_AWT_WM_NONEREPARENTING=1
 # GTK后端为 wayland和x11,优先wayland
 export GDK_BACKEND="wayland,x11"
end

 # 命令行输入这个命令启动hyprland,可以自定义
function starth
 set_wayland_env

 export XDG_SESSION_TYPE=wayland
 export XDG_SESSION_DESKTOP=Hyprland
 export XDG_CURRENT_DESKTOP=Hyprland
 # 启动 Hyprland程序
 exec Hyprland
end

# fish_config theme choose "Rosé Pine"
function trash
    set del_date (date +%Y%m%d%H%M%S)
    for arg in $argv
       echo $arg
       mkdir ~/.trashbin/$arg-$del_date
       mv $arg ~/.trashbin/$arg-$del_date
    end
end

function na
	set tmp (mktemp -t "yazi-cwd.XXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
 
# set alias
# alias rm trash
alias rl 'ls ~/.trashbin/'

# set git alias
alias gal 'git add --all'
alias gst 'git status'
alias gcommit 'git commit -m'
alias gamend 'git commit --amend'
alias glog 'git log'
alias gpf 'git push -f'
alias gpull 'git pull'
alias gpush 'git push'
alias gmerge 'git merge'
alias grebase 'git rebase'
alias grc 'git rebase --continue'
alias gri 'git rebase -i'
alias gnew 'git checkout -b'
alias gswich 'git checkout'
alias gbranch 'git branch'
alias gsta 'git stash'
alias gsp 'git stash pop'

# set system alias

alias coreUpdate 'sudo pacman -Syyu'
alias cleanOrphan 'sudo pacman -Rscn $(pacman -Qdtq)'
alias cleanCache 'sudo pacman -Scc'
alias checkInstall 'sudo pacman -Q'
alias Search 'sudo pacman -Ss'
alias Install 'sudo pacman -S'
alias baibai 'sudo pacman -R'

alias SystemCache 'du -sh ~/.cache/* | sort -h'
alias autoClean 'find ~/.cache/ -type f -atime +100 -delete'
alias makeGrub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias setWallpaper 'feh --randomize --bg-fill'

alias ch 'cd ~'
alias cw 'cd /data/workspace'
alias cb 'cd /data/workspace/Blog'
alias cs 'nv ~/.scratch.md'

alias vim 'neovide --no-multigrid'

alias pv 'sh ~/scripts/preview.sh'
alias lv 'lvim'

alias ':q' 'cd ..'
alias 'px' 'proxychains4 -f ~/scripts/proxychains.conf'

alias nv nvim

alias changeSource 'sudo pacman-mirrors -c China'
