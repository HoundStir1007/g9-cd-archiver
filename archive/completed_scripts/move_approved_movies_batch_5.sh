#!/bin/bash

# 🎬 Approved Movies Batch 5 Migration to Jellyfin
# Move 25 approved feature films to Jellyfin media library

echo "🎬 APPROVED MOVIES BATCH 5 MIGRATION STARTED - $(date)"
echo "=================================================="

# Create Jellyfin movies directory if it doesn't exist
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
mkdir -p "$JELLYFIN_MOVIES"

# Log file for tracking
LOG_FILE="approved_movies_batch_5_$(date +%Y%m%d_%H%M%S).log"
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

# List of approved movies with their full paths
declare -a movies=(
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/A Bug's Life.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Hotel Transylvania.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Megamind.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Mother (1996) DVDRip x264.mkv"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/FRIENDS_WITH_KIDS.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/My Neighbor Totoro.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Spy Kids 4 All the Time In The World.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Postcards From The Edge.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Teenage Mutant Ninja Turtles 2.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Big Chill.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Lorax.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Sixteen Candles.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Kung-Fu Panda 2.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Lego_ The Adventures of Clutch Powers.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Away We Go.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Alpha and Omega.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Sky High.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Louis C.K._ Live at the Beacon Theater.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Hangover.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Monty Python and the Holy Grail.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Despicable Me.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Monsters vs. Aliens.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Ice Age 4 - Continental Drift.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Flushed Away.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Horton Hears a Who.m4v"
)

echo "🎬 Starting migration of 25 approved feature films..."
echo "📊 Total movies to process: ${#movies[@]}"
echo "---"

# Move each approved movie
for movie in "${movies[@]}"; do
    move_movie "$movie"
done

echo "🎬 BATCH 5 MIGRATION COMPLETE - $(date)"
echo "📊 Check log file: $LOG_FILE"
echo "📁 Movies moved to: $JELLYFIN_MOVIES"
echo "🎯 Total approved films processed: ${#movies[@]}" 