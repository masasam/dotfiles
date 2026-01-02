#!/bin/sh

# Get the volume level and convert it to a percentage
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo "$volume" | awk '{print $2}')
volume=$(echo "( $volume * 100 ) / 1" | bc)

notify-send -t 1000 -a 'wp-vol' -h string:x-canonical-private-synchronous:volume -h int:value:$volume "Volume: ${volume}%"