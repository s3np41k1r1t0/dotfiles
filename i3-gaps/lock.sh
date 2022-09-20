#!/usr/bin/env bash
TMPBG=/tmp/screen.png
RES=$(xrandr | grep 'current' | sed -E 's/.*current\s([0-9]+)\sx\s([0-9]+).*/\1x\2/')
 
ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -filter_complex "boxblur=10:1" -vframes 1 $TMPBG -loglevel quiet
i3lock -i $TMPBG

if [[ $1 == "suspend" ]]
then
	systemctl suspend
fi

rm $TMPBG
