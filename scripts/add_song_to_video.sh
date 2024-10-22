#!/bin/bash
# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <video_file_folder> <audio_file_folder> <output_file>"
    exit 1
fi

# Assign arguments to variables
VIDEO_FILE_FOLDER=$1
AUDIO_FILE_FOLDER=$2
OUTPUT_FILE_PATH=$3

# Assign arguments to variables
gum style --foreground 212 "Select video file:" && VIDEO_FILE=$(gum file $VIDEO_FILE_FOLDER --height=10)
gum style --foreground 212 "Select audio file:" && AUDIO_FILE=$(gum file $AUDIO_FILE_FOLDER --height=10)
while true; do
    OUTPUT_FILE=$(gum input --value "$OUTPUT_FILE_PATH" --prompt "Enter output video filepath: ")
    if [ -f "$OUTPUT_FILE" ]; then
        gum confirm "File already exists. Do you want to overwrite it?" && OVERWRITE=1 || OVERWRITE=0
        if [ "$OVERWRITE" -eq 1 ]; then
            break
        fi
    else
        break
    fi
done
FADE_DURATION=$(gum input --value 10 --prompt "Enter fade duration: ")

# Get the duration of the video
VIDEO_DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO_FILE")

# Calculate the fade start time as 10 seconds before the end of the video
FADE_START_TIME=$(echo "$VIDEO_DURATION - $FADE_DURATION" | bc)

# Run the ffmpeg command
gum spin --spinner dot --title "Adding song to the video and adding fade..." -- ffmpeg -loglevel error -y -i "$VIDEO_FILE" -i "$AUDIO_FILE" -filter_complex "[1:a]afade=t=out:st=$FADE_START_TIME:d=10[a]" -map 0:v:0 -map "[a]" -c:v copy -shortest "$OUTPUT_FILE"
