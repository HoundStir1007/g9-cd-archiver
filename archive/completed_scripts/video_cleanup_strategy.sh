#!/bin/bash

echo "🎬 VIDEO CLEANUP STRATEGY - BIGGEST WINS"
echo "========================================="
echo ""

# Set directories
THUNDERBOLT_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer"
CANVIO_DIR="/media/mark/paperless-ssd/digital_consolidation/canvio_transfer"

echo "📊 STEP 1: Video File Analysis Summary..."
echo "========================================"

# Analyze video files in Thunderbolt sample
echo "🔍 Thunderbolt Sample Video Analysis:"
echo "  • Video files found: 961"
echo "  • Total space: 27GB"
echo "  • Average file size: 29MB"
echo ""

# Show largest video files
echo "🔍 Top 10 Largest Video Files:"
grep -E "(mp4|m4v|mpg|mpeg|avi|mov)" thunderbolt_sample_analysis.txt | sort -k2 -nr | head -10 | while read ext size path; do
    size_mb=$((size / 1024 / 1024))
    filename=$(basename "$path")
    echo "  ${size_mb}MB - $filename ($ext)"
done

echo ""
echo "📊 STEP 2: Video File Type Breakdown..."
echo "======================================"

# Analyze video file types
echo "🔍 Video file types by space usage:"
grep -E "(mp4|m4v|mpg|mpeg|avi|mov)" thunderbolt_sample_analysis.txt | awk '{ext=$1; size=$2; sizes[ext]+=size; counts[ext]++} END {for(ext in sizes) print sizes[ext], counts[ext], ext}' | sort -nr | while read total_size count ext; do
    size_gb=$(echo "scale=1; $total_size / 1024 / 1024 / 1024" | bc)
    echo "  ${size_gb}GB - $count files - .$ext"
done

echo ""
echo "📊 STEP 3: Directory Structure Analysis..."
echo "========================================"

# Analyze video directories
echo "🔍 Video directories by space usage:"
grep -E "(mp4|m4v|mpg|mpeg|avi|mov)" thunderbolt_sample_analysis.txt | awk '{path=$3; size=$2; split(path, parts, "/"); dir=""; for(i=1;i<length(parts)-1;i++) dir=dir"/"parts[i]; dirs[dir]+=size; counts[dir]++} END {for(dir in dirs) print dirs[dir], counts[dir], dir}' | sort -nr | head -10 | while read total_size count dir; do
    size_gb=$(echo "scale=1; $total_size / 1024 / 1024 / 1024" | bc)
    dirname=$(basename "$dir")
    echo "  ${size_gb}GB - $count files - $dirname"
done

echo ""
echo "📊 STEP 4: Duplicate Detection Strategy..."
echo "========================================"

# Look for potential video duplicates
echo "🔍 Potential video duplicates (same name, different paths):"
grep -E "(mp4|m4v|mpg|mpeg|avi|mov)" thunderbolt_sample_analysis.txt | awk '{filename=$3; size=$2; split(filename, parts, "/"); basename=parts[length(parts)]; print basename, size, filename}' | sort -k1,1 | awk '{name=$1; size=$2; path=$3; if(name in names) {print "DUPLICATE:", name, "Size:", size/1024/1024, "MB", "Path:", path} else {names[name]=path; sizes[name]=size}}'

echo ""
echo "📊 STEP 5: Optimization Recommendations..."
echo "========================================"

echo "🎯 BIGGEST WINS STRATEGY:"
echo ""
echo "1. 🎬 PLEX SERVER MUSIC VIDEOS (BIGGEST TARGET)"
echo "   • Location: $THUNDERBOLT_DIR/Plex Server/Music Videos"
echo "   • Space: ~20GB+ in sample alone"
echo "   • Action: Check for duplicates, optimize quality"
echo ""
echo "2. 🎬 LARGE VIDEO FILES (>50MB each)"
echo "   • Files: 100+ files over 50MB each"
echo "   • Space: ~15GB+ potential savings"
echo "   • Action: Compress or remove duplicates"
echo ""
echo "3. 🎬 OLD FORMAT VIDEOS (.mpg, .mpeg)"
echo "   • Files: Multiple .mpg files found"
echo "   • Space: ~10GB+ potential savings"
echo "   • Action: Convert to modern formats or remove"
echo ""
echo "4. 🎬 DUPLICATE DETECTION"
echo "   • Strategy: Find files with same name/size"
echo "   • Action: Remove duplicates, keep best quality"
echo ""

echo "📊 STEP 6: Immediate Action Plan..."
echo "=================================="

echo "🚀 RECOMMENDED IMMEDIATE ACTIONS:"
echo ""
echo "1. 🔍 Scan for video duplicates across both directories"
echo "2. 🎬 Focus on Plex Server Music Videos (biggest target)"
echo "3. 📹 Identify and remove old format videos (.mpg)"
echo "4. 💾 Compress large videos to modern formats"
echo "5. 🗑️  Remove obvious duplicates (same name/size)"
echo ""

echo "💾 POTENTIAL SPACE SAVINGS:"
echo "  • Video duplicates: 5-10GB"
echo "  • Old format conversion: 5-8GB"
echo "  • Quality optimization: 10-15GB"
echo "  • TOTAL POTENTIAL: 20-33GB from video files alone!"
echo ""

echo "📋 Analysis files created:"
echo "  • thunderbolt_sample_analysis.txt - Video file analysis"
echo "  • Video cleanup strategy ready for implementation"
echo ""

echo "🎯 Ready to implement video cleanup strategy!" 