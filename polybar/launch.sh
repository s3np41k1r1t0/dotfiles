#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar monitor1 -r &

#xrandr --output eDP1 --mode 1920x1080 --rate 75 --output HDMI1 --off &
