#!/usr/bin/env sh

# Set the directory paths
waybar_dir=`dirname $(realpath $0)`
modes_dir="$waybar_dir/modes"

# Get the current symlink target
current_target=$(readlink "$waybar_dir/config.jsonc")

# Get the list of available files in modes directory
file_list=("$modes_dir"/*.jsonc)
num_files=${#file_list[@]}

# Check if there are no files or only one file
if [[ $num_files -eq 0 ]]; then
    echo "Error: No files found in modes directory."
    exit 1
elif [[ $num_files -eq 1 ]]; then
    echo "Only one file found. No changes made."
    exit 0
fi

# Find the index of the current target in the file list
current_index=-1
for ((i=0; i<num_files; i++)); do
    if [[ ${file_list[$i]} == "$current_target" ]]; then
        current_index=$i
        break
    fi
done

# Check if the current symlink target was found
if [[ $current_index -eq -1 ]]; then
    echo "Error: Symbolic link target not found in modes directory."
    exit 1
fi

# Function to calculate the next or previous index
calculate_index() {
    local current=$1
    local increment=$2
    local result=$(( (current + increment + num_files) % num_files ))
    echo $result
}

## evaluate options ##
while getopts "np" option ; do
    case $option in
    n ) # set the next waybar
        next_index=$(calculate_index $current_index 1)
        new_target=${file_list[$next_index]} ;;
    p ) # set the previous waybar
        prev_index=$(calculate_index $current_index -1)
        new_target=${file_list[$prev_index]} ;;
    * ) # invalid option
        echo "n : set next menubar"
        echo "p : set previous menubar"
        exit 1 ;;
    esac
done


# Update the symbolic link
ln -sf "$new_target" "$waybar_dir/config.jsonc"
sleep 1
killall waybar # I have tried killall -SIGUSR2 waybar w/o success
waybar > /dev/null 2>&1 &
