#!/bin/bash

# 🎬 Thunderbolt Movie Migration to Jellyfin (Fixed)
# Move largest movies from Thunderbolt analysis to Jellyfin media library

echo "🎬 THUNDERBOLT MOVIE MIGRATION STARTED - $(date)"
echo "=================================================="

# Create Jellyfin movies directory if it doesn't exist
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
mkdir -p "$JELLYFIN_MOVIES"

# Log file for tracking
LOG_FILE="thunderbolt_movie_migration_fixed_$(date +%Y%m%d_%H%M%S).log"
echo "Migration started at $(date)" > "$LOG_FILE"

# Function to move movie with progress tracking
move_movie() {
    local source="$1"
    local filename=$(basename "$source")
    local destination="$JELLYFIN_MOVIES/$filename"
    
    echo "🎬 Moving: $filename"
    echo "📁 From: $source"
    echo "📁 To: $destination"
    
    # Check if destination already exists
    if [ -f "$destination" ]; then
        echo "⚠️  WARNING: $filename already exists in Jellyfin - SKIPPING"
        echo "SKIP: $filename (already exists)" >> "$LOG_FILE"
        return
    fi
    
    # Check if source exists
    if [ ! -f "$source" ]; then
        echo "⚠️  WARNING: Source file doesn't exist: $source"
        echo "MISSING: $source" >> "$LOG_FILE"
        return
    fi
    
    # Move the file with progress
    echo "🔄 Moving $(du -h "$source" | cut -f1) of data..."
    if mv "$source" "$destination"; then
        echo "✅ SUCCESS: $filename moved to Jellyfin"
        echo "SUCCESS: $filename" >> "$LOG_FILE"
    else
        echo "❌ ERROR: Failed to move $filename"
        echo "ERROR: $filename" >> "$LOG_FILE"
    fi
    echo "---"
}

# Extract largest movies from analysis and move them
echo "🔍 Extracting largest movies from Thunderbolt analysis..."

# Create a temporary file with properly formatted paths
TEMP_FILE="temp_movie_list.txt"
grep "mkv\|m4v\|mp4" thunderbolt_full_analysis.txt | sort -k2 -nr | head -20 > "$TEMP_FILE"

# Process each line properly
while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue
    
    # Extract file path (everything after the second space)
    file_path=$(echo "$line" | sed 's/^[^ ]* [^ ]* //')
    
    # Check if file still exists
    if [ -f "$file_path" ]; then
        move_movie "$file_path"
    else
        echo "⚠️  File no longer exists: $file_path"
        echo "MISSING: $file_path" >> "$LOG_FILE"
    fi
done < "$TEMP_FILE"

# Clean up temp file
rm -f "$TEMP_FILE"

echo "🎬 MIGRATION COMPLETE - $(date)"
echo "📊 Check log file: $LOG_FILE"
echo "📁 Movies moved to: $JELLYFIN_MOVIES" 