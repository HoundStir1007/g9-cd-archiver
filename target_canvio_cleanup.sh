#!/bin/bash

echo "🎯 TARGETED CANVIO CLEANUP (319GB)"
echo "==================================="
echo ""

# Set target directory
CANVIO_DIR="/media/mark/paperless-ssd/digital_consolidation/canvio_transfer"
if [ ! -d "$CANVIO_DIR" ]; then
    echo "❌ Canvio directory not found at: $CANVIO_DIR"
    exit 1
fi

echo "📊 STEP 1: Quick Canvio Analysis..."
echo "=================================="

# Get total size and file count
total_size=$(du -sh "$CANVIO_DIR" 2>/dev/null | cut -f1)
file_count=$(find "$CANVIO_DIR" -type f 2>/dev/null | wc -l)

echo "📋 Canvio Transfer Stats:"
echo "  • Total Size: $total_size"
echo "  • File Count: $file_count"
echo ""

echo "📊 STEP 2: Finding Biggest Wins in Canvio..."
echo "============================================"

# Find largest files in Canvio
echo "🔍 Top 20 largest files in Canvio:"
find "$CANVIO_DIR" -type f 2>/dev/null -exec ls -lh {} \; | sort -k5 -hr | head -20 | while read line; do
    size=$(echo "$line" | awk '{print $5}')
    file=$(echo "$line" | awk '{for(i=9;i<=NF;i++) printf $i" "; print ""}')
    echo "  $size - $file"
done

echo ""
echo "📊 STEP 3: File Type Analysis in Canvio..."
echo "========================================="

# Analyze file types by space usage
echo "🔍 Analyzing file types..."
find "$CANVIO_DIR" -type f 2>/dev/null | while read file; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || echo 0)
        ext=$(echo "$file" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')
        if [ "$ext" = "$file" ]; then
            ext="no_extension"
        fi
        echo "$ext $size $file" >> canvio_file_analysis.txt
    fi
done

# Show top file types by space
if [ -f "canvio_file_analysis.txt" ]; then
    echo ""
    echo "📋 Top file types by space usage:"
    awk '{ext=$1; size=$2; sizes[ext]+=size; counts[ext]++} END {for(ext in sizes) print sizes[ext], counts[ext], ext}' canvio_file_analysis.txt | sort -nr | head -10 | while read total_size count ext; do
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
echo "📊 STEP 4: System Junk Detection..."
echo "=================================="

# Find system junk files
echo "🗑️  System junk files found:"
junk_count=0
junk_size=0

# .DS_Store files (Mac)
ds_count=$(find "$CANVIO_DIR" -name ".DS_Store" 2>/dev/null | wc -l)
if [ $ds_count -gt 0 ]; then
    ds_size=$(find "$CANVIO_DIR" -name ".DS_Store" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    ds_size_mb=$((ds_size / 1024 / 1024))
    echo "  • $ds_count .DS_Store files (${ds_size_mb}MB)"
    junk_count=$((junk_count + ds_count))
    junk_size=$((junk_size + ds_size))
fi

# Thumbs.db files (Windows)
thumbs_count=$(find "$CANVIO_DIR" -name "Thumbs.db" 2>/dev/null | wc -l)
if [ $thumbs_count -gt 0 ]; then
    thumbs_size=$(find "$CANVIO_DIR" -name "Thumbs.db" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    thumbs_size_mb=$((thumbs_size / 1024 / 1024))
    echo "  • $thumbs_count Thumbs.db files (${thumbs_size_mb}MB)"
    junk_count=$((junk_count + thumbs_count))
    junk_size=$((junk_size + thumbs_size))
fi

# Temp files
temp_count=$(find "$CANVIO_DIR" -name "*.tmp" -o -name "*.temp" -o -name "*.cache" 2>/dev/null | wc -l)
if [ $temp_count -gt 0 ]; then
    temp_size=$(find "$CANVIO_DIR" -name "*.tmp" -o -name "*.temp" -o -name "*.cache" -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum}')
    temp_size_mb=$((temp_size / 1024 / 1024))
    echo "  • $temp_count temp/cache files (${temp_size_mb}MB)"
    junk_count=$((junk_count + temp_count))
    junk_size=$((junk_size + temp_size))
fi

echo ""
echo "📊 STEP 5: Duplicate Detection..."
echo "================================"

# Find potential duplicates (same name + size)
echo "🔍 Looking for duplicates..."
find "$CANVIO_DIR" -type f 2>/dev/null -printf "%s %f %p\n" | sort -k1,2 | uniq -d -w 50 > canvio_duplicates.txt

dup_count=$(wc -l < canvio_duplicates.txt)
if [ $dup_count -gt 0 ]; then
    echo "📋 Found $dup_count potential duplicates"
    
    # Calculate duplicate space
    dup_size=0
    while read size name path; do
        dup_size=$((dup_size + size))
    done < canvio_duplicates.txt
    
    dup_size_mb=$((dup_size / 1024 / 1024))
    echo "  • Potential savings: ${dup_size_mb}MB"
    
    echo ""
    echo "📋 Top 10 duplicates:"
    head -10 canvio_duplicates.txt | while read size name path; do
        size_mb=$((size / 1024 / 1024))
        echo "  ${size_mb}MB - $name"
    done
else
    echo "✅ No obvious duplicates found"
fi

echo ""
echo "📊 STEP 6: Quick Wins Summary..."
echo "================================"

# Calculate total potential savings
total_junk_mb=$((junk_size / 1024 / 1024))
total_dup_mb=$((dup_size / 1024 / 1024))
total_savings_mb=$((total_junk_mb + total_dup_mb))

echo "💾 POTENTIAL SPACE SAVINGS:"
echo "  • System junk: ${total_junk_mb}MB"
echo "  • Duplicates: ${total_dup_mb}MB"
echo "  • TOTAL: ${total_savings_mb}MB"
echo ""

echo "🎯 RECOMMENDED ACTIONS:"
echo "  1. Delete $junk_count system junk files (${total_junk_mb}MB)"
echo "  2. Review and remove $dup_count duplicates (${total_dup_mb}MB)"
echo "  3. Focus on largest file types identified above"
echo ""

echo "📋 Analysis files created:"
echo "  • canvio_file_analysis.txt - File type breakdown"
echo "  • canvio_duplicates.txt - Duplicate candidates"
echo ""

echo "🚀 Ready to clean up Canvio Transfer!" 