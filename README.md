# --// Hyprdots //--

- [--// Hyprdots //--](#---hyprdots---)
  - [My Arch Hyprland Config | Keybindings](#my-arch-hyprland-config--keybindings)
    - [Installation](#installation)
    - [Theming](#theming)
    - [Styles](#styles)
    - [Packages](#packages)
    - [Keybindings](#keybindings)
    - [Playlist](#playlist)
    - [Known Issues](#known-issues)

<p align="center">
  <img width="250" src="https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/hyprdots_arch.png" alt="hyprdots + Archlinux(w/ hyprdots color) logo">
</p>

<https://user-images.githubusercontent.com/106020512/235429801-e8b8dae2-c1ad-4e23-9aa2-b1edb6cabe99.mp4>

## My Arch Hyprland Config | [Keybindings](#keybindings)

<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/showcase_1.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/showcase_2.png" />
    <img align="center" width="49%" src="https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/showcase_3.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/showcase_4.png" />
</p>

### Installation

The installation script is made for Arch, but **may** work on some Arch based distros.
For Debian, please refer **Senshi111**'s version [here](https://github.com/Senshi111/debian-hyprland-hyprdots). <br>
Tested on: <br>

- [EndeavourOS](https://endeavouros.com/)
- [Arco Linux](https://arcolinux.info/)
- [Arch using ALCI - Arch Linux Calamares Installer](https://alci.online/)

> **Warning**
>
> Install script will auto-detect nvidia card and install nvidia-dkms drivers for your kernel.
> Nvidia drm will be enabled in grub, so please [ensure](https://wiki.archlinux.org/title/NVIDIA) your nvidia card supports dkms drivers/hyprland.

After minimal Arch install (with grub), clone this repo -

```shell
sudo pacman -Sy git
git clone https://github.com/devckvargas/hyprdots ~/Hyprdots
cd ~/Hyprdots/Scripts
```

> **Note**
>
> Add apps you want to install (replace **nvim** with your own editor e.g. nano, vim, code, kate, etc..)
>
> ```shell
>nvim ~/Hyprdots/Scripts/custom_apps.lst
>```
>
> Pass the file as a parameter to install it -
>
>```shell
>./install.sh custom_apps.lst
>```

Please **reboot after the install script completes and takes you to sddm login screen** (or black screen) for the first time.
For more details, please refer [installation.md](https://github.com/devckvargas/hyprdots/blob/main/installation.md)

### Theming

To add your own custom theme, please refer [theming.md](https://github.com/devckvargas/hyprdots/blob/main/theming.md)

- Available themes
  - [x] Catppuccin-Mocha
  - [x] Catppuccin-Latte
  - [x] Decay-Green
  - [x] Rosé-Pine
  - [x] Tokyo-Night
  - [x] Material-Sakura
  - [x] Graphite-Mono
  - [x] Cyberpunk-Edge
  - [ ] Nordic-Blue (maybe later)

- Contributors themes
  - [x] Frosted-Glass by T-Crypt
  - [x] Gruvbox-Retro by T-Crypt

| Catppuccin-Mocha |
| :-: |
| ![Catppuccin-Mocha#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_mocha_1.png) |
| ![Catppuccin-Mocha#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_mocha_2.png) |

| Catppuccin-Latte |
| :-: |
| ![Catppuccin-Latte#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_latte_1.png) |
| ![Catppuccin-Latte#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_latte_2.png) |

| Decay-Green |
| :-: |
| ![Decay-Green#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_decay_1.png) |
| ![Decay-Green#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_decay_2.png) |

| Rosé-Pine |
| :-: |
| ![Rosé-Pine#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_rosine_1.png) |
| ![Rosé-Pine#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_rosine_2.png) |

| Tokyo-Night |
| :-: |
| ![Tokyo-Night#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_tokyo_1.png) |
| ![Tokyo-Night#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_tokyo_2.png) |

| Material-Sakura |
| :-: |
| ![Material-Sakura#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_maura_1.png) |
| ![Material-Sakura#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_maura_2.png) |

| Graphite-Mono |
| :-: |
| ![Graphite-Mono#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_graph_1.png) |
| ![Graphite-Mono#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_graph_2.png) |

| Cyberpunk-Edge |
| :-: |
| ![Cyberpunk-Edge#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_cedge_1.png) |
| ![Cyberpunk-Edge#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_cedge_2.png) |

| Frosted-Glass |
| :-: |
| ![Frosted-Glass#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_frosted_1.png) |
| ![Frosted-Glass#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_frosted_2.png) |

| Gruvbox-Retro |
| :-: |
| ![Gruvbox-Retro#1](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_gruvbox_1.png) |
| ![Gruvbox-Retro#2](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_gruvbox_2.png) |

### Styles

| Theme Select |
| :-: |
| ![Theme Select](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/theme_select.png) |

| Wallpaper Select |
| :-: |
| ![Wallpaper Select](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/walls_select.png) |

| Launcher Style Select |
| :-: |
| ![Launcher Style Select](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_sel.png) |

| Launcher Styles |
| :-: |
| ![rofi style#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_1.png) |
| ![rofi style#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_2.png) |
| ![rofi style#3](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_3.png) |
| ![rofi style#4](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_4.png) |
| ![rofi style#5](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_5.png) |
| ![rofi style#6](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_6.png) |
| ![rofi style#7](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_7.png) |
| ![rofi style#8](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/rofi_style_8.png) |

| Wlogout Menu |
| :-: |
| ![Wlogout Menu#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/wlog_style_1.png) |
| ![Wlogout Menu#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/wlog_style_2.png) |

| Game Launchers |
| :-: |
| ![Game Launchers#1](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/game_launch_1.png) |
| ![Game Launchers#2](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/game_launch_2.png) |
| ![Game Launchers#3](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/game_launch_3.png) |
| ![Game Launchers#4](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/game_launch_4.png) |

### Packages

| nvidia | |
| :-- | --- |
linux-headers | for main kernel (script will auto detect from /usr/lib/modules/)
linux-zen-headers | for zen kernel (script will auto detect from /usr/lib/modules/)
linux-lts-headers | for lts kernel (script will auto detect from /usr/lib/modules/)
nvidia-dkms | nvidia drivers (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")
nvidia-utils | nvidia drivers (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")

| tools | |
| :-- | --- |
pipewire | audio and video server
pipewire-alsa | for audio
pipewire-audio | for audio
pipewire-jack | for audio
pipewire-pulse | for audio
gst-plugin-pipewire | for audio
wireplumber | audio and video server
networkmanager | network manager
network-manager-applet | nm tray
bluez | for bluetooth
bluez-utils | for bluetooth
blueman | bt tray
brightnessctl | brightness control for laptop

| login | |
| :-- | --- |
sddm-git | display manager for login
qt5-wayland | for QT wayland XDP
qt6-wayland | for QT wayland XDP
qt5-quickcontrols | for sddm theme
qt5-quickcontrols2 | for sddm theme
qt5-graphicaleffects | for sddm theme

| hypr | |
| :-- | --- |
hyprland-git | main window manager (script will change this to hyprland-nvidia-git if nvidia card is detected)
dunst | graphical notification daemon
rofi-lbonn-wayland-git | app launcher
waybar-hyprland-git | status bar
swww | wallpaper app
swaylock-effects-git | lockscreen
swayidle | idle management daemon
wlogout | logout screen
grim | screenshot tool
slurp | selects region for screenshot/screenshare
swappy | screenshot editor
cliphist | clipboard manager

| dependencies | |
| :-- | --- |
polkit-kde-agent | authentication agent
xdg-desktop-portal-hyprland-git | XDG Desktop Portal
imagemagick | for kitty/neofetch image processing
qt5-imageformats | for dolphin thumbnails
pavucontrol | audio settings gui
pamixer | for waybar audio

| theming | |
| :-- | --- |
nwg-look | theming GTK apps
kvantum | theming QT apps
qt5ct | theming QT5 apps

| applications | |
| :-- | --- |
firefox | browser
kitty | terminal
neofetch | fetch tool
dolphin | kde file manager
visual-studio-code-bin | gui code editor
vim | text editor
ark | kde file archiver

| shell | |
| :-- | --- |
zsh | main shell
exa | colorful file lister
oh-my-zsh-git | for zsh plugins
zsh-theme-powerlevel10k-git | theme for zsh
zsh-syntax-highlighting-git | highlighting of commands
zsh-autosuggestions-git | see completion as you type
pokemon-colorscripts-git | display pokemon sprites

### Keybindings

| Keys | Action |
| :--  | :-- |
| `Super + Q` | quit active/focused window
| `Alt + F4` | quit active/focused window
| `Super + L` | lock screen
| `Super + Backspace` | logout menu
| `Super + Del` | quit hyprland session (logout w/out confirmation)
| `Super + SPACE` | toggle window on focus to float
| `Super + F` | toggle window on focus to fullscreen
| `SUPER + J` | toggle layout
| `SUPER + P` | toggle pseudotile
| `Super + G` | toggle window group
| `Super + RETURN` / `(Numpad ENTER)` | launch terminal (kitty)
| `Super + E` | launch file explorer (dolphin)
| `Super + C` | launch editor (vscode)
| `Super + B` | launch browser (msedge)
| `Super + D` | launch desktop applications (rofi)
| `Super + Tab` | switch open applications (rofi)
| `Super + R` | browse system files (rofi)
| `Super + period` | browse emoji
| `fn + F9` | mute audio output (toggle)
| `fn + F10` `(hold)` | decrease volume
| `fn + F11` `(hold)` | increase volume
| `Super + Ctrl + ALT + S`| open spotify
| `Super + Ctrl + ALT + ↓` `(hold)` | decrease volume for spotify
| `Super + Ctrl + ALT + ↑` `(hold)` | increase volume for spotify
| `Super + V` | clipboard history paste
| `Super + P` | screenshot snip (rectangular select)
| `Super + Alt + P` / `PrintScreen` | screenshot all screen
| `Super + SHIFT + X` | open screenshot folder (HOME/Pictures)
| `Super + RightClick` `(drag)` | resize the window
| `Super + LeftClick` `(drag)` | change the window position
| `Super + MouseScroll` / `PageUp/PageDown` | cycle through workspaces
| `Super + Shift + ←→↑↓` `(hold)` | resize windows
| `Super + [0-9]` | switch to workspace [0-9]
| `Super + backtick` / `backquote` | switch to workspace [0]
| `Super + Shift + [0-9]` | move active window to workspace [0-9]
| `Super + Shift + backtick` / `backquote` | move active window to workspace [0]
| `Super + ALT + [0-9]` | move active window to workspace silently [0-9] (cursor won't follow)
| `Super + ALT + backtick` / `backquote` | move active window to workspace silently [0] (cursor won't follow)
| `Super + CTRL + S` | move window to special workspace
| `Super + CTRL + ←→↑↓` | move window around
| `Super + S` | toogle to special workspace
| `Super + Alt + G` | disable hypr effects for gamemode
| `Super + Alt + →` | next wallpaper
| `Super + Alt + ←` | previous wallpaper
| `Super + Alt + ↑` | next waybar mode
| `Super + Alt + ↓` | previous waybar mode
| `Super + ALT + D` | toggle (theme <//> wall) based colors
| `Super + ALT + T` | theme select menu
| `Super + ALT + W` | wallpaper select menu
| `Super + ALT + A` | rofi style select menu
| `Super + ALT + PageDown/PageUp` | turn on/off blue light filter

### Playlist

| youtube (Prasanth Rangan) |
| --- |
| [![youtube video screenshot](https://raw.githubusercontent.com/devckvargas/hyprdots/main/Source/assets/yt_playlist.png)](https://www.youtube.com/watch?v=_nyStxAI75s&list=PLt8rU_ebLsc5yEHUVsAQTqokIBMtx3RFY) |

### Known Issues

- [ ] Few scaling issues with rofi configs, as they are created based on [prasanthrangan's](https://github.com/prasanthrangan/) ultrawide (21:9) display.
- [ ] Random lockscreen crash, refer <https://github.com/swaywm/sway/issues/7046>
- [ ] Waybar launching rofi breaks mouse input (added `sleep 0.1` as workaround), refer <https://github.com/Alexays/Waybar/issues/1850>
- [ ] Flatpak QT apps does not follow system theme
