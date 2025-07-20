#!/bin/bash

echo "🎬 TARGETED VIDEO CLEANUP - BIGGEST WINS"
echo "========================================"
echo ""

# Create backup log
BACKUP_LOG="targeted_video_cleanup_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Analyzing Largest Video Files..."
echo "=========================================="

# Get top 20 largest video files
echo "🔍 Top 20 largest video files (potential targets):"
sort -k2 -nr all_video_files.txt | head -20 | while read filename size path; do
    size_mb=$((size / 1024 / 1024))
    size_gb=$(echo "scale=1; $size_mb / 1024" | bc)
    echo "  ${size_gb}GB - $filename"
    echo "    Path: $path"
done

echo ""
echo "📊 STEP 2: Finding Exact Duplicates..."
echo "====================================="

# Find exact duplicates (same filename, different paths)
echo "🔍 Looking for exact duplicates..."
awk '{filename=$1; size=$2; path=$3; if(filename in files) {print "DUPLICATE:", filename, "Size:", size/1024/1024, "MB", "Original:", files[filename], "Duplicate:", path} else {files[filename]=path}}' all_video_files.txt > exact_duplicates.txt

exact_duplicates=$(grep "^DUPLICATE:" exact_duplicates.txt | wc -l)
echo "📋 Found $exact_duplicates exact duplicate files"

echo ""
echo "📊 STEP 3: Creating Safe Removal Script..."
echo "========================================"

# Create removal script for exact duplicates
cat > remove_exact_duplicates.sh << 'EOF'
#!/bin/bash

echo "🎬 REMOVING EXACT VIDEO DUPLICATES"
echo "================================="

# Read exact duplicate list and remove safely
while IFS= read -r line; do
    if [[ $line =~ ^DUPLICATE: ]]; then
        # Extract duplicate file path
        duplicate_path=$(echo "$line" | awk '{print $NF}')
        
        if [ -f "$duplicate_path" ]; then
            # Get file info before removal
            size=$(stat -c%s "$duplicate_path" 2>/dev/null || echo 0)
            size_mb=$((size / 1024 / 1024))
            filename=$(basename "$duplicate_path")
            
            echo "🗑️  Removing duplicate: $filename (${size_mb}MB)"
            echo "   Path: $duplicate_path"
            
            # Log before removal
            echo "$(date): Removing exact duplicate: $duplicate_path (${size_mb}MB)" >> targeted_video_cleanup_$(date +%Y%m%d_%H%M%S).log
            
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
done < exact_duplicates.txt

echo ""
echo "🎯 Exact duplicate removal complete!"
EOF

chmod +x remove_exact_duplicates.sh

echo "📊 STEP 4: Space Savings Summary..."
echo "=================================="

# Calculate potential space savings from exact duplicates
total_duplicate_space=$(grep "^DUPLICATE:" exact_duplicates.txt | awk '{sum+=$4} END {print sum/1024/1024/1024}')

echo "💾 POTENTIAL SPACE SAVINGS:"
echo "  • Exact duplicates: $exact_duplicates files"
echo "  • Duplicate space: ${total_duplicate_space}GB"
echo "  • Largest files: 20+ files over 1GB each"
echo ""

echo "🎯 RECOMMENDED ACTIONS:"
echo "  1. Remove exact duplicates (safe, immediate wins)"
echo "  2. Review largest files for manual cleanup"
echo "  3. Focus on Plex Server directory (biggest space usage)"
echo ""

echo "🛡️  SAFETY MEASURES:"
echo "  • Backup log: $BACKUP_LOG"
echo "  • Exact duplicate list: exact_duplicates.txt"
echo "  • Safe removal script: remove_exact_duplicates.sh"
echo "  • Original files preserved (keeping best quality)"
echo ""

echo "🚀 READY FOR TARGETED CLEANUP!"
echo ""
echo "To remove exact duplicates, run:"
echo "  ./remove_exact_duplicates.sh" 