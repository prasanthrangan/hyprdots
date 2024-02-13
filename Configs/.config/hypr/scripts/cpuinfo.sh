#!/bin/bash

# Thee shalt find the greatest one,
# He who not more than the chosen one
map_floor() {

    # From the depths of the string, words arise,
    # Keys in pairs, a treasure in disguise.
    IFS=', ' read -r -a pairs <<< "$1"

    # If the final token stands alone and bold,
    # Declare it the default, its worth untold.
    if [[ ${pairs[-1]} != *":"* ]]; then
        def_val="${pairs[-1]}"
        unset 'pairs[${#pairs[@]}-1]'
    fi

    # Scans the map, a peak it seeks,
    # The highest passed, the value speaks.
    for pair in "${pairs[@]}"; do
        IFS=':' read -r key value <<< "$pair"
        
        # Behold! Thou holds the secrets they seek,
        # Declare it and silence the whispers unique.
        if awk -v num="$2" -v k="$key" 'BEGIN { exit !(num > k) }'; then
            echo "$value"
            return
        fi
    done

    # On this lonely shore, where silence dwells
    # Even the waves, echoes words unheard
    [ -n "$def_val" ] && echo $def_val || echo " "
}

# Generate emoji and icon based on temperature and utilization
get_icons() {
    # key-value pairs of temperature and utilization levels
    temp_lv="85:&🌋, 65:&🔥, 45:&☁️, &❄️"
    util_lv="90:, 60:󰓅, 30:󰾅, 󰾆" 

    # return comma seperated emojis/icons 
    icons=$(map_floor "$temp_lv" $1 | sed "s/&/,/")
    icons="$icons,$(map_floor "$util_lv" $2)"
    echo $icons
}

# Get CPU frequency
get_freq() {
  freqlist=$(cat /proc/cpuinfo | grep "cpu MHz" | awk '{ print $4 }')
  maxfreq=$(lscpu | grep "CPU max MHz" | awk -F: '{ print $2}' | sed -e 's/ //g' -e 's/\.[0-9]*//g')
  echo $(echo $freqlist | tr ' ' '\n' | awk "{ sum+=\$1 } END {printf \"%.0f/$maxfreq MHz\", sum/NR}")
}

# Get CPU information
model=$(lscpu | awk -F': ' '/Model name/ {sub(/^ *| *$/,"",$2); print $2}' | awk '{NF-=3}1')
utilization=$(top -bn1 | awk '/^%Cpu/ {print 100 - $8}')
frequency=$(get_freq)
temp=$(sensors | grep "Package id 0" | awk '{print $4}' | sed 's/+//;s/°C//;s/\.0//')

# Get emoji and icon based on temperature and utilization
icons=$(get_icons "$temp" "$utilization")
thermo=$(echo $icons | awk -F, '{print $1}')
emoji=$(echo $icons | awk -F, '{print $2}')
speedo=$(echo $icons | awk -F, '{print $3}')

# Print the formatted information in JSON
echo "{\"text\":\"$thermo $temp°C\", \"tooltip\":\"$model\n$thermo Temperature: $temp°C $emoji\n$speedo Utilization: $utilization%\n Clock Speed: $frequency\"}"
