#!/bin/bash

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)

# Function to execute the AMD GPU Python script and use its output
execute_amd_script() {
  local amd_output
  amd_output=$(python3 ~/.config/hypr/scripts/amdgpu.py)
  echo "$amd_output"
}

# Function to install a package using yay without confirmation
install_package() {
  local package_name="$1"
  if ! command -v "$package_name" &>/dev/null; then
    echo "Installing $package_name..."
    yay -S --noconfirm "$package_name"
  fi
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

# Check if primary GPU is NVIDIA or not found
if [ -n "$nvidia_gpu" ]; then
  primary_gpu="NVIDIA GPU"
  # Collect GPU information for NVIDIA
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

  # Get emoji based on temperature
  emoji=$(get_temperature_emoji "$temperature")
 
  # Print the formatted information in JSON
  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"
else
  primary_gpu="AMD GPU"
  # Check if the python-pyamdgpuinfo package is installed, and install it if not
  install_package "python-pyamdgpuinfo"
  # Execute the AMD GPU Python script and use its output
  amd_output=$(execute_amd_script)
  if [ -n "$amd_output" ]; then
    # Extract GPU Temperature, GPU Load, GPU Core Clock, and GPU Power Usage from amd_output
    temperature=$(echo "$amd_output" | jq -r '.["GPU Temperature"]' | sed 's/°C//')
    gpu_load=$(echo "$amd_output" | jq -r '.["GPU Load"]' | sed 's/%//')
    core_clock=$(echo "$amd_output" | jq -r '.["GPU Core Clock"]' | sed 's/ GHz//')
    power_usage=$(echo "$amd_output" | jq -r '.["GPU Power Usage"]' | sed 's/ Watts//')

    # Get emoji based on temperature
    emoji=$(get_temperature_emoji "$temperature")

    # Print the formatted information in JSON
    echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n Utilization: $gpu_load%\n Clock Speed: $core_clock GHz\nPower Usage: $power_usage W\"}"
  else
    echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: $primary_gpu\nAMD GPU device not found\"}"
  fi
fi
