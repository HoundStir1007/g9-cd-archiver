#!/bin/bash

# Background Jellyfin Migration - Continue where we left off
# Runs in background to complete the migration safely

LOG_FILE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research/migration_background.log"

echo "🚀 Background Migration Started: $(date)" | tee -a "$LOG_FILE"
echo "=================================================================" | tee -a "$LOG_FILE"

SOURCE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media"
TARGET="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media"

# Remaining directories to move (excluding Music Videos and Concerts)
REMAINING_DIRS=(
    "movies"
    "music" 
    "music_archive_common"
    "music_quarantine"
    "music_rare_collection"
    "Riffing"
    "Stand-Up"
    "tv"
)

# Clean up partial home-videos first
echo "🧹 Cleaning up partial home-videos transfer..." | tee -a "$LOG_FILE"
if [ -d "$TARGET/home-videos" ]; then
    rm -rf "$TARGET/home-videos"
    echo "✅ Removed partial home-videos copy" | tee -a "$LOG_FILE"
fi

# Add home-videos back to migration list
ALL_DIRS=("home-videos" "${REMAINING_DIRS[@]}")

echo "📦 Directories to migrate:" | tee -a "$LOG_FILE"
for dir in "${ALL_DIRS[@]}"; do
    if [ -d "$SOURCE/$dir" ]; then
        size=$(du -sh "$SOURCE/$dir" | cut -f1)
        echo "  ✅ $dir ($size)" | tee -a "$LOG_FILE"
    else
        echo "  ❌ $dir (not found)" | tee -a "$LOG_FILE"
    fi
done

echo "" | tee -a "$LOG_FILE"
echo "🔒 EXCLUDED: Music Videos and Concerts (active Christmas ripping)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Move each directory with progress logging
for dir in "${ALL_DIRS[@]}"; do
    if [ -d "$SOURCE/$dir" ]; then
        echo "📦 Starting migration of $dir at $(date)" | tee -a "$LOG_FILE"
        
        # Use rsync with minimal output for background operation
        rsync -a --progress "$SOURCE/$dir/" "$TARGET/$dir/" >> "$LOG_FILE" 2>&1
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully moved $dir at $(date)" | tee -a "$LOG_FILE"
            # Remove source after successful copy
            rm -rf "$SOURCE/$dir"
            echo "🗑️  Removed source $dir at $(date)" | tee -a "$LOG_FILE"
        else
            echo "❌ Failed to move $dir at $(date)" | tee -a "$LOG_FILE"
            echo "   Check $LOG_FILE for details" | tee -a "$LOG_FILE"
            # Continue with other directories instead of exiting
        fi
        echo "" | tee -a "$LOG_FILE"
    fi
done

echo "🎉 Background migration completed at $(date)" | tee -a "$LOG_FILE"
echo "📊 Final structure:" | tee -a "$LOG_FILE"
ls -la "$TARGET/" >> "$LOG_FILE" 2>&1

echo "" | tee -a "$LOG_FILE"
echo "🎄 NEXT: Move 'Music Videos and Concerts' after Christmas ripping:" | tee -a "$LOG_FILE"
echo "   mv '$SOURCE/Music Videos and Concerts' '$TARGET/'" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "📝 Ready for next steps:" | tee -a "$LOG_FILE"
echo "   1. Update jellyfin-docker-compose.yml" | tee -a "$LOG_FILE"
echo "   2. Restart Jellyfin" | tee -a "$LOG_FILE"
echo "   3. Update library paths in Jellyfin web interface" | tee -a "$LOG_FILE"

# Create completion flag
touch "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research/migration_complete.flag" 