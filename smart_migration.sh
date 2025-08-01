#!/bin/bash

# Smart Jellyfin Migration - Handles big files better
# Moves one directory at a time for better control

LOG_FILE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research/smart_migration.log"

echo "🧠 Smart Migration Started: $(date)" | tee -a "$LOG_FILE"
echo "=================================================================" | tee -a "$LOG_FILE"

SOURCE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media"
TARGET="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media"

# All directories that need migration
DIRS_TO_MOVE=(
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

# Function to move directory with smart handling
move_directory() {
    local dir="$1"
    
    echo "📦 Starting migration of '$dir' at $(date)" | tee -a "$LOG_FILE"
    
    if [ ! -d "$SOURCE/$dir" ]; then
        echo "❌ Directory '$dir' not found in source" | tee -a "$LOG_FILE"
        return 1
    fi
    
    # Check directory size
    size=$(du -sh "$SOURCE/$dir" | cut -f1)
    echo "📊 Directory size: $size" | tee -a "$LOG_FILE"
    
    # Create target directory
    mkdir -p "$TARGET/$dir"
    
    # Use mv for faster operation on same filesystem
    echo "🚀 Moving $dir using mv (same filesystem)..." | tee -a "$LOG_FILE"
    
    # Move directory contents
    mv "$SOURCE/$dir"/* "$TARGET/$dir/" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully moved $dir at $(date)" | tee -a "$LOG_FILE"
        # Remove empty source directory
        rmdir "$SOURCE/$dir" 2>/dev/null
        return 0
    else
        echo "⚠️ mv failed, trying rsync as backup..." | tee -a "$LOG_FILE"
        
        # Fallback to rsync
        rsync -av --progress "$SOURCE/$dir/" "$TARGET/$dir/" >> "$LOG_FILE" 2>&1
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully moved $dir with rsync at $(date)" | tee -a "$LOG_FILE"
            rm -rf "$SOURCE/$dir"
            return 0
        else
            echo "❌ Failed to move $dir completely" | tee -a "$LOG_FILE"
            return 1
        fi
    fi
}

# Move each directory
for dir in "${DIRS_TO_MOVE[@]}"; do
    echo "" | tee -a "$LOG_FILE"
    move_directory "$dir"
    
    # Small pause between directories
    sleep 2
done

echo "" | tee -a "$LOG_FILE"
echo "🎉 Smart migration completed at $(date)" | tee -a "$LOG_FILE"
echo "📊 Final structure:" | tee -a "$LOG_FILE"
ls -la "$TARGET/" >> "$LOG_FILE" 2>&1

echo "" | tee -a "$LOG_FILE"
echo "🎄 NEXT: Move 'Music Videos and Concerts' after Christmas ripping" | tee -a "$LOG_FILE"
echo "   mv '$SOURCE/Music Videos and Concerts' '$TARGET/'" | tee -a "$LOG_FILE"

# Create completion flag
touch "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research/smart_migration_complete.flag" 