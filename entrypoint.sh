#!/bin/bash
echo "Starting MTG Arena watcher..."

# Default fade-out time if not set
FADEOUT_TIME=${FADEOUT_TIME:-1}

while true; do
  # Loop through all .mp3 files in /input/audio
  for audio in /input/audio/*.mp3; do
    [ -e "$audio" ] || continue
    
    filename=$(basename "$audio" .mp3)
    
    # 1. Determine group prefix and index
    if [[ "$filename" =~ ^(.*)_([0-9]+)$ ]]; then
      group_prefix="${BASH_REMATCH[1]}"
      index="${BASH_REMATCH[2]}"
      # Find all files in the group
      group_files=($(ls -v /input/audio/${group_prefix}_*.mp3 2>/dev/null))
    else
      group_prefix="$filename"
      index=""
      group_files=("$audio")
    fi
    
    total_count=${#group_files[@]}
    
    # Find position in group
    pos=1
    for gfile in "${group_files[@]}"; do
      if [ "$(basename "$gfile" .mp3)" == "$filename" ]; then
        break
      fi
      ((pos++))
    done

    # 2. Extract trigram from group_prefix
    # Expected formats: BAT_ONE_hash, TMT_BAT_hash, BAT_ONE, ONE, etc.
    IFS='_' read -ra PARTS <<< "$group_prefix"
    if [ "${PARTS[0]}" == "BAT" ] && [ "${#PARTS[@]}" -ge 2 ]; then
      trigram="${PARTS[1]}"
    elif [ "${#PARTS[@]}" -ge 2 ] && [ "${PARTS[1]}" == "BAT" ]; then
      trigram="${PARTS[0]}"
    else
      trigram="${PARTS[0]}"
    fi
    
    # 3. Find image for trigram (support .png, .jpg, .jpeg)
    image=""
    for ext in png PNG jpg JPG jpeg JPEG; do
      if [ -f "/input/keyart/$trigram.$ext" ]; then
        image="/input/keyart/$trigram.$ext"
        break
      fi
    done
    
    if [ -z "$image" ]; then
      continue
    fi
    
    # 4. Determine output filename
    if [ "$total_count" -le 1 ]; then
      output="/output/MTGArena OST - $trigram.mp4"
    else
      output="/output/MTGArena OST - $trigram ${pos}_${total_count}.mp4"
    fi

    # If the output video hasn't been created yet
    if [ ! -f "$output" ]; then
      echo "Processing $filename -> $(basename "$output")..."

      # Get audio duration via ffprobe
      duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio")
      # Compute fade-out start time (duration - FADEOUT_TIME)
      fade_out=$(echo "$duration - $FADEOUT_TIME" | bc)

      # Encode the video
      ffmpeg -y -loop 1 -i "$image" -i "$audio" \
        -vf "fade=t=in:st=0:d=1,fade=t=out:st=$fade_out:d=$FADEOUT_TIME" \
        -c:v libx264 -tune stillimage -pix_fmt yuv420p -c:a copy -shortest "$output" </dev/null
      
      echo "Done: $(basename "$output")"
    fi
  done
  sleep 5
done
