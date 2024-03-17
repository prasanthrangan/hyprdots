#!/bin/bash
# set -x

# read control file and initialize variables

export ScrDir=`dirname "$(realpath "$0")"`

DEBUG=0
monitor=""
enable=0
disable=0
reload_flag=0
debug_log="/tmp/$(basename $0).log"
monitors_conf="$HOME/.config/hypr/configs/monitors.conf"

function debugPrint() {
    if [ "$DEBUG" -eq 1 ]; then
        echo -e "$1" | tee -a "$debug_log"
    fi
}

function usage() {
    echo "Usage: $(basename $0) [OPTIONS]"
    echo "Options:"
    echo "  a|-a|--enable-all         Enable all monitors"
    echo "  e|-e|--enable [ID|PORT]   Enable the monitor by ID or port"
    echo "  d|-d|--disable [ID|PORT]  Disable the monitor by ID or port"
    echo "  c|-c|--disable-current    Disable the current monitor"
    echo
    echo "  -h|--help                 Display this help"
    echo "  --debug                   Enable debug mode"
    exit 1
}

function wait_for_monitor() {
    local _monitor="$1"
    local _state="$2"
    local wait_time=0
    while true; do
        monitor_in_json=$(hyprctl monitors all -j | jq -r ".[] | select(.id == \"$_monitor\" or .name == \"$_monitor\") | .name")
        if [ "$_state" = "enabled" ]; then
            [ ! -z "$monitor_in_json" ] || [ "$wait_time" -ge 5 ] && break
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
                notify-send -a "t1" -i "$HOME/.config/dunst/icons/displays.jpeg" "Turn on display" "$name"
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
                notify-send -a "t1" -i "$HOME/.config/dunst/icons/displays.jpeg" "Turn on display" "$name"
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
        notify-send -a "t1" -i "$HOME/.config/dunst/icons/displays.jpeg" "Turn off display" "$name"
    done < <(hyprctl monitors -j | jq -r ".[] | select(.id == \"$_monitor\" or .name == \"$_monitor\") | .name")
}


if [ $# -eq 0 ]; then
    usage
fi

while [ "$1" != "" ]; do
    case $1 in
        a|-a|--all|--enable-all )
                                monitor="all"
                                enable=1
                                ;;
        e|-e|--enable )           shift
                                monitor="$1"
                                enable=1
                                ;;
        d|-d|--disable )          shift
                                monitor="$1"
                                disable=1
                                ;;
        c|-c|--disable-current )
                                monitor="$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .name')"
                                disable=1
                                ;;
        --debug )
                                DEBUG=1
                                ;;
        -h|--help )             usage
                                ;;
        * )                     usage
    esac
    shift
done

if [ "$enable" -eq 1 ]; then
    enable "$monitor"
fi
if [ "$disable" -eq 1 ]; then
    disable "$monitor"
fi

if [ "$reload_flag" -eq 1 ]; then
    sleep 1 && $ScrDir/wbarconfgen.sh --restart $( [ "$DEBUG" -eq 1 ] && echo "--debug" || echo "" )
    debugPrint "Reloaded waybar config..."
else
    debugPrint "No changes made. Exiting..."
    notify-send -a "t1" -i "$HOME/.config/dunst/icons/displays.jpeg" "No display changes made..."
fi
