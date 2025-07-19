#!/bin/bash

# 🎵 Quarantine Problematic Music Files
# Identifies and moves files causing Jellyfin scanning issues

echo "🎵 Identifying problematic music files..."

MUSIC_DIR="/media/mark/paperless-ssd/jellyfin/media/music"
QUARANTINE_DIR="/media/mark/paperless-ssd/jellyfin/media/music_quarantine"

# Create quarantine directory
mkdir -p "$QUARANTINE_DIR"

echo "📁 Created quarantine directory: $QUARANTINE_DIR"
echo ""

# Function to test a file with ffprobe
test_file() {
    local file="$1"
    local result
    
    # Test with ffprobe and capture any errors
    result=$(ffprobe -v error -show_format -show_streams "$file" 2>&1)
    
    # Check for specific problematic patterns
    if echo "$result" | grep -q "Unsupported codec with id 98314\|Invalid data found\|No such file\|Permission denied\|timescale not set"; then
        return 1  # File is problematic
    else
        return 0  # File is OK
    fi
}

# Find and test files
echo "🔍 Scanning for problematic files..."
PROBLEMATIC_COUNT=0
TOTAL_COUNT=0

# Test the specific file we know is problematic
KNOWN_PROBLEM="/media/mark/paperless-ssd/jellyfin/media/music/One High Five/OC ROCK RADIO/OCROCKRADIO 3-21-2011.m4a"
if [ -f "$KNOWN_PROBLEM" ]; then
    echo "🎯 Testing known problematic file: OCROCKRADIO 3-21-2011.m4a"
    if ! test_file "$KNOWN_PROBLEM"; then
        echo "❌ Confirmed problematic: OCROCKRADIO 3-21-2011.m4a"
        
        # Create directory structure in quarantine
        REL_PATH=$(dirname "${KNOWN_PROBLEM#$MUSIC_DIR/}")
        mkdir -p "$QUARANTINE_DIR/$REL_PATH"
        
        # Move the file
        mv "$KNOWN_PROBLEM" "$QUARANTINE_DIR/$REL_PATH/"
        echo "📦 Quarantined: $REL_PATH/OCROCKRADIO 3-21-2011.m4a"
        ((PROBLEMATIC_COUNT++))
    fi
fi

# Quick scan for other obviously problematic files
echo ""
echo "🔍 Quick scan for other problematic files..."

# Look for files with unusual extensions or patterns that might cause issues
find "$MUSIC_DIR" -type f \( -name "*.tmp" -o -name ".*" -o -name "*~" \) 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        echo "🗑️  Found temp/hidden file: $(basename "$file")"
        REL_PATH=$(dirname "${file#$MUSIC_DIR/}")
        mkdir -p "$QUARANTINE_DIR/temp_files/$REL_PATH"
        mv "$file" "$QUARANTINE_DIR/temp_files/$REL_PATH/"
        echo "📦 Quarantined: $REL_PATH/$(basename "$file")"
        ((PROBLEMATIC_COUNT++))
    fi
done

# Look for zero-byte files
find "$MUSIC_DIR" -type f -size 0 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        echo "📭 Found zero-byte file: $(basename "$file")"
        REL_PATH=$(dirname "${file#$MUSIC_DIR/}")
        mkdir -p "$QUARANTINE_DIR/zero_byte/$REL_PATH"
        mv "$file" "$QUARANTINE_DIR/zero_byte/$REL_PATH/"
        echo "📦 Quarantined: $REL_PATH/$(basename "$file")"
        ((PROBLEMATIC_COUNT++))
    fi
done

echo ""
echo "📊 QUARANTINE SUMMARY:"
echo "   Files quarantined: $PROBLEMATIC_COUNT"
echo "   Quarantine location: $QUARANTINE_DIR"
echo ""
echo "🎵 Your music library should now scan more reliably!"
echo "   Go to Jellyfin → Dashboard → Libraries → Music → Scan Library"
echo ""
echo "💡 To restore quarantined files later:"
echo "   mv $QUARANTINE_DIR/* $MUSIC_DIR/" 