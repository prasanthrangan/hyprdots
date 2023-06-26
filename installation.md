# --// Hyprdots Installation //--

```shell
   _  _    _____               _     _          _____         _       _ _     _   _              _  _ 
  / |/ |  |  |  |_ _ ___ ___ _| |___| |_ ___   |     |___ ___| |_ ___| | |___| |_|_|___ ___     / |/ |
 / // /   |     | | | . |  _| . | . |  _|_ -|  |-   -|   |_ -|  _| .'| | | .'|  _| | . |   |   / // / 
|_/|_/    |__|__|_  |  _|_| |___|___|_| |___|  |_____|_|_|___|_| |__,|_|_|__,|_| |_|___|_|_|  |_/|_/  
                |___|_|                                                                               
```


## Process

The install script has 3 main sections
- [i]nstall
    - prepare temp list of packages `install_pkg.lst` from main package list `custom_hypr.lst`
    - if the user pass additional list `custom_apps.lst`, then add it to the list `install_pkg.lst`
    - if nvidia card is detected in system, add `nvidia-dkms` and `nvidia-utils` to the list `install_pkg.lst`
    - install packages from `install_pkg.lst`
        - use `pacman` to install package if its available in official arch repo
        - use `yay` to install package if its available in AUR

- [r]estore
    - uncompress `tar.gz` files from `Source/arcs/` to the target location specified in `restore_fnt.lst`
    - copy dot files from `Configs` directory to corresponding target location specified in `restore_cfg.lst` for installed packages
    - fix/update all the symlinks used

- [s]ervice
    - enable and start system services like sddm and bluetooth


## Flow

![](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/install_flow.png)


## Execution

The install script can be executed in different modes,

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
./install.sh -r # just restores the config files
./install.sh -s # start and enable system services
```

