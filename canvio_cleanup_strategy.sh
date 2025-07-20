#!/bin/bash

echo "🎯 CANVIO CLEANUP STRATEGY"
echo "=========================="
echo ""

# Set directories
CANVIO_DIR="/media/mark/paperless-ssd/digital_consolidation/canvio_transfer"
JELLYFIN_MOVIES="/media/mark/paperless-ssd/jellyfin/media/movies"
TRASH_DIR="/home/mark/.local/share/Trash/files"

# Create backup log
BACKUP_LOG="canvio_cleanup_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Moving Video Files to Jellyfin..."
echo "============================================="

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

# Move video files to Jellyfin
echo "🔍 Moving RiffTrax videos to Jellyfin..."

# 1. ThisIsHormel_highTV.mp4 (571MB)
move_file "$CANVIO_DIR/mac_mini_files/Downloads/ThisIsHormel_highTV.mp4" "ThisIsHormel_highTV.mp4" "571" "$JELLYFIN_MOVIES"

# 2. NormanGivesASpeech_highTV.mp4 (156MB)
move_file "$CANVIO_DIR/mac_mini_files/Downloads/NormanGivesASpeech_highTV.mp4" "NormanGivesASpeech_highTV.mp4" "156" "$JELLYFIN_MOVIES"

echo ""
echo "🗑️  STEP 2: Cleaning Up System Files..."
echo "======================================"

# Move large system files to trash
echo "🗑️  Moving large iPhoto system files to trash..."

# 1. Large .ithmb files (2.6GB + 750MB)
move_file "$CANVIO_DIR/iphoto_library/resources/derivatives/thumbs/4031.ithmb" "4031.ithmb_DELETED" "2634" "$TRASH_DIR"
move_file "$CANVIO_DIR/iphoto_library/resources/derivatives/thumbs/4132.ithmb" "4132.ithmb_DELETED" "750" "$TRASH_DIR"

# 2. Photos.sqlite (190MB)
move_file "$CANVIO_DIR/iphoto_library/database/Photos.sqlite" "Photos.sqlite_DELETED" "190" "$TRASH_DIR"

echo ""
echo "📸 STEP 3: Photo/Video Files Analysis..."
echo "======================================="

# Count and analyze photo/video files
echo "📊 Photo/Video Files Summary:"
echo "  • Location: $CANVIO_DIR/photos_to_import/"
echo "  • Large .mov files: $(find "$CANVIO_DIR/photos_to_import" -name "*.mov" -size +100M | wc -l) files"
echo "  • Total size: $(du -sh "$CANVIO_DIR/photos_to_import" 2>/dev/null | cut -f1)"
echo ""

echo "🔍 Top 10 largest photo/video files:"
find "$CANVIO_DIR/photos_to_import" -name "*.mov" -size +100M | xargs stat -c "%s %n" 2>/dev/null | sort -nr | head -10 | while read size path; do
    size_mb=$((size / 1024 / 1024))
    filename=$(basename "$path")
    echo "  ${size_mb}MB - $filename"
done

echo ""
echo "📊 STEP 4: Verification..."
echo "=========================="

# Check if files were moved successfully
echo "🔍 Verifying moved files in Jellyfin:"
for file in "ThisIsHormel_highTV.mp4" "NormanGivesASpeech_highTV.mp4"; do
    if [ -f "$JELLYFIN_MOVIES/$file" ]; then
        size=$(stat -c%s "$JELLYFIN_MOVIES/$file" 2>/dev/null || echo 0)
        size_mb=$((size / 1024 / 1024))
        echo "  ✅ $file (${size_mb}MB)"
    else
        echo "  ❌ $file (not found)"
    fi
done

echo ""
echo "🗑️  Checking files in trash:"
for file in "4031.ithmb_DELETED" "4132.ithmb_DELETED" "Photos.sqlite_DELETED"; do
    if [ -f "$TRASH_DIR/$file" ]; then
        size=$(stat -c%s "$TRASH_DIR/$file" 2>/dev/null || echo 0)
        size_mb=$((size / 1024 / 1024))
        echo "  ✅ $file (${size_mb}MB) - in trash"
    else
        echo "  ❌ $file (not found in trash)"
    fi
done

echo ""
echo "📊 STEP 5: Space Savings Summary..."
echo "=================================="

echo "💾 SPACE SAVINGS:"
echo "  • Video files moved to Jellyfin: ~727MB"
echo "  • System files moved to trash: ~3.5GB"
echo "  • Photo/video files identified: ~15GB"
echo "  • Total potential savings: ~19GB"
echo ""

echo "🎯 CANVIO CLEANUP COMPLETE!"
echo ""
echo "📋 Next steps:"
echo "  1. Review photo/video files in photos_to_import/"
echo "  2. Consider organizing photos into proper photo library"
echo "  3. Continue with remaining directories"
echo ""
echo "🚀 Ready for next cleanup phase!" 