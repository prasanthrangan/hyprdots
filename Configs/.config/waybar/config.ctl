# Display config

ID1=51|ID1=CN41470SDV # LA2405 (1K)

ID0=50|ID0=0x01010101,ID2=0x000000C2 # PL4372UH (4K), Kamvas Pro16+ (4K)
ID2=52|ID0=0x01010101,ID2=0x000000C2 # PL4372UH (4K), Kamvas Pro16+ (4K)

ID0=52|ID0=0x01010101,ID1=CN41470SDV,ID2=0x000000C2 # Kamvas Pro16+ (4K), LA2405 (1K), PL4372UH (4K)
ID1=51|ID0=0x01010101,ID1=CN41470SDV,ID2=0x000000C2 # Kamvas Pro16+ (4K), LA2405 (1K), PL4372UH (4K)
ID2=50|ID0=0x01010101,ID1=CN41470SDV,ID2=0x000000C2 # Kamvas Pro16+ (4K), LA2405 (1K), PL4372UH (4K)

ID1=51|ID1=CN41470SDV,ID2=0x000000C2 # LA2405 (1K), PL4372UH (4K)
ID2=50|ID1=CN41470SDV,ID2=0x000000C2 # LA2405 (1K), PL4372UH (4K)

ID2=51|ID2=0x000000C2 # PL4372UH (4K)

# Waybar config
1|28|bottom|( cpu memory custom/cpuinfo custom/gpuinfo ) ( idle_inhibitor clock )|( hyprland/workspaces hyprland/window )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
2|28|top|( cpu memory custom/cpuinfo custom/gpuinfo ) ( idle_inhibitor clock )|( hyprland/workspaces hyprland/window )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
3|28|bottom|( cpu memory custom/cpuinfo custom/gpuinfo ) ( idle_inhibitor clock ) ( hyprland/workspaces )|( hyprland/window )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
4|28|top|( cpu memory custom/cpuinfo ) ( idle_inhibitor clock ) ( hyprland/workspaces )|( hyprland/window )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
5||bottom||( hyprland/workspaces hyprland/window )|( idle_inhibitor clock )|( cpu memory custom/cpuinfo custom/gpuinfo ) ( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
6||top||( hyprland/workspaces hyprland/window )|( idle_inhibitor clock )|( cpu memory custom/cpuinfo custom/gpuinfo ) ( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
7|31|bottom|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( wlr/taskbar custom/spotify ) |( idle_inhibitor clock )|( tray battery ) ( backlight network bluetooth pulseaudio pulseaudio#microphone custom/keybindhint )
8|31|left|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( wlr/taskbar custom/spotify ) |( idle_inhibitor clock )|( tray battery ) ( backlight network bluetooth pulseaudio pulseaudio#microphone custom/keybindhint )
9|31|top|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( wlr/taskbar custom/spotify ) |( idle_inhibitor clock )|( tray battery ) ( backlight network bluetooth pulseaudio pulseaudio#microphone custom/keybindhint )
10|31|right|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( wlr/taskbar custom/spotify ) |( idle_inhibitor clock )|( tray battery ) ( backlight network bluetooth pulseaudio pulseaudio#microphone custom/keybindhint )
11|32|bottom||( custom/power ) ( tray battery ) ( wlr/taskbar idle_inhibitor clock ) ( custom/cliphist ) ( custom/wbar ) ( custom/wallchange ) ( custom/theme )|
12|32|left||( custom/power ) ( tray battery ) ( wlr/taskbar idle_inhibitor clock ) ( custom/cliphist ) ( custom/wbar ) ( custom/wallchange ) ( custom/theme )|
13|32|top||( custom/power ) ( tray battery ) ( wlr/taskbar idle_inhibitor clock ) ( custom/cliphist ) ( custom/wbar ) ( custom/wallchange ) ( custom/theme )|
14|32|right||( custom/power ) ( tray battery ) ( wlr/taskbar idle_inhibitor clock ) ( custom/cliphist ) ( custom/wbar ) ( custom/wallchange ) ( custom/theme )|
15|31|bottom|( cpu memory custom/cpuinfo custom/gpuinfo ) ( idle_inhibitor clock ) ( hyprland/workspaces )|( wlr/taskbar )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
16|31|top|( cpu memory custom/cpuinfo custom/gpuinfo ) ( idle_inhibitor clock ) ( hyprland/workspaces )|( wlr/taskbar )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates custom/keybindhint ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
17|29|bottom|( wlr/taskbar mpris )|( idle_inhibitor clock )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
18|29|left|( wlr/taskbar mpris )|( idle_inhibitor clock )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
19|29|top|( wlr/taskbar mpris )|( idle_inhibitor clock )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
20|29|right|( wlr/taskbar mpris )|( idle_inhibitor clock )|( backlight network bluetooth pulseaudio pulseaudio#microphone custom/updates ) ( tray battery ) ( custom/wallchange custom/theme custom/wbar custom/cliphist custom/power )
21|28|bottom|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( idle_inhibitor clock custom/spotify )|( wlr/taskbar )|( tray ) ( backlight network bluetooth pulseaudio pulseaudio#microphone )
22|28|left|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( idle_inhibitor clock custom/spotify )|( wlr/taskbar )|( tray ) ( backlight network bluetooth pulseaudio pulseaudio#microphone )
23|28|top|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( idle_inhibitor clock custom/spotify )|( wlr/taskbar )|( tray ) ( backlight network bluetooth pulseaudio pulseaudio#microphone )
24|28|right|( custom/power custom/cliphist custom/wbar custom/theme custom/wallchange ) ( idle_inhibitor clock custom/spotify )|( wlr/taskbar )|( tray ) ( backlight network bluetooth pulseaudio pulseaudio#microphone )

50|40|bottom|( custom/arch ) ( custom/monitor ) ( custom/wbar ) ( hyprland/workspaces )|( wlr/taskbar )|( custom/monitorinfo memory cpu custom/gpu custom/cpuinfo custom/gpuinfo )
51|30|top|( custom/arch ) ( custom/monitor ) ( custom/cliphist custom/wbar custom/theme custom/wallchange custom/wallbash cava ) ( hyprland/workspaces )|( wlr/taskbar )|( tray ) ( custom/updates ) ( custom/weather backlight network bluetooth pulseaudio#microphone pulseaudio custom/notifications )
52|50|top|( custom/arch ) ( custom/monitor ) ( custom/wbar ) ( hyprland/workspaces ) ( wlr/taskbar )|( idle_inhibitor clock cava mpris )|( tray ) ( custom/weather backlight network bluetooth pulseaudio#microphone pulseaudio custom/notifications )
