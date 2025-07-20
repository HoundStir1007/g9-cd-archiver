#!/bin/bash

echo "🎬 MOVING BATCH 4 OF LARGE VIDEOS TO JELLYFIN"
echo "=============================================="
echo "🗑️  DUPLICATE CLEANUP INCLUDED"
echo ""

# Set source and destination directories
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
TRASH_DIR="/home/mark/.local/share/Trash/files"

# Create backup log
BACKUP_LOG="batch_4_move_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Moving Batch 4 Files (With Duplicate Cleanup)..."
echo "==========================================================="

# Function to move a file safely
move_file() {
    local source_file="$1"
    local filename="$2"
    local size_mb="$3"
    local destination="$4"
    
    if [ -f "$source_file" ]; then
        echo "🎬 Moving: $filename (${size_mb}MB)"
        echo "   From: $source_file"
        echo "   To: $destination/$filename"
        
        # Log before move
        echo "$(date): Moving $filename (${size_mb}MB) from $source_file to $destination/" >> "$BACKUP_LOG"
        
        # Move the file
        mv "$source_file" "$destination/$filename"
        
        if [ $? -eq 0 ]; then
            echo "   ✅ Moved successfully"
        else
            echo "   ❌ Failed to move"
        fi
    else
        echo "⚠️  File not found: $source_file"
    fi
}

# Move the 9 files to Jellyfin
echo "🔍 Moving files to Jellyfin..."

# 1. RISE_OF_THE_GUARDIANS.m4v (1.6GB) - First instance
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/RISE_OF_THE_GUARDIANS.m4v" "RISE_OF_THE_GUARDIANS.m4v" "1600" "$JELLYFIN_MOVIES"

# 2. Pitch.Perfect.2012.1080p.BRrip.264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Pitch Perfect (2012) [1080p]/Pitch.Perfect.2012.1080p.BRrip.264.YIFY.mp4" "Pitch.Perfect.2012.1080p.BRrip.264.YIFY.mp4" "1500" "$JELLYFIN_MOVIES"

# 3. Bridesmaids.2011.BRRip.XviD.Ac3.Feel-Free.avi (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Bridesmaids.2011.BRRip.XviD.Ac3.Feel-Free.avi" "Bridesmaids.2011.BRRip.XviD.Ac3.Feel-Free.avi" "1500" "$JELLYFIN_MOVIES"

# 4. Cars.m4v (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/Cars.m4v" "Cars.m4v" "1500" "$JELLYFIN_MOVIES"

# 5. The.Hobbit.An.Unexpected.Journey.2012.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hobbit An Unexpected Journey (2012) [1080p]/The.Hobbit.An.Unexpected.Journey.2012.1080p.BluRay.x264.YIFY.mp4" "The.Hobbit.An.Unexpected.Journey.2012.1080p.BluRay.x264.YIFY.mp4" "1500" "$JELLYFIN_MOVIES"

# 6. The.Hobbit.The.Desolation.of.Smaug.2013.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hobbit The Desolation of Smaug (2013) [1080p]/The.Hobbit.The.Desolation.of.Smaug.2013.1080p.BluRay.x264.YIFY.mp4" "The.Hobbit.The.Desolation.of.Smaug.2013.1080p.BluRay.x264.YIFY.mp4" "1500" "$JELLYFIN_MOVIES"

# 7. The.Hobbit.The.Battle.of.the.Five.Armies.2014.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hobbit The Battle of the Five Armies (2014) [1080p]/The.Hobbit.The.Battle.of.the.Five.Armies.2014.1080p.BluRay.x264.YIFY.mp4" "The.Hobbit.The.Battle.of.the.Five.Armies.2014.1080p.BluRay.x264.YIFY.mp4" "1500" "$JELLYFIN_MOVIES"

# 8. The.Hunger.Games.2012.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hunger Games (2012) [1080p]/The.Hunger.Games.2012.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.2012.1080p.BluRay.x264.YIFY.mp4" "1500" "$JELLYFIN_MOVIES"

# 9. The.Hunger.Games.Catching.Fire.2013.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hunger Games Catching Fire (2013) [1080p]/The.Hunger.Games.Catching.Fire.2013.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.Catching.Fire.2013.1080p.BluRay.x264.YIFY.mp4" "1500" "$JELLYFIN_MOVIES"

echo ""
echo "🗑️  STEP 2: Moving Duplicate to Trash..."
echo "========================================"

# Move duplicate to trash
echo "🗑️  Moving duplicate RISE_OF_THE_GUARDIANS.m4v to trash..."
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/Movies/RISE_OF_THE_GUARDIANS.m4v" "RISE_OF_THE_GUARDIANS_DUPLICATE.m4v" "1600" "$TRASH_DIR"

echo ""
echo "📊 STEP 3: Verification..."
echo "=========================="

# Check if files were moved successfully
echo "🔍 Verifying moved files in Jellyfin:"
for file in "RISE_OF_THE_GUARDIANS.m4v" "Pitch.Perfect.2012.1080p.BRrip.264.YIFY.mp4" "Bridesmaids.2011.BRRip.XviD.Ac3.Feel-Free.avi" "Cars.m4v" "The.Hobbit.An.Unexpected.Journey.2012.1080p.BluRay.x264.YIFY.mp4" "The.Hobbit.The.Desolation.of.Smaug.2013.1080p.BluRay.x264.YIFY.mp4" "The.Hobbit.The.Battle.of.the.Five.Armies.2014.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.2012.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.Catching.Fire.2013.1080p.BluRay.x264.YIFY.mp4"; do
    if [ -f "$JELLYFIN_MOVIES/$file" ]; then
        size=$(stat -c%s "$JELLYFIN_MOVIES/$file" 2>/dev/null || echo 0)
        size_mb=$((size / 1024 / 1024))
        echo "  ✅ $file (${size_mb}MB)"
    else
        echo "  ❌ $file (not found)"
    fi
done

echo ""
echo "🗑️  Checking duplicate in trash:"
if [ -f "$TRASH_DIR/RISE_OF_THE_GUARDIANS_DUPLICATE.m4v" ]; then
    size=$(stat -c%s "$TRASH_DIR/RISE_OF_THE_GUARDIANS_DUPLICATE.m4v" 2>/dev/null || echo 0)
    size_mb=$((size / 1024 / 1024))
    echo "  ✅ RISE_OF_THE_GUARDIANS_DUPLICATE.m4v (${size_mb}MB) - in trash"
else
    echo "  ❌ Duplicate not found in trash"
fi

echo ""
echo "📊 STEP 4: Space Savings Summary..."
echo "=================================="

echo "💾 SPACE SAVINGS:"
echo "  • Files moved to Jellyfin: 9 large video files"
echo "  • Total space moved: ~13.5GB to Jellyfin"
echo "  • Duplicate removed: 1.6GB to trash"
echo "  • Organized: Videos now in proper media library"
echo ""

echo "🎯 BATCH 4 MOVING COMPLETE!"
echo ""
echo "📋 Files are now available in Jellyfin media library:"
echo "  $JELLYFIN_MOVIES"
echo ""
echo "🗑️  Duplicate is in trash:"
echo "  $TRASH_DIR"
echo ""
echo "🚀 Ready for Jellyfin to scan and index these movies!" 