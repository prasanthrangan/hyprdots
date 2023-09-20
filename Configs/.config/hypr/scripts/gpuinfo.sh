#!/bin/bash

# Function to install a package using yay without confirmation
install_package() {
  local package_name="$1"
  if ! command -v "$package_name" &>/dev/null; then
    echo "Installing $package_name..."
    yay -S --noconfirm "$package_name"
  fi
}

# Check if amdgpu_top is installed
if ! command -v "amdgpu_top" &>/dev/null; then
  install_package "amdgpu_top"
fi

# Check if intel-gpu-tools is installed
if ! command -v "intel_gpu_top" &>/dev/null; then
  install_package "intel-gpu-tools"
fi

# Function to collect GPU information for Intel
collect_gpu_info_intel() {
  local gpu_info_intel
  gpu_info_intel=$(timeout 5 intel_gpu_top -s 1 -o - | awk '/Temperature/ {print $2}' | tr '\n' ',' | sed 's/,$/\n/')
  echo "$gpu_info_intel"
}

# Function to collect GPU information for AMD
collect_gpu_info_amd() {
  local gpu_info_amd
  gpu_info_amd=$(amdgpu_top -d)
  echo "$gpu_info_amd"
}

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)

# Initialize variables for integrated GPUs
intel_gpu=""
amd_gpu=""

# Check for Intel integrated GPU
if command -v "intel_gpu_top" &>/dev/null; then
  intel_gpu="Intel GPU"
  # Collect GPU information for Intel
  gpu_info_intel=$(collect_gpu_info_intel)
fi

# Check for AMD integrated GPU using amdgpu_top
if command -v "amdgpu_top" &>/dev/null; then
  if [ -z "$intel_gpu" ]; then
    amd_gpu="AMD GPU"
  fi
  # Collect GPU information for AMD
  gpu_info_amd=$(collect_gpu_info_amd)
fi

# Check for AMD integrated GPU using amdgpu_top
if command -v "amdgpu_top" &>/dev/null; then
  if [ -z "$intel_gpu" ]; then
    amd_gpu="AMD GPU"
  fi
  # Collect GPU information for AMD
  gpu_info_amd=$(collect_gpu_info_amd)
  echo "AMD GPU Info:"
  echo "$gpu_info_amd"
fi

# Check if primary GPU is NVIDIA, AMD, Intel, or not found
if [ -n "$nvidia_gpu" ]; then
  primary_gpu="NVIDIA GPU"
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits)
elif [ -n "$gpu_info_amd" ]; then
  primary_gpu="$amd_gpu"
  # Use the same formatting for AMD GPU information as for NVIDIA
  temperature=$(echo "$gpu_info_amd" | grep -oP 'Edge Temp:\s*\K\d+')
  utilization=$(echo "$gpu_info_amd" | grep -oP 'average_gfx_activity:\s*\K\d+')
  current_clock_speed=$(echo "$gpu_info_amd" | grep -oP 'current_gfxclk:\s*\K\d+')
  max_clock_speed=$(echo "$gpu_info_amd" | grep -oP 'average_gfxclk_frequency:\s*\K\d+')
  power_usage=$(echo "$gpu_info_amd" | grep -oP 'Power Avg.:\s*\K\d+')
  power_limit="N/A"  # Adjust this as per available metrics
  gpu_info="$temperature,$utilization,$current_clock_speed,$max_clock_speed,$power_usage,$power_limit"
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
