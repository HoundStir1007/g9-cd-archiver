#!/bin/bash

echo "🎯 BIGGEST WINS ANALYSIS - COMPREHENSIVE"
echo "========================================"
echo ""

# Set directories
CANVIO_DIR="/media/mark/paperless-ssd/digital_consolidation/canvio_transfer"
THUNDERBOLT_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer"

echo "📊 STEP 1: Full Thunderbolt Analysis (262K files)..."
echo "=================================================="

# Check if Thunderbolt directory exists
if [ ! -d "$THUNDERBOLT_DIR" ]; then
    echo "❌ Thunderbolt directory not found at: $THUNDERBOLT_DIR"
    exit 1
fi

# Full file analysis for Thunderbolt
echo "🔍 Analyzing all files in Thunderbolt..."
find "$THUNDERBOLT_DIR" -type f 2>/dev/null | while read file; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || echo 0)
        ext=$(echo "$file" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')
        if [ "$ext" = "$file" ]; then
            ext="no_extension"
        fi
        echo "$ext $size $file" >> thunderbolt_full_analysis.txt
    fi
done

echo "✅ Thunderbolt analysis complete!"

echo ""
echo "📊 STEP 2: Analyzing Results..."
echo "=============================="

# Show summary of Thunderbolt analysis
if [ -f "thunderbolt_full_analysis.txt" ]; then
    echo "📋 Thunderbolt Analysis Summary:"
    echo "  • Total files: $(wc -l < thunderbolt_full_analysis.txt)"
    echo "  • Analysis file size: $(ls -lh thunderbolt_full_analysis.txt | awk '{print $5}')"
    
    echo ""
    echo "🔍 Top 10 largest file types by space usage:"
    awk '{ext=$1; size=$2; sizes[ext]+=size; counts[ext]++} END {for(ext in sizes) print sizes[ext], counts[ext], ext}' thunderbolt_full_analysis.txt | sort -nr | head -10 | while read total_size count ext; do
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
echo "📊 STEP 3: Biggest Wins Identification..."
echo "======================================="

# Find largest individual files
echo "🔍 Top 20 largest individual files:"
find "$THUNDERBOLT_DIR" -type f 2>/dev/null -exec ls -lh {} \; | sort -k5 -hr | head -20 | while read line; do
    size=$(echo "$line" | awk '{print $5}')
    file=$(echo "$line" | awk '{for(i=9;i<=NF;i++) printf $i" "; print ""}')
    echo "  $size - $file"
done

echo ""
echo "📊 STEP 4: Directory Structure Analysis..."
echo "========================================"

# Analyze subdirectories by size
echo "🔍 Largest subdirectories:"
du -h "$THUNDERBOLT_DIR"/* 2>/dev/null | sort -hr | head -10 | while read size path; do
    echo "  $size - $path"
done

echo ""
echo "🎯 BIGGEST WINS SUMMARY"
echo "======================="
echo "✅ Full Thunderbolt analysis complete!"
echo "📊 Ready for targeted cleanup based on results"
echo ""
echo "📋 Analysis files created:"
echo "  • thunderbolt_full_analysis.txt - Complete file analysis"
echo ""
echo "🚀 Ready to implement biggest wins strategy!" 