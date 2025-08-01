#!/bin/bash

# 🎵 Restore Over-Quarantined Files & Fix Properly
# Only quarantine actual problematic files (macOS metadata)

echo "🔄 Restoring legitimate music files..."

MUSIC_DIR="/media/mark/paperless-ssd/jellyfin/media/music"
QUARANTINE_DIR="/media/mark/paperless-ssd/jellyfin/media/music_quarantine"

# First, restore ALL quarantined files back to music directory
echo "📁 Restoring all files back to music library..."
if [ -d "$QUARANTINE_DIR" ]; then
    cd "$QUARANTINE_DIR"
    find . -type f -exec cp --parents {} "$MUSIC_DIR/" \;
    echo "✅ All files restored"
else
    echo "⚠️  Quarantine directory not found"
fi

# Now remove only the actual problematic files (macOS metadata)
echo "🧹 Removing only actual problematic files..."

cd "$MUSIC_DIR"

# Remove .DS_Store files
echo "Removing .DS_Store files..."
find . -name ".DS_Store" -type f -delete
echo "✅ .DS_Store files removed"

# Remove ._ files (macOS resource forks)
echo "Removing ._ metadata files..."
find . -name "._*" -type f -delete  
echo "✅ ._ metadata files removed"

# Remove empty directories left behind
echo "Cleaning up empty directories..."
find . -type d -empty -delete 2>/dev/null
echo "✅ Empty directories cleaned"

# Count final results
echo ""
echo "📊 Final Results:"
echo "Total music files now: $(find . -type f | wc -l)"
echo "🎵 Ready for clean library scan!" 