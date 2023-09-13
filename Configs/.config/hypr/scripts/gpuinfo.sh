#!/bin/bash

# Get the GPU temperature using nvidia-smi
gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits)

# Split the comma-separated values into an array
IFS=',' read -ra gpu_data <<< "$gpu_info"

# Extract individual values
temperature="${gpu_data[0]// /}"
utilization="${gpu_data[1]// /}"
current_clock_speed="${gpu_data[2]// /}"
max_clock_speed="${gpu_data[3]// /}"
power_usage="${gpu_data[4]// /}"
power_limit="${gpu_data[5]// /}"

# Print the formatted information
text="󰈸 $temperature°C\n\
󰾆 $utilization%\n\
 $current_clock_speed/$max_clock_speed Mhz\n\
 $power_usage/$power_limit W"

#echo "$temperature°C"
echo "{\"text\":\"$temperature°C\", \"tooltip\":\"$text\"}"
