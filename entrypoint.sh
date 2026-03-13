#!/bin/bash
echo "Starting MTG Arena watcher..."

while true; do
  # Loop through all .mp3 files in /input/audio
  for audio in /input/audio/*.mp3; do
    [ -e "$audio" ] || continue
    
    # Extract filename without extension (e.g. TMT)
    filename=$(basename "$audio" .mp3)
    image="/input/keyart/$filename.png"
    output="/output/$filename.mp4"

    # If the matching .png exists and the output video hasn't been created yet
    if [ -f "$image" ] && [ ! -f "$output" ]; then
      echo "Processing $filename..."

      # Get audio duration via ffprobe
      duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio")
      # Compute fade-out start time (duration - 1s)
      fade_out=$(echo "$duration - 1" | bc)

      # Encode the video
      ffmpeg -y -loop 1 -i "$image" -i "$audio" \
        -vf "fade=t=in:st=0:d=1,fade=t=out:st=$fade_out:d=1" \
        -c:v libx264 -tune stillimage -pix_fmt yuv420p -c:a copy -shortest "$output"
      
      echo "Done: $filename.mp4"
    fi
  done
  sleep 5
done
