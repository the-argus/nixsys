#!/bin/sh

LOCATION_1=/tmp/albumart1.jpeg
LOCATION_2=/tmp/albumart2.jpeg
IMAGE_FILE_LOCATION=$LOCATION_1

function swap_file_location () {
    if [ "$IMAGE_FILE_LOCATION" = "$LOCATION_1" ]; then
        IMAGE_FILE_LOCATION=$LOCATION_2
    elif [ "$IMAGE_FILE_LOCATION" = "$LOCATION_2" ]; then
        IMAGE_FILE_LOCATION=$LOCATION_1
    else
        exit 1
    fi
}

playerctl --follow metadata --format {{mpris:artUrl}} 2>/dev/null |
    while read arturl; do
        swap_file_location
        wget $arturl -O $IMAGE_FILE_LOCATION
        echo $IMAGE_FILE_LOCATION
    done
