#!/bin/bash

# Convert all salvaged VOB files to MP4
echo "🎬 Converting all salvaged clips to MP4..."

SALVAGE_DIR="/mnt/storage/dvd_salvage_20250713_162809/Samsung Dvd Recorder Volume/VIDEO_TS"

# Convert Title 1 (2:12)
echo "🎬 Converting Title 1 (2:12)..."
HandBrakeCLI -i "$SALVAGE_DIR/VTS_01_1.VOB" -o "title_1_clip.mp4" --preset="Fast 1080p30"

# Convert Title 2 (2:50)
echo "🎬 Converting Title 2 (2:50)..."
HandBrakeCLI -i "$SALVAGE_DIR/VTS_02_1.VOB" -o "title_2_clip.mp4" --preset="Fast 1080p30"

# Convert Title 3 (3:43) - may have errors
echo "🎬 Converting Title 3 (3:43)..."
HandBrakeCLI -i "$SALVAGE_DIR/VTS_03_1.VOB" -o "title_3_clip.mp4" --preset="Fast 1080p30"

# Convert Title 6 (25:34) - we have this file!
echo "🎬 Converting Title 6 (25:34)..."
HandBrakeCLI -i "$SALVAGE_DIR/VTS_06_1.VOB" -o "title_6_clip.mp4" --preset="Fast 1080p30"

# Convert Title 7 (4:16:29) - longest clip
echo "🎬 Converting Title 7 (4:16:29)..."
HandBrakeCLI -i "$SALVAGE_DIR/VTS_07_1.VOB" -o "title_7_clip.mp4" --preset="Fast 1080p30"

echo "🎉 All clips converted!"
echo "📁 Check your MP4 files in the current directory" 