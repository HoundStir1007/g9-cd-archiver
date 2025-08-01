#!/bin/bash

# Movies Migration Script (Run after Muppets rip completes)
# Moves movies from paperless-ssd to large drive
# Created: January 28, 2025

set -e  # Exit on any error

echo "🎬 Movies Migration Script"
echo "=========================="

# Define source and destination
SOURCE="/media/mark/paperless-ssd1/jellyfin/media/movies"
DEST="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/movies"

# Check if movies folder exists
if [ ! -d "$SOURCE" ]; then
    echo "❌ Movies folder not found: $SOURCE"
    exit 1
fi

# Check if destination already exists
if [ -d "$DEST" ]; then
    echo "⚠️  Movies destination already exists: $DEST"
    echo "   This means movies were already migrated!"
    exit 1
fi

echo "📁 Creating destination directory..."
mkdir -p "$DEST"

echo "🔄 Moving Movies folder..."
echo "   From: $SOURCE"
echo "   To:   $DEST"
echo "   Size: $(du -sh "$SOURCE" | cut -f1)"

# Move with progress
rsync -av --progress "$SOURCE/" "$DEST/"
if [ $? -eq 0 ]; then
    echo "✅ Successfully moved Movies folder"
    # Remove source after successful move
    rm -rf "$SOURCE"
    echo "🗑️  Removed source directory"
else
    echo "❌ Failed to move Movies folder"
    exit 1
fi

echo ""
echo "🎉 Movies migration complete!"
echo ""
echo "📊 Space freed on paperless-ssd:"
du -sh "$SOURCE" 2>/dev/null || echo "Source directory removed"
echo ""
echo "📊 New space used on large drive:"
du -sh "$DEST" 2>/dev/null
echo ""
echo "🔧 Next steps:"
echo "1. Update Jellyfin library path for movies"
echo "2. Test movie playback in Jellyfin"
echo "3. Verify all movies are accessible" 