#!/bin/bash

echo "🗂️ DAY 2: AUTO-SORT BY FILE EXTENSION (FIXED)"
echo "==============================================="
echo ""

# Safety check - make sure cleanup was run first
if [ ! -f "digital_consolidation_cleanup/deleted_files_log.txt" ]; then
    echo "❌ ERROR: Please run day1_aggressive_cleanup.sh first!"
    exit 1
fi

# Create organized directory structure
ORGANIZED_BASE="/mnt/storage/digital_consolidation/ORGANIZED"
echo "📁 Creating organized directory structure at: $ORGANIZED_BASE"

mkdir -p "$ORGANIZED_BASE"/{photos_and_images,audio_files,video_files,documents,archives,unknown}

# Fix permissions on the organized directory
sudo chown -R mark:mark "$ORGANIZED_BASE"
sudo chmod -R 755 "$ORGANIZED_BASE"

# Create sorting log
mkdir -p digital_consolidation_sorting
cd digital_consolidation_sorting
touch sorting_log.txt
touch files_moved.txt
touch permission_errors.txt

echo ""
echo "🚀 STARTING AUTO-SORT PROCESS (WITH PERMISSION FIXES)..."
echo "======================================================"

# Function to log file moves
log_move() {
    echo "$(date): MOVED: $1 → $2" >> sorting_log.txt
    echo "$2" >> files_moved.txt
}

# Function to log permission errors
log_permission_error() {
    echo "$(date): PERMISSION ERROR: $1" >> permission_errors.txt
}

# Function to safely move files with permission handling
safe_move() {
    local source="$1"
    local dest_dir="$2"
    local filename=$(basename "$source")
    
    # Handle filename conflicts
    local dest="$dest_dir/$filename"
    local counter=1
    
    while [ -f "$dest" ]; do
        local name_without_ext="${filename%.*}"
        local extension="${filename##*.}"
        if [ "$name_without_ext" = "$extension" ]; then
            # No extension
            dest="$dest_dir/${filename}_${counter}"
        else
            dest="$dest_dir/${name_without_ext}_${counter}.${extension}"
        fi
        counter=$((counter + 1))
    done
    
    # Try to move with sudo if regular move fails
    if mv "$source" "$dest" 2>/dev/null; then
        log_move "$source" "$dest"
        return 0
    else
        # Try with sudo
        if sudo mv "$source" "$dest" 2>/dev/null; then
            sudo chown mark:mark "$dest" 2>/dev/null
            log_move "$source" "$dest"
            return 0
        else
            log_permission_error "$source"
            return 1
        fi
    fi
}

echo ""
echo "📸 STEP 1: Sorting photos and images..."
echo "======================================"

photo_count=0
photo_errors=0
for ext in jpg jpeg png gif bmp tiff tif raw cr2 nef arw dng webp svg ico; do
    echo "  Processing .$ext files..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | while read file; do
        if [ -f "$file" ] && [[ "$file" != *"/ORGANIZED/"* ]]; then
            if safe_move "$file" "$ORGANIZED_BASE/photos_and_images"; then
                photo_count=$((photo_count + 1))
            else
                photo_errors=$((photo_errors + 1))
            fi
        fi
    done
done

echo "  ✅ Photos and images sorted! (Moved: $photo_count, Errors: $photo_errors)"

echo ""
echo "🎵 STEP 2: Sorting audio files..."
echo "================================"

audio_count=0
audio_errors=0
for ext in mp3 wav flac m4a aac ogg wma aiff mp2 ac3 dts; do
    echo "  Processing .$ext files..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | while read file; do
        if [ -f "$file" ] && [[ "$file" != *"/ORGANIZED/"* ]]; then
            if safe_move "$file" "$ORGANIZED_BASE/audio_files"; then
                audio_count=$((audio_count + 1))
            else
                audio_errors=$((audio_errors + 1))
            fi
        fi
    done
done

echo "  ✅ Audio files sorted! (Moved: $audio_count, Errors: $audio_errors)"

echo ""
echo "🎬 STEP 3: Sorting video files..."
echo "================================"

video_count=0
video_errors=0
for ext in mp4 avi mkv mov wmv flv webm m4v 3gp mpg mpeg ts vob; do
    echo "  Processing .$ext files..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | while read file; do
        if [ -f "$file" ] && [[ "$file" != *"/ORGANIZED/"* ]]; then
            if safe_move "$file" "$ORGANIZED_BASE/video_files"; then
                video_count=$((video_count + 1))
            else
                video_errors=$((video_errors + 1))
            fi
        fi
    done
done

echo "  ✅ Video files sorted! (Moved: $video_count, Errors: $video_errors)"

echo ""
echo "📄 STEP 4: Sorting documents..."
echo "=============================="

doc_count=0
doc_errors=0
for ext in pdf doc docx txt rtf odt xls xlsx ppt pptx csv; do
    echo "  Processing .$ext files..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | while read file; do
        if [ -f "$file" ] && [[ "$file" != *"/ORGANIZED/"* ]]; then
            if safe_move "$file" "$ORGANIZED_BASE/documents"; then
                doc_count=$((doc_count + 1))
            else
                doc_errors=$((doc_errors + 1))
            fi
        fi
    done
done

echo "  ✅ Documents sorted! (Moved: $doc_count, Errors: $doc_errors)"

echo ""
echo "🗂️ STEP 5: Sorting archives..."
echo "=============================="

archive_count=0
archive_errors=0
for ext in zip rar 7z tar gz bz2 xz dmg iso; do
    echo "  Processing .$ext files..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | while read file; do
        if [ -f "$file" ] && [[ "$file" != *"/ORGANIZED/"* ]]; then
            if safe_move "$file" "$ORGANIZED_BASE/archives"; then
                archive_count=$((archive_count + 1))
            else
                archive_errors=$((archive_errors + 1))
            fi
        fi
    done
done

echo "  ✅ Archives sorted! (Moved: $archive_count, Errors: $archive_errors)"

echo ""
echo "❓ STEP 6: Moving unknown files for manual review..."
echo "==================================================="

unknown_count=0
unknown_errors=0
# Move everything else to unknown folder for manual review
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
    if [ -f "$file" ]; then
        if safe_move "$file" "$ORGANIZED_BASE/unknown"; then
            unknown_count=$((unknown_count + 1))
        else
            unknown_errors=$((unknown_errors + 1))
        fi
    fi
done

echo "  ✅ Unknown files moved for manual review! (Moved: $unknown_count, Errors: $unknown_errors)"

echo ""
echo "🧹 STEP 7: Cleaning up empty directories..."
echo "==========================================="

# Remove empty directories
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type d -empty 2>/dev/null | grep -v "/ORGANIZED/" | while read dir; do
    if [ -d "$dir" ]; then
        if rmdir "$dir" 2>/dev/null; then
            echo "  Removed empty: $dir"
        else
            sudo rmdir "$dir" 2>/dev/null && echo "  Removed empty (sudo): $dir"
        fi
    fi
done

echo "  ✅ Empty directories cleaned!"

echo ""
echo "📊 CALCULATING ORGANIZATION RESULTS..."
echo "====================================="

# Count files in each category
photos_final=$(find "$ORGANIZED_BASE/photos_and_images" -type f 2>/dev/null | wc -l)
audio_final=$(find "$ORGANIZED_BASE/audio_files" -type f 2>/dev/null | wc -l)
video_final=$(find "$ORGANIZED_BASE/video_files" -type f 2>/dev/null | wc -l)
docs_final=$(find "$ORGANIZED_BASE/documents" -type f 2>/dev/null | wc -l)
archives_final=$(find "$ORGANIZED_BASE/archives" -type f 2>/dev/null | wc -l)
unknown_final=$(find "$ORGANIZED_BASE/unknown" -type f 2>/dev/null | wc -l)

total_organized=$((photos_final + audio_final + video_final + docs_final + archives_final + unknown_final))

echo ""
echo "🎯 AUTO-SORT COMPLETE!"
echo "======================"
echo ""
echo "📊 ORGANIZATION SUMMARY:"
echo "  📸 Photos & Images: $photos_final files"
echo "  🎵 Audio Files: $audio_final files"
echo "  🎬 Video Files: $video_final files"
echo "  📄 Documents: $docs_final files"
echo "  🗂️ Archives: $archives_final files"
echo "  ❓ Unknown (manual review): $unknown_final files"
echo "  ──────────────────────────────"
echo "  📁 Total Organized: $total_organized files"

# Calculate directory sizes
echo ""
echo "💾 ORGANIZED DIRECTORY SIZES:"
du -sh "$ORGANIZED_BASE"/* 2>/dev/null | sed 's/^/  /'

echo ""
echo "📁 NEW ORGANIZED STRUCTURE:"
echo "  $ORGANIZED_BASE/"
echo "  ├── 📸 photos_and_images/     ($photos_final files)"
echo "  ├── 🎵 audio_files/           ($audio_final files)"
echo "  ├── 🎬 video_files/           ($video_final files)"
echo "  ├── 📄 documents/             ($docs_final files)"
echo "  ├── 🗂️ archives/              ($archives_final files)"
echo "  └── ❓ unknown/               ($unknown_final files - for manual review)"

# Check for permission errors
permission_error_count=$(wc -l < permission_errors.txt 2>/dev/null || echo 0)
if [ $permission_error_count -gt 0 ]; then
    echo ""
    echo "⚠️  PERMISSION ERRORS FOUND: $permission_error_count files"
    echo "   Check: digital_consolidation_sorting/permission_errors.txt"
fi

echo ""
echo "💡 NEXT STEPS:"
echo "  1. Review unknown/ folder for any important files"
echo "  2. Run Day 3 integration with Jellyfin/Plex"
echo "  3. Celebrate your organized digital life! 🎉"

# Save sorting summary
{
    echo "DIGITAL CONSOLIDATION AUTO-SORT (FIXED) - $(date)"
    echo "==============================================="
    echo ""
    echo "Files organized: $total_organized"
    echo "Permission errors: $permission_error_count"
    echo ""
    echo "Organization breakdown:"
    echo "  Photos & Images: $photos_final files"
    echo "  Audio Files: $audio_final files"
    echo "  Video Files: $video_final files"
    echo "  Documents: $docs_final files"
    echo "  Archives: $archives_final files"
    echo "  Unknown (manual review): $unknown_final files"
    echo ""
    echo "Organized structure: $ORGANIZED_BASE/"
    echo ""
    echo "Log files:"
    echo "  • sorting_log.txt"
    echo "  • files_moved.txt"
    echo "  • permission_errors.txt"
} > sorting_summary.txt

echo ""
echo "📋 Sorting summary saved to: digital_consolidation_sorting/sorting_summary.txt"
echo ""
echo "🎉 DAY 2 COMPLETE! Your digital files are now beautifully organized!" 