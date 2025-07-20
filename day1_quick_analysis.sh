#!/bin/bash

echo "🚀 DAY 1: QUICK DIGITAL ARCHAEOLOGY ANALYSIS"
echo "============================================="
echo ""

# Create working directory for our analysis
mkdir -p digital_consolidation_analysis
cd digital_consolidation_analysis

echo "📊 STEP 1: Quick size assessment..."
echo ""

# Get current total sizes
echo "📁 CURRENT STORAGE USAGE:"
du -sh /mnt/storage/digital_consolidation 2>/dev/null | sed 's/^/  /'
du -sh /media/mark/paperless-ssd/digital_consolidation 2>/dev/null | sed 's/^/  /'

echo ""
echo "📋 STEP 2: Quick file type breakdown (sampling first 5000 files)..."

# Quick file type analysis
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f 2>/dev/null | head -5000 | while read file; do
    size=$(stat -c%s "$file" 2>/dev/null)
    basename=$(basename "$file")
    echo "$size $basename"
done | grep -E '\.(jpg|jpeg|png|gif|raw|tiff|mp3|wav|flac|m4a|aac|mp4|mov|avi|mkv|pdf|doc|docx|txt|zip|rar|7z|exe|msi|dmg|pkg)$' | sort -nr > quick_file_inventory.txt

echo "📊 File type breakdown (by count):"
awk '{print $2}' quick_file_inventory.txt | sed 's/.*\.//' | sort | uniq -c | sort -nr | head -20 | sed 's/^/  /'

echo ""
echo "💾 Largest files found (top 20):"
head -20 quick_file_inventory.txt | while read size name; do
    size_mb=$((size / 1024 / 1024))
    echo "  ${size_mb}MB - $name"
done

echo ""
echo "🔍 STEP 3: Finding obvious duplicates (same filename + size)..."

# Find obvious duplicates by filename and size
find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -type f -printf "%s %f %p\n" 2>/dev/null | sort -k1,2 | uniq -d -w 50 > obvious_duplicates.txt

dup_count=$(wc -l < obvious_duplicates.txt)
echo "  Found $dup_count obvious duplicate files!"

if [ $dup_count -gt 0 ]; then
    echo ""
    echo "📋 Top 10 duplicate files:"
    head -10 obvious_duplicates.txt | while read size name path; do
        size_mb=$((size / 1024 / 1024))
        echo "  ${size_mb}MB - $name"
    done
fi

echo ""
echo "🗑️ STEP 4: Finding system junk files..."

# Count system junk files
junk_files=0
junk_size=0

for pattern in ".DS_Store" "Thumbs.db" "*.tmp" "*.temp" "desktop.ini" ".Spotlight-V100" ".fseventsd"; do
    count=$(find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "$pattern" 2>/dev/null | wc -l)
    if [ $count -gt 0 ]; then
        echo "  $pattern: $count files"
        junk_files=$((junk_files + count))
    fi
done

echo "  Total junk files: $junk_files"

echo ""
echo "📅 STEP 5: Finding old software installers (>2 years old)..."

find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation \( -name "*.exe" -o -name "*.msi" -o -name "*.dmg" -o -name "*.pkg" \) -mtime +730 2>/dev/null > old_software.txt

old_software_count=$(wc -l < old_software.txt)
echo "  Found $old_software_count old software installers (>2 years)"

if [ $old_software_count -gt 0 ]; then
    echo ""
    echo "📋 Examples of old software:"
    head -5 old_software.txt | while read file; do
        echo "  $(basename "$file")"
    done
fi

echo ""
echo "🎯 QUICK ANALYSIS COMPLETE!"
echo "=========================="
echo ""
echo "📊 SUMMARY:"
echo "  • File inventory: $(wc -l < quick_file_inventory.txt) files analyzed"
echo "  • Obvious duplicates: $dup_count files"
echo "  • System junk: $junk_files files"
echo "  • Old software: $old_software_count files"
echo ""
echo "💡 NEXT STEP: Run aggressive cleanup to start saving space!"
echo "   → bash day1_aggressive_cleanup.sh"
echo ""

# Save summary for later reference
{
    echo "DIGITAL CONSOLIDATION ANALYSIS - $(date)"
    echo "========================================"
    echo ""
    echo "Files analyzed: $(wc -l < quick_file_inventory.txt)"
    echo "Obvious duplicates: $dup_count"
    echo "System junk files: $junk_files"
    echo "Old software installers: $old_software_count"
    echo ""
    echo "Analysis files created:"
    echo "  • quick_file_inventory.txt"
    echo "  • obvious_duplicates.txt"
    echo "  • old_software.txt"
} > analysis_summary.txt

echo "📋 Analysis summary saved to: digital_consolidation_analysis/analysis_summary.txt" 