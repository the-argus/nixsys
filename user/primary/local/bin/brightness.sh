#!/bin/sh

mode=$1

increment=2

if [ $mode = "up" ]; then
    xbacklight -inc $increment
elif [ $mode = "down" ]; then
    xbacklight -dec $increment
fi

# attempt to notify
OUT=$(xbacklight -get)

# send notification with dunst
msgTag='brightness_refresh'
dunstify -a "changeBrightness" -u low -h string:x-dunst-stack-tag:$msgTag \
	-h int:value:"$OUT" "Brightness: ${OUT}%"
