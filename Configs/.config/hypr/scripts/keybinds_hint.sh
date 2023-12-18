#!/usr/bin/env sh

ScrDir=$(dirname $(realpath $0))
source $HOME/.config/hypr/scripts/globalcontrol.sh
roconf="~/.config/rofi/keybinds_hint.rasi"

# read hypr theme border
wind_border=$((hypr_border * 3))
elem_border=$([ $hypr_border -eq 0 ] && echo "10" || echo $((hypr_border * 2)))
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"

# read hypr font size
fnt_override=$(gsettings get org.gnome.desktop.interface font-name | awk '{gsub(/'\''/,""); print $NF}')
fnt_override="configuration {font: \"JetBrainsMono Nerd Font ${fnt_override}\";}"

# read hypr theme icon
icon_override=$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")
icon_override="configuration {icon-theme: \"${icon_override}\";}"



#? Script to re Modify hyprctl json output

add_delim() {
awk -F '=!' '{if ($2 != "") printf "%-25s %-3s %-30s\n", $1, "", $2; else printf "%-30s\n", $1}'
}

is_COMMENT() { #! This Part tries to parse comments but hyprctl doesn't give enough information
  keyfile1="$HOME/.config/hypr/keybindings.conf"  # replace with your actual file path
  keyfile2="$HOME/.config/hypr/userprefs.conf"  # replace with your second file path
  tempFile="/tmp/tempfile"  # replace with your preferred path for the temporary file
  cat "$keyfile1" "$keyfile2" > "$tempFile"
  awk -F ' = ' -v file="$tempFile" -v OFS=' = ' '
    $4 == "exec" && $8 ~ /^ *$/ {
      value=$5
      gsub(/[.*|\\/]/, "\\\\&", value)
      command="awk \"/bind/ && /$3/ && /exec/ && /" value "/ { split(\\$0, arr, /#/); print arr[2] }\" " file
      command | getline result
      close(command)
      $8 = result
    }
    { print }'
}

GROUP() {
  awk -F '=!' '
  {
    category = $1
    binds[category] = binds[category] ? binds[category] "\n" $0 : $0
  }

  END {
    maxLen = 0
    n = asorti(binds, b)
    for (i = 1; i <= n; i++) {
      gsub(/\[.*\] =/, "", b[i])
      split(binds[b[i]], lines, "\n")
      for (j in lines) {
        line = substr(lines[j], index(lines[j], "=") + 2)
        len = length(line)
        if (len > maxLen) maxLen = len
        print line
      }
      for (j = 1; j <= maxLen; j++) printf "━"
      printf "\n"
    }
  }'
}

DISPLAY() { awk -F '=!' '{if ($0 ~ /=/) printf "%-30s %-40s\n", $5, $6; else print $0}' ;}



#! This is Our Translator for some binds 
metaData="$(hyprctl binds -j | jq -c '
  def modmask_mapping: { #? Define mapping for modmask numbers represents bitmask
    "64": " ",  #? SUPER
#    "32" : "ERROR:32",  #* Dont know
#    "16": "Err:16",      #* Dont know
    "8": "ALT", 
    "4": "CTRL", 
#!    "2":  "SHIFT",  # Wrong dunno yet
    "1": "SHIFT",
    "0": " ",
  };
  def key_mapping: { #?Define mappings for .keys to become symbols
    "mouse_up" : "󱕑",
    "mouse_down" : "󱕐",
    "mouse:272" : "󰍽",
    "mouse:273" : "󰍽",
    "UP" : "",
    "DOWN" : "",
    "LEFT" : "",
    "RIGHT" : "",
    "XF86AudioLowerVolume" : "󰝞",
    "XF86AudioMicMute" : "󰍭",
    "XF86AudioMute" : "󰓄",
    "XF86AudioNext" : "󰒭",
    "XF86AudioPause" : "󰏤",
    "XF86AudioPlay" : "󰐊",
    "XF86AudioPrev" : "󰒮",
    "XF86AudioRaiseVolume" : "󰝝",
    "XF86MonBrightnessDown" : "󰃜",
    "XF86MonBrightnessUp" : "󰃠",
  };
  def category_mapping: { #? Define Category Names, derive from Dispatcher
    "exec" : "Execute Something Here:",
    "global": "Global:",
    "exit" : "Exit Hyprland Session",
    "fullscreen" : "Toggle Functions",
    "mouse" : "Mouse functions",
    "movefocus" : "Window functions",
    "movewindow" : "Window functions",
    "resizeactive" : "Window functions",
    "togglefloating" : "Toggle Functions",
    "togglegroup" : "Toggle Functions",
    "togglespecialworkspace" : "Toggle Functions",
    "togglesplit" : "Toggle Functions",
    "workspace" : "Navigate Workspace",
    "movetoworkspace" : "Navigate Workspace",
    "movetoworkspacesilent" : "Navigate Workspace",
    

  };
def arg_mapping: { #? Do not Change this used for Demo only...
    "arg1": "mapped_arg1",
    "arg2": "mapped_arg2",
  };

    def description_mapping: {  #? Derived from dispatcher and Gives Description for Dispatchers 
    "movefocus": "Move",
    "resizeactive": "Resize Active Floting Window",
    "exit" : "End Hyprland Session",
    "movetoworkspacesilent" : "Silently Move to Workspace",
    "movewindow" : "Move Window",
    "exec" : "" , #? Remove exec as execuatable will give the Description
    "movetoworkspace" : "Move To Workspace:",
    "workspace" : "Navigate to Workspace:",
    "togglefloating" : "Toggle Floating",
    "fullscreen" : "Toggle Fullscreen",
    "togglegroup" : "Toggle Group",
    "togglesplit" : "Toggle Split",
    "togglespecialworkspace" : "Toggle Special Workspace",

  };
def executables_mapping: {  #? Derived from .args to parse scripts to have a Readable name

" empty " :  "Empty",
"r+1" : "Relative Right: ",
"r-1" : "Relative Left: ",
"e+1" : "Next Workspace: ",
"e-1" : "Previous Workspace: ",


"d" : "Down",
"l" : "Left",
"r" : "Right",
"u" : "Up",

"killall -SIGUSR1 waybar": "Toggle Waybar",
"pkill -x rofi || ~/.config/hypr/scripts/cliphist.sh c" : "Clipboard",
"swaylock && systemctl suspend" : "Lock and Suspend after Lid Close",
"killall waybar || waybar" : "Toggle Waybar",
"hyprctl dispatch pin" : "Pin Active Window",


"~/.config/hypr/scripts/wallbashtoggle.sh" : "Wallbash Toggle",
"~/.config/hypr/scripts/logoutlaunch.sh 1" : "Logout Launcher",
"~/.config/hypr/scripts/screenshot.sh p" : "Print all screens",
"~/.config/hypr/scripts/screenshot.sh s" : "Snip current screen",
"~/.config/hypr/scripts/screenshot.sh sf" : "Snip current screen",
"~/.config/hypr/scripts/screenshot.sh m" : "Print focused monitor",
"~/.config/hypr/scripts/brightnesscontrol.sh d" : "Brightness - ",
"~/.config/hypr/scripts/dontkillsteam.sh" : "What this do",
"~/.config/hypr/scripts/swwwallpaper.sh -n" : "Next Wallpaper",
"~/.config/hypr/scripts/swwwallpaper.sh -p" : "Previous Wallpaper",
"~/.config/hypr/scripts/gamemode.sh" : "Gamemode",
"pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh d" : "App Launcher",
"code" : "Open Vscode",
"~/.config/hypr/scripts/sysmonlaunch.sh" : "System Monitor",
"~/.config/hypr/scripts/brightnesscontrol.sh i" : "Brightness -",
"playerctl next" : "Next",
"playerctl previous" : "Prev",
"playerctl play-pause" : "Pause",
"~/.config/hypr/scripts/wbarconfgen.sh n" : "Next Waybar",
"~/.config/hypr/scripts/wbarconfgen.sh p" : "Prev Waybar",
"pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh f" : "Run",
"pkill -x rofi || ~/.config/hypr/scripts/rofiselect.sh" : "Rofi Format",
"pkill -x rofi || ~/.config/hypr/scripts/themeselect.sh" : "Select Theme",
"pkill -x rofi || ~/.config/hypr/scripts/swwwallselect.sh" : "Select Wallpaper",
"pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh w" : "Running Application",
"~/.config/hypr/scripts/keyboardswitch.sh" : "Toggle Keyboard",
"pkill -x rofi || ~/.config/hypr/scripts/quickapps.sh brave kitty" : "Quickapps",
"~/.config/hypr/scripts/volumecontrol.sh -i m" : "Mute Microphone",
"~/.config/hypr/scripts/volumecontrol.sh -o d" : "Decrease Volume",
"~/.config/hypr/scripts/volumecontrol.sh -o i" : "Increment Volume",
"~/.config/hypr/scripts/volumecontrol.sh -o m" : "Mute Speaker",

};


  def get_keys: #? Funtions to Convert modmask into Keys
    if . == 0 then
      ""
    elif . >= 64 then
      . -= 64 | modmask_mapping["64"] + " " + get_keys
    elif . >= 32 then
      . -= 32 | modmask_mapping["32"] + " " + get_keys
    elif . >= 16 then
      . -= 16 | modmask_mapping["16"] + " " + get_keys
    elif . >= 8 then
      . -= 8 | modmask_mapping["8"] + " " + get_keys
    elif . >= 4 then
      . -= 4 | modmask_mapping["4"] + " " + get_keys
    elif . >= 2 then
      . -= 2 | modmask_mapping["2"] + " " + get_keys
    elif . >= 1 then
      . -= 1 | modmask_mapping["1"] + " " + get_keys
    else
      .
    end;
  .[] | 
  
  
.dispatcher as $dispatcher | .description = $dispatcher |  
.dispatcher as $dispatcher | .category = $dispatcher |
.arg as $arg | .executables = $arg |

.modmask |= (get_keys | ltrimstr(" ")) |
.key |= (key_mapping[.] // .) |

.keybind = (.modmask | tostring // "") + (.key // "") |

.flags = " locked=" + (.locked | tostring) + " mouse=" + (.mouse | tostring) + " release=" + (.release | tostring) + " repeat=" + (.repeat | tostring) + " non_consuming=" + (.non_consuming | tostring) |

.category |= (category_mapping[.] // .) |

#!if .modmask and .modmask != " " and .modmask != "" then .modmask |= (split(" ") | map(select(length > 0)) | if length > 1 then join("  + ") else .[0] end) else .modmask = "" end |
if .keybind and .keybind != " " and .keybind != "" then .keybind |= (split(" ") | map(select(length > 0)) | if length > 1 then join("  + ") else .[0] end) else .keybind = "" end |


  .arg |= (arg_mapping[.] // .) |
#! .executables |= gsub("~/.config/hypr/scripts/"; "") |
 #!    .executables |= gsub(".sh"; "") |

  .executables |= (executables_mapping[.] // .) | 
  .description |= (description_mapping[.] // .)    
 
          
' #? <---- There is a '   do not delete this'


)"

 header="$(printf "%-40s %-1s %-30s\n" "󰌌 Keybinds" "󱧣" "Description")"
 line="$(printf '%.0s━' $(seq 1 66) "")"


metaData="$(echo "$metaData"  |  jq -r '"\(.category) =! \(.modmask) =! \(.key) =! \(.dispatcher) =! \(.arg) =! \(.keybind) =!  > \(.description) \(.executables) =! \(.flags)"' | tr -s ' ' | sort -k 1 )" #! this Part Gives extra laoding time as I don't have efforts to make all spaces on each class only 1

#echo "$metaData"

display="$(echo "$metaData" | GROUP | DISPLAY )"

# output=$(echo -e "${header}\n${line}\n${primMenu}\n${line}\n${display}")
output=$(echo -e "${header}\n${line}\n${display}")




selected=$(echo  "$output" | rofi -dmenu -p -i -theme-str "${fnt_override}" -theme-str "${r_override}" -theme-str "${icon_override}" -config "${roconf}" | sed 's/.*\s*//')
#
echo "$selected"

selected_part1=$(echo "$selected" | cut -d '>' -f 1 | awk '{$1=$1};1')

run="$(echo "$metaData" | grep "$selected_part1" )"

run_flg="$(echo "$run" | awk -F '=!' '{print $8}')"
run_sel="$(echo "$run" | awk -F '=!' '{gsub(/^ *| *$/, "", $5); if ($5 ~ /[[:space:]]/ && $5 !~ /^[0-9]+$/ && substr($5, 1, 1) != "-") print $4, "\""$5"\""; else print $4, $5}')"

#  echo "$run_sel"
#   echo "$run_flg"
if [ -n "$run_sel" ] && [ "$(echo "$run_sel" | wc -l)" -eq 1 ]; then
    eval "$run_flg"
    if [ "$repeat" = true ]; then



while true; do
    repeat_command=$(echo -e "Repeat" | rofi -dmenu -no-custom -p "[Enter] repeat; [ESC] exit") #? Needed a separate Rasi ? Dunno how to make; Maybe Something like comfirmation rasi for buttons Yes and No then the -p will be the Question like Proceed? Repeat? 

    if [ "$repeat_command" = "Repeat" ]; then
        # Repeat the command here
        eval "hyprctl dispatch $run_sel"
    else
        exit 0
    fi
done

    else
        eval "hyprctl dispatch $run_sel"
    fi

fi


#! to TEST
exit 0
case "$selected" in
"This Menu")
  ~/.config/hypr/scripts/keybinds_hint.sh
  ;;
"Kill Hyprland Sesssion")
  hyprctl dispatch exit
  ;;
"Kitty")
  kitty
  ;;
"Firefox")
  firefox
  ;;
"Dolphin")
  dolphin
  ;;
"App Launcher")
  if pgrep -x "rofi" >/dev/null; then
    killall rofi
  else
    ~/.config/hypr/scripts/rofilaunch.sh d
  fi
  ;;
*)
  # if command -V "$selected" ; then
  # command "$selected"
  # fi
 echo ~/.config/hypr/scratch/hotkeys.sh
  # exit 1
  ;;
esac