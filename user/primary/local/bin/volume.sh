#!/bin/sh

mode=$1

increment=2%

if [ $mode = "up" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +$increment
elif [ $mode = "down" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -$increment
elif [ $mode = "mute" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

# Arbitrary but unique message tag
msgTag="volume_refresh"

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//' )"
mute="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"
if [[ $volume == 0 || "$mute" == "yes" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -h string:x-dunst-stack-tag:$msgTag "Volume muted" 
else
    # Show the volume notification
    dunstify -a "changeVolume" -u low -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume: ${volume}%"
fi

# Play the volume changed sound
# canberra-gtk-play -i audio-volume-change -d "changeVolume" notify send here
