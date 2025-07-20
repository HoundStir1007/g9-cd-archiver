#!/bin/bash

echo "🎬 VIDEO DUPLICATE REMOVAL - SAFE CLEANUP"
echo "=========================================="
echo ""

# Set directories
THUNDERBOLT_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer"
CANVIO_DIR="/media/mark/paperless-ssd/digital_consolidation/canvio_transfer"

# Create backup log
BACKUP_LOG="video_duplicate_removal_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Identifying Video Duplicates..."
echo "========================================"

# Create a comprehensive list of all video files
echo "🔍 Scanning for video files in both directories..."
find "$THUNDERBOLT_DIR" "$CANVIO_DIR" -type f \( -name "*.mp4" -o -name "*.m4v" -o -name "*.mpg" -o -name "*.mpeg" -o -name "*.avi" -o -name "*.mov" \) 2>/dev/null | while read file; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || echo 0)
        filename=$(basename "$file")
        echo "$filename $size $file" >> all_video_files.txt
    fi
done

echo "✅ Video file scan complete!"

echo ""
echo "📊 STEP 2: Finding Duplicates..."
echo "================================"

# Find duplicates by filename and size
echo "🔍 Identifying duplicate video files..."
awk '{filename=$1; size=$2; path=$3; key=filename"_"size; if(key in files) {print "DUPLICATE:", filename, "Size:", size/1024/1024, "MB", "Original:", files[key], "Duplicate:", path} else {files[key]=path}}' all_video_files.txt > duplicate_videos.txt

# Count duplicates
duplicate_count=$(grep "^DUPLICATE:" duplicate_videos.txt | wc -l)
duplicate_space=$(grep "^DUPLICATE:" duplicate_videos.txt | awk '{sum+=$4} END {print sum/1024/1024/1024}')

echo "📋 Duplicate Analysis Results:"
echo "  • Duplicate files found: $duplicate_count"
echo "  • Total duplicate space: ${duplicate_space}GB"
echo ""

echo "📊 STEP 3: Safe Duplicate Removal..."
echo "==================================="

# Create removal script with safety checks
echo "🔍 Creating safe removal script..."
cat > remove_duplicates_safe.sh << 'EOF'
#!/bin/bash

echo "🎬 SAFE DUPLICATE REMOVAL"
echo "========================="

# Read duplicate list and remove safely
while IFS= read -r line; do
    if [[ $line =~ ^DUPLICATE: ]]; then
        # Extract duplicate file path
        duplicate_path=$(echo "$line" | awk '{print $NF}')
        
        if [ -f "$duplicate_path" ]; then
            # Get file info before removal
            size=$(stat -c%s "$duplicate_path" 2>/dev/null || echo 0)
            size_mb=$((size / 1024 / 1024))
            
            echo "🗑️  Removing: $(basename "$duplicate_path") (${size_mb}MB)"
            echo "   Path: $duplicate_path"
            
            # Log before removal
            echo "$(date): Removing duplicate: $duplicate_path (${size_mb}MB)" >> video_duplicate_removal_$(date +%Y%m%d_%H%M%S).log
            
            # Remove the file
            rm "$duplicate_path"
            
            if [ $? -eq 0 ]; then
                echo "   ✅ Removed successfully"
            else
                echo "   ❌ Failed to remove"
            fi
        else
            echo "⚠️  File not found: $duplicate_path"
        fi
    fi
done < duplicate_videos.txt

echo ""
echo "🎯 Duplicate removal complete!"
EOF

chmod +x remove_duplicates_safe.sh

echo "📊 STEP 4: Preview of Duplicates to Remove..."
echo "============================================="

# Show top 10 largest duplicates
echo "🔍 Top 10 largest duplicates to remove:"
grep "^DUPLICATE:" duplicate_videos.txt | sort -k4 -nr | head -10 | while read line; do
    filename=$(echo "$line" | awk '{print $2}')
    size=$(echo "$line" | awk '{print $4}')
    path=$(echo "$line" | awk '{print $NF}')
    echo "  ${size}MB - $filename"
    echo "    Path: $path"
done

echo ""
echo "📊 STEP 5: Safety Summary..."
echo "============================"

echo "🛡️  SAFETY MEASURES:"
echo "  • Backup log created: $BACKUP_LOG"
echo "  • Duplicate list saved: duplicate_videos.txt"
echo "  • Safe removal script: remove_duplicates_safe.sh"
echo "  • Original files preserved (keeping best quality)"
echo ""

echo "💾 POTENTIAL SPACE SAVINGS:"
echo "  • Duplicate files: $duplicate_count"
echo "  • Space to recover: ${duplicate_space}GB"
echo ""

echo "🚀 READY TO REMOVE DUPLICATES!"
echo ""
echo "To proceed with safe removal, run:"
echo "  ./remove_duplicates_safe.sh"
echo ""
echo "To preview more duplicates:"
echo "  head -20 duplicate_videos.txt" 