<p align="center"><br><br>
  <img width="100" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/hyde.png">
</p><br>


## Execution

Clone the repo and change the directory to the script path. Then make sure the user has [w]rite and e[x]ecute permission to the clone directory
```
pacman -Sy git
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE
cd ~/HyDE/Scripts
```

<br>

> [!Caution]
> Do not execute the script with sudo or as root user

<br>

Now the install script can be executed in different modes,

- for default full hyprland installation with all configs
```shell
./install.sh
```

- for full or minimal hyprland installation + your favorite packages (ex. `custom_apps.lst`) 
```shell
./install.sh custom_apps.lst # full install custom_hypr.lst + custom_app.lst with configs
./install.sh -i custom_apps.lst # minimal install custom_hypr.lst + custom_app.lst without configs
```

- each [section](#process) can also be independently executed as,
```shell
./install.sh -i # minimal install hyprland without any configs
./install.sh -d # minimal install hyprland without any configs, but with (--noconfirm) install
./install.sh -r # just restores the config files
./install.sh -s # start and enable system services
./install.sh -drs # same as ./install.sh, but with (--noconfirm) install
```

<br><br>


## Packages

> [!Warning]
> Removing packages from this list might break some dependencies

<table><tr><td><code>n</code><br><code>v</code><br><code>i</code><br><code>d</code><br><code>i</code><br><code>a</code></td><td><table>
    <tr><td>linux-headers</td><td>for main kernel (script will auto detect from /usr/lib/modules/)</td></tr>
    <tr><td>linux-zen-headers</td><td>for zen kernel (script will auto detect from /usr/lib/modules/)</td></tr>
    <tr><td>linux-lts-headers</td><td>for lts kernel (script will auto detect from /usr/lib/modules/)</td></tr>
    <tr><td>nvidia-dkms</td><td>nvidia drivers (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")</td></tr>
    <tr><td>nvidia-utils</td><td>nvidia utils (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")</td></tr>
</table></td></tr></table>

<table><tr><td><code>s</code><br><code>y</code><br><code>s</code><br><code>t</code><br><code>e</code><br><code>m</code></td><td><table>
    <tr><td>pipewire</td><td>audio/video server</td></tr>
    <tr><td>pipewire-alsa</td><td>pipewire alsa client</td></tr>
    <tr><td>pipewire-audio</td><td>pipewire audio client</td></tr>
    <tr><td>pipewire-jack</td><td>pipewire jack client</td></tr>
    <tr><td>pipewire-pulse</td><td>pipewire pulseaudio client</td></tr>
    <tr><td>gst-plugin-pipewire</td><td>pipewire gstreamer client</td></tr>
    <tr><td>wireplumber</td><td>pipewire session manager</td></tr>
    <tr><td>pavucontrol</td><td>pulseaudio volume control</td></tr>
    <tr><td>pamixer</td><td>pulseaudio cli mixer</td></tr>
    <tr><td>networkmanager</td><td>network manager</td></tr>
    <tr><td>network-manager-applet</td><td>network manager system tray utility</td></tr>
    <tr><td>bluez</td><td>bluetooth protocol stack</td></tr>
    <tr><td>bluez-utils</td><td>bluetooth utility cli</td></tr>
    <tr><td>blueman</td><td>bluetooth manager gui</td></tr>
    <tr><td>brightnessctl</td><td>screen brightness control</td></tr>
</table></td></tr></table>

<table><tr><td><code>l</code><br><code>o</code><br><code>g</code><br><code>i</code><br><code>n</code></td><td><table>
    <tr><td>sddm</td><td>display manager for KDE plasma</td></tr>
    <tr><td>qt5-quickcontrols</td><td>for sddm theme ui elements</td></tr>
    <tr><td>qt5-quickcontrols2</td><td>for sddm theme ui elements</td></tr>
    <tr><td>qt5-graphicaleffects</td><td>for sddm theme effects</td></tr>
</table></td></tr></table>

<table><tr><td><code>h</code><br><code>y</code><br><code>p</code><br><code>r</code></td><td><table>
    <tr><td>hyprland</td><td>wlroots-based wayland compositor</td></tr>
    <tr><td>dunst</td><td>notification daemon</td></tr>
    <tr><td>rofi-lbonn-wayland-git</td><td>application launcher</td></tr>
    <tr><td>waybar</td><td>system bar</td></tr>
    <tr><td>swww</td><td>wallpaper</td></tr>
    <tr><td>swaylock-effects-git</td><td>lock screen</td></tr>
    <tr><td>wlogout</td><td>logout menu</td></tr>
    <tr><td>grimblast-git</td><td>screenshot tool</td></tr>
    <tr><td>hyprpicker-git</td><td>color picker</td></tr>
    <tr><td>slurp</td><td>region select for screenshot/screenshare</td></tr>
    <tr><td>swappy</td><td>screenshot editor</td></tr>
    <tr><td>cliphist</td><td>clipboard manager</td></tr>
</table></td></tr></table>

<table><tr><td>
<code>d</code><br><code>e</code><br><code>p</code><br><code>e</code><br><code>n</code><br><code>d</code><br><code>e</code><br><code>n</code><br><code>c</code><br><code>y</code></td><td><table>
    <tr><td>polkit-kde-agent</td><td>authentication agent</td></tr>
    <tr><td>xdg-desktop-portal-hyprland</td><td>xdg desktop portal for hyprland</td></tr>
    <tr><td>pacman-contrib</td><td>for system update check</td></tr>
    <tr><td>python-pyamdgpuinfo</td><td>for amd gpu info</td></tr>
    <tr><td>parallel</td><td>for parallel processing</td></tr>
    <tr><td>jq</td><td>for json processing</td></tr>
    <tr><td>imagemagick</td><td>for image processing</td></tr>
    <tr><td>qt5-imageformats</td><td>for dolphin image thumbnails</td></tr>
    <tr><td>ffmpegthumbs</td><td>for dolphin video thumbnails</td></tr>
    <tr><td>kde-cli-tools</td><td>for dolphin file type defaults</td></tr>
</table></td></tr></table>

<table><tr><td>
<code>t</code><br><code>h</code><br><code>e</code><br><code>m</code><br><code>e</code></td><td><table>
    <tr><td>nwg-look</td><td>gtk configuration tool</td></tr>
    <tr><td>qt5ct</td><td>qt5 configuration tool</td></tr>
    <tr><td>qt6ct</td><td>qt6 configuration tool</td></tr>
    <tr><td>kvantum</td><td>svg based qt theme engine</td></tr>
    <tr><td>qt5-wayland</td><td>wayland support in qt5</td></tr>
    <tr><td>qt6-wayland</td><td>wayland support in qt6</td></tr>    
</table></td></tr></table>

<table><tr><td>
<code>a</code><br><code>p</code><br><code>p</code><br><code>s</code></td><td><table>
    <tr><td>firefox</td><td>browser</td></tr>
    <tr><td>kitty</td><td>terminal</td></tr>
    <tr><td>dolphin</td><td>kde file manager</td></tr>
    <tr><td>ark</td><td>kde file archiver</td></tr>
    <tr><td>vim</td><td>terminal text editor</td></tr>
    <tr><td>visual-studio-code-bin</td><td>IDE text editor</td></tr>
</table></td></tr></table>

<table><tr><td>
    <code>s</code><br><code>h</code><br><code>e</code><br><code>l</code><br><code>l</code></td><td><table>
    <tr><td>eza</td><td>file lister for zsh</td></tr>
    <tr><td>oh-my-zsh-git</td><td>plugin manager for zsh</td></tr>
    <tr><td>zsh-theme-powerlevel10k-git</td><td>theme for zsh</td></tr>
    <tr><td>lsd</td><td>file lister for fish</td></tr>
    <tr><td>starship</td><td>customizable shell prompt</td></tr>
    <tr><td>neofetch</td><td>fetch tool</td></tr>
    <tr><td>pokemon-colorscripts-git</td><td>display pokemon sprites</td></tr>
</table></td></tr></table>

<table><tr><td>
    <code></code></td><td><table>
    <tr><td>hyde-cli</td><td>cli tool to manage HyDE</td></tr>
</table></td></tr></table>

<br><br>

## Process

The install script has sections : &ensp;[<kbd>1</kbd>](#-Section-1)&ensp;[<kbd>2</kbd>](#-Section-2)&ensp;[<kbd>3</kbd>](#-Section-3)&ensp;[<kbd>4</kbd>](#-Section-4)&ensp;[<kbd>5</kbd>](#-Section-5)&ensp;<br><br>

### *<div align = right>// Section 1</div>*
#### Pre-Install
```shell
./install.sh -ir # this section only runs when [i]nstall and [r]estore options are passed
```

- detect grub
  - backup existing config file `/etc/default/grub` and `/boot/grub/grub.cfg`
  - add `nvidia_drm.modeset=1` to boot option, only for nvidia system
  - install grub theme based on user input,
    - <kbd>1</kbd> for `retroboot`
    - <kbd>2</kbd> for `pochita`
    - <kbd>*</kbd> press any other key to skip grub theme

- detect systemd-boot
  - backup existing config files `/boot/loader/entries/*.conf`
  - add `nvidia_drm.modeset=1` to boot option, only for nvidia system

- configure pacman
  - backup existing config file `/etc/pacman.conf`
  - enable candy and parallel downloads
  - add `xero_hypr` repo (yet to be implemented)

<br>

### *<div align = right>// Section 2</div>*
#### Install
```shell
./install.sh -i
```

- prepare a temp list of packages from main package list [custom_hypr.lst](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/custom_hypr.lst)
- here `custom_hypr.lst` is a `|` delimited control file where column,
  - <kbd>1</kbd> is the package name
  - <kbd>2</kbd> is space separated package list to check cyclic dependency

- if the user pass additional list (for ex. `custom_apps.lst`), then add it to the temp list

- install shell based on user input,
  - <kbd>1</kbd> for `zsh`
  - <kbd>2</kbd> for `fish`

- if nvidia card is detected, add corresponding `nvidia-dkms` and `nvidia-utils` to the temp list based on [lookup](https://github.com/prasanthrangan/hyprdots/tree/main/Scripts/.nvidia)

- install AUR helper based on user input,
  - <kbd>1</kbd> for `yay`
  - <kbd>2</kbd> for `paru`

- install packages from the generated temp list
  - use `pacman` to install package if its available in official arch repo
  - use AUR helper ( detect if its `yay` or `paru` ) to install packages if its available in AUR

<br>

#### Default
```shell
./install.sh -d
```

- exactly same as install, but with `--noconfirm` option
- will skip user input and use default option(s) to install, but prompts sudo password when required

<br>

### *<div align = right>// Section 3</div>*
#### Restore
```shell
./install.sh -r
```

- restore gtk themes, icons, cursors and fonts
  - uncompress `*.tar.gz` files from `Source/arcs/` to the target location based on this [restore_fnt](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/restore_fnt.lst) control file
  - here `restore_fnt.lst` is a `|` delimited control file where column,
    - <kbd>1</kbd> is compressed source `*.tar.gz` file located in `Source/arcs/`
    - <kbd>2</kbd> is the target location to extract

- restore config files
  - restore the dot files based on this [restore_cfg](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/restore_cfg.lst) control file
  - here `restore_cfg.lst` is a `|` delimited control file where column,
    - <kbd>1</kbd> is overwrite flag [`Y`/`N`], to overwrite the target from source if it already exist
    - <kbd>2</kbd> is backup flag [`Y`/`N`], to copy the target file to backup directory
    - <kbd>3</kbd> is the target directory path
    - <kbd>4</kbd> is the source file/directory name(s), space separated list
    - <kbd>5</kbd> is the space separated package dependency list, to skip configs for packages that are not installed

- generate wallpaper cache
- fix/update all the symlinks used

<br>

### *<div align = right>// Section 4</div>*
#### Post-Install
```shell
./install.sh -ir # this section only runs when [i]nstall and [r]estore options are passed
```

- patch/skip additional themes from [themepatcher](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/themepatcher.lst) list, based on user input

- configure sddm
  - install sddm theme based on user input,
    - <kbd>1</kbd> for `candy`
    - <kbd>2</kbd> for `corners`

- set dolphin as default file manager
- configure shell
  - detect shell installed, `zsh` or `fish`
  - for zsh, install plugins based on [restore_zsh](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/restore_zsh.lst) list

- enable flatpak and install apps from [custom_flat](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/.extra/custom_flat.lst) list

<br>

### *<div align = right>// Section 5</div>*
#### Service
```shell
./install.sh -s
```

- enable and start system services based on [system_ctl](https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/system_ctl.lst) list
