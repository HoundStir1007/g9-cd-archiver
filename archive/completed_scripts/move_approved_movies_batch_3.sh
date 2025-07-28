#!/bin/bash

# 🎬 Approved Movies Batch 3 Migration to Jellyfin
# Move 15 approved feature films to Jellyfin media library

echo "🎬 APPROVED MOVIES BATCH 3 MIGRATION STARTED - $(date)"
echo "=================================================="

# Create Jellyfin movies directory if it doesn't exist
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
mkdir -p "$JELLYFIN_MOVIES"

# Log file for tracking
LOG_FILE="approved_movies_batch_3_$(date +%Y%m%d_%H%M%S).log"
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
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/E.T. The Extra Terrestrial.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Adventures of Sharkboy and Lava Girl.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Toy.Story.Of.Terror.2013.1080p.BluRay.x264-SNOW[rarbg]/snow-toy.story.of.terror.2013.1080p.bluray.x264.mkv"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Dinner for Schmucks.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Grand Budapest Hotel (2014) [1080p]/The.Grand.Budapest.Hotel.2014.1080p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Inside Out (2015) [1080p]/Inside.Out.2015.1080p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Reality Bites (1994) [1080p]/Reality.Bites.1994.1080p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Mr. Peabody and Sherman (2014) [1080p]/Mr..Peabody.and.Sherman.2014.1080p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Muppet Movie (1979) [1080p]/The.Muppet.Movie.1979.1080p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Gran Torino.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Birdemic_ Shock and Terror.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Ghost Town.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Madagascar 2.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Wreck.it.Ralph.2012.1080p.BrRip.x264.BOKUTOX.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/X-Mas/How the Grinch Stole Christmas (2000) [1080p]/How.the.Grinch.Stole.Christmas.2000.1080p.BrRip.x264.BOKUTOX.YIFY.mp4"
)

echo "🎬 Starting migration of 15 approved feature films..."
echo "📊 Total movies to process: ${#movies[@]}"
echo "---"

# Move each approved movie
for movie in "${movies[@]}"; do
    move_movie "$movie"
done

echo "🎬 BATCH 3 MIGRATION COMPLETE - $(date)"
echo "📊 Check log file: $LOG_FILE"
echo "📁 Movies moved to: $JELLYFIN_MOVIES"
echo "🎯 Total approved films processed: ${#movies[@]}" 