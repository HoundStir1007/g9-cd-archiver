#!/bin/bash

echo "🎯 TARGETED THUNDERBOLT CLEANUP (994GB)"
echo "========================================"
echo ""

# Set target directory
THUNDERBOLT_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer"
if [ ! -d "$THUNDERBOLT_DIR" ]; then
    echo "❌ Thunderbolt directory not found at: $THUNDERBOLT_DIR"
    echo "🔍 Searching for actual path..."
    find /mnt/storage/digital_consolidation /media/mark/paperless-ssd/digital_consolidation -name "*thunderbolt*" -o -name "*Thunderbolt*" 2>/dev/null | head -5
    exit 1
fi

echo "📊 STEP 1: Quick Thunderbolt Analysis..."
echo "======================================="

# Get total size and file count
total_size=$(du -sh "$THUNDERBOLT_DIR" 2>/dev/null | cut -f1)
file_count=$(find "$THUNDERBOLT_DIR" -type f 2>/dev/null | wc -l)

echo "📋 Thunderbolt Transfer Stats:"
echo "  • Total Size: $total_size"
echo "  • File Count: $file_count"
echo ""

echo "📊 STEP 2: Finding Biggest Wins in Thunderbolt..."
echo "================================================"

# Find largest files in Thunderbolt
echo "🔍 Top 20 largest files in Thunderbolt:"
find "$THUNDERBOLT_DIR" -type f 2>/dev/null -exec ls -lh {} \; | sort -k5 -hr | head -20 | while read line; do
    size=$(echo "$line" | awk '{print $5}')
    file=$(echo "$line" | awk '{for(i=9;i<=NF;i++) printf $i" "; print ""}')
    echo "  $size - $file"
done

echo ""
echo "📊 STEP 3: Directory Structure Analysis..."
echo "========================================"

# Analyze subdirectories by size
echo "🔍 Largest subdirectories:"
du -h "$THUNDERBOLT_DIR"/* 2>/dev/null | sort -hr | head -10 | while read size path; do
    echo "  $size - $path"
done

echo ""
echo "📊 STEP 4: System Junk Detection..."
echo "=================================="

# Find system junk files
echo "🗑️  System junk files found:"
junk_count=0
junk_size=0

# .DS_Store files (Mac)
ds_count=$(find "$THUNDERBOLT_DIR" -name ".DS_Store" 2>/dev/null | wc -l)
if [ $ds_count -gt 0 ]; then
    ds_size=$(find "$THUNDERBOLT_DIR" -name ".DS_Store" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    ds_size_mb=$((ds_size / 1024 / 1024))
    echo "  • $ds_count .DS_Store files (${ds_size_mb}MB)"
    junk_count=$((junk_count + ds_count))
    junk_size=$((junk_size + ds_size))
fi

# Thumbs.db files (Windows)
thumbs_count=$(find "$THUNDERBOLT_DIR" -name "Thumbs.db" 2>/dev/null | wc -l)
if [ $thumbs_count -gt 0 ]; then
    thumbs_size=$(find "$THUNDERBOLT_DIR" -name "Thumbs.db" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    thumbs_size_mb=$((thumbs_size / 1024 / 1024))
    echo "  • $thumbs_count Thumbs.db files (${thumbs_size_mb}MB)"
    junk_count=$((junk_count + thumbs_count))
    junk_size=$((junk_size + thumbs_size))
fi

# Temp files
temp_count=$(find "$THUNDERBOLT_DIR" -name "*.tmp" -o -name "*.temp" -o -name "*.cache" 2>/dev/null | wc -l)
if [ $temp_count -gt 0 ]; then
    temp_size=$(find "$THUNDERBOLT_DIR" -name "*.tmp" -o -name "*.temp" -o -name "*.cache" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    temp_size_mb=$((temp_size / 1024 / 1024))
    echo "  • $temp_count temp/cache files (${temp_size_mb}MB)"
    junk_count=$((junk_count + temp_count))
    junk_size=$((junk_size + temp_size))
fi

echo ""
echo "📊 STEP 5: File Type Quick Analysis..."
echo "====================================="

# Quick file type analysis (sample)
echo "🔍 Analyzing file types (sampling first 1000 files)..."
find "$THUNDERBOLT_DIR" -type f 2>/dev/null | head -1000 | while read file; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || echo 0)
        ext=$(echo "$file" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')
        if [ "$ext" = "$file" ]; then
            ext="no_extension"
        fi
        echo "$ext $size $file" >> thunderbolt_sample_analysis.txt
    fi
done

# Show top file types from sample
if [ -f "thunderbolt_sample_analysis.txt" ]; then
    echo ""
    echo "📋 Top file types by space usage (sample):"
    awk '{ext=$1; size=$2; sizes[ext]+=size; counts[ext]++} END {for(ext in sizes) print sizes[ext], counts[ext], ext}' thunderbolt_sample_analysis.txt | sort -nr | head -10 | while read total_size count ext; do
        if [ $total_size -gt 1073741824 ]; then
            size_display=$(echo "scale=1; $total_size / 1073741824" | bc)
            size_unit="GB"
        elif [ $total_size -gt 1048576 ]; then
            size_display=$(echo "scale=1; $total_size / 1048576" | bc)
            size_unit="MB"
        else
            size_display=$(echo "scale=1; $total_size / 1024" | bc)
            size_unit="KB"
        fi
        echo "  $size_display$size_unit - $count files - .$ext"
    done
fi

echo ""
echo "📊 STEP 6: Quick Wins Summary..."
echo "================================"

# Calculate potential savings
total_junk_mb=$((junk_size / 1024 / 1024))

echo "💾 POTENTIAL SPACE SAVINGS:"
echo "  • System junk: ${total_junk_mb}MB"
echo ""

echo "🎯 RECOMMENDED ACTIONS:"
echo "  1. Delete $junk_count system junk files (${total_junk_mb}MB)"
echo "  2. Focus on largest subdirectories identified above"
echo "  3. Target the biggest file types from sample analysis"
echo "  4. Look for obvious duplicates in large directories"
echo ""

echo "📋 Analysis files created:"
echo "  • thunderbolt_sample_analysis.txt - File type sample"
echo ""

echo "🚀 Ready to clean up Thunderbolt Transfer!" 