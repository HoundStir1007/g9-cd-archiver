#!/bin/bash

echo "🎬 MOVING BATCH 3 OF LARGE VIDEOS TO JELLYFIN"
echo "=============================================="
echo ""

# Set source and destination directories
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"

# Create backup log
BACKUP_LOG="batch_3_move_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Moving Batch 3 Files (Excluding Personal Video)..."
echo "============================================================="

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

# Move the 9 files (excluding personal video)
echo "🔍 Moving files..."

# 1. The.Neverending.Story.1984.1080p.BluRay.x264.anoXmous.mp4 (1.8GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/The.Neverending.Story.1984.1080p.BluRay.x264.anoXmous.mp4" "The.Neverending.Story.1984.1080p.BluRay.x264.anoXmous.mp4" "1844"

# 2. NEWSIES.m4v (1.7GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Clips/80s clips/NEWSIES.m4v" "NEWSIES.m4v" "1788"

# 3. the.dark.knight.rises.2012.1080p.bluray.x264-alliance.m4v (1.7GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/the.dark.knight.rises.2012.1080p.bluray.x264-alliance.m4v" "the.dark.knight.rises.2012.1080p.bluray.x264-alliance.m4v" "1755"

# 4. ti40UnKnOwN.avi (1.6GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/This Is 40 2012 DVD Screener Xvid UnKnOwN/ti40UnKnOwN.avi" "ti40UnKnOwN.avi" "1688"

# 5. Home.Alone.1990.1080p.BluRay.x264.YIFY.mp4 (1.6GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/X-Mas/Home Alone (1990) [1080p]/Home.Alone.1990.1080p.BluRay.x264.YIFY.mp4" "Home.Alone.1990.1080p.BluRay.x264.YIFY.mp4" "1655"

# 6. Big.Hero.6.2014.1080p.BluRay.x264.YIFY.mp4 (1.6GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Big Hero 6 (2014) [1080p]/Big.Hero.6.2014.1080p.BluRay.x264.YIFY.mp4" "Big.Hero.6.2014.1080p.BluRay.x264.YIFY.mp4" "1633"

# 7. Lets.Be.Cops.2014.1080p.BluRay.x264.YIFY.mp4 (1.6GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Let's Be Cops (2014) [1080p]/Lets.Be.Cops.2014.1080p.BluRay.x264.YIFY.mp4" "Lets.Be.Cops.2014.1080p.BluRay.x264.YIFY.mp4" "1622"

# 8. Frozen.2013.1080p.BluRay.x264.YIFY.mp4 (1.6GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Frozen (2013) [1080p]/Frozen.2013.1080p.BluRay.x264.YIFY.mp4" "Frozen.2013.1080p.BluRay.x264.YIFY.mp4" "1611"

# 9. RiffTraxLive-SFSketchfest2013_Tablet.mp4 (1.6GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/RiffTrax/RiffTraxLive-SFSketchfest2013_Tablet.mp4" "RiffTraxLive-SFSketchfest2013_Tablet.mp4" "1600"

echo ""
echo "📊 STEP 2: Verification..."
echo "=========================="

# Check if files were moved successfully
echo "🔍 Verifying moved files:"
for file in "The.Neverending.Story.1984.1080p.BluRay.x264.anoXmous.mp4" "NEWSIES.m4v" "the.dark.knight.rises.2012.1080p.bluray.x264-alliance.m4v" "ti40UnKnOwN.avi" "Home.Alone.1990.1080p.BluRay.x264.YIFY.mp4" "Big.Hero.6.2014.1080p.BluRay.x264.YIFY.mp4" "Lets.Be.Cops.2014.1080p.BluRay.x264.YIFY.mp4" "Frozen.2013.1080p.BluRay.x264.YIFY.mp4" "RiffTraxLive-SFSketchfest2013_Tablet.mp4"; do
    if [ -f "$JELLYFIN_MOVIES/$file" ]; then
        size=$(stat -c%s "$JELLYFIN_MOVIES/$file" 2>/dev/null || echo 0)
        size_mb=$((size / 1024 / 1024))
        echo "  ✅ $file (${size_mb}MB)"
    else
        echo "  ❌ $file (not found)"
    fi
done

echo ""
echo "📊 STEP 3: Space Savings Summary..."
echo "=================================="

echo "💾 SPACE SAVINGS:"
echo "  • Files moved: 9 large video files"
echo "  • Total space: ~14.4GB moved to Jellyfin"
echo "  • Skipped: 1 personal video file (im3mutelego.mov)"
echo "  • Organized: Videos now in proper media library"
echo ""

echo "🎯 BATCH 3 MOVING COMPLETE!"
echo ""
echo "📋 Files are now available in Jellyfin media library:"
echo "  $JELLYFIN_MOVIES"
echo ""
echo "🚀 Ready for Jellyfin to scan and index these movies!" 