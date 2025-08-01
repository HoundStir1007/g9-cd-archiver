#!/bin/bash

# 🎬 Finalize Paula Poundstone Subtitle Fix
# Run this ONLY after testing the fixed file and confirming it works perfectly

echo "🎬 Finalizing Paula Poundstone subtitle fix..."

ORIGINAL="/media/mark/paperless-ssd/jellyfin/media/movies/Paula Poundstone Cats Cops and Stuff (INCOMPLETE).mp4"
FIXED="/media/mark/paperless-ssd/jellyfin/media/movies/Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_FIXED.mp4"
BACKUP="/media/mark/paperless-ssd/jellyfin/media/movies/Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_BACKUP.mp4"

echo "⚠️  WARNING: This will replace the original file with the fixed version!"
echo "Make sure you've tested the _FIXED.mp4 file first!"
echo ""
read -p "Are you sure the fixed file works perfectly? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
    echo "🔄 Replacing original with fixed version..."
    mv "$FIXED" "$ORIGINAL"
    echo "✅ Done! Fixed version is now the main file."
    echo "💾 Backup remains at: Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_BACKUP.mp4"
    echo ""
    echo "🎬 Your Paula Poundstone movie now has properly synchronized subtitles! ✨"
else
    echo "❌ Operation cancelled. Test the _FIXED.mp4 file first!"
fi 