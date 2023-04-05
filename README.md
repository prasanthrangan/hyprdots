# --// hyprdots //--

## My Arch Hyprland Config files

WARNING : Install script is setup for nvidia-dkms drivers and nvidia drm is enabled in grub and Hyperland is launched by sddm!!


```

# nvidia
linux-zen-headers -- for nvidia drivers
linux-lts-headers -- for nvidia drivers
nvidia-dkms -- for nvidia drivers
nvidia-utils -- for nvidia drivers

# hardware
pipewire -- audio and video server
wireplumber -- audio and video server
networkmanager -- network manager
network-manager-applet -- nm tray
bluez -- for bluetooth
bluez-utils -- for bluetooth
blueman -- bt tray

# login
sddm -- display manager for login
qt5-wayland -- for QT wayland XDP
qt6-wayland -- for QT wayland XDP
qt5-quickcontrols -- for sddm theme
qt5-quickcontrols2 -- for sddm theme
qt5-graphicaleffects -- for sddm theme

# hypr
hyprland -- main window manager
mako -- graphical notification daemon
rofi-lbonn-wayland-git -- app launcher
waybar-hyprland-git -- status bar
hyprpaper-git -- wallpaper app
swaylock-effects-git -- lockscreen
wlogout -- logout screen
grim -- screenshot tool
slurp -- selects region for screenshot/screenshare
swappy -- screenshot editor

# dependencies
polkit-kde-agent -- authentication agent
xdg-desktop-portal-hyprland-git -- XDG Desktop Portal
imagemagick -- for kitty/neofetch image processing
python-requests -- for waybar weather
pavucontrol -- audio settings gui
pamixer -- for waybar audio
noto-fonts-emoji -- for waybar weather

```
