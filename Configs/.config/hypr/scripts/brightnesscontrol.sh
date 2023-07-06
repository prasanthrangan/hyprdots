#!/usr/bin/env bash

tagBright="notifybright"

function send_notification {
  brightness=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
  brightinfo="Notify"

  angle="$(((($brightness + 2) / 5) * 5))"
  ico="~/.config/dunst/iconvol/vol-${angle}.svg"
  
  if [ $brightness -ne 0 ]; then
    dunstify -i $ico -a "$brightinfo" -u low -h string:x-dunst-stack-tag:$tagBright \
      -h int:value:"$brightness" "Brightness: ${brightness}%" -r 91190 -t 800

  else
    dunstify -i $ico "Brightness: ${brightness}%" -a "$brightinfo" -u low -r 91190 -t 800
  fi

}

function get_brightness {
  brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)
  # increase the backlight by 5%
  brightnessctl set +5%
  send_notification
  ;;
d)
  if [[ $(get_brightness) -lt 5 ]]; then
    # avoid 0% brightness
    brightnessctl set 1%
  else
    # decrease the backlight by 5%
    brightnessctl set 5%-
  fi
  send_notification
  ;;
esac
