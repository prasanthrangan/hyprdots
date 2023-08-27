# --// Hyprdots //--


<p align="center">
  <img width="250" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/hyprdots_arch.png">
</p>
    


## My Arch Hyprland Config

https://user-images.githubusercontent.com/106020512/235429801-e8b8dae2-c1ad-4e23-9aa2-b1edb6cabe99.mp4

| <!-- --> | <!-- --> |
| --- | --- |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_1.png) | ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_2.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_3.png) | ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/showcase_4.png) |


### Installation

> **Warning**
>
> Install script will auto-detect nvidia card and install nvidia-dkms drivers for your kernel.   
> Nvidia drm will be enabled only in grub and Hyperland is launched by sddm!!   
> So please ensure that hyprland supports your nvidia card.   

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
    - [ ] Frosted-Glass (maybe later)
    - [ ] Gruvbox-Retro (maybe later)
    - [ ] Nordic-Blue (maybe later)

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

| Theme Select |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_select.png) |

| wallpaper Select |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/walls_select.png) |


### Rofi
| launchers |
| :-: |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_sel.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_1.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_2.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_3.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_4.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_5.png) |
| ![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_6.png) |


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
xdg-desktop-portal-gtk | XDG Desktop Portal file picker
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
| `Super` + `Q`| quit active/focused window
| `Super` + `Del` | quit hyprland session
| `Super` + `W` | toggle window on focus to float
| `Alt` + `Enter` | toggle window on focus to fullscreen
| `Alt` + `J` | toggle layout
| `Super` + `G` | disable hypr effects for gamemode
| `Super` + `T` | launch kitty terminal
| `Super` + `E` | launch dolphin file explorer
| `Super` + `V` | launch Vs code
| `Super` + `F` | launch firefox
| `Super` + `A` | launch desktop applications (rofi)
| `Super` + `Tab` | switch open applications (rofi)
| `Super` + `R` | browse system files (rofi)
| `F10` | mute audio output (toggle)
| `F11` | decrease volume (hold)
| `F12` | increase volume (hold)
| `Super` + `L` | lock screen
| `Super` + `Backspace` | logout menu
| `Super` + `P` | screenshot snip
| `Super` + `Alt` + `P` | print current screen
| `Super` + `RightClick` | resize the window 
| `Super` + `LeftClick` | change the window position
| `Super` + `MouseScroll` | cycle through workspaces
| `Super` + `Shift` + `←` `→` `↑` `↓` | resize windows (hold)
| `Super` + `[0-9]` | switch to workspace [0-9]
| `Super` + `Shift` + `[0-9]` | move active window to workspace [0-9]
| `Super` + `Alt` + `S` | move window to special workspace
| `Super` + `S` | toogle to special workspace
| `Super` + `Alt` + `→` | next wallpaper
| `Super` + `Alt` + `←` | previous wallpaper
| `Super` + `Alt` + `↑` | next waybar mode
| `Super` + `Alt` + `↓` | previous waybar mode
| `Super` + `Shift` + `T` | theme select menu
| `Super` + `Shift` + `W` | wallpaper select menu
| `Super` + `Shift` + `A` | rofi style select menu

</details>


<details>
<summary><h4>Playlist</h4></summary>

| youtube |
| --- |
| [![IMAGE ALT TEXT](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/yt_playlist.png)](https://www.youtube.com/watch?v=_nyStxAI75s&list=PLt8rU_ebLsc5yEHUVsAQTqokIBMtx3RFY) |

</details>


<details>
<summary><h4>To-Do</h4></summary>

- [x] Wallpaper change script (ver2)
- [x] Theme selector script
- [x] Theme change script (ver2)
- [x] Update rofi configs
- [x] Clipboard manager in waybar
- [x] Add options to install script (ver2)
- [x] Dynamic waybar config generator script
- [x] Media control mpris module for waybar
- [x] Update Volume control script/notification (ver2)
- [x] Rofi config change script + add new configs
- [x] Make wlogout configs dynamic and sync with theme
- [x] Wallpaper select script with rofi menu
- [ ] Fix rofi configs/scripts for dynamic scaling
- [ ] Sync PC/keyboard hw rgb with current theme (themeswitch.sh + openrgb)
- [ ] Add battery and brightness indicator/notification for laptop users
- [ ] Add Eww widgets? (maybe later)

</details>


<details>
<summary><h4>Known Issues</h4></summary>

- [ ] Few scaling issues with rofi configs, as they are created based on my ultrawide (21:9) display.
- [ ] Random lockscreen crash, refer https://github.com/swaywm/sway/issues/7046
- [ ] Waybar launching rofi breaks mouse input (added `sleep 0.1` as workaround), refer https://github.com/Alexays/Waybar/issues/1850
- [ ] Flatpak QT apps does not follow system theme

</details>

