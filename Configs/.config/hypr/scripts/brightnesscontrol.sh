#!/usr/bin/env bash

gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"

if [ "${gtkMode}" == "light" ] ; then
  ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
fi

function send_notification {
  brightness=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
  brightinfo=$(brightnessctl info | awk -F"'" '/Device/ {print $2}')

  angle="$(((($brightness + 2) / 5) * 5))"
  ico="~/.config/dunst/icons/vol/vol-${angle}.svg"
  bar=$(seq -s "." $(($brightness / 15)) | sed 's/[0-9]//g')

  if [ $brightness -ne 0 ]; then
    dunstify $ncolor "brightctl" -i $ico -a "$brightness$bar" "Device: $brightinfo" -r 91190 -t 800

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
