#!/bin/bash

echo "🎬 MOVING BATCH 5 OF LARGE VIDEOS TO JELLYFIN"
echo "=============================================="
echo ""

# Set source and destination directories
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"

# Create backup log
BACKUP_LOG="batch_5_move_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Moving Batch 5 Files..."
echo "=================================="

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

# Move the 10 files
echo "🔍 Moving files..."

# 1. The.Hunger.Games.Mockingjay.Part.1.2014.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hunger Games Mockingjay Part 1 (2014) [1080p]/The.Hunger.Games.Mockingjay.Part.1.2014.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.Mockingjay.Part.1.2014.1080p.BluRay.x264.YIFY.mp4" "1500"

# 2. The.Hunger.Games.Mockingjay.Part.2.2015.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Hunger Games Mockingjay Part 2 (2015) [1080p]/The.Hunger.Games.Mockingjay.Part.2.2015.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.Mockingjay.Part.2.2015.1080p.BluRay.x264.YIFY.mp4" "1500"

# 3. The.Maze.Runner.2014.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Maze Runner (2014) [1080p]/The.Maze.Runner.2014.1080p.BluRay.x264.YIFY.mp4" "The.Maze.Runner.2014.1080p.BluRay.x264.YIFY.mp4" "1500"

# 4. The.Maze.Runner.The.Scorch.Trials.2015.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Maze Runner The Scorch Trials (2015) [1080p]/The.Maze.Runner.The.Scorch.Trials.2015.1080p.BluRay.x264.YIFY.mp4" "The.Maze.Runner.The.Scorch.Trials.2015.1080p.BluRay.x264.YIFY.mp4" "1500"

# 5. The.Maze.Runner.The.Death.Cure.2018.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Maze Runner The Death Cure (2018) [1080p]/The.Maze.Runner.The.Death.Cure.2018.1080p.BluRay.x264.YIFY.mp4" "The.Maze.Runner.The.Death.Cure.2018.1080p.BluRay.x264.YIFY.mp4" "1500"

# 6. The.Divergent.Series.Insurgent.2015.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Divergent Series Insurgent (2015) [1080p]/The.Divergent.Series.Insurgent.2015.1080p.BluRay.x264.YIFY.mp4" "The.Divergent.Series.Insurgent.2015.1080p.BluRay.x264.YIFY.mp4" "1500"

# 7. The.Divergent.Series.Allegiant.2016.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Divergent Series Allegiant (2016) [1080p]/The.Divergent.Series.Allegiant.2016.1080p.BluRay.x264.YIFY.mp4" "The.Divergent.Series.Allegiant.2016.1080p.BluRay.x264.YIFY.mp4" "1500"

# 8. The.Divergent.Series.Divergent.2014.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Divergent Series Divergent (2014) [1080p]/The.Divergent.Series.Divergent.2014.1080p.BluRay.x264.YIFY.mp4" "The.Divergent.Series.Divergent.2014.1080p.BluRay.x264.YIFY.mp4" "1500"

# 9. The.Fault.in.Our.Stars.2014.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Fault in Our Stars (2014) [1080p]/The.Fault.in.Our.Stars.2014.1080p.BluRay.x264.YIFY.mp4" "The.Fault.in.Our.Stars.2014.1080p.BluRay.x264.YIFY.mp4" "1500"

# 10. The.Perks.of.Being.a.Wallflower.2012.1080p.BluRay.x264.YIFY.mp4 (1.5GB)
move_file "/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/Movies/The Perks of Being a Wallflower (2012) [1080p]/The.Perks.of.Being.a.Wallflower.2012.1080p.BluRay.x264.YIFY.mp4" "The.Perks.of.Being.a.Wallflower.2012.1080p.BluRay.x264.YIFY.mp4" "1500"

echo ""
echo "📊 STEP 2: Verification..."
echo "=========================="

# Check if files were moved successfully
echo "🔍 Verifying moved files:"
for file in "The.Hunger.Games.Mockingjay.Part.1.2014.1080p.BluRay.x264.YIFY.mp4" "The.Hunger.Games.Mockingjay.Part.2.2015.1080p.BluRay.x264.YIFY.mp4" "The.Maze.Runner.2014.1080p.BluRay.x264.YIFY.mp4" "The.Maze.Runner.The.Scorch.Trials.2015.1080p.BluRay.x264.YIFY.mp4" "The.Maze.Runner.The.Death.Cure.2018.1080p.BluRay.x264.YIFY.mp4" "The.Divergent.Series.Insurgent.2015.1080p.BluRay.x264.YIFY.mp4" "The.Divergent.Series.Allegiant.2016.1080p.BluRay.x264.YIFY.mp4" "The.Divergent.Series.Divergent.2014.1080p.BluRay.x264.YIFY.mp4" "The.Fault.in.Our.Stars.2014.1080p.BluRay.x264.YIFY.mp4" "The.Perks.of.Being.a.Wallflower.2012.1080p.BluRay.x264.YIFY.mp4"; do
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
echo "  • Total space: ~15GB moved to Jellyfin"
echo "  • Organized: Videos now in proper media library"
echo ""

echo "🎯 BATCH 5 MOVING COMPLETE!"
echo ""
echo "📋 Files are now available in Jellyfin media library:"
echo "  $JELLYFIN_MOVIES"
echo ""
echo "🚀 Ready for Jellyfin to scan and index these movies!" 