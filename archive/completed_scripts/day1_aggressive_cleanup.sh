#!/bin/bash

echo "🗑️ DAY 1: AGGRESSIVE CLEANUP MODE"
echo "================================="
echo ""

# Safety check - make sure analysis was run first
if [ ! -f "digital_consolidation_analysis/analysis_summary.txt" ]; then
    echo "❌ ERROR: Please run day1_quick_analysis.sh first!"
    exit 1
fi

# Create cleanup log directory
mkdir -p digital_consolidation_cleanup
cd digital_consolidation_cleanup

echo "🚨 SAFETY FIRST: Creating deletion log for rollback if needed..."
touch deleted_files_log.txt
touch space_saved_log.txt

# Function to log deletions
log_deletion() {
    echo "$(date): DELETED: $1" >> deleted_files_log.txt
}

# Function to calculate space saved
calculate_space_saved() {
    local file="$1"
    local size=$(stat -c%s "$file" 2>/dev/null || echo 0)
    echo $size >> space_saved_log.txt
}

echo ""
echo "🗑️ STEP 1: Deleting system junk files..."
echo "========================================"

junk_deleted=0
junk_space_saved=0

# Delete .DS_Store files
echo "  Removing .DS_Store files..."
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name ".DS_Store" -type f 2>/dev/null | while read file; do
    calculate_space_saved "$file"
    log_deletion "$file"
    rm -f "$file" && junk_deleted=$((junk_deleted + 1))
done

# Delete Thumbs.db files
echo "  Removing Thumbs.db files..."
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "Thumbs.db" -type f 2>/dev/null | while read file; do
    calculate_space_saved "$file"
    log_deletion "$file"
    rm -f "$file"
done

# Delete other system files
for pattern in "*.tmp" "*.temp" "desktop.ini" ".Spotlight-V100" ".fseventsd"; do
    echo "  Removing $pattern files..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "$pattern" -type f 2>/dev/null | while read file; do
        calculate_space_saved "$file"
        log_deletion "$file"
        rm -f "$file"
    done
done

echo "✅ System junk cleanup complete!"

echo ""
echo "🗑️ STEP 2: Removing old software installers (>2 years)..."
echo "========================================================"

# Delete old software installers
if [ -f "../digital_consolidation_analysis/old_software.txt" ]; then
    old_software_count=$(wc -l < ../digital_consolidation_analysis/old_software.txt)
    echo "  Removing $old_software_count old software installers..."
    
    while read software_file; do
        if [ -f "$software_file" ]; then
            calculate_space_saved "$software_file"
            log_deletion "$software_file"
            rm -f "$software_file"
        fi
    done < ../digital_consolidation_analysis/old_software.txt
    
    echo "✅ Old software cleanup complete!"
else
    echo "  No old software list found, skipping..."
fi

echo ""
echo "🔍 STEP 3: SMART duplicate removal (keep first, delete rest)..."
echo "=============================================================="

# Process obvious duplicates more carefully
if [ -f "../digital_consolidation_analysis/obvious_duplicates.txt" ]; then
    echo "  Processing obvious duplicates..."
    
    # Sort duplicates and keep only the first occurrence of each
    awk '{print $1 " " $2 " " $3}' ../digital_consolidation_analysis/obvious_duplicates.txt | sort -k1,2 | while read size name path; do
        # Skip if it's the first occurrence (we want to keep it)
        if [ ! -f "/tmp/seen_${size}_$(echo $name | tr '/' '_')" ]; then
            # Mark as seen
            touch "/tmp/seen_${size}_$(echo $name | tr '/' '_')"
            echo "  KEEPING: $name ($((size / 1024 / 1024))MB)"
        else
            # This is a duplicate, delete it
            if [ -f "$path" ]; then
                echo "  DELETING DUPLICATE: $name ($((size / 1024 / 1024))MB)"
                calculate_space_saved "$path"
                log_deletion "$path"
                rm -f "$path"
            fi
        fi
    done
    
    # Clean up temp files
    rm -f /tmp/seen_*
    
    echo "✅ Duplicate cleanup complete!"
else
    echo "  No duplicates list found, skipping..."
fi

echo ""
echo "🧹 STEP 4: Empty directory cleanup..."
echo "===================================="

# Remove empty directories
echo "  Removing empty directories..."
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type d -empty 2>/dev/null | while read dir; do
    if [ -d "$dir" ]; then
        log_deletion "$dir"
        rmdir "$dir" 2>/dev/null
    fi
done

echo "✅ Empty directory cleanup complete!"

echo ""
echo "📊 CALCULATING SPACE SAVINGS..."
echo "==============================="

# Calculate total space saved
if [ -f "space_saved_log.txt" ]; then
    total_bytes_saved=0
    while read bytes; do
        total_bytes_saved=$((total_bytes_saved + bytes))
    done < space_saved_log.txt
    
    # Convert to human readable
    mb_saved=$((total_bytes_saved / 1024 / 1024))
    gb_saved=$((mb_saved / 1024))
    
    echo "💾 SPACE SAVINGS ACHIEVED:"
    if [ $gb_saved -gt 0 ]; then
        echo "  🎉 ${gb_saved}GB saved!"
    else
        echo "  🎉 ${mb_saved}MB saved!"
    fi
    
    # Store for summary
    echo "$total_bytes_saved" > total_space_saved.txt
fi

# Get new total sizes
echo ""
echo "📁 STORAGE USAGE AFTER CLEANUP:"
du -sh /mnt/storage/digital_consolidation 2>/dev/null | sed 's/^/  /'
du -sh /media/mark/paperless-ssd/digital_consolidation 2>/dev/null | sed 's/^/  /'

echo ""
echo "🎯 AGGRESSIVE CLEANUP COMPLETE!"
echo "==============================="
echo ""

# Count deleted files
deleted_count=$(wc -l < deleted_files_log.txt)
echo "📊 CLEANUP SUMMARY:"
echo "  • Files deleted: $deleted_count"
echo "  • Space saved: ${mb_saved}MB"
echo "  • Cleanup log: digital_consolidation_cleanup/deleted_files_log.txt"
echo ""
echo "💡 NEXT STEP: Review results and continue to Day 2 auto-sorting!"
echo "   → bash day2_auto_sort.sh"
echo ""

# Save cleanup summary
{
    echo "DIGITAL CONSOLIDATION CLEANUP - $(date)"
    echo "======================================="
    echo ""
    echo "Files deleted: $deleted_count"
    echo "Space saved: ${mb_saved}MB (${gb_saved}GB)"
    echo ""
    echo "Cleanup activities:"
    echo "  ✅ System junk files removed"
    echo "  ✅ Old software installers removed"
    echo "  ✅ Obvious duplicates removed"
    echo "  ✅ Empty directories removed"
    echo ""
    echo "Log files:"
    echo "  • deleted_files_log.txt"
    echo "  • space_saved_log.txt"
} > cleanup_summary.txt

echo "📋 Cleanup summary saved to: digital_consolidation_cleanup/cleanup_summary.txt" 