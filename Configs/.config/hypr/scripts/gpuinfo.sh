#!/bin/bash

# Function to install a package using a package manager without confirmation
install_package() {
  local package_manager="yay"  # Change this to your preferred package manager
  local package_name="$1"
  local escaped_package_name="${package_name//&/\\&}"  # Escape '&' character
  if ! command -v "$package_name" &>/dev/null; then
    echo "Installing $package_name..."
    sudo "$package_manager" -S "$escaped_package_name"
  fi
}

# Function to check and install intel_gpu_top
install_intel_gpu_top() {
  install_package "intel-gpu-tools"
}

# Function to check and install radeontop
install_radeontop() {
  install_package "radeontop"
}

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)

# Initialize variables for integrated GPUs
intel_gpu=""
amd_gpu=""

# Check for Intel integrated GPU
if install_intel_gpu_top; then
  intel_gpu="Intel GPU"
  # Collect GPU information for Intel
  gpu_info_intel=$(intel_gpu_top -b -o - | awk '/Kernel\ Time|Render\ Time/ {print $3}')
fi

# Check for AMD integrated GPU using radeontop
if install_radeontop; then
  if [ -z "$intel_gpu" ]; then
    amd_gpu="AMD GPU"
  fi
  # Collect GPU information for AMD
  gpu_info_amd=$(radeontop -b -d 1 | grep -E "Temp|Util|Core(Memory) Clock|Power Draw Limit" | awk '{print $2}' | tr '\n' ',' | sed 's/,$/\n/')
fi

# Check if primary GPU is NVIDIA, AMD, Intel, or not found
if [ -n "$nvidia_gpu" ]; then
  primary_gpu="NVIDIA GPU"
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits)
elif [ -n "$gpu_info_amd" ]; then
  primary_gpu="$amd_gpu"
  gpu_info="$gpu_info_amd"
elif [ -n "$gpu_info_intel" ]; then
  primary_gpu="Intel GPU"
  gpu_info="$gpu_info_intel"
else
  primary_gpu="Not found"
  gpu_info=""
fi

# Split the comma-separated values into an array
IFS=',' read -ra gpu_data <<< "$gpu_info"

# Extract individual values
temperature="${gpu_data[0]// /}"
utilization="${gpu_data[1]// /}"
core_clock="${gpu_data[2]// /}"
power_limit="${gpu_data[3]// /}"

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
 Core Clock: $core_clock MHz\n\
 Power Limit: $power_limit W"

#echo "$temperature°C"
echo "{\"text\":\"$temperature°C\", \"tooltip\":\"$text\"}"
