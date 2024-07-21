# HyDE Wiki - SWWW Wallpaper

This repository contains several scripts (`swwwallselect.sh`, `swwwallcache.sh`, `swwwallkon.sh`, `swwwallpaper.sh`) designed to manage and set wallpapers using the `swww` wallpaper manager. Each script has specific functionalities to enhance the wallpaper management experience on your Arch Hyprland setup.

## Scripts and Their Functionalities

### 1. swwwallselect.sh

This script provides a user interface for selecting wallpapers using `rofi`.
[](https://github.com/prasanthrangan/hyprdots/blob/09b3480ed0cfc28e590866fe3626866cce8fb620/Source/assets/walls_select.png)

**Features:**

- Display a list of available wallpapers using `rofi`.
- Supports scaling and customization options for the `rofi` menu.

**Usage:**

```sh
./swwwallselect.sh
```

### 2. swwwallcache.sh

This script manages the wallpaper cache, ensuring that wallpapers are stored and retrieved efficiently.

**Features:**

- Maintains a cache of current, square, thumbnail, blur, quad, and dual color versions of wallpapers.
- Handles setting the next, previous, or specific wallpaper based on input options.

**Usage:**

```sh
./swwwallcache.sh -[option]

Options:
-w : Generate cache for input wallpaper
-t : Generate cache for input theme
-f : Full cache rebuild
```

### 3. swwwallkon.sh

[!CAUTION]
How does it work and for what is it?
?This skript updates the Menu entry and allow to set a wallpaper using `swww`.?

**Features:**

- Sets background using the current wallpaper.
- Ensures consistency across different display elements.

**Usage:**

```sh
./swwwallkon.sh -[option]

Options:
-t : add wallpaper to current theme
-w : add wallpaper to current wallpaper
```

### 4. swwwallpaper.sh

This script applies the selected wallpaper using `swww`.

**Features:**

- Sets the wallpaper with various transition effects.
- Configures transition parameters such as duration, type, and frame rate.

**Usage:**

```sh
./swwwallpaper.sh -[option]

Options:
-s : Set a specific wallpaper file
-n : Set the next wallpaper
-p : Set the previous wallpaper
```

## Example Commands

1. **Select a wallpaper using rofi:**

   ```sh
   ./swwwallselect.sh
   ```

2. **Set a specific wallpaper:**

   ```sh
   ./swwwallpaper.sh -s /path/to/your/wallpaper.jpg
   ```

3. **Set the next wallpaper:**

   ```sh
   ./swwwallcache.sh -n
   ```

4. **Set the previous wallpaper:**

   ```sh
   ./swwwallcache.sh -p
   ```

## Contributions

Feel free to contribute to this project by submitting issues or pull requests. Ensure to follow the contribution guidelines provided in `CONTRIBUTING.md`.

## License

This project is licensed under the GPL-3.0 License. See the `LICENSE` file for more details.

## Contact

For any queries, reach out to the maintainer at [GitHub](https://github.com/prasanthrangan/hyprdots).
