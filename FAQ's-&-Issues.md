<p align="center"><br><br>
  <img width="100" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/hyde.png">
</p><br>


## Frequently Asked Questions 

**HyDE related questions, Hyprland related questions should be referenced to [Hyprland Wiki](https://wiki.hyprland.org/)**


***


**How do I change wallpaper to custom wallpaper?** 
```
~/.config/hypr/scripts/swwwallpaper.sh -s path/to/wallpaper
```


***


**How do I screen record?**

You can screen record using the following two wayland based recording packages.

[wl-screenrec](https://github.com/russelltg/wl-screenrec)

[wf-recorder](https://github.com/ammen99/wf-recorder)


***


**How do I set my own preferences?**

You can set your Hyprland preferences in `~/.config/hypr/userprefs.conf`. These settings are retained even when updating the repository.


***

**How do I update my dotfiles to the latest?**

```
cd ~/HyDE/Scripts
git pull
./install.sh -r
```


***


**How do I set my monitor resolution and refresh rate?**

You can set the monitor resolution and refresh rate in `~/.config/hypr/monitors.conf` 

`monitor = DP-1,2560x1440@144,0x0, 1` >> The @ set's the refresh rate 


***


**How do I remove the pokemon characters or change the terminal startup intro?**

You need to edit the .zshrc file in your home directory at `~/.zshrc` 
```
1. Open a terminal
2. nano .zshrc / or your favorite editor
3. add a # to line 158 where pokemon-colorscripts --no-title -r 1,3,6
4. CRTL + X and save
```


***


**How do I edit the sddm wallpaper or settings?**

* Change Wallpaper 

You need to manually run the script `~/.config/hypr/sddmwall.sh` on the wallpaper you want for the login screen, you can select the wallpaper from the themes and make sure it is the current swww wallpaper.

* Change SDDM settings

(colors, background, date format, font) can be configured in `/usr/share/sddm/themes/corners/theme.conf`

if you want to modify the structure then you'll have to modify the qml files in
`/usr/share/sddm/themes/corners/components`


***


**How can I change keyboard layout?**

You can change the keyboard layout by adding the keyboard layouts to the `Hyprland.conf` in `~/.config/hypr/`

Then use the keyboard bind `Super + K`


***


**How do I get my wallpapers to load in Themeselect or WallpaperSwitch?**

If your wallpapers are not loading run the script `create_cache.sh` in the HyDE repository that was cloned.

`~/HyDE/Scripts/create_cache.sh`


***


**How do I edit the waybar?** 

You can set your required modules in this file - `~/.config/waybar/config.ctl`

Refer to the theming documentation here in the Wiki. [Waybar](https://github.com/prasanthrangan/hyprdots/wiki/Theming#waybar)


***


**How do I remove the blur on waybar?**

You can remove the blur on waybar by removing `blurls = waybar` in the themes directory by commenting the line at the end of each theme.conf file.

Themes Directory: `~/.config/hypr/themes/`

***


**How do I launch the gamebar shown in the preview?**

You'll need steam game or lutris library installed, and then run this:
```
~/.config/hypr/scripts/gamelauncher.sh <n> # where n is style [1-4]
```

## Blurry apps

**Reasons**
Read this first: https://www.linux.org/threads/why-use-wayland-with-xwayland.45125/post-192531
+ XWayland applications can appear blurry, especially on high-resolution displays, due to Xorg’s inability to scale properly. This is a known issue.
+ Electron apps (e.g discord,chromimium-base-apps/browsers) run in XWayland mode by default, which can lead to blurriness.
+ Electron apps can also appear blurry when fractional scaling is enabled on Wayland. This is because the scaling process can result in applications not being rendered at the correct pixel density, leading to a blurry appearance


**Fixes**

+ Identify the application first. Search engines are free. Query for 'How to run Application XXX in Wayland?'. 
+ Run ``` hyprctl clients ```, find the package of interest and confirm if xwayland value is 1 
![image](https://github.com/prasanthrangan/hyprdots/assets/53417443/62abd678-53b7-4186-a9bb-862a5b62d110)

> [!Important]
> Running apps natively on wayland should fix mostly all of the blur issues.

### Electron/Chromium 

##### Browsers (chrome/brave)

Open the browser >> navigate ``` chrome://flags/  ``` >> search for ``` Preferred Ozone platform ``` >> Select wayland 

##### Other Electron apps 

Take ``` Vs code ``` for example.
Be sure to exit all VS Code instance
Run ``` code --enable-features=UseOzonePlatform --ozone-platform=wayland ``` 

> [!Caution]
> Add/remove this flag ```--disable-gpu ``` if sometimes the application becomes invisible

**How can I launch it on app launcher**

+ Find the .desktop entry using this handy command ```  find /usr/share/applications -name '*code.desktop'  ```
![image](https://github.com/prasanthrangan/hyprdots/assets/53417443/93e7ead2-60c0-4767-82ab-000b581bb342)
+ You should copy then edit the .desktop entry of each application to ``` ~/.local/share/applications/ ```
+ Find the ``` Exec = ``` part then add the flags  
![image](https://github.com/prasanthrangan/hyprdots/assets/53417443/b4229427-14c9-43c3-a180-2a7fc0da9e0d)

> [!Note]
>Remember, if you're looking to edit or create a .desktop file, it's a good practice to place it in ``` ~/.local/share/applications/ ``` to avoid modifying system-wide files. This ensures that your changes are user-specific and do not require administrative privileges

This repo is not a Linux tutorial, so here is the [wiki on how to deal with .desktop entries.](https://wiki.archlinux.org/title/desktop_entries) 

## Xwayland(👹)

Please navigate to the Hyprland wiki for the explanation. 
#### [XWayland](https://wiki.hyprland.org/Configuring/XWayland/) 

### Note that if the application does not support Wayland, HyDE, Hyprland and Wayland itself don't have powers to magically fixed the issue! Do not report this as an issue, try to open questions on the [Discussion panel](https://github.com/prasanthrangan/hyprdots/discussions) for help.

## Known Issues

- Few scaling issues with rofi configs, as they are created based on my ultrawide (21:9) display.
- Random lockscreen crash, refer https://github.com/swaywm/sway/issues/7046
- Waybar launching rofi breaks mouse input (added `sleep 0.1` as workaround), refer https://github.com/Alexays/Waybar/issues/1850
- Flatpak QT apps do not follow system theme
