#!/bin/bash

echo "🎬 MOVING NEXT BATCH OF LARGE VIDEOS TO JELLYFIN"
echo "================================================"
echo ""

# Set source and destination directories
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"

# Create backup log
BACKUP_LOG="next_batch_move_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Moving Next Batch of Large Files..."
echo "=============================================="

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

# Move the next batch of 10 large files
echo "🔍 Moving files..."

# 1. RifftraxLive-Sketchfest2015_highTV.mp4 (2.0GB) - Canvio
move_file "/media/mark/paperless-ssd/digital_consolidation/canvio_transfer/mac_mini_files/Downloads/RifftraxLive-Sketchfest2015_highTV.mp4" "RifftraxLive-Sketchfest2015_highTV.mp4" "2114"

# 2. Avengers.Age.of.Ultron.2015.1080p.BluRay.x264.YIFY.mp4 (2.0GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Avengers Age of Ultron (2015) [1080p]/Avengers.Age.of.Ultron.2015.1080p.BluRay.x264.YIFY.mp4" "Avengers.Age.of.Ultron.2015.1080p.BluRay.x264.YIFY.mp4" "2103"

# 3. The.Wolverine.2013.1080p.BluRay.x264.YIFY.mp4 (2.0GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Wolverine (2013) [1080p]/The.Wolverine.2013.1080p.BluRay.x264.YIFY.mp4" "The.Wolverine.2013.1080p.BluRay.x264.YIFY.mp4" "2090"

# 4. Episode.IV-A.New.Hope.1977.1080p.BluRay.x264.anoXmous_.mp4 (2.0GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Music/Star Wars Complete/1.Episode.IV-A.New.Hope.1977.1080p.BluRay.x264.anoXmous/Episode.IV-A.New.Hope.1977.1080p.BluRay.x264.anoXmous_.mp4" "Episode.IV-A.New.Hope.1977.1080p.BluRay.x264.anoXmous_.mp4" "2083"

# 5. The.Avengers.m4v (1.9GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/The.Avengers.m4v" "The.Avengers.m4v" "2019"

# 6. Captain.America.The.Winter.Soldier.2014.1080p.BluRay.x264.YIFY.mp4 (1.9GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Captain America The Winter Soldier (2014) [1080p]/Captain.America.The.Winter.Soldier.2014.1080p.BluRay.x264.YIFY.mp4" "Captain.America.The.Winter.Soldier.2014.1080p.BluRay.x264.YIFY.mp4" "2006"

# 7. Iron.Man.3.2013.1080p.BluRay.x264.YIFY.mp4 (1.9GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Iron.Man.3.2013.1080p.BluRay.x264.YIFY.mp4" "Iron.Man.3.2013.1080p.BluRay.x264.YIFY.mp4" "1998"

# 8. Life.of.Pi.2012.1080p.BRrip.x264.GAZ.YIFY.mp4 (1.8GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Life of Pi (2012) [1080p]/Life.of.Pi.2012.1080p.BRrip.x264.GAZ.YIFY.mp4" "Life.of.Pi.2012.1080p.BRrip.x264.GAZ.YIFY.mp4" "1944"

# 9. Guardians.of.the.Galaxy.2014.1080p.BluRay.x264.YIFY.mp4 (1.8GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Guardians of the Galaxy (2014) [1080p]/Guardians.of.the.Galaxy.2014.1080p.BluRay.x264.YIFY.mp4" "Guardians.of.the.Galaxy.2014.1080p.BluRay.x264.YIFY.mp4" "1896"

# 10. BEASTSOFTHESOUTHERNWILD.m4v (1.8GB) - Plex
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/BEASTSOFTHESOUTHERNWILD.m4v" "BEASTSOFTHESOUTHERNWILD.m4v" "1882"

echo ""
echo "📊 STEP 2: Verification..."
echo "=========================="

# Check if files were moved successfully
echo "🔍 Verifying moved files:"
for file in "RifftraxLive-Sketchfest2015_highTV.mp4" "Avengers.Age.of.Ultron.2015.1080p.BluRay.x264.YIFY.mp4" "The.Wolverine.2013.1080p.BluRay.x264.YIFY.mp4" "Episode.IV-A.New.Hope.1977.1080p.BluRay.x264.anoXmous_.mp4" "The.Avengers.m4v" "Captain.America.The.Winter.Soldier.2014.1080p.BluRay.x264.YIFY.mp4" "Iron.Man.3.2013.1080p.BluRay.x264.YIFY.mp4" "Life.of.Pi.2012.1080p.BRrip.x264.GAZ.YIFY.mp4" "Guardians.of.the.Galaxy.2014.1080p.BluRay.x264.YIFY.mp4" "BEASTSOFTHESOUTHERNWILD.m4v"; do
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
echo "  • Files moved: 10 large video files"
echo "  • Total space: ~20GB moved to Jellyfin"
echo "  • Organized: Videos now in proper media library"
echo ""

echo "🎯 NEXT BATCH MOVING COMPLETE!"
echo ""
echo "📋 Files are now available in Jellyfin media library:"
echo "  $JELLYFIN_MOVIES"
echo ""
echo "🚀 Ready for Jellyfin to scan and index these movies!" 