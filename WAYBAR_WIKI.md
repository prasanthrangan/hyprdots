# HyDE Wiki - Waybar Configuration

This wiki is about the HyDE tool for managing the status bar and it's layouts. It explains the syntax used in the `config.ctl` file to configure the status bar layout with modules organized into three segments: **left, center, and right** across the screen. This guide provides an overview of the configuration syntax and how to customize your status bar layouts effectively and toggle between them using the scripts and the `config.ctl` file.

## Scripts and Configuration File

The scripts are located in the `~/.local/share/bin` and the configuration file is located in the `~/.config/waybar` folder. The scripts generate the layout and style for the status bar. The configuration file `config.ctl` contains the different layout configurations for the status bar. The `wbarconfgen.sh` and `wbarstylegen.sh` scripts are used to generate the configuration and style files for the status bar. The jsonc files located in the `~/.config/waybar/modules` folder are used to generate the status bar. They are used to customize the status bar modules.

The scripts are as follows:

- `config.ctl`: The configuration file for the status bar layouts.
- `wbarconfgen.sh`: The Script that generates the configuration file for the status bar.
- `wbarstylegen.sh`: The Script that generates the style file for the status bar.

### Example Configuration

The `config.ctl` file contains the different layouts for the status bar. Here is the example configuration for the status bar:
[](https://github.com/prasanthrangan/hyprdots/blob/main/Source/assets/waybar_example.png)

The config.ctl line for the status bar is:

```shell
1|31|bottom|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( wlr/taskbar custom/spotify )|( idle_inhibitor clock )|( tray battery ) ( backlight network pulseaudio pulseaudio#microphone custom/notifications custom/keybindhint )
```

### Explanation of Syntax

1. **Status (`1`)**: Indicates the status bar is active.
2. **Size (`31`)**: Specifies the size of the status bar in pixels or another unit.
3. **Position (`bottom`)**: Positions the status bar at the bottom of the screen.

### Segmentation by Position

- **Left**: `( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( wlr/taskbar custom/spotify )`

  - Divided into two segments:
    1. `( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange )`: Modules like `power`, `cliphist`, `wbar`, `theme`, and `wallchange`, positioned at the left edge of the status bar.
    2. `( wlr/taskbar custom/spotify )`: Modules like `taskbar` and `spotify`, positioned next to the left edge of the status bar.

- **Center**: `( idle_inhibitor clock )`

  - Modules like `idle_inhibitor` and `clock`, centered within the status bar.

- **Right**: `( tray battery ) ( backlight network pulseaudio pulseaudio#microphone custom/notifications custom/keybindhint )`

  - Divided into two segments:
    1. `( tray battery )`: Modules like `tray` and `battery`, positioned to the left of the `backlight`, `network`, `pulseaudio`, `pulseaudio#microphone`, `custom/notifications`, and `custom/keybindhint`, Modules.
    2. `( backlight network pulseaudio pulseaudio#microphone custom/notifications custom/keybindhint )`: Modules like `backlight`, `network`, `pulseaudio`, `pulseaudio#microphone`, `custom/notifications`, and `custom/keybindhint`, positioned at the far right edge of the status bar.

### Notes

- Use parentheses `()` to group modules within segments.
- Ensure the syntax matches your desired configuration to avoid errors in the status bar setup.
- Refer to the Waybar wiki for creating custom modules to further personalize your status bar.

## Contributions

Feel free to contribute to this project by submitting issues or pull requests. Ensure to follow the contribution guidelines provided in `CONTRIBUTING.md`.

## License

This project is licensed under the GPL-3.0 License. See the `LICENSE` file for more details.

## Contact

For any queries, reach out to the maintainer at [GitHub](https://github.com/prasanthrangan/hyprdots).
