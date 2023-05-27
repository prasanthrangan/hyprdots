# --// Hyprdots Theming //--

## Theme Structure

To create/add new theme (for ex. `My-Fav-Theme`), here are the files required to theme the base applications

```shell

~/.themes/
    |
    +--> My-Fav-Theme/ # main theme for GTK apps

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

```
