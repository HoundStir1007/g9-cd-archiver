#!/bin/bash

# 🎬 Approved Movies Batch 2 Migration to Jellyfin
# Move 25 approved feature films to Jellyfin media library

echo "🎬 APPROVED MOVIES BATCH 2 MIGRATION STARTED - $(date)"
echo "=================================================="

# Create Jellyfin movies directory if it doesn't exist
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
mkdir -p "$JELLYFIN_MOVIES"

# Log file for tracking
LOG_FILE="approved_movies_batch_2_$(date +%Y%m%d_%H%M%S).log"
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
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/The Breakfast Club.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Concert For George 1.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Indiana Jones Quadrilogy 1981 2008 Bluray 720p x264 aac/Indiana Jones 4 2008 Kingdom Of The Crystal Skull.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/Indiana Jones 2 1984 Temple Of Doom.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/Indiana Jones 1 1981 Raiders Of The Lost Ark.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Barry Lyndon.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/RiffTrax/RiffTrax Live House on Haunted Hill.avi"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Nick and Norah's Infinite Playlist.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Harry Potter and the Prisoner of Azkaban.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Harry Potter and the Sorcerer's Stone.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Little Fugitive.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Harry Potter and the Chamber of Secrets.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/George of the Jungle.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Love Actually.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/It Might Get Loud.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Dark Knight.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Dumb and Dumber (unrated).m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Rifftrax MKB - The Wizard Of Oz/Rifftrax MKB - The Wizard Of Oz 1939 75th Anniversary Edition 1080p.mkv"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Teenage Mutant Ninja Turtles.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Life of Brian.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/THE_GOONIES.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Hop.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Inception.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Darjeeling Limited[2007]DvDrip[Eng]-FXG/The.Darjeeling.Limited.2007.720p.BluRay.x264.anoXmous_.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Mr. Bean's Holiday.m4v"
)

echo "🎬 Starting migration of 25 approved feature films..."
echo "📊 Total movies to process: ${#movies[@]}"
echo "---"

# Move each approved movie
for movie in "${movies[@]}"; do
    move_movie "$movie"
done

echo "🎬 BATCH 2 MIGRATION COMPLETE - $(date)"
echo "📊 Check log file: $LOG_FILE"
echo "📁 Movies moved to: $JELLYFIN_MOVIES"
echo "🎯 Total approved films processed: ${#movies[@]}" 