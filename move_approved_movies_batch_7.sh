#!/bin/bash

# 🎬 Approved Movies Batch 7 Migration to Jellyfin
# Move 25 approved feature films to Jellyfin media library

echo "🎬 APPROVED MOVIES BATCH 7 MIGRATION STARTED - $(date)"
echo "=================================================="

# Create Jellyfin movies directory if it doesn't exist
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
mkdir -p "$JELLYFIN_MOVIES"

# Log file for tracking
LOG_FILE="approved_movies_batch_7_$(date +%Y%m%d_%H%M%S).log"
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
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Tarzan.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Princess and the Frog.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Grand Budapest Hotel (2014)/The.Grand.Budapest.Hotel.2014.720p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Philomena (2013)/Philomena.2013.720p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Up In The Air.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Turbo (2013)/Turbo.2013.720p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Superman (1978)/Superman.1978.720.BrRip.264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Pulp Fiction (1994)/Pulp.Fiction.1994.720p.BrRip.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Rushmore (1998)/Rushmore.1998.720p.BluRay.x264.YIFY.mp4"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/I Love You Man.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Shrek.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Inglorious Basterds.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Shrek 2.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Wall-E.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The Pirates_ Band of Misfits.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Nine.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Hot Fuzz.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Casino Royale.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Strangers With Candy.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Shrek Forever After.m4v"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Moonrise.Kingdom.2012.LiMiTED.BRRip.XVID.AbSurdiTy/Moonrise.Kingdom.2012.LiMiTED.BRRip.XVID.AbSurdiTy.avi"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/X-Men Origins Wolverine (2009) DVDRip XviD-MAXSPEED/X-Men Origins Wolverine (2009) DVDRip XviD-MAXSPEED www.torentz.3xforum.ro.avi"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Beatles - Let it Be the Film - From Laser Disc DivX-ZoM/Beatles - Let It Be The Film DVD Ripp Grannyphone.avi"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/National.Lampoon's.Christmas.Vacation.DVDRip.XviD-hm1.avi"
    "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/Beetlejuice 1988 DvDrip[Eng]-greenbud1969.avi"
)

echo "🎬 Starting migration of 25 approved feature films..."
echo "📊 Total movies to process: ${#movies[@]}"
echo "---"

# Move each approved movie
for movie in "${movies[@]}"; do
    move_movie "$movie"
done

echo "🎬 BATCH 7 MIGRATION COMPLETE - $(date)"
echo "📊 Check log file: $LOG_FILE"
echo "📁 Movies moved to: $JELLYFIN_MOVIES"
echo "🎯 Total approved films processed: ${#movies[@]}" 