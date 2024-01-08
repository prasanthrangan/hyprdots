#!/bin/bash

if [ -z /usr/bin/swayidle ];then
	echo "swayidle is not installed"
	exit
fi

if [ -z /usr/bin/swaylock ];then
	echo "swaylock is not installed"
	exit
fi

dunstify "idle script is now active" -t 5000

swayidle -w \
	timeout 300 'swaylock -f' \
	before-sleep 'swaylock -f'
