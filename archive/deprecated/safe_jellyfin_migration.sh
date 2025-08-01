#!/bin/bash

# Safe Jellyfin Media Migration Script
# Moves from /jellyfin/media/ to /media/ while preserving active ripping

echo "🚀 Safe Jellyfin Media Migration - Excluding Active Christmas Ripping"
echo "=================================================================="

SOURCE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media"
TARGET="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media"

# Create target directory if it doesn't exist
mkdir -p "$TARGET"

echo "📂 Source: $SOURCE"
echo "📂 Target: $TARGET"
echo ""

# List of directories to move (excluding Music Videos and Concerts)
DIRS_TO_MOVE=(
    "AtmosFX"
    "audiobooks" 
    "books"
    "comedy"
    "home-videos"
    "movies"
    "music"
    "music_archive_common"
    "music_quarantine"
    "music_rare_collection"
    "Riffing"
    "Stand-Up"
    "tv"
)

echo "🎯 Directories to migrate:"
for dir in "${DIRS_TO_MOVE[@]}"; do
    if [ -d "$SOURCE/$dir" ]; then
        size=$(du -sh "$SOURCE/$dir" | cut -f1)
        echo "  ✅ $dir ($size)"
    else
        echo "  ❌ $dir (not found)"
    fi
done

echo ""
echo "🔒 EXCLUDED (for safety):"
if [ -d "$SOURCE/Music Videos and Concerts" ]; then
    size=$(du -sh "$SOURCE/Music Videos and Concerts" | cut -f1)
    echo "  🎄 Music Videos and Concerts ($size) - Contains active Christmas ripping"
else
    echo "  ❌ Music Videos and Concerts (not found)"
fi

echo ""
read -p "Continue with migration? (y/N): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ Migration cancelled"
    exit 1
fi

echo ""
echo "🚀 Starting migration..."

# Move each directory
for dir in "${DIRS_TO_MOVE[@]}"; do
    if [ -d "$SOURCE/$dir" ]; then
        echo "📦 Moving $dir..."
        
        # Use rsync for safe move with progress
        rsync -av --progress "$SOURCE/$dir/" "$TARGET/$dir/"
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully moved $dir"
            # Remove source after successful copy
            rm -rf "$SOURCE/$dir"
            echo "🗑️  Removed source $dir"
        else
            echo "❌ Failed to move $dir"
            exit 1
        fi
        echo ""
    fi
done

echo "🎉 Migration complete!"
echo ""
echo "📊 New structure:"
ls -la "$TARGET/"

echo ""
echo "🎄 REMINDER: Move 'Music Videos and Concerts' after Christmas ripping is complete:"
echo "   mv '$SOURCE/Music Videos and Concerts' '$TARGET/'"
echo ""
echo "📝 Next steps:"
echo "   1. Update jellyfin-docker-compose.yml"
echo "   2. Restart Jellyfin"
echo "   3. Update library paths in Jellyfin web interface" 