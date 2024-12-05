#!/usr/bin/env bash
# set -x

# read control file and initialize variables

declare ScrDir && ScrDir=$(dirname "$(realpath "$0")")

DEBUG=0
debug_option=""
monitor=""

mode="" # mode: enable disable only_current
reload_flag=0

basename="$(basename "$0")"
debug_log="/tmp/$basename.log"
dunst_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dunst"
hypr_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
monitors_conf=$(find "$hypr_dir" -name "monitors.conf" -print -quit)

function debugPrint() {
    if [ "$DEBUG" -eq 1 ]; then
        echo -e "$1" | tee -a "$debug_log"
    fi
}

function usage() {
    echo "Usage: $basename [OPTIONS]"
    echo "Options:"
    echo "  a|-a|--enable-all ------------- Enable all monitors"
    echo "  e|-e|--enable [ID|PORT] ------- Enable the monitor by ID or port"
    echo "  d|-d|--disable [ID|PORT] ------ Disable the monitor by ID or port"
    echo "  c|-c|--disable-current -------- Disable the current monitor"
    echo "  x|-x|--disable-except-current - Disable all monitors except the current one"
    echo
    echo "  -h|--help --------------------- Display this help"
    echo "  --debug ----------------------- Enable debug mode"
    exit 1
}

function wait_for_monitor() {
    local _monitor="$1"
    local _state="$2"
    local wait_time=0
    while true; do
        monitor_in_json=$(hyprctl monitors all -j | jq -r ".[] | select(.id == \"$_monitor\" or .name == \"$_monitor\") | .name")
        if [ "$_state" = "enabled" ]; then
            [ -n "$monitor_in_json" ] || [ "$wait_time" -ge 5 ] && break
        else
            [ -z "$monitor_in_json" ] || [ "$wait_time" -ge 5 ] && break
        fi
        sleep 1
        wait_time=$((wait_time+1))
    done
}

function enable() {
    local _monitor="$1"

    if [ "$_monitor" == "all" ]; then
        debugPrint "Enabling all monitors..."
        while read -r name; do
            if grep -q "monitor=$name,disable" "$monitors_conf"; then
                debugPrint "Enabling monitor $name"
                sed -i "/monitor=$name,disable/d" "$monitors_conf"
                reload_flag=1
                wait_for_monitor "$name" "enabled"
                notify-send -a "t1" -i "$dunst_dir/icons/displays.jpeg" "Turn on display" "$name"
            fi
        done < <(hyprctl monitors all -j | jq -r '.[] | .name')
    else
        debugPrint "Enabling monitor $1..."
        while read -r name; do
            if grep -q "monitor=$name,disable" "$monitors_conf"; then    
                debugPrint "Enabling monitor $name"
                sed -i "/monitor=$name,disable/d" "$monitors_conf"
                reload_flag=1
                wait_for_monitor "$name" "enabled"
                notify-send -a "t1" -i "$dunst_dir/icons/displays.jpeg" "Turn on display" "$name"
            fi
        done < <(hyprctl monitors all -j | jq -r ".[] | select(.id == \"$_monitor\" or .name == \"$_monitor\") | .name")
    fi
}

function disable() {
    local _monitor="$1"
    debugPrint "Disabling monitor..."
    enabled_count=$(hyprctl monitors -j | jq '.[] | .id' | wc -l)
    
    if [ "$enabled_count" -le 1 ]; then
        debugPrint "Cannot disable all monitors. At least one monitor must remain enabled."
        return
    fi
    while read -r name; do
        debugPrint "Disabling monitor $name"
        echo "monitor=$name,disable" >> "$monitors_conf"
        reload_flag=1
        wait_for_monitor "$name" "disabled"
        notify-send -a "t1" -i "$dunst_dir/icons/displays.jpeg" "Turn off display" "$name"
    done < <(hyprctl monitors -j | jq -r ".[] | select(.id == \"$_monitor\" or .name == \"$_monitor\") | .name")
}

function disable_all_except_current() {
    local _current_monitor="$1"
    debugPrint "Disabling all monitors except the current one..."
    declare -a names
    while read -r name; do
        if [ "$name" != "$_current_monitor" ]; then
            debugPrint "Disabling monitor $name"
            echo "monitor=$name,disable" >> "$monitors_conf"
            reload_flag=1
            names+=("$name")
            notify-send -a "t1" -i "$dunst_dir/icons/displays.jpeg" "Turn off display" "$name"
        fi
    done < <(hyprctl monitors -j | jq -r '.[] | .name')

    for name in "${names[@]}"; do
        wait_for_monitor "$name" "disabled"
    done
}

# help message
if [ $# -eq 0 ]; then
    usage
fi

while [ "$1" != "" ]; do
    case $1 in
        a|-a|--all|--enable-all )
                                monitor="all"
                                mode="enable"
                                ;;
        e|-e|--enable )           shift
                                monitor="$1"
                                mode="enable"
                                ;;
        d|-d|--disable )          shift
                                monitor="$1"
                                mode="disable"
                                ;;
        c|-c|--disable-current )
                                monitor="$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .name')"
                                mode="disable"
                                ;;
        x|-x|--disable-except-current )
                                monitor="$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .name')"
                                mode="only_current"
                                ;;
        --debug )
                                DEBUG=1
                                debug_option="--debug"
                                ;;
        -h|--help )             usage
                                ;;
        * )                     usage
    esac
    shift
done

# Exit if lock file exists or mode is the same
content=$(cat "/tmp/$basename.prelock")
if [ -f "/tmp/$basename.lock" ] || [ "$content" == "$mode" ]; then
    debugPrint "Lock file already exists. exiting..."
    exit 0
fi

# Prelock on first run to check if running by double click (wait 1s)
if [ ! -f "/tmp/$basename.prelock" ]; then
    echo $mode > "/tmp/$basename.prelock"
    sleep 1
    if [ -f "/tmp/$basename.lock" ]; then
        debugPrint "Second click detected. exiting..."
        exit 0
    fi
fi
touch "/tmp/$basename.lock"

# Run command mode
if [ "$mode" == "enable" ]; then
    enable "$monitor"
elif [ "$mode" == "disable" ]; then
    disable "$monitor"
elif [ "$mode" == "only_current" ]; then
    disable_all_except_current "$monitor"
fi

# Reload waybar
if [ "$reload_flag" -eq 1 ]; then
    sleep 1 && "${ScrDir}/wbarconfgen.sh" --restart $debug_option
    debugPrint "Reloaded waybar config..."
else
    debugPrint "No changes made. Exiting..."
    notify-send -a "t1" -i "$dunst_dir/icons/displays.jpeg" "No display changes made... ($mode $monitor)"
fi

rm "/tmp/$basename.prelock" > /dev/null 2>&1
rm "/tmp/$basename.lock" > /dev/null 2>&1
