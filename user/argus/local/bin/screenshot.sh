#!/bin/sh

DATE=$(echo $(date +"%F_%T"))
NAME=$(echo screenshot_$DATE)

ffmpeg -f x11grab -video_size 1920x1080 -i $DISPLAY -vframes 1 ~/Screenshots/$NAME.png

# send notif
dunstify -a "takeScreenshot" -u low -h string:x-dunst-stack-tag:"takeScreenshot" $NAME
