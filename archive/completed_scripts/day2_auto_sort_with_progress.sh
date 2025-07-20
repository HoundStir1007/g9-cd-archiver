#!/bin/bash

echo "🗂️ DAY 2: AUTO-SORT BY FILE EXTENSION (WITH PROGRESS BARS!)"
echo "=========================================================="
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

# Progress tracking variables
total_files_found=0
files_processed=0
start_time=$(date +%s)

# Function to show progress bar
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%% (%d/%d)" $percentage $current $total
    
    # Calculate ETA - FIXED VERSION
    if [ $current -gt 0 ]; then
        local elapsed=$(( $(date +%s) - start_time ))
        if [ $elapsed -gt 0 ]; then
            local rate=$((current / elapsed))
            if [ $rate -gt 0 ]; then
                local remaining=$(( (total - current) / rate ))
                # Cap ETA at 999 minutes to avoid crazy numbers
                if [ $remaining -lt 999 ]; then
                    local eta_minutes=$((remaining / 60))
                    local eta_seconds=$((remaining % 60))
                    printf " ETA: %02d:%02d" $eta_minutes $eta_seconds
                else
                    printf " ETA: >16h"
                fi
            fi
        fi
    fi
}

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
echo "🔍 STEP 0: Scanning for files to organize..."
echo "==========================================="

# Count total files to organize
echo "  Scanning directories for files..."
total_files_found=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)
echo "  Found $total_files_found files to organize"
echo ""

echo "🚀 STARTING AUTO-SORT PROCESS WITH PROGRESS TRACKING..."
echo "======================================================"

echo ""
echo "📸 STEP 1: Sorting photos and images..."
echo "======================================"

photo_count=0
photo_errors=0
photo_files=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.bmp" -o -name "*.tiff" -o -name "*.tif" -o -name "*.raw" -o -name "*.cr2" -o -name "*.nef" -o -name "*.arw" -o -name "*.dng" -o -name "*.webp" -o -name "*.svg" -o -name "*.ico" \) 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)

echo "  Found $photo_files photo files to process"
echo "  Processing photos..."

photo_processed=0
for ext in jpg jpeg png gif bmp tiff tif raw cr2 nef arw dng webp svg ico; do
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
        if [ -f "$file" ]; then
            if safe_move "$file" "$ORGANIZED_BASE/photos_and_images"; then
                photo_count=$((photo_count + 1))
            else
                photo_errors=$((photo_errors + 1))
            fi
            photo_processed=$((photo_processed + 1))
            show_progress $photo_processed $photo_files
        fi
    done
done

echo ""
echo "  ✅ Photos and images sorted! (Moved: $photo_count, Errors: $photo_errors)"

echo ""
echo "🎵 STEP 2: Sorting audio files..."
echo "================================"

audio_count=0
audio_errors=0
audio_files=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f \( -name "*.mp3" -o -name "*.wav" -o -name "*.flac" -o -name "*.m4a" -o -name "*.aac" -o -name "*.ogg" -o -name "*.wma" -o -name "*.aiff" -o -name "*.mp2" -o -name "*.ac3" -o -name "*.dts" \) 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)

echo "  Found $audio_files audio files to process"
echo "  Processing audio..."

audio_processed=0
for ext in mp3 wav flac m4a aac ogg wma aiff mp2 ac3 dts; do
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
        if [ -f "$file" ]; then
            if safe_move "$file" "$ORGANIZED_BASE/audio_files"; then
                audio_count=$((audio_count + 1))
            else
                audio_errors=$((audio_errors + 1))
            fi
            audio_processed=$((audio_processed + 1))
            show_progress $audio_processed $audio_files
        fi
    done
done

echo ""
echo "  ✅ Audio files sorted! (Moved: $audio_count, Errors: $audio_errors)"

echo ""
echo "🎬 STEP 3: Sorting video files..."
echo "================================"

video_count=0
video_errors=0
video_files=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f \( -name "*.mp4" -o -name "*.avi" -o -name "*.mkv" -o -name "*.mov" -o -name "*.wmv" -o -name "*.flv" -o -name "*.webm" -o -name "*.m4v" -o -name "*.3gp" -o -name "*.mpg" -o -name "*.mpeg" -o -name "*.ts" -o -name "*.vob" \) 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)

echo "  Found $video_files video files to process"
echo "  Processing videos..."

video_processed=0
for ext in mp4 avi mkv mov wmv flv webm m4v 3gp mpg mpeg ts vob; do
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
        if [ -f "$file" ]; then
            if safe_move "$file" "$ORGANIZED_BASE/video_files"; then
                video_count=$((video_count + 1))
            else
                video_errors=$((video_errors + 1))
            fi
            video_processed=$((video_processed + 1))
            show_progress $video_processed $video_files
        fi
    done
done

echo ""
echo "  ✅ Video files sorted! (Moved: $video_count, Errors: $video_errors)"

echo ""
echo "📄 STEP 4: Sorting documents..."
echo "=============================="

doc_count=0
doc_errors=0
doc_files=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f \( -name "*.pdf" -o -name "*.doc" -o -name "*.docx" -o -name "*.txt" -o -name "*.rtf" -o -name "*.odt" -o -name "*.xls" -o -name "*.xlsx" -o -name "*.ppt" -o -name "*.pptx" -o -name "*.csv" \) 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)

echo "  Found $doc_files document files to process"
echo "  Processing documents..."

doc_processed=0
for ext in pdf doc docx txt rtf odt xls xlsx ppt pptx csv; do
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
        if [ -f "$file" ]; then
            if safe_move "$file" "$ORGANIZED_BASE/documents"; then
                doc_count=$((doc_count + 1))
            else
                doc_errors=$((doc_errors + 1))
            fi
            doc_processed=$((doc_processed + 1))
            show_progress $doc_processed $doc_files
        fi
    done
done

echo ""
echo "  ✅ Documents sorted! (Moved: $doc_count, Errors: $doc_errors)"

echo ""
echo "🗂️ STEP 5: Sorting archives..."
echo "=============================="

archive_count=0
archive_errors=0
archive_files=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f \( -name "*.zip" -o -name "*.rar" -o -name "*.7z" -o -name "*.tar" -o -name "*.gz" -o -name "*.bz2" -o -name "*.xz" -o -name "*.dmg" -o -name "*.iso" \) 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)

echo "  Found $archive_files archive files to process"
echo "  Processing archives..."

archive_processed=0
for ext in zip rar 7z tar gz bz2 xz dmg iso; do
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*.$ext" -o -name "*.${ext^^}" 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
        if [ -f "$file" ]; then
            if safe_move "$file" "$ORGANIZED_BASE/archives"; then
                archive_count=$((archive_count + 1))
            else
                archive_errors=$((archive_errors + 1))
            fi
            archive_processed=$((archive_processed + 1))
            show_progress $archive_processed $archive_files
        fi
    done
done

echo ""
echo "  ✅ Archives sorted! (Moved: $archive_count, Errors: $archive_errors)"

echo ""
echo "❓ STEP 6: Moving unknown files for manual review..."
echo "==================================================="

unknown_count=0
unknown_errors=0
unknown_files=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)

echo "  Found $unknown_files remaining files to process"
echo "  Moving unknown files..."

unknown_processed=0
# Move everything else to unknown folder for manual review
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f 2>/dev/null | grep -v "/ORGANIZED/" | while read file; do
    if [ -f "$file" ]; then
        if safe_move "$file" "$ORGANIZED_BASE/unknown"; then
            unknown_count=$((unknown_count + 1))
        else
            unknown_errors=$((unknown_errors + 1))
        fi
        unknown_processed=$((unknown_processed + 1))
        show_progress $unknown_processed $unknown_files
    fi
done

echo ""
echo "  ✅ Unknown files moved for manual review! (Moved: $unknown_count, Errors: $unknown_errors)"

echo ""
echo "🧹 STEP 7: Cleaning up empty directories..."
echo "==========================================="

# Remove empty directories
echo "  Removing empty directories..."
empty_dirs=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type d -empty 2>/dev/null | grep -v "/ORGANIZED/" | wc -l)
echo "  Found $empty_dirs empty directories to remove"

dirs_removed=0
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type d -empty 2>/dev/null | grep -v "/ORGANIZED/" | while read dir; do
    if [ -d "$dir" ]; then
        if rmdir "$dir" 2>/dev/null; then
            dirs_removed=$((dirs_removed + 1))
        else
            sudo rmdir "$dir" 2>/dev/null && dirs_removed=$((dirs_removed + 1))
        fi
        show_progress $dirs_removed $empty_dirs
    fi
done

echo ""
echo "  ✅ Empty directories cleaned! ($dirs_removed removed)"

echo ""
echo "📊 CALCULATING FINAL RESULTS..."
echo "=============================="

# Count files in each category
photos_final=$(find "$ORGANIZED_BASE/photos_and_images" -type f 2>/dev/null | wc -l)
audio_final=$(find "$ORGANIZED_BASE/audio_files" -type f 2>/dev/null | wc -l)
video_final=$(find "$ORGANIZED_BASE/video_files" -type f 2>/dev/null | wc -l)
docs_final=$(find "$ORGANIZED_BASE/documents" -type f 2>/dev/null | wc -l)
archives_final=$(find "$ORGANIZED_BASE/archives" -type f 2>/dev/null | wc -l)
unknown_final=$(find "$ORGANIZED_BASE/unknown" -type f 2>/dev/null | wc -l)

total_organized=$((photos_final + audio_final + video_final + docs_final + archives_final + unknown_final))

# Calculate total time
end_time=$(date +%s)
total_time=$((end_time - start_time))
minutes=$((total_time / 60))
seconds=$((total_time % 60))

echo ""
echo "🎯 AUTO-SORT COMPLETE!"
echo "======================"
echo ""
echo "⏱️  TOTAL TIME: ${minutes}m ${seconds}s"
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
    echo "DIGITAL CONSOLIDATION AUTO-SORT (WITH PROGRESS) - $(date)"
    echo "======================================================="
    echo ""
    echo "Files organized: $total_organized"
    echo "Permission errors: $permission_error_count"
    echo "Total time: ${minutes}m ${seconds}s"
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