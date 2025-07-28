#!/bin/bash

# Extract All DVD Clips Script
# Converts salvaged DVD content to individual MP4 files

echo "🎬 DVD Clip Extraction Tool"
echo "=========================="

# Create output directory
OUTPUT_DIR="/mnt/storage/dvd_clips_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"
echo "📁 Output directory: $OUTPUT_DIR"

# Check what we have salvaged
SALVAGE_DIR="/mnt/storage/dvd_salvage_20250713_162809/Samsung Dvd Recorder Volume"

if [ ! -d "$SALVAGE_DIR" ]; then
    echo "❌ Salvaged content not found. Please run salvage_dvd_content.sh first."
    exit 1
fi

echo ""
echo "🔍 Available content from salvage:"
ls -la "$SALVAGE_DIR/VIDEO_TS/" | grep VTS

echo ""
echo "📺 Converting salvaged content to MP4 clips..."

# Convert salvaged VTS files to MP4
cd "$SALVAGE_DIR"

# Title 1 (2:12 duration)
if [ -f "VIDEO_TS/VTS_01_1.VOB" ]; then
    echo "🎬 Converting Title 1 (2:12)..."
    HandBrakeCLI -i . -t 1 -o "$OUTPUT_DIR/title_1_clip.mp4" --preset="Fast 1080p30" --audio-lang-list=und
fi

# Title 2 (2:50 duration) 
if [ -f "VIDEO_TS/VTS_02_1.VOB" ]; then
    echo "🎬 Converting Title 2 (2:50)..."
    HandBrakeCLI -i . -t 2 -o "$OUTPUT_DIR/title_2_clip.mp4" --preset="Fast 1080p30" --audio-lang-list=und
fi

# Title 3 (3:43 duration) - may have read errors
if [ -f "VIDEO_TS/VTS_03_1.VOB" ]; then
    echo "🎬 Converting Title 3 (3:43)..."
    HandBrakeCLI -i . -t 3 -o "$OUTPUT_DIR/title_3_clip.mp4" --preset="Fast 1080p30" --audio-lang-list=und
fi

# Title 5 (24:23 duration)
if [ -f "VIDEO_TS/VTS_05_1.VOB" ] && [ -s "VIDEO_TS/VTS_05_1.VOB" ]; then
    echo "🎬 Converting Title 5 (24:23)..."
    HandBrakeCLI -i . -t 5 -o "$OUTPUT_DIR/title_5_clip.mp4" --preset="Fast 1080p30" --audio-lang-list=und
fi

# Title 6 (25:34 duration)
if [ -f "VIDEO_TS/VTS_06_1.VOB" ]; then
    echo "🎬 Converting Title 6 (25:34)..."
    HandBrakeCLI -i . -t 6 -o "$OUTPUT_DIR/title_6_clip.mp4" --preset="Fast 1080p30" --audio-lang-list=und
fi

# Title 7 (4:16:29 duration) - longest clip
if [ -f "VIDEO_TS/VTS_07_1.VOB" ]; then
    echo "🎬 Converting Title 7 (4:16:29)..."
    HandBrakeCLI -i . -t 7 -o "$OUTPUT_DIR/title_7_clip.mp4" --preset="Fast 1080p30" --audio-lang-list=und
fi

echo ""
echo "🎉 Conversion complete!"
echo "📁 Check your clips in: $OUTPUT_DIR"
echo ""
echo "📊 Summary of available clips:"
echo "  - Title 1: 2:12 (short clip)"
echo "  - Title 2: 2:50 (short clip)" 
echo "  - Title 3: 3:43 (short clip, may have errors)"
echo "  - Title 5: 24:23 (medium clip)"
echo "  - Title 6: 25:34 (medium clip)"
echo "  - Title 7: 4:16:29 (long clip)"
echo ""
echo "💡 Next steps:"
echo "   - Add clips to Jellyfin library"
echo "   - Organize by date or content type"
echo "   - Check for any corrupted sections" 