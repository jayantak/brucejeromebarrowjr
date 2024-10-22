#!/bin/bash
# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <video_file> <audio_file> <output_file>"
    exit 1
fi

# Assign arguments to variables
VIDEO_FILE=$1
AUDIO_FILE=$2
OUTPUT_FILE=$3

# Get the duration of the video
VIDEO_DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO_FILE")

# Calculate the fade start time as 10 seconds before the end of the video
FADE_START_TIME=$(echo "$VIDEO_DURATION - 10" | bc)

echo "Fade start time: $FADE_START_TIME"

# Run the ffmpeg command
ffmpeg -i "$VIDEO_FILE" -i "$AUDIO_FILE" -filter_complex "[1:a]afade=t=out:st=$FADE_START_TIME:d=10[a]" -map 0:v:0 -map "[a]" -c:v copy -shortest "$OUTPUT_FILE"
