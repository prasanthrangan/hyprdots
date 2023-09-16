# --// Hyprdots //--

<p align="center">
  <img width="250" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/hyprdots_arch.png">   
</p>


## My Arch Hyprland Config

https://user-images.githubusercontent.com/106020512/235429801-e8b8dae2-c1ad-4e23-9aa2-b1edb6cabe99.mp4

<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_1.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_2.png" />   
    <img align="center" width="49%" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_3.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_4.png" />   
</p>


### Installation

The installation script is made for Arch, but **may** work on some Arch based distros.   
For Debian, please refer **Senshi111**'s version [here](https://github.com/Senshi111/debian-hyprland-hyprdots).

> **Warning**
>
> Install script will auto-detect nvidia card and install nvidia-dkms drivers for your kernel.   
> Nvidia drm will be enabled in grub, so please [ensure](https://wiki.archlinux.org/title/NVIDIA) your nvidia card supports dkms drivers/hyprland.   

After minimal Arch install (with grub), clone and execute -
```shell
pacman -Sy git
git clone https://github.com/prasanthrangan/hyprdots ~/Hyprdots
cd ~/Hyprdots/Scripts
./install.sh
```

> **Note**
>
> You can also create your own list (for ex. `custom_apps.lst`) with all your favorite apps and pass the file as a parameter to install it -
>```shell
>./install.sh custom_apps.lst
>```

Please reboot after the install script completes and takes you to sddm login screen (or black screen) for the first time.   
For more details, please refer [installation.md](https://github.com/prasanthrangan/hyprdots/blob/main/installation.md)


### Theming
To add your own custom theme, please refer [theming.md](https://github.com/prasanthrangan/hyprdots/blob/main/theming.md)
- Available themes
    - [x] Catppuccin-Mocha
    - [x] Catppuccin-Latte
    - [x] Decay-Green
    - [x] Rosé-Pine
    - [x] Tokyo-Night
    - [x] Material-Sakura
    - [x] Graphite-Mono
    - [x] Cyberpunk-Edge
    - [ ] Gruvbox-Retro (maybe later)
    - [ ] Nordic-Blue (maybe later)

- Contributors themes
    - [x] Frosted-Glass by T-Crypt

| Catppuccin-Mocha |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_mocha_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_mocha_2.png) |

| Catppuccin-Latte |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_latte_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_latte_2.png) |

| Decay-Green |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_decay_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_decay_2.png) |

| Rosé-Pine |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_rosine_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_rosine_2.png) |

| Tokyo-Night |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_tokyo_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_tokyo_2.png) |

| Material-Sakura |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_maura_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_maura_2.png) |

| Graphite-Mono |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_graph_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_graph_2.png) |

| Cyberpunk-Edge |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_cedge_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_cedge_2.png) |

| Frosted-Glass |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_frosted_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_frosted_2.png) |


### Styles

| Theme Select |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_select.png) |

| Wallpaper Select |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/walls_select.png) |

| Launcher Style Select |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_sel.png) |

| Launcher Styles |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_2.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_3.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_4.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_5.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_6.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_7.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_8.png) |

| Wlogout Menu |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_2.png) |

| Game Launchers |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_2.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_3.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_4.png) |


<details>
<summary><h4>Packages</h4></summary>

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

</details>


<details>
<summary><h4>Keybindings</h4></summary>

| Keys | Action |
| :--  | :-- |
| <kbd>Super</kbd> + <kbd>Q</kbd> | quit active/focused window
| <kbd>Alt</kbd> + <kbd>F4</kbd> | quit active/focused window
| <kbd>Super</kbd> + <kbd>Del</kbd> | quit hyprland session
| <kbd>Super</kbd> + <kbd>W</kbd> | toggle window on focus to float
| <kbd>Alt</kbd> + <kbd>Enter</kbd> | toggle window on focus to fullscreen
| <kbd>Alt</kbd> + <kbd>J</kbd> | toggle layout
| <kbd>Super</kbd> + <kbd>G</kbd> | toggle window group
| <kbd>Super</kbd> + <kbd>T</kbd> | launch kitty terminal
| <kbd>Super</kbd> + <kbd>E</kbd> | launch dolphin file explorer
| <kbd>Super</kbd> + <kbd>C</kbd> | launch vscode
| <kbd>Super</kbd> + <kbd>F</kbd> | launch firefox
| <kbd>Super</kbd> + <kbd>A</kbd> | launch desktop applications (rofi)
| <kbd>Super</kbd> + <kbd>Tab</kbd> | switch open applications (rofi)
| <kbd>Super</kbd> + <kbd>R</kbd> | browse system files (rofi)
| <kbd>F10</kbd> | mute audio output (toggle)
| <kbd>F11</kbd> | decrease volume (hold)
| <kbd>F12</kbd> | increase volume (hold)
| <kbd>Super</kbd> + <kbd>V</kbd> | clipboard history paste
| <kbd>Super</kbd> + <kbd>L</kbd> | lock screen
| <kbd>Super</kbd> + <kbd>Backspace</kbd> | logout menu
| <kbd>Super</kbd> + <kbd>P</kbd> | screenshot snip
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd> | print current screen
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> | launch obs
| <kbd>Super</kbd> + <kbd>RightClick</kbd> | resize the window 
| <kbd>Super</kbd> + <kbd>LeftClick</kbd> | change the window position
| <kbd>Super</kbd> + <kbd>MouseScroll</kbd> | cycle through workspaces
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd>| resize windows (hold)
| <kbd>Super</kbd> + <kbd>[0-9]</kbd> | switch to workspace [0-9]
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>[0-9]</kbd> | move active window to workspace [0-9]
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd> | move window to special workspace
| <kbd>Super</kbd> + <kbd>S</kbd> | toogle to special workspace
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>G</kbd> | disable hypr effects for gamemode
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>→</kbd> | next wallpaper
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>←</kbd> | previous wallpaper
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>↑</kbd> | next waybar mode
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>↓</kbd> | previous waybar mode
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> | theme select menu
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | wallpaper select menu
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd> | rofi style select menu

</details>


<details>
<summary><h4>Playlist</h4></summary>

| youtube |
| --- |
| [![IMAGE ALT TEXT](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/yt_playlist.png)](https://www.youtube.com/watch?v=_nyStxAI75s&list=PLt8rU_ebLsc5yEHUVsAQTqokIBMtx3RFY) |

</details>


<details>
<summary><h4>Known Issues</h4></summary>

- [ ] Few scaling issues with rofi configs, as they are created based on my ultrawide (21:9) display.
- [ ] Random lockscreen crash, refer https://github.com/swaywm/sway/issues/7046
- [ ] Waybar launching rofi breaks mouse input (added `sleep 0.1` as workaround), refer https://github.com/Alexays/Waybar/issues/1850
- [ ] Flatpak QT apps does not follow system theme

</details>

