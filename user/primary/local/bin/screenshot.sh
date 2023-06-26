#!/bin/sh

DATE=$(echo $(date +"%F_%T"))
NAME=$(echo screenshot_$DATE)

shotgun -g 1920x1080+0+0 -f png -s ~/Screenshots/$NAME.png

# send notif
dunstify -a "takeScreenshot" -u low -h string:x-dunst-stack-tag:"takeScreenshot" $NAME
