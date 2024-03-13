#!/usr/bin/env bash
#set -x

# read control file and initialize variables

export ScrDir=`dirname "$(realpath "$0")"`
waybar_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
modules_dir="$waybar_dir/modules"
conf_file="$waybar_dir/config.jsonc"
conf_ctl="$waybar_dir/config.ctl"
default_waybar_id="1"

DEBUG=0
debug_log="/tmp/$(basename $0).log"

# module generator function
gen_mod()
{
    local id=$1
    local pos=$2
    local col=$3
    local mod=""
    mod=`grep "^$id|" $conf_ctl | cut -d '|' -f ${col}`
    mod="${mod//(/"custom/l_end"}"
    mod="${mod//)/"custom/r_end"}"
    mod="${mod//[/"custom/sl_end"}"
    mod="${mod//]/"custom/sr_end"}"
    mod="${mod//\{/"custom/rl_end"}"
    mod="${mod//\}/"custom/rr_end"}"
    mod="${mod// /"\",\""}"
    echo -e "\t\"modules-${pos}\": [\"custom/padd\",\"${mod}\",\"custom/padd\"]," >> $conf_file
    write_mod=`echo $write_mod $mod`
}

# Function to create a new screen configuration
create_new_config() {
    local monitors_setup="$1"
    local default_waybar_id="$2"
    local build_setup=""
    local return_models=""

    # Iterate over each monitor
    while read -r monitor; do
        # Extract the model, width, and height
        model=$(echo $monitor | jq -r '.model')
        width=$(echo $monitor | jq -r '.width')
        height=$(echo $monitor | jq -r '.height')

        # Convert the resolution to 1k, 2k, 2.5k, 4k, 8k, etc.
        if (( width >= 7680 ))
        then
            resolution="8K"
        elif (( width >= 3840 ))
        then
            resolution="4K"
        elif (( width >= 2560 ))
        then
            resolution="2.5K"
        elif (( width >= 2048 ))
        then
            resolution="2K"
        elif (( width >= 1280 ))
        then
            resolution="1K"
        else
            resolution="${width}p"
        fi

        # Add the model with resolution to the monitor models string
        if [ "$return_models" = "" ]; then
            return_models="${model} (${resolution})"
        else
            return_models="$return_models, ${model} (${resolution})"
        fi
    done < <(echo "$(hyprctl monitors -j)" | jq -c '.[]')
    # echo "return_models=$return_models"

    local IFS=","
    for monitor in $monitors_setup; do
        local id=${monitor%%=*}
        local value=${monitor#*=}
        # monitor_models=$(get_monitor_models)
        # local monitor_models=$(hyprctl monitors -j | jq -r '.[] | .model' | tr '\n' ',')

        build_setup+="$id=$default_waybar_id|$monitors_setup # $return_models\n" # Append monitorID=default_waybar_id and the monitors_setup to 'build_setup'
    done

    debugPrint "Adding new displays setup to $(basename "$conf_ctl"): $build_setup"

    local found=0  # Flag to track the first '#'

    # Insert 'build_setup' after the first '#' into the configuration file
    awk -v bs="$build_setup" '/^#/ && !found {print; print bs; found=1; next} 1' "${conf_ctl}" > "${ScrDir}/tmp" && mv "${ScrDir}/tmp" "${conf_ctl}"
}

# Find all waybar ids
find_values() {
    # Initialize an empty array
    values=()

    # Read the file line by line
    while IFS= read -r line
    do
        # Check if the line contains exactly 5 separators |
        if [[ $(echo $line | tr -cd '|' | wc -c) -eq 5 ]]; then
        # Extract the first argument (assuming it's before the first |)
        value=$(echo $line | cut -d'|' -f1)
        # Check if the value is a number
        if [[ $value =~ ^[0-9]+$ ]]; then
            # Store the value in the array
            values+=("$value")
        fi
        fi
    done < "$1"

    # Return the array of values
    echo "${values[@]}"
}

debugPrint() {
    if [ "$DEBUG" -eq 1 ]; then
        echo -e "$1" | tee -a "$debug_log"
    fi
}

printHelp() {
    echo "Usage: cmd [no-args|b|-b|--build] [p|-p|--previous] [n|-n|--next] [d|-d|--debug] [h|--help]"
    echo
    echo "Options:"
    echo "  b, -b, --build       Build the waybar configuration"
    echo "  p, -p, --previous    Set the previous waybar configuration"
    echo "  n, -n, --next        Set the next waybar configuration"
    echo "  r, -r, --restart      Restart waybar"
    echo "  h, -h, --help        Display this help message"
    echo "  d, -d, --debug       Enable the 'debug' option and specify the debug log"
    echo
    echo "Only one of the 'build', 'previous', 'next' options can be used at a time."
}

args() {
    required_flag_count=0

    # If no arguments were provided, return immediately
    [ $# -eq 0 ] && return

    while (( "$#" )); do
        case "$1" in
            b|-b|--build)
            ((required_flag_count++))
            shift
            ;;
            p|-p|--previous)
            previous=1
            ((required_flag_count++))
            shift
            ;;
            n|-n|--next)
            next=1
            ((required_flag_count++))
            shift
            ;;
            r|-r|--restart)
            export reload_flag=1
            shift
            ;;
            h|-h|--help)
            printHelp
            exit 0
            ;;
            d|-d|--debug)
            DEBUG=1
            if [ -n "$2" ] && [[ $2 != -* ]]; then
                debug_log="$2"
                shift 2
            else
                shift
            fi
            ;;
            --)
            shift
            break
            ;;
            -*|--*=)
            echo "Invalid Option: $1" 1>&2
            exit 1
            ;;
        esac
    done

    # Check if more than one required flag is provided, or if none was provided
    if [ $required_flag_count -gt 1 ]; then
        printHelp
        exit 1
    fi
}

# Parse options
previous=0
next=0
args "$@"

# Get the list of connected displays in JSON format
connected_outputs=$(hyprctl monitors -j)

# Count the number of monitors by counting the number of 'id' fields in the JSON output
monitor_count=$(echo "$connected_outputs" | jq '.[] | .id' | wc -l)
debugPrint "Monitor Count: $monitor_count"

# Init the current display setup
monitors_setup=""

while read -r monitor_json; do
    # Extract the parameters for the current monitor
    monitor_id=$(echo "$monitor_json" | jq -r '.id')
    monitor_output=$(echo "$monitor_json" | jq -r '.name')
    monitor_model=$(echo "$monitor_json" | jq -r '.model')
    monitor_serial=$(echo "$monitor_json" | jq -r '.serial')
    monitor_description=$(echo "$monitor_json" | jq -r '.description')

    debugPrint "\nMonitor ID: $monitor_id"
    debugPrint "Monitor Output: $monitor_output"
    debugPrint "Monitor Model: $monitor_model"
    debugPrint "Monitor Serial: $monitor_serial"
    debugPrint "Monitor Description: $monitor_description"

    # Add the monitor setup to the monitors_setup variable
    if [ -z "$monitors_setup" ]; then
        monitors_setup="ID$monitor_id=$monitor_serial"
    else
        monitors_setup="$monitors_setup,ID$monitor_id=$monitor_serial"
    fi
done < <(echo "$connected_outputs" | jq -c 'sort_by(.id)[]')

debugPrint "\nMonitors Setup: $monitors_setup"

# Find the corresponding configuration line in the configuration file and extract the first argument
# monitors_conf_ID=$(awk -F'|' -v setup="$monitors_setup" '$2 ~ setup {print $1}' $conf_ctl)
# monitors_conf_ID=$(awk -F'|' -v setup="$monitors_setup" '$2 == setup {print $1}' $conf_ctl)
monitors_conf_ID=$(awk -F'|' -v setup="$monitors_setup" '$2 ~ ("^" setup "[[:space:]]#.*$") {print $1}' $conf_ctl)

# Check if $monitor_conf_ID is found
if [ -z "$monitors_conf_ID" ]; then
    # If the current screen configuration is not found, create a new one
    return_models=""
    create_new_config "$monitors_setup" "$default_waybar_id"

    # Find the corresponding configuration line in the configuration file and extract the first argument
    monitors_conf_ID=$(awk -F'|' -v setup="$monitors_setup" '$2 ~ setup {print $1}' $conf_ctl)
fi

# Check if $monitor_conf_ID is found
if [ -n "$monitors_conf_ID" ]; then

    # initialize variables
    switch=0
    waybar_ids=()

    # Start of config file
    echo "[" > $conf_file

    # Analyze each line in $monitors_conf_ID
    echo "$monitors_conf_ID" | while read line; do
        # Use parameter expansion to remove 'ID' from the beginning of the string
        temp=${line#ID}
        # Split the string on '='
        displayID=${temp%%=*}  # Get the part before '='
        waybarID=${temp#*=}  # Get the part after '='

        # Get the index of the current display
        current_displayID=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .id')

        # update control file to set next/prev mode
        if [ "$previous" -eq 1 ] || [ "$next" -eq 1 ] ; then
            # only if displayID and current displayID matches
            if [ "$current_displayID" = "$displayID" ] ; then
                # Find all waybar ids only if waybar_ids is empty
                if [ -z "$waybar_ids" ]; then
                    waybar_ids=($(find_values $conf_ctl))
                fi
                # Display the values
                debugPrint "\nWaybar IDs: ${waybar_ids[@]}"

                array_length=${#waybar_ids[@]} # Get the length of the array
                waybarID_index=$(echo ${waybar_ids[@]} | tr ' ' '\n' | grep -n -x $waybarID | cut -d':' -f1) # Get the index of the current waybarID in the array

                if [ "$next" -eq 1 ] ; then
                    # Calculate the next index, handling overflow
                    next_index=$(( (waybarID_index % array_length) ))
                    next_id=${waybar_ids[$next_index]}
                    switch=1
                elif [ "$previous" -eq 1 ] ; then
                    # Calculate the previous index, handling underflow
                    next_index=$(( (waybarID_index - 2 + array_length) % array_length ))
                    next_id=${waybar_ids[$next_index]}
                    switch=1
                fi

                if [ $switch -eq 1 ] ; then
                    debugPrint "Set newID $next_id, previous ID: $waybarID into $(basename "$conf_ctl")"

                    # build displays setup
                    old_setup="$displayID=$waybarID|$monitors_setup"
                    new_setup="$displayID=$next_id|$monitors_setup"

                    # Use sed to replace the old setup line with the new one in the file
                    sed -i "s#$old_setup#$new_setup#g" "$conf_ctl"

                    # Apply the new ID
                    switch=0
                    waybarID=$next_id
                    export reload_flag=1
                fi
            fi
        fi

        # export monitor port name
        monitor_json=$(echo "$connected_outputs" | jq -c ".[] | select(.id == ${displayID})")
        monitor_output=$(echo "$monitor_json" | jq -r '.name')
        export display=$monitor_output

        debugPrint "Build waybar config $waybarID on display $displayID port $monitor_output"

        if [ $waybarID -gt 0 ]; then
            # overwrite config from header module

            export set_sysname=`hostnamectl hostname`
            export w_position=`grep "^$waybarID|" $conf_ctl | cut -d '|' -f 3`

            case ${w_position} in
                left) export hv_pos="width" ; export r_deg=90 ;;
                right) export hv_pos="width" ; export r_deg=270 ;;
                *) export hv_pos="height" ; export r_deg=0 ;;
            esac

            waybar_conf_size=$(grep "^$waybarID|" "$conf_ctl" | cut -d '|' -f 2)

            if [ -z "$b_height" ] || [ "$b_height" -gt "$waybar_conf_size" ] ; then
                export b_height="$waybar_conf_size" # pass value to wbarstylegen.sh
            fi

            if [ -z "$w_height" ] || [ "$w_height" -gt "$waybar_conf_size" ] ; then
                export w_height="$waybar_conf_size" # pass value to jsonc modules
            fi

            if [ -z "$w_height" ] ; then
                # y_monres=`cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2`
                y_monres=$(echo "$connected_outputs" | jq -s '.[] | .[] | .height' | sort -n | head -1) # return the height of the smallest monitor
                export w_height=$(( y_monres*2/100 ))
            fi

            export i_size=$(( w_height*6/10 ))
            if [ $i_size -lt 12 ] ; then
                export i_size="12"
            fi

            export i_theme=`gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g"`
            export i_task=$(( w_height*6/10 ))
            if [ $i_task -lt 16 ] ; then
                export i_task="16"
            fi

            envsubst < $modules_dir/header.jsonc >> $conf_file

            # write positions for modules

            echo -e "\n\n// positions generated based on config.ctl //\n" >> $conf_file
            gen_mod "$waybarID" left 4
            gen_mod "$waybarID" center 5
            gen_mod "$waybarID" right 6


            # copy modules/*.jsonc to the config

            echo -e "\n\n// sourced from modules based on config.ctl //\n" >> $conf_file
            echo "$write_mod" | sed 's/","/\n/g ; s/ /\n/g' | awk -F '/' '{print $NF}' | awk -F '#' '{print $1}' | awk '!x[$0]++' | while read mod_cpy
            do
                if [ -f $modules_dir/$mod_cpy.jsonc ] ; then
                    envsubst < $modules_dir/$mod_cpy.jsonc >> $conf_file
                fi
            done


            cat $modules_dir/footer.jsonc >> $conf_file

        fi
    done

    # End of config
    echo "]" >> $conf_file

    # generate style and restart waybar
    debugPrint "\nGenerate style and restart waybar..."
    $ScrDir/wbarstylegen.sh --restart $( [ "$DEBUG" -eq 1 ] && echo "--debug" || echo "" )
fi