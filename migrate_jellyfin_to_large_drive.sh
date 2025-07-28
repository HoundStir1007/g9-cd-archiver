#!/bin/bash

# Jellyfin Media Migration Script
# Moves Jellyfin media from paperless-ssd to large drive
# Created: January 28, 2025

set -e  # Exit on any error

echo "🎬 Jellyfin Media Migration Script"
echo "=================================="

# Define source and destination
SOURCE="/media/mark/paperless-ssd1/jellyfin/media"
DEST="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media"

# Create destination directory structure
echo "📁 Creating destination directory structure..."
mkdir -p "$DEST"

# Function to safely move directory
move_directory() {
    local source="$1"
    local dest="$2"
    local name="$3"
    
    if [ -d "$source" ]; then
        echo "🔄 Moving $name..."
        echo "   From: $source"
        echo "   To:   $dest"
        
        # Check if destination already exists
        if [ -d "$dest" ]; then
            echo "⚠️  Destination already exists! Skipping $name"
            return
        fi
        
        # Move with progress
        rsync -av --progress "$source/" "$dest/"
        if [ $? -eq 0 ]; then
            echo "✅ Successfully moved $name"
            # Remove source after successful move
            rm -rf "$source"
            echo "🗑️  Removed source directory"
        else
            echo "❌ Failed to move $name"
            exit 1
        fi
    else
        echo "⚠️  Source directory not found: $source"
    fi
    echo ""
}

# Move each media directory
echo "🚀 Starting migration..."

echo "⏸️  SKIPPING Movies folder - Muppets rip in progress!"
echo "   Will migrate movies separately after rip completes"
echo ""

move_directory "$SOURCE/music" "$DEST/music" "Music (40GB)"
move_directory "$SOURCE/music_archive_common" "$DEST/music_archive_common" "Music Archive (116GB)"
move_directory "$SOURCE/tv" "$DEST/tv" "TV Shows (46GB)"
move_directory "$SOURCE/home-videos" "$DEST/home-videos" "Home Videos (62GB)"
move_directory "$SOURCE/Stand-Up" "$DEST/Stand-Up" "Stand-Up (3.5GB)"
move_directory "$SOURCE/Riffing" "$DEST/Riffing" "Riffing (12GB)"
move_directory "$SOURCE/Music Videos and Concerts" "$DEST/Music Videos and Concerts" "Music Videos (17GB)"
move_directory "$SOURCE/AtmosFX" "$DEST/AtmosFX" "AtmosFX (110GB)"
move_directory "$SOURCE/books" "$DEST/books" "Books (576MB)"
move_directory "$SOURCE/music_quarantine" "$DEST/music_quarantine" "Music Quarantine (93MB)"
move_directory "$SOURCE/music_rare_collection" "$DEST/music_rare_collection" "Music Rare Collection (40KB)"

echo "🎉 Migration complete!"
echo ""
echo "📊 Space freed on paperless-ssd:"
du -sh "$SOURCE" 2>/dev/null || echo "Source directory removed"
echo ""
echo "📊 New space used on large drive:"
du -sh "$DEST" 2>/dev/null
echo ""
echo "🔧 Next steps:"
echo "1. Update Jellyfin docker-compose.yml with new paths"
echo "2. Restart Jellyfin container"
echo "3. Verify all media is accessible" 