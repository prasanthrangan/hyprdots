#!/bin/sh

# Detect GPU brand
brand=$(glxinfo | grep "OpenGL vendor string" | cut -d' ' -f4)

if [ "$brand" = "NVIDIA" ]; then
    # Use nvidia-smi for NVIDIA GPUs
    nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,clocks.current.graphics,clocks.max.graphics --format=csv,noheader,nounits | awk -F ', ' '{print "{\"text\":\""$1"\", \"tooltip\":\"NVIDIA GPU\\n Temperature: " $2 "°C\\n󰾆 Utilization: " $1 " %\\n Clock Speed: " $3 "/" $4 "MHz\"}"}'
elif [ "$brand" = "AMD" ]; then
    # Use radeontop or another tool for AMD GPUs
    # This is a placeholder as the actual command depends on the specific tool you're using
    echo "{ \"text\":\"$(radeontop -d - -l 1 | grep 'gpu' | awk '{print $3}' | cut -d'.' -f1)\", \"tooltip\":\"AMD GPU\\n Temperature: $(sensors amdgpu-pci-* | grep 'edge' | awk '{print $2}' | cut -d'.' -f1)°C\\n󰾆 Utilization: $(radeontop -d - -l 1 | grep 'gpu' | awk '{print $3}' | cut -d'.' -f1) %\\n Clock Speed: N/A\"}"
elif [ "$brand" = "Intel" ]; then
    # Use intel_gpu_top for Intel GPUs
    echo "{ \"text\":\"$(intel_gpu_top -J | jq '. | .busy')\", \"tooltip\":\"Intel GPU\\n Temperature: $(sensors i915-pci-* | grep 'Package id' | awk '{print $4}' | cut -d'.' -f1)°C\\n󰾆 Utilization: $(intel_gpu_top -J | jq '. | .busy') %\\n Clock Speed: N/A\"}"
else
    echo "Unsupported GPU brand: $brand"
fi