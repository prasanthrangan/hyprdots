#!/bin/bash

get_icons() {
    
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
            if [ ${2%%.*} -gt $key ]; then
                echo "$value"
                return
            fi
        done

        # On this lonely shore, where silence dwells
        # Even the waves, echoes words unheard
        [ -n "$def_val" ] && echo $def_val || echo " "
    }

    temp_lv="85:🌋, 65:🔥, 45:☁️, ❄️"
    util_lv="90:, 60:󰓅, 30:󰾅, 󰾆" 

    echo "$(map_floor "$util_lv" $2)$(map_floor "$temp_lv" $1)"
}

# Get static CPU information
model=$(lscpu | awk -F': ' '/Model name/ {gsub(/^ *| *$| CPU.*/,"",$2); print $2}')
maxfreq=$(lscpu | awk '/CPU max MHz/ { sub(/\..*/,"",$4); print $4}')

# Get CPU stat
statFile=$(cat /proc/stat | head -1)
prevStat=$(awk '{print $2+$3+$4+$6+$7+$8 }' <<< $statFile)
prevIdle=$(awk '{print $5 }' <<< $statFile)

while true; do
    # Get CPU stat
    statFile=$(cat /proc/stat | head -1)
    currStat=$(awk '{print $2+$3+$4+$6+$7+$8 }' <<< $statFile)
    currIdle=$(awk '{print $5 }' <<< $statFile)
    diffStat=$((currStat-prevStat))
    diffIdle=$((currIdle-prevIdle))

    # Get dynamic CPU information
    utilization=$(awk -v stat="$diffStat" -v idle="$diffIdle" 'BEGIN {printf "%.1f", (stat/(stat+idle))*100}')
    temperature=$(sensors | awk -F': ' '/Package id 0|Tctl/ { gsub(/^ *\+?|\..*/,"",$2); print $2; f=1; exit} END { if (!f) print "N/A"; }')
    frequency=$(cat /proc/cpuinfo | awk '/cpu MHz/{ sum+=$4; c+=1 } END { printf "%.0f", sum/c }')

    # Generate glyphs
    icons=$(get_icons "$temperature" "$utilization")
    speedo=$(echo ${icons:0:1})
    thermo=$(echo ${icons:1:1})
    emoji=$(echo ${icons:2})

    # Print the output
    echo "{\"text\":\"$thermo $temperature°C\", \"tooltip\":\"$model\n$thermo Temperature: $temperature°C $emoji\n$speedo Utilization: $utilization%\n Clock Speed: $frequency/$maxfreq MHz\"}"

    # Store state and sleep
    prevStat=$currStat
    prevIdle=$currIdle
    sleep 5
done
