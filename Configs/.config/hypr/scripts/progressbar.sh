#!/bin/bash
# Reference: https://www.baeldung.com/linux/command-line-progress-bar

bar_size=25
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=0

current=$(bc <<< "$1")
total=$(bc <<< "$2")

function show_progress {


    # calculate the progress in percentage 
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # output the bar
    echo -ne "\r[${done_sub_bar}${todo_sub_bar}] ${percent}%"
}

show_progress
