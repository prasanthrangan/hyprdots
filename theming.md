# --// Hyprdots Theming //--

## Applications

These are the applications currently supported by the `themeswitch` script
- swww
- waybar
- gtk apps
- qt apps
- kitty
- flatpak
- rofi
- hypr
- wlogout (to be added later)


## Theme Structure

To create/add new theme (for ex. `My-Fav-Theme`), here are the files required to theme the base applications

> **Note**
>
> The theme name `My-Fav-Theme` should be consistent for all config file name

```shell

~/.config/
    |
    +--> hypr/themes/
    |   |
    |   +--> My-Fav-Theme.conf
    |
    +--> kitty/themes/
    |   |
    |   +--> My-Fav-Theme.conf
    |
    +--> Kvantum/My-Fav-Theme/
    |   |
    |   +--> My-Fav-Theme.kvconfig
    |   +--> My-Fav-Theme.svg
    |
    +--> qt5ct/colors/
    |   |
    |   +--> My-Fav-Theme.conf
    |
    +--> rofi/themes/
    |   |
    |   +--> My-Fav-Theme.rasi
    |
    +--> swww/
    |   |
    |   +--> wall.ctl   # main control file
    |   +--> My-Fav-Theme/*   # place wallpapers here
    |
    +--> waybar/themes/
        |
        +--> My-Fav-Theme.css

~/..icons/
    |
    +--> <your-Fav-icon-pack>/ # for icons
    +--> <your-Fav-cursor-pack>/ # for cursors

~/.themes/
    |
    +--> My-Fav-Theme/ # main theme for GTK apps

```


## Theme Control

The `themeswitch` script works based on the `|` delimited control file `~/.config/swww/wall.ctl`

```shell
❯ cd ~/.config/swww
❯ cat wall.ctl
1|Catppuccin-Mocha|~/.config/swww/Catppuccin-Mocha/forest_dark_winter.jpg
0|Catppuccin-Latte|~/.config/swww/Catppuccin-Latte/jormungandr.jpg
0|My-Fav-Theme|<image file with full path>
```

where column,
1. is `0` or `1`, where `1` indicates the current theme in use
2. is the theme name `My-Fav-Theme`
3. is the Dir/Wallpaper to be used for `My-Fav-Theme` 

> **Note**
>
> As wallpapers can be changed/cycled, column 3 here gets updated by the wallpaper script.
> Also, all files in the wallpaper dir should be valid image files or animated gif files

```shell
❯ cd ~/.config/hypr/scripts
❯ ./themeswitch.sh -h
./themeswitch.sh: illegal option -- h
n : set next theme
p : set previous theme
s : set theme from parameter
t : display tooltip
❯ 
❯ ./themeswitch.sh -s My-Fav-Theme
```
