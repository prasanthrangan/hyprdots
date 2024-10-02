#!/bin/env bash
#----- Optimized bars animation without much CPU usage increase --------
#----- Optimized bars animation without much CPU usage increase pt2 --------

scrDir=$(dirname "$(realpath "$0")")
# shellcheck source=/dev/null
. "${scrDir}/globalcontrol.sh"
usage() {
    cat <<HELP
Usage: $(basename "$0") [OPTIONS]

Options:
  --bar <waybar_cava_bar>  Specify the characters to use for the bar animation (default: ▁▂▃▄▅▆▇█).
  --width <waybar_cava_width>     Specify the width of the bar.
  --range <waybar_cava_range>     Specify the range of the bar.
  --help                  Display this help message and exit.
  --restart               Restart the waybar_cava.
  --mode <waybar_cava_stbmode>   Specify the standby mode for waybar cava (default: 0).
HELP
    exit 1
}

# Parse command line arguments using getopt
if ! ARGS=$(getopt -o "hr" -l "help,bar:,width:,range:,restart,mode:" -n "$0" -- "$@"); then
    usage
fi

eval set -- "$ARGS"
while true; do
    case "$1" in
    --help | -h)
        usage
        ;;
    --bar)
        waybar_cava_bar="$2"
        shift 2
        ;;
    --width)
        waybar_cava_width="$2"
        shift 2
        ;;
    --range)
        waybar_cava_range="$2"
        shift 2
        ;;
    --restart) # restart the waybar_cava
        pkill -f "cava -p /tmp/bar_cava_config"
        exit 0
        ;;
    --mode)
        waybar_cava_stbmode="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        usage
        ;;
    esac
done

bar="${waybar_cava_bar:-▁▂▃▄▅▆▇█}"
dict="s/;//g"

# Calculate the length of the bar outside the loop
bar_length=${#bar}
bar_width=${waybar_cava_width:-${bar_length}}
bar_range=${waybar_cava_range:-$((bar_length - 1))}

standby_mode=${waybar_cava_stbmode:-0} # 0:clean, 1:blank, 2:full,3:last
if [ "${standby_mode}" -le 0 ]; then unset standby_bar; fi
# Create dictionary to replace char with bar
i=0
while [ $i -lt "${bar_length}" ] || [ $i -lt "${bar_width}" ]; do
    if [ $i -lt "${bar_length}" ]; then
        dict="$dict;s/$i/${bar:$i:1}/g"
    fi
    if [ $i -lt "${bar_width}" ] && [ "${standby_mode}" -gt 0 ]; then
        if [ "${standby_mode}" -eq 2 ]; then
            standby_bar="$standby_bar${bar:$i:1}"
        elif [ "${standby_mode}" -eq 1 ]; then
            standby_bar="$standby_bar "
        fi
    fi
    ((i++))
done

# Create cava config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = ${bar_width}
sleep_timer = 1

[input]
method = pulse
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = ${bar_range}
EOF

listen_to_cava() {
    echo ""
    while IFS= read -r line; do
        if grep -qE "^0;(0;)*$" <<<"$line" && [ "${standby_mode}" -ne 3 ]; then echo "${standby_bar}" && continue; fi
        sed -u "$dict" <<<"${line}"
    done < <(cava -p "$config_file")
}

# Call the function
listen_to_cava &
disown # saves a tiny bit of memory
