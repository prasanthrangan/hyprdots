#!/bin/bash

# Function to convert millidegrees to Celsius
to_celsius() {
  local millidegrees="$1"
  local celsius=$((millidegrees / 1000))
  echo "$celsius"
}

# Function to read GPU temperature
read_gpu_temperature() {
  local temp_path="/sys/class/drm/card0/device/hwmon/hwmon*/temp1_input"
  local temp_millidegrees=$(cat $temp_path)
  local temp_celsius=$(to_celsius $temp_millidegrees)
  echo "$temp_celsius"
}

# Function to read GPU utilization
read_gpu_utilization() {
  local utilization_path="/sys/class/drm/card0/device/gpu_busy_percent"
  local utilization=$(cat $utilization_path)
  echo "$utilization"
}

# Function to read P-states
read_p_states() {
  local p_states_path="/sys/class/drm/card0/device/pp_od_clk_voltage"
  local p_states=$(cat $p_states_path)
  echo "$p_states"
}

# Function to read VRAM frequency
read_vram_frequency() {
  local vram_freq_path="/sys/class/drm/card0/device/pp_dpm_mclk"
  local vram_freq=$(cat $vram_freq_path | tr '\n' ',' | sed 's/,$/\n/')
  echo "$vram_freq"
}

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

# Check if primary GPU is NVIDIA, AMD, Intel, or not found
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
  # Define emoji based on temperature
  if [ "$temperature" -lt 60 ]; then
    emoji="❄️"  # Ice emoji for less than 60°C
  else
    emoji="🔥"  # Fire emoji for 60°C or higher
  fi
  # Print the formatted information in JSON
  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"
elif [ -n "$amd_gpu" ]; then
  primary_gpu="AMD GPU"
  # Extract temperature, utilization, P-states, and VRAM frequency from the AMD GPU
  temperature=$(read_gpu_temperature)
  utilization=$(read_gpu_utilization)
  p_states=$(read_p_states)
  vram_frequency=$(read_vram_frequency)
  # Define emoji based on temperature
  if [ "$temperature" -lt 60 ]; then
    emoji="❄️"  # Ice emoji for less than 60°C
  else
    emoji="🔥"  # Fire emoji for 60°C or higher
  fi
  # Print the formatted information in JSON
  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n🔄 P-states: $p_states\n🌐 VRAM Frequency: $vram_frequency\"}"
elif [ -n "$intel_gpu" ]; then
  primary_gpu="Intel GPU"
  # Collect GPU information for Intel
  gpu_info=$(lspci -v | grep -A 12 "VGA controller" | grep -B 1 "$intel_gpu" | grep "Subsystem" -A 4 | grep "Kernel driver in use")
else
  primary_gpu="Not found"
  gpu_info=""
fi

# Print the formatted information
echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\"}"
