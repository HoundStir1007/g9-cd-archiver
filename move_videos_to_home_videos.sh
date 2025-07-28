#!/bin/bash

# Move specific video files from Movies to Home Videos
# Files to move: 1,2,3,4,5,9 (as specified by user)

echo "🎬 Moving video files from Movies to Home Videos..."

# Source and destination directories
SOURCE_DIR="/media/mark/paperless-ssd/jellyfin/media/movies"
DEST_DIR="/media/mark/paperless-ssd/jellyfin/media/home-videos"

# Files to move (in order specified: 1,2,3,4,5,9)
FILES=(
    "Cal High Jazz Festival 1996.mp4"
    "Cal High Talent Show 1997.mp4"
    "Hugo Reid Elementary School December 2014 - The Incredible Reindeer.mp4"
    "Hugo Reid Elementary School December 2017 - North Pole Exposure.mp4"
    "Mrs. Morris 1st Grade Class Hugo Reid Primary 2013-14.mp4"
    "SAMSUNG DVD RECORDER VOLUME.mp4"
)

# Check if source and destination directories exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: Source directory $SOURCE_DIR does not exist"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo "❌ Error: Destination directory $DEST_DIR does not exist"
    exit 1
fi

# Move each file
for file in "${FILES[@]}"; do
    source_file="$SOURCE_DIR/$file"
    dest_file="$DEST_DIR/$file"
    
    echo "📁 Processing: $file"
    
    # Check if source file exists
    if [ ! -f "$source_file" ]; then
        echo "⚠️  Warning: Source file $file not found, skipping..."
        continue
    fi
    
    # Check if destination file already exists
    if [ -f "$dest_file" ]; then
        echo "⚠️  Warning: Destination file $file already exists, skipping..."
        continue
    fi
    
    # Move the file
    if mv "$source_file" "$dest_file"; then
        echo "✅ Successfully moved: $file"
    else
        echo "❌ Error moving: $file"
    fi
done

echo "🎬 Video move operation completed!"
echo "📊 Summary:"
echo "   Source: $SOURCE_DIR"
echo "   Destination: $DEST_DIR"
echo "   Files processed: ${#FILES[@]}" 