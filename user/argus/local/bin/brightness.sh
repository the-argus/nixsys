#!/bin/sh

mode=$1

if [ $mode = "up" ]; then
    xbacklight -inc 10
elif [ $mode = "down" ]; then
    xbacklight -dec 10
fi

# attempt to notify
notify-send $(xbacklight -get)
