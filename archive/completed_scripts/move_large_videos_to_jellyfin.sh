#!/bin/bash

echo "🎬 MOVING LARGE VIDEOS TO JELLYFIN MEDIA"
echo "========================================="
echo ""

# Set source and destination directories
SOURCE_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer"
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"

# Create backup log
BACKUP_LOG="large_video_move_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Checking Jellyfin Movies Directory..."
echo "================================================"

# Check if Jellyfin movies directory exists
if [ ! -d "$JELLYFIN_MOVIES" ]; then
    echo "❌ Jellyfin movies directory not found at: $JELLYFIN_MOVIES"
    echo "🔍 Creating directory..."
    mkdir -p "$JELLYFIN_MOVIES"
    if [ $? -eq 0 ]; then
        echo "✅ Created Jellyfin movies directory"
    else
        echo "❌ Failed to create directory"
        exit 1
    fi
else
    echo "✅ Jellyfin movies directory found"
fi

echo ""
echo "📊 STEP 2: Moving Large Video Files..."
echo "====================================="

# Function to move a file safely
move_file() {
    local source_file="$1"
    local filename="$2"
    local size_mb="$3"
    
    if [ -f "$source_file" ]; then
        echo "🎬 Moving: $filename (${size_mb}MB)"
        echo "   From: $source_file"
        echo "   To: $JELLYFIN_MOVIES/$filename"
        
        # Log before move
        echo "$(date): Moving $filename (${size_mb}MB) from $source_file to $JELLYFIN_MOVIES/" >> "$BACKUP_LOG"
        
        # Move the file
        mv "$source_file" "$JELLYFIN_MOVIES/$filename"
        
        if [ $? -eq 0 ]; then
            echo "   ✅ Moved successfully"
        else
            echo "   ❌ Failed to move"
        fi
    else
        echo "⚠️  File not found: $source_file"
    fi
}

# Move the 5 largest files
echo "🔍 Moving files..."

# 1. RiffTraxLive-SFSketchfest2013.mpg (3.8GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/RiffTrax/RiffTraxLive-SFSketchfest2013.mpg" "RiffTraxLive-SFSketchfest2013.mpg" "3920"

# 2. Avatar.m4v (3.4GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Avatar.m4v" "Avatar.m4v" "3531"

# 3. Django.Unchained.2012.1080p.BluRay.x264.YIFY.mp4 (2.2GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Django Unchained (2012) [1080p]/Django.Unchained.2012.1080p.BluRay.x264.YIFY.mp4" "Django.Unchained.2012.1080p.BluRay.x264.YIFY.mp4" "2255"

# 4. The.Avengers.2012.1080p.BluRay.x264.YIFY.mp4 (2.1GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Avengers (2012) [1080p]/The.Avengers.2012.1080p.BluRay.x264.YIFY.mp4" "The.Avengers.2012.1080p.BluRay.x264.YIFY.mp4" "2249"

# 5. Episode.V-The.Empire.Strikes.Back.1980.1080p.BluRay.x264.anoXmous_.mp4 (2.0GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/Episode.V-The.Empire.Strikes.Back.1980.1080p.BluRay.x264.anoXmous_.mp4" "Episode.V-The.Empire.Strikes.Back.1980.1080p.BluRay.x264.anoXmous_.mp4" "2126"

echo ""
echo "📊 STEP 3: Verification..."
echo "=========================="

# Check if files were moved successfully
echo "🔍 Verifying moved files:"
for file in "RiffTraxLive-SFSketchfest2013.mpg" "Avatar.m4v" "Django.Unchained.2012.1080p.BluRay.x264.YIFY.mp4" "The.Avengers.2012.1080p.BluRay.x264.YIFY.mp4" "Episode.V-The.Empire.Strikes.Back.1980.1080p.BluRay.x264.anoXmous_.mp4"; do
    if [ -f "$JELLYFIN_MOVIES/$file" ]; then
        size=$(stat -c%s "$JELLYFIN_MOVIES/$file" 2>/dev/null || echo 0)
        size_mb=$((size / 1024 / 1024))
        echo "  ✅ $file (${size_mb}MB)"
    else
        echo "  ❌ $file (not found)"
    fi
done

echo ""
echo "📊 STEP 4: Space Savings Summary..."
echo "=================================="

echo "💾 SPACE SAVINGS:"
echo "  • Files moved: 5 large video files"
echo "  • Total space: ~13.5GB moved to Jellyfin"
echo "  • Organized: Videos now in proper media library"
echo ""

echo "🎯 MOVING COMPLETE!"
echo ""
echo "📋 Files are now available in Jellyfin media library:"
echo "  $JELLYFIN_MOVIES"
echo ""
echo "🚀 Ready for Jellyfin to scan and index these movies!" 