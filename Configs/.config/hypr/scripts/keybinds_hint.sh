#!/usr/bin/env sh

pkill -x rofi && exit
ConfDir="${XDG_CONFIG_HOME:-$HOME/.config}"
keyConfDir="$ConfDir/hypr"
keyConf="$keyConfDir/hyprland.conf $keyConfDir/keybindings.conf $keyConfDir/userprefs.conf  $*"
tmpMapDir="/tmp"
tmpMap="$tmpMapDir/hyprdots-keybinds.jq"

. $HOME/.config/hypr/scripts/globalcontrol.sh
roDir="$ConfDir/rofi"
roconf="$roDir/Keybinds_Hint.rasi"

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

 keyVars="$(grep -h '^ *\$' $keyConf | awk -F ' = ' '{gsub(/^ *\$| *$/, "", $1); gsub(/^ *| *$/, "", $2); print $1 "='\''"$2"'\''"}')"
keyVars+="
"
keyVars+="HOME=$HOME"
#  echo "$keyVars"

substitute_vars() {
  local s="$1"
  local IFS=$'\n'
  for var in $keyVars; do
    varName="${var%%=*}"
    varValue="${var#*=}"
    varValue="${varValue#\'}"
    varValue="${varValue%\'}"
    s="${s//\$$varName/$varValue}"
  done
  IFS=$' \t\n'
  echo "$s"
}
#? Other accurate but risky option
#  eval "$keyVars"
# substitute_vars() {
#   local s="$1"
#   local IFS=$'\n'
#   for var in $keyVars; do
#     varName="${var%%=*}"
#     s="${s//\$$varName/${!varName}}"
#   done
#   IFS=$' \t\n'
#   echo "$s"
# }



# scrPath='~/.config/hypr/scripts'
# comments=$(awk -v scrPath="$scrPath" -F ',' '!/^#/ && /bind*/ && $3 ~ /exec/ && NF && $4 !~ /^ *$/ {gsub(/\$scrPath/, scrPath, $4); print $4}' $keyConf | sed "s#\"#'#g" )
  comments=$(awk  -F ',' '!/^#/ && /bind*/ && $3 ~ /exec/ && NF && $4 !~ /^ *$/ { print $4}' $keyConf | sed "s#\"#'#g" )
  comments=$(substitute_vars "$comments" | awk -F'#' '{gsub(/^ */, "", $1); gsub(/ *$/, "", $1); split($2, a, " "); a[1] = toupper(substr(a[1], 1, 1)) substr(a[1], 2); $2 = a[1]; for(i=2; i<=length(a); i++) $2 = $2" "a[i]; gsub(/^ */, "", $2); gsub(/ *$/, "", $2); if (length($1) > 0) print "\""$1"\" : \""(length($2) > 0 ? $2 : $1)"\","}'|
  awk '!seen[$0]++')
  # echo "$comments"
#  exit
cat << EOF > $tmpMap
# hyprdots-keybinds.jq
def executables_mapping: {  #? Derived from .args to parse scripts to be Readable
#? Auto Generated Comment Conversion
$comments
#? Defaults
" empty " :  "Empty",
"r+1" : "Relative Right",
"r-1" : "Relative Left",
"e+1" : "Next",
"e-1" : "Previous",
"movewindow" : "Move window",
"resizewindow" : "Resize window",
"d" : "Down",
"l" : "Left",
"r" : "Right",
"u" : "Up",
};
EOF

#? Script to re Modify hyprctl json output
#! This is Our Translator for some binds  #Khing!
jsonData="$(hyprctl binds -j | jq -L "$tmpMapDir" -c '
include "hyprdots-keybinds";

  def modmask_mapping: { #? Define mapping for modmask numbers represents bitmask
    "64": " ",  #? SUPER  󰻀
#    "32" : "ERROR:32",  #* Dont know
#    "16": "Err:16",      #* Dont know
    "8": "ALT", 
    "4": "CTRL", 
#!    "2":  "SHIFT",  # Wrong dunno yet
    "1": "SHIFT",
    "0": " ",
  };
  def key_mapping: { #?Define mappings for .keys to be readable symbols
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
    "switch:on:Lid Switch" : "󰛧",
    "backspace" : "󰁮"
  };
  def category_mapping: { #? Define Category Names, derive from Dispatcher
    "exec" : "Execute a Command:",
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
def arg_mapping: { #! Do not Change this used for Demo only... As this will change .args! will be fatal
    "arg2": "mapped_arg2",
  };

    def description_mapping: {  #? Derived from dispatcher and Gives Description for Dispatchers; Basically translates dispatcher.
    "movefocus": "Move Focus",
    "resizeactive": "Resize Active Floting Window",
    "exit" : "End Hyprland Session",
    "movetoworkspacesilent" : "Silently Move to Workspace",
    "movewindow" : "Move Window",
    "exec" : "" , #? Remove exec as execuatable will give the Description from separate function
    "movetoworkspace" : "Move To Workspace:",
    "workspace" : "Navigate to Workspace:",
    "togglefloating" : "Toggle Floating",
    "fullscreen" : "Toggle Fullscreen",
    "togglegroup" : "Toggle Group",
    "togglesplit" : "Toggle Split",
    "togglespecialworkspace" : "Toggle Special Workspace",
    "mouse" : "Use Mouse"

  };

  def get_keys: #? Funtions to Convert modmask into Keys, There should be a beter math for this but Im lazy
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
 #!    .executables |= gsub(".sh"; "") | #? Usefull soon

  .executables |= (executables_mapping[.] // .) | 
  .description |= (description_mapping[.] // .)    
 
' #? <---- There is a '   do not delete this'
)"

#? Now we have the metadata we can Group it accordingly
GROUP() { 
  awk -F '!=!' '
  {
    category = $1
    binds[category] = binds[category] ? binds[category] "\n" $0 : $0
  }

  END {
    n = asorti(binds, b)
    for (i = 1; i <= n; i++) {
      print b[i]  # Print the header name
      gsub(/\[.*\] =/, "", b[i])
      split(binds[b[i]], lines, "\n")
      for (j in lines) {
        line = substr(lines[j], index(lines[j], "=") + 2)
        print line
      }
      for (j = 1; j <= 68; j++) printf "━"
      printf "\n"
    }
  }'
}

#? Here we we format the output into a desirable format we want.
DISPLAY() { awk -F '!=!' '{if ($0 ~ /=/ && $6 != "") printf "%-25s    >  %-30s\n", $5, $6; else if ($0 ~ /=/) printf "%-25s\n", $5; else print $0}' ;}

#? Extra design use for distiction
header="$(printf "%-35s %-1s %-20s\n" "󰌌 Keybinds" "󱧣" "Description")"
line="$(printf '%.0s━' $(seq 1 68) "")"


# echo "$jsonData"
metaData="$(echo "$jsonData"  |  jq -r '"\(.category) !=! \(.modmask) !=! \(.key) !=! \(.dispatcher) !=! \(.arg) !=! \(.keybind) !=! \(.description) \(.executables) !=! \(.flags)"' | tr -s ' ' | sort -k 1 )" #! this Part Gives extra laoding time as I don't have efforts to make all spaces on each class only 1
#  echo "$metaData"

display="$(echo "$metaData" | GROUP | DISPLAY )"

# output=$(echo -e "${header}\n${line}\n${primMenu}\n${line}\n${display}")
output=$(echo -e "${header}\n${line}\n${display}")

#? will display on the terminal if rofi is not found
if ! command -v rofi &> /dev/null
then
    echo "$output"
    echo "rofi not detected. Displaying on terminal instead"
    exit 0
fi

#? Actions to do when selected
selected=$(echo  "$output" | rofi -dmenu -p -i -theme-str "${fnt_override}" -theme-str "${r_override}" -theme-str "${icon_override}" -config "${roconf}" | sed 's/.*\s*//')
if [ -z "$selected" ]; then exit 0; fi

sel_1=$(echo "$selected" | cut -d '>' -f 1 | awk '{$1=$1};1')
sel_2=$(echo "$selected" | cut -d '>' -f 2 | awk '{$1=$1};1')
run="$(echo "$metaData" | grep "$sel_1" | grep "$sel_2" )"

run_flg="$(echo "$run" | awk -F '!=!' '{print $8}')"
run_sel="$(echo "$run" | awk -F '!=!' '{gsub(/^ *| *$/, "", $5); if ($5 ~ /[[:space:]]/ && $5 !~ /^[0-9]+$/ && substr($5, 1, 1) != "-") print $4, "\""$5"\""; else print $4, $5}')"
#   echo "$run_sel" ; echo "$run_flg"

#? 
RUN() { case "$(eval "hyprctl dispatch $run_sel")" in *"Not enough arguments"*) exec $0 ;; esac }

#? If flag is repeat then repeat rofi if not then just execute once
if [ -n "$run_sel" ] && [ "$(echo "$run_sel" | wc -l)" -eq 1 ]; then
    eval "$run_flg"
    if [ "$repeat" = true ]; then

while true; do
    repeat_command=$(echo -e "Repeat" | rofi -dmenu -no-custom -p "[Enter] repeat; [ESC] exit") #? Needed a separate Rasi ? Dunno how to make; Maybe Something like comfirmation rasi for buttons Yes and No then the -p will be the Question like Proceed? Repeat? 

    if [ "$repeat_command" = "Repeat" ]; then
        # Repeat the command here
        RUN
    else
        exit 0
    fi
done
    else RUN
    fi
else  exec $0 
fi
