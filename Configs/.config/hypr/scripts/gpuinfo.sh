#!/bin/bash

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)

# Find all GPUs using lspci
all_gpus=$(lspci -nn | grep -E 'VGA|3D controller' | grep -oE '\[....:....\]' | tr -d '[]')

# Initialize variables for integrated GPUs
intel_gpu=""
amd_gpu=""

# Loop through all GPUs to identify integrated ones
for gpu in $all_gpus; do
  gpu_info=$(lspci -v | grep -A 12 "VGA controller" | grep -B 1 "$gpu")

  # Check for Intel integrated GPU
  if echo "$gpu_info" | grep -iq 'Intel Corporation'; then
    intel_gpu="$gpu"
  fi

  # Check for AMD integrated GPU
  if echo "$gpu_info" | grep -iq 'Advanced Micro Devices'; then
    amd_gpu="$gpu"
  fi
done

# Check if primary GPU is NVIDIA, AMD, or not found
if [ -n "$nvidia_gpu" ]; then
  primary_gpu="NVIDIA GPU"
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits)
elif [ -n "$amd_gpu" ]; then
  primary_gpu="AMD GPU"
  # Collect GPU information for AMD
  gpu_info=$(sudo -E /opt/amdgpu-pro/bin/clinfo | grep "Name\|Temp\|Core\|Power\|Max Clock" | awk '{ print $2 }' | tr '\n' ',' | sed 's/,$/\n/')
elif [ -n "$intel_gpu" ]; then
  primary_gpu="Intel GPU"
  # Collect GPU information for Intel
  gpu_info=$(lspci -v | grep -A 12 "VGA controller" | grep -B 1 "$intel_gpu" | grep "Subsystem" -A 4 | grep "Kernel driver in use")
else
  # If neither dedicated nor integrated Intel GPU is found, check for integrated AMD GPU
  amd_integrated_gpu=$(lspci -nn | grep 'VGA.*ATI' | grep -oE '\[....:....\]' | tr -d '[]')
  
  if [ -n "$amd_integrated_gpu" ]; then
    primary_gpu="AMD GPU"
    # Collect GPU information for AMD
    gpu_info=$(sudo -E /opt/amdgpu-pro/bin/clinfo | grep "Name\|Temp\|Core\|Power\|Max Clock" | awk '{ print $2 }' | tr '\n' ',' | sed 's/,$/\n/')
  else
    primary_gpu="Not found"
    gpu_info=""
  fi
fi

# Split the comma-separated values into an array
IFS=',' read -ra gpu_data <<< "$gpu_info"

# Extract individual values
temperature="${gpu_data[0]// /}"
utilization="${gpu_data[1]// /}"
current_clock_speed="${gpu_data[2]// /}"
max_clock_speed="${gpu_data[3]// /}"
power_usage="${gpu_data[4]// /}"
power_limit="${gpu_data[5]// /}"

# Define emoji based on temperature
if [ "$temperature" -lt 60 ]; then
  emoji="❄️"  # Ice emoji for less than 60°C
else
  emoji="🔥"  # Fire emoji for 60°C or higher
fi

# Print the formatted information
text="Primary GPU: $primary_gpu\n\
$emoji Temperature: $temperature°C\n\
󰾆 Utilization: $utilization%\n\
 Clock Speed: $current_clock_speed/$max_clock_speed MHz\n\
 Power Usage: $power_usage/$power_limit W"

#echo "$temperature°C"
echo "{\"text\":\"$temperature°C\", \"tooltip\":\"$text\"}"
