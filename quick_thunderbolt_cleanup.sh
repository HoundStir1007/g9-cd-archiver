#!/bin/bash

echo "🚀 QUICK THUNDERBOLT CLEANUP - IMMEDIATE WINS"
echo "=============================================="
echo ""

THUNDERBOLT_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer"

if [ ! -d "$THUNDERBOLT_DIR" ]; then
    echo "❌ Thunderbolt directory not found!"
    exit 1
fi

echo "📊 STEP 1: System Junk Cleanup..."
echo "================================="

# Create backup log
LOG_FILE="thunderbolt_cleanup_$(date +%Y%m%d_%H%M%S).log"
echo "Thunderbolt Cleanup Log - $(date)" > "$LOG_FILE"

# Remove system junk files
echo "🗑️  Removing system junk files..."

# .DS_Store files (Mac)
ds_count=$(find "$THUNDERBOLT_DIR" -name ".DS_Store" 2>/dev/null | wc -l)
if [ $ds_count -gt 0 ]; then
    echo "  • Removing $ds_count .DS_Store files..."
    find "$THUNDERBOLT_DIR" -name ".DS_Store" -delete 2>/dev/null
    echo "  ✅ Removed $ds_count .DS_Store files" | tee -a "$LOG_FILE"
fi

# Thumbs.db files (Windows)
thumbs_count=$(find "$THUNDERBOLT_DIR" -name "Thumbs.db" 2>/dev/null | wc -l)
if [ $thumbs_count -gt 0 ]; then
    echo "  • Removing $thumbs_count Thumbs.db files..."
    find "$THUNDERBOLT_DIR" -name "Thumbs.db" -delete 2>/dev/null
    echo "  ✅ Removed $thumbs_count Thumbs.db files" | tee -a "$LOG_FILE"
fi

# Temp files
temp_count=$(find "$THUNDERBOLT_DIR" -name "*.tmp" -o -name "*.temp" -o -name "*.cache" 2>/dev/null | wc -l)
if [ $temp_count -gt 0 ]; then
    echo "  • Removing $temp_count temp/cache files..."
    find "$THUNDERBOLT_DIR" -name "*.tmp" -o -name "*.temp" -o -name "*.cache" -delete 2>/dev/null
    echo "  ✅ Removed $temp_count temp/cache files" | tee -a "$LOG_FILE"
fi

echo ""
echo "📊 STEP 2: Large Directory Analysis..."
echo "===================================="

# Find largest subdirectories
echo "🔍 Largest subdirectories (potential targets):"
du -h "$THUNDERBOLT_DIR"/* 2>/dev/null | sort -hr | head -10 | while read size path; do
    echo "  $size - $path"
done

echo ""
echo "📊 STEP 3: Quick File Type Sample..."
echo "==================================="

# Quick sample of file types (first 500 files)
echo "🔍 Sampling first 500 files for file types..."
find "$THUNDERBOLT_DIR" -type f 2>/dev/null | head -500 | while read file; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || echo 0)
        ext=$(echo "$file" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')
        if [ "$ext" = "$file" ]; then
            ext="no_extension"
        fi
        echo "$ext $size" >> thunderbolt_quick_sample.txt
    fi
done

# Show top file types from sample
if [ -f "thunderbolt_quick_sample.txt" ]; then
    echo ""
    echo "📋 Top file types from sample:"
    awk '{ext=$1; size=$2; sizes[ext]+=size; counts[ext]++} END {for(ext in sizes) print sizes[ext], counts[ext], ext}' thunderbolt_quick_sample.txt | sort -nr | head -10 | while read total_size count ext; do
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
echo "📊 STEP 4: Space Savings Summary..."
echo "=================================="

# Calculate space saved
original_size=$(du -s "$THUNDERBOLT_DIR" 2>/dev/null | cut -f1)
echo "💾 Space analysis:"
echo "  • Original size: ${original_size}KB"
echo "  • System junk removed: $((ds_count + thumbs_count + temp_count)) files"
echo ""

echo "🎯 NEXT STEPS:"
echo "  1. Review largest subdirectories above"
echo "  2. Focus on biggest file types from sample"
echo "  3. Wait for full analysis to complete"
echo ""

echo "📋 Log file created: $LOG_FILE"
echo "🚀 Quick cleanup complete!" 