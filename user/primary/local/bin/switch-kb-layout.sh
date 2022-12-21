#!/bin/sh

CURRENT_LAYOUT=$(xkb-switch)
LAYOUTS=$(xkb-switch -l)
NEW_LAYOUT=""

LAYOUT_AFTER_CURRENT=
REACHED_CURRENT=0

for layout in $LAYOUTS; do
    # in this case, the layout was not the last one in the list and we
    # switch to the next one
    if [ -z $LAYOUT_AFTER_CURRENT ] && [ $REACHED_CURRENT -eq 1 ]; then
        LAYOUT_AFTER_CURRENT=$layout
        echo "switching to $LAYOUT_AFTER_CURRENT"
        notify-send "layout: $LAYOUT_AFTER_CURRENT"
        xkb-switch -s $LAYOUT_AFTER_CURRENT
        exit 0
    fi
    # once we reach this we start tracking layout_after
    if [ "$layout" = "$CURRENT_LAYOUT" ]; then
        REACHED_CURRENT=1
    fi
done

LAYOUT_ARRAY=($LAYOUTS)
TARGET=${LAYOUT_ARRAY[0]}
echo "finding next item failed, switching to $TARGET"
notify-send "layout: $TARGET"
xkb-switch -s $TARGET
