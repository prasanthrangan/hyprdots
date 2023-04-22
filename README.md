# --// Hyprdots //--

## My Arch Hyprland Config Files

WARNING : Install script is setup for nvidia-dkms drivers and nvidia drm is enabled in grub and Hyperland is launched by sddm!!


### Main install script
After minimal Arch install, clone and execute
```
pacman -Sy git
git clone https://github.com/prasanthrangan/hyprdots ~/Dots
cd ~/Dots/Scripts
./install.sh
```

### These packages will be installed by the script

#### nvidia
- linux-headers -- for nvidia drivers for main kernel
- linux-zen-headers -- for nvidia drivers for zen kernel
- linux-lts-headers -- for nvidia drivers for lts kernel
- nvidia-dkms -- nvidia drivers
- nvidia-utils -- nvidia drivers

#### tools
- pipewire -- audio and video server
- wireplumber -- audio and video server
- networkmanager -- network manager
- network-manager-applet -- nm tray
- bluez -- for bluetooth
- bluez-utils -- for bluetooth
- blueman -- bt tray

#### login
- sddm -- display manager for login
- qt5-wayland -- for QT wayland XDP
- qt6-wayland -- for QT wayland XDP
- qt5-quickcontrols -- for sddm theme
- qt5-quickcontrols2 -- for sddm theme
- qt5-graphicaleffects -- for sddm theme

#### hypr
- hyprland-nvidia-git -- main window manager
- dunst -- graphical notification daemon
- rofi-lbonn-wayland-git -- app launcher
- waybar-hyprland-git -- status bar
- swww-- wallpaper app
- swaylock-effects-git -- lockscreen
- wlogout -- logout screen
- grim -- screenshot tool
- slurp -- selects region for screenshot/screenshare
- swappy -- screenshot editor

#### dependencies
- polkit-kde-agent -- authentication agent
- pacman-contrib -- to check for available updates
- xdg-desktop-portal-hyprland-git -- XDG Desktop Portal
- imagemagick -- for kitty/neofetch image processing
- pavucontrol -- audio settings gui
- pamixer -- for waybar audio
- ~~python-requests -- for waybar weather~~
- ~~noto-fonts-emoji -- for waybar weather~~

#### theming
- nwg-look -- theming GTK apps
- kvantum -- theming QT apps
- qt5ct -- theming QT5 apps
- ~~qt6ct -- theming QT6 apps~~

#### applications
- firefox -- browser
- kitty -- terminal
- neofetch -- fetch tool
- dolphin -- kde file manager
- visual-studio-code-bin -- gui code editor
- vim -- text editor
- ark -- kde file archiver

### To-Do
- [x] Script to change light/dark theme
    - [x] wallpaper
    - [x] waybar
    - [x] gtk theme
    - [x] qt theme
    - [x] terminal
- [x] Update rofi configs
- [ ] Clipboard tool
- [ ] Volums control script/notification
- [ ] Media control for waybar

### Known Issues
- [ ] Flatpak Gnome Boxes needs xdg-desktop-portal-gtk
- [ ] Flatpak GTK apps does not follow system cursor
- [ ] Flatpak QT apps does not follow system theme

