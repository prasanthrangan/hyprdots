#!/bin/bash

pgrep_output=$(pgrep swayidle)
pgrep_arr=($pgrep_output)
if [[ "${#pgrep_arr[@]}" == "1" ]] || [[ "${#pgrep_arr[@]}" == "0" ]]; then
    echo "Swayidle is not running. Starting Swayidle."
    ./lockscreentime.sh
else
    echo "Swayidle is running. Killing swayidle."
    killall swayidle
fi
