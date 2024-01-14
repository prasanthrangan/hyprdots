#!/bin/bash

gpuQ="/tmp/hyprdots-gpuinfo-query$2"
tired=false
if [[ " $* " =~ " --tired " ]];then tired=true ; fi
if [[ " $* " =~ " --start " ]]; then
   gpuQ="/tmp/hyprdots-gpuinfo-query"
fi
query() { 
 nvidia_flag=0 amd_flag=0 intel_flag=0
touch "$gpuQ"
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)
# intel_gpu=$(lspci -nn | grep -i "VGA compatible controller" | grep -i "Intel Corporation" | awk -F' ' '{print $1}')
intel_gpu=$(lspci | grep -E "VGA compatible controller.*Intel Corporation" | awk -F'Intel Corporation ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')
if lsmod | grep -q 'nouveau'; then 
      echo "nvidia_gpu=\"Linux\"" >> "$gpuQ" #? Incase If nouveau is installed 
      echo "nvidia_flag=1 # Using nouveau an open-source nvidia driver" >> "$gpuQ"
elif [ -n "$nvidia_gpu" ] ; then  # Check for NVIDIA GPU
    if  [[ "$nvidia_gpu" == *"NVIDIA-SMI has failed"* ]]; then  #? Second Layer for dGPU 
    echo "nvidia_flag=0 # NVIDIA-SMI has failed" >> "$gpuQ"
    else
echo "nvidia_gpu=\"${nvidia_gpu/NVIDIA /}\"" >> "$gpuQ"

    echo "nvidia_flag=1" >> "$gpuQ"
    fi
fi

if lspci | grep -E "(VGA|3D)" | grep -iq "Advanced Micro Devices"; then
   echo "amd_flag=1" >> "$gpuQ"
fi

if [ -n "$intel_gpu" ]; then echo "intel_flag=1" >> "$gpuQ" # Check for Intel GPU
echo "intel_gpu=\"$intel_gpu\"" >> "$gpuQ" ; fi
}

toggle() {
  if [ -n "$1" ]; then
      curr_prioGPU="$1_flag"
  else
    # Initialize gpu_flags and prioGPU if they don't exist
    if ! grep -q "gpu_flags=" "$gpuQ"; then
        gpu_flags=$(grep "flag=1" "$gpuQ" | cut -d '=' -f 1 | tr '\n' ' ')
        echo "" >> "$gpuQ"
        echo "gpu_flags=\"${gpu_flags[*]}\"" >> "$gpuQ"
    fi

    if ! grep -q "prioGPU=" "$gpuQ"; then
        gpu_flags=$(grep "gpu_flags=" /tmp/hyprdots-gpuinfo-query  | cut -d'=' -f 2)
            initGPU=$(echo "$gpu_flags" | cut -d ' ' -f  1)
        echo "prioGPU=$initGPU" >> "$gpuQ"
    fi
    IFS=' ' read -ra gpu_flags <<< "$(grep "flag=1" "$gpuQ" | cut -d '=' -f 1)"# Get the list of gpu_flags from the file
    prioGPU=$(grep "prioGPU=" "$gpuQ" | cut -d'=' -f 2)    # Get the current prioGPU from the file
    # Find the index of the current prioGPU in the gpu_flags array
    for index in "${!gpu_flags[@]}"; do
        if [[ "${gpu_flags[$index]}" = "${prioGPU}" ]]; then
            current_index=$index
        fi
    done
    next_index=$(( (current_index + 1) % ${#gpu_flags[@]} ))
    curr_prioGPU=${gpu_flags[$next_index]#\#}
fi

# Set the next prioGPU and remove the '#' character
sed -i 's/^\(nvidia_flag=1\|amd_flag=1\|intel_flag=1\)/#\1/' "$gpuQ" # Comment out all the gpu flags in the file
sed -i "s/^#$curr_prioGPU/$curr_prioGPU/" "$gpuQ" # Uncomment the next prioGPU in the file
sed -i "s/prioGPU=$prioGPU/prioGPU=$curr_prioGPU/" "$gpuQ" # Update the prioGPU in the file
}

get_temperature_emoji() { # Function to define emoji based on temperature
  local temperature="$1"
  if [ "$temperature" -lt 60 ]; then
    echo ""  # Ice emoji for less than 60°C
  else
    echo "󰈸"  # Fire emoji for 60°C or higher
  fi
}

generate_json() {
  emoji=$(get_temperature_emoji "$temperature")
  local json="{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C"
#? Soon Add Something incase needed.
  declare -A tooltip_parts
  if [ -n "$utilization" ]; then tooltip_parts["\n󰾆 Utilization: "]="$utilization%" ; fi
  if [ -n "$current_clock_speed" ] && [ -n "$max_clock_speed" ]; then tooltip_parts["\n Clock Speed: "]="$current_clock_speed/$max_clock_speed MHz" ; fi
  if [ -n "$gpu_load" ]; then tooltip_parts["\n󰾆 Utilization: "]="$gpu_load%" ; fi
  if [ -n "$core_clock" ]; then tooltip_parts["\n Clock Speed: "]="$core_clock MHz" ;fi
  if [ -n "$power_usage" ]; then if [ -n "$power_limit" ]; then
                                    tooltip_parts["\n Power Usage: "]="$power_usage/$power_limit W"
                                  else
                                    tooltip_parts["\n Power Usage: "]="$power_usage W"
                                  fi
  fi
  if [ -n "$power_discharge" ] && [ "$power_discharge" != "0" ]; then tooltip_parts["\n Power Discharge: "]="$power_discharge W" ;fi

  for key in "${!tooltip_parts[@]}"; do
    local value="${tooltip_parts[$key]}"
    if [[ -n "$value" && "$value" =~ [a-zA-Z0-9] ]]; then
      json+="$key$value"
    fi
  done
  json="$json\"}"
  echo "$json"
}

general_query() { # Function to get temperature from 'sensors'
	filter=''	
temperature=$(sensors | $filter grep -E "(Package id.*|edge|another keyword)" | awk -F ':' '{print int($2)}')
  # gpu_load=$()
  # core_clock=$()
for file in /sys/class/power_supply/BAT*/power_now; do
    [ -f "$file" ] && power_discharge=$(awk '{print $1*10^-6 ""}' "$file") && break
done
[ -z "$power_discharge" ] && for file in /sys/class/power_supply/BAT*/current_now; do
    [ -f "$file" ] && power_discharge=$(awk -v current="$(cat "$file")" -v voltage="$(cat "${file/current_now/voltage_now}")" 'BEGIN {print (current * voltage) / 10^12 ""}') && break
done
# power_limit=$()
utilization=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1" "}')
current_clock_speed=$(awk '{sum += $1; n++} END {if (n > 0) print sum / n / 1000 ""}' /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq)
max_clock_speed=$(awk '{print $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
}

intel_GPU() {
    # Not foundCheck for Intel GPU
    primary_gpu="INTEL $intel_gpu"
    general_query
}

nvidia_GPU() {
    primary_gpu="NVIDIA $nvidia_gpu"

  if [ "$nvidia_gpu" == "Linux" ]; then general_query ; return ; fi #? Open source driver
if $tired && [ "$(cat /sys/bus/pci/devices/0000:"$(lspci | grep -i nvidia | cut -d' ' -f1)"/power/runtime_status)" == "suspend" ];then
printf '{"text":"󰤂", "tooltip":"%s\n ⏾ Suspended mode"}\n' "$primary_gpu"; exit ;fi
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.max_limit --format=csv,noheader,nounits)
  # Split the comma-separated values into an array
  IFS=',' read -ra gpu_data <<< "$gpu_info"
  # Extract individual values
  temperature="${gpu_data[0]// /}"
  utilization="${gpu_data[1]// /}"
  current_clock_speed="${gpu_data[2]// /}"
  max_clock_speed="${gpu_data[3]// /}"
  power_usage="${gpu_data[4]// /}"
  power_limit="${gpu_data[5]// /}"
}

amd_GPU() {
  primary_gpu="AMD"
    # Execute the AMD GPU Python script and use its output
  amd_output=$(python3 ~/.config/hypr/scripts/amdgpu.py)
if [[ ! $amd_output == *"No AMD GPUs detected."* ]] && [[ ! $amd_output == *"Unknown query failure"* ]]; then #! This will be changed if "(python3 ~/.config/hypr/scripts/amdgpu.py)" Changes!
  # Extract GPU Temperature, GPU Load, GPU Core Clock, and GPU Power Usage from amd_output
  temperature=$(echo "$amd_output" | jq -r '.["GPU Temperature"]' | sed 's/°C//')
  gpu_load=$(echo "$amd_output" | jq -r '.["GPU Load"]' | sed 's/%//')
  core_clock=$(echo "$amd_output" | jq -r '.["GPU Core Clock"]' | sed 's/ GHz//;s/ MHz//')
  power_usage=$(echo "$amd_output" | jq -r '.["GPU Power Usage"]' | sed 's/ Watts//')

# elif  #? Can add another Layer of query if "~/.config/hypr/scripts/amdgpu.py" fails

else
general_query
fi
}

if [ -f "$gpuQ" ]; then  eval "$(cat "$gpuQ")"
else query ; echo -e "Initialized Variable:\n$(cat "$gpuQ")\n\nReboot or rm /tmp/hyprdots-gpuinfo-query to RESET Variables"
fi

case "$1" in
  "--toggle"|"-t")
      toggle "$2"
    ;;
  "--start")
      toggle "$2"
    ;;
  "--reset"|"-rf")
    rm -fr /tmp/hyprdots-gpuinfo-query*
    query
    echo -e "Initialized Variable:\n$(cat "$gpuQ")\n\nReboot or rm /tmp/hyprdots-gpuinfo-query to RESET Variables"
    exit 0
    ;;
esac

nvidia_flag=${nvidia_flag:-0} intel_flag=${intel_flag:-0} amd_flag=${amd_flag:-0}
#? Based on the flags, call the corresponding function multi flags means multi GPU.
if [[ "$nvidia_flag" -eq 1 ]]; then 
  nvidia_GPU
elif [[ "$amd_flag" -eq 1 ]]; then 
  amd_GPU
elif [[ "$intel_flag" -eq 1 ]]; then 
  intel_GPU
else primary_gpu="Not found"
  general_query
fi

generate_json #? AutoGen the Json txt for Waybar
