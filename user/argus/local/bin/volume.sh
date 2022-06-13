#!/bin/sh

mode=$1

if [ $mode = "up" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +10%
elif [ $mode = "down" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -10%
elif [ $mode = "mute" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

# notify send here
