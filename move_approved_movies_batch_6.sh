#!/bin/bash

# 🎬 Approved Movies Batch 6 Migration to Jellyfin
# Move 25 approved feature films to Jellyfin media library

echo "🎬 APPROVED MOVIES BATCH 6 MIGRATION STARTED - $(date)"
echo "=================================================="

# Create Jellyfin movies directory if it doesn't exist
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
mkdir -p "$JELLYFIN_MOVIES"

# Log file for tracking
LOG_FILE="approved_movies_batch_6_$(date +%Y%m%d_%H%M%S).log"
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
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Zookeeper.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Bean.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/A_MONSTER_IN_PARIS.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Hangover 2.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Chicken Run.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Jungle Book 2/The Jungle Book 2.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/ASTRO_BOY.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Wallace and Grommit_ The Curse of the Were-Rabbit.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Hunger Games.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/MACGRUBER-1.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Zoom Academy For Superheroes.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/National Lampoon's Vacation (1983).mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Fantastic Mr. Fox.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/RobDelaney - Live at the Bowery Ballroom.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Toy Story 3.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Fun and Fancy Free.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Here Comes Science.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Madagascar 3_ Europe's Most Wanted.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Great Gatsby (2013)/The.Great.Gatsby.2013.720p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/MACGRUBER-2theatrical.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Tarzan and Jane.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Sword In The Stone.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Peter Pan.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Inspector Gadget.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Big Tease.m4v"
)

echo "🎬 Starting migration of 25 approved feature films..."
echo "📊 Total movies to process: ${#movies[@]}"
echo "---"

# Move each approved movie
for movie in "${movies[@]}"; do
    move_movie "$movie"
done

echo "🎬 BATCH 6 MIGRATION COMPLETE - $(date)"
echo "📊 Check log file: $LOG_FILE"
echo "📁 Movies moved to: $JELLYFIN_MOVIES"
echo "🎯 Total approved films processed: ${#movies[@]}" 