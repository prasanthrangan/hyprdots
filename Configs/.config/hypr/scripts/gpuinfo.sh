#!/bin/bash

# Function to execute the AMD GPU Python script and use its output
execute_amd_script() {
  local amd_output
  amd_output=$(python3 ~/.config/hypr/scripts/amdgpu.py)
  if [[ $amd_output == *"No AMD GPUs detected."* ]]; then #? This Message is from  python3 ~/.config/hypr/scripts/amdgpu.py
    return 1
  else
    echo "$amd_output"
    return 0
  fi
}

# Function to get Intel GPU temperature from 'sensors'
get_intel_gpu_temperature() {
  local temperature
  temperature=$(sensors | grep "Package id 0" | awk '{print $4}' | sed 's/+//;s/°C//;s/\.0//')
  echo "$temperature"
}

# Function to define emoji based on temperature
get_temperature_emoji() {
  local temperature="$1"
  if [ "$temperature" -lt 60 ]; then
    echo "❄️"  # Ice emoji for less than 60°C
  else
    echo "🔥"  # Fire emoji for 60°C or higher
  fi
}

intel_GPU() {
    # Check for Intel GPU
    primary_gpu="Intel GPU"
    if [ -n "$intel_gpu" ]; then
      temperature=$(get_intel_gpu_temperature)
      emoji=$(get_temperature_emoji "$temperature")
      # Print the formatted information in JSON
      echo "{\"text\":\" $temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\"}"
    else
      primary_gpu="Not found"
      gpu_info=""
      # Print the formatted information in JSON
      echo "{\"text\":\"INTEL\", \"tooltip\":\"Primary GPU: $primary_gpu\"}"
    fi
}

nvidia_GPU() {
    primary_gpu="NVIDIA GPU"
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

  # Get emoji based on temperature
  emoji=$(get_temperature_emoji "$temperature")

  # Print the formatted information in JSON
  echo "{\"text\":\" $temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"

}

amd_GPU() {
    # Execute the AMD GPU Python script and use its output
  amd_output=$(execute_amd_script)
  # Extract GPU Temperature, GPU Load, GPU Core Clock, and GPU Power Usage from amd_output
  temperature=$(echo "$amd_output" | jq -r '.["GPU Temperature"]' | sed 's/°C//')
  gpu_load=$(echo "$amd_output" | jq -r '.["GPU Load"]' | sed 's/%//')
  core_clock=$(echo "$amd_output" | jq -r '.["GPU Core Clock"]' | sed 's/ GHz//;s/ MHz//')
  power_usage=$(echo "$amd_output" | jq -r '.["GPU Power Usage"]' | sed 's/ Watts//')

  # Get emoji based on temperature
  emoji=$(get_temperature_emoji "$temperature")

  # Print the formatted information in JSON
  if [ -n "$temperature" ]; then
    primary_gpu="AMD GPU"
    echo "{\"text\":\" $temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $gpu_load%\n Clock Speed: $core_clock MHz\n Power Usage: $power_usage W\"}"

  fi
}

query() { nvidia_flag=0 amd_flag=0 intel_flag=0

touch $gpuQ ; : > $gpuQ # Clear the contents of the hyprdots-gpuinfo.query file

nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)
intel_gpu=$(lspci -nn | grep -i "VGA compatible controller" | grep -i "Intel Corporation" | awk -F' ' '{print $1}')

if [ -n "$nvidia_gpu" ] ; then  # Check for NVIDIA GPU
echo "nvidia_gpu=\"$nvidia_gpu\"" >> $gpuQ 
#! if nvidia-smi gives "NVIDIA-SMI has failed"(Even if it has no problem) 
#! Or something inconsitent maybe we should rerun this lines below, Comment OUT the lines below until else
if  [[ "$nvidia_gpu" == *"NVIDIA-SMI has failed"* ]]; then  #? Second Layer for dGPU 
echo "nvidia_flag=0 # NVIDIA-SMI has failed" >> $gpuQ
else
echo "nvidia_flag=1" >> $gpuQ
fi

 fi

if execute_amd_script > /dev/null 2>&1; then echo "amd_flag=1" >> $gpuQ ; fi # Check for AMD GPU

if [ -n "$intel_gpu" ]; then echo "intel_flag=1" >> $gpuQ # Check for Intel GPU
echo "intel_gpu=\"$intel_gpu\"" >> $gpuQ ; fi
}

gpuQ="/tmp/hyprdots-gpuinfo-query"
if [ -f "$gpuQ" ]; then eval "$(cat $gpuQ)"
else query ; echo -e "Initialized Variable:\n$(cat $gpuQ)\n\nReboot or rm /tmp/hyprdots-gpuinfo-query to RESET Variables  " ;exit
fi

#? If all flags are not set, output that no primary GPU was found
if [[ "$nvidia_flag" -ne 1 ]] && [[ "$amd_flag" -ne 1 ]] && [[ "$intel_flag" -ne 1 ]]; then echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: Not found\"}" ; fi

#? Based on the flags, call the corresponding function multi flags means multi GPU.
if [ "$nvidia_flag" -eq 1 ]; then
nvidia_GPU
#! if nvidia-smi gives "NVIDIA-SMI has failed"(Even if it has no problem) 
#! Or something inconsitent maybe we should rerun this lines below, Uncomment the lines below
# nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)
#     if  [[ "$nvidia_gpu" != *"NVIDIA-SMI has failed"* ]]; then nvidia_GPU 
#       amd_flag=0 intel_flag=0
#     elif [[ $amd_flag -eq 0 ]] && [[ $intel_flag -eq 0 ]] ; then echo "{\"text\":\"N/A\", \"tooltip\":\"NVIDIA GPU: Not found\"}"
#       exit 0
#     fi
fi

#? AMD
if [[ "$amd_flag" -eq 1 ]]; then 
intel_flag=0 
amd_GPU 
fi

#? Last Priority INTEL
if [ "$intel_flag" -eq 1 ]; then intel_GPU ; fi
