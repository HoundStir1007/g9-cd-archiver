#!/bin/bash

# DVD Content Salvage Script
# Extracts content from problematic DVD with multiple options

echo "🎬 DVD Content Salvage Tool"
echo "=========================="

# Check if DVD is mounted
if [ ! -d "/media/mark/SAMSUNG DVD RECORDER VOLUME" ]; then
    echo "❌ DVD not mounted. Please insert the DVD first."
    exit 1
fi

# Create output directory
OUTPUT_DIR="/mnt/storage/dvd_salvage_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"
echo "📁 Output directory: $OUTPUT_DIR"

echo ""
echo "🔍 Available options:"
echo "1. Complete DVD backup (all content)"
echo "2. Extract main feature only (Title Set 7)"
echo "3. Extract individual title sets"
echo "4. Quick HandBrake conversion"
echo "5. Just copy files to storage"
echo ""

read -p "Choose option (1-5): " choice

case $choice in
    1)
        echo "📀 Creating complete DVD backup..."
        sudo dvdbackup -i /dev/sr0 -o "$OUTPUT_DIR" -M
        echo "✅ Complete backup saved to: $OUTPUT_DIR"
        ;;
    2)
        echo "🎬 Extracting main feature (Title Set 7)..."
        sudo dvdbackup -i /dev/sr0 -o "$OUTPUT_DIR" -t 7
        echo "✅ Main feature saved to: $OUTPUT_DIR"
        ;;
    3)
        echo "📺 Extracting all title sets individually..."
        for i in {1..7}; do
            echo "Extracting Title Set $i..."
            sudo dvdbackup -i /dev/sr0 -o "$OUTPUT_DIR/title_$i" -t $i
        done
        echo "✅ All title sets saved to: $OUTPUT_DIR"
        ;;
    4)
        echo "🔄 Quick HandBrake conversion..."
        echo "Converting main feature to MP4..."
        HandBrakeCLI -i /dev/sr0 -t 7 -o "$OUTPUT_DIR/main_feature.mp4" --preset="Fast 1080p30"
        echo "✅ Converted to: $OUTPUT_DIR/main_feature.mp4"
        ;;
    5)
        echo "📋 Copying raw files to storage..."
        sudo cp -r "/media/mark/SAMSUNG DVD RECORDER VOLUME" "$OUTPUT_DIR/raw_dvd_files"
        echo "✅ Raw files copied to: $OUTPUT_DIR/raw_dvd_files"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "🎉 Salvage complete!"
echo "📁 Check your content in: $OUTPUT_DIR"
echo ""
echo "💡 Next steps:"
echo "   - Add to Jellyfin library"
echo "   - Convert to modern formats if needed"
echo "   - Organize in your media collection" 