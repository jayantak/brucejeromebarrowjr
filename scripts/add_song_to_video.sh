#!/bin/bash
# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <fade_start_time> <video_file> <audio_file> <output_file>"
    exit 1
fi

# Assign arguments to variables
FADE_START_TIME=$1
VIDEO_FILE=$2
AUDIO_FILE=$3
OUTPUT_FILE=$4

# Run the ffmpeg command
ffmpeg -i "$VIDEO_FILE" -i "$AUDIO_FILE" -filter_complex "[1:a]afade=t=out:st=$FADE_START_TIME:d=10[a]" -map 0:v:0 -map "[a]" -c:v copy -shortest "$OUTPUT_FILE"
