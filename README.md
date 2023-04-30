# --// Hyprdots //--

## My Arch Hyprland Config Files

WARNING : Install script will auto-detect nvidia card and install nvidia-dkms drivers for your kernel.
Nvidia drm will be enabled only in grub and Hyperland is launched by sddm!!


### Main install script
After minimal Arch install (with grub), clone and execute -
```
pacman -Sy git
git clone https://github.com/prasanthrangan/hyprdots ~/Dots
cd ~/Dots/Scripts
./install.sh
```

If you get this prompt, select xdg-desktop-portal-gtk (option 2) -
```
:: There are 5 providers available for xdg-desktop-portal-impl:
:: Repository extra:
    1) xdg-desktop-portal-gnome  2) xdg-desktop-portal-gtk  3) xdg-desktop-portal-kde
:: Repository community:
    4) xdg-desktop-portal-lxqt  5) xdg-desktop-portal-wlr
Enter a number (default=1): 2
```

Make sure you don't have any other xdg-desktop-portal-* packages installed (except xdg-desktop-portal-gtk for file dialogs)
```
pacman -Q | grep xdg-desktop-portal-
```

Please reboot after the install script completes and takes you to sddm login screen for the first time.


### These packages will be installed by the script
NOTE : You can also create your own file (for ex. custom_app.lst) with all your favorite apps and pass the file as a parameter to install it -
```
./install.sh custom_app.lst
```

#### nvidia
- linux-headers -- for main kernel (script will auto detect from /usr/lib/modules/)
- linux-zen-headers -- for zen kernel (script will auto detect from /usr/lib/modules/)
- linux-lts-headers -- for lts kernel (script will auto detect from /usr/lib/modules/)
- nvidia-dkms -- nvidia drivers (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")
- nvidia-utils -- nvidia drivers (script will auto detect from lspci -k | grep -A 2 -E "(VGA|3D)")

#### tools
- pipewire -- audio and video server
- pipewire-alsa -- for audio
- pipewire-audio -- for audio
- pipewire-jack -- for audio
- pipewire-pulse -- for audio
- gst-plugin-pipewire -- for audio
- wireplumber -- audio and video server
- networkmanager -- network manager
- network-manager-applet -- nm tray
- bluez -- for bluetooth
- bluez-utils -- for bluetooth
- blueman -- bt tray

#### login
- sddm-git -- display manager for login
- qt5-wayland -- for QT wayland XDP
- qt6-wayland -- for QT wayland XDP
- qt5-quickcontrols -- for sddm theme
- qt5-quickcontrols2 -- for sddm theme
- qt5-graphicaleffects -- for sddm theme

#### hypr
- hyprland-git -- main window manager (script will change this to hyprland-nvidia-git if nvidia card is detected)
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
- qt5-imageformats -- for dolphin thumbnails
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
    - [x] flatpak (gtk)
    - [x] rofi
    - [ ] logout
    - [ ] lockscreen
- [x] Update rofi configs
- [ ] Clipboard manager in waybar
- [x] Volume control script/notification
- [ ] Media control for waybar

### Known Issues
- [ ] Random lockscreen crash, refer https://github.com/swaywm/sway/issues/7046
- [x] Flatpak Gnome Boxes needs xdg-desktop-portal-gtk
- [ ] Flatpak QT apps does not follow system theme

