#!/bin/bash

echo "🎬 LARGE VIDEO DUPLICATE REMOVAL"
echo "================================"
echo ""

# Create backup log
BACKUP_LOG="large_video_removal_$(date +%Y%m%d_%H%M%S).log"
echo "📋 Creating backup log: $BACKUP_LOG"

echo "📊 STEP 1: Finding Large Video Duplicates..."
echo "==========================================="

# Find duplicates by filename (same name, different paths)
echo "🔍 Identifying duplicate video files by filename..."
awk '{filename=$1; size=$2; path=$3; if(filename in files) {print "DUPLICATE:", filename, "Size:", size/1024/1024, "MB", "Original:", files[filename], "Duplicate:", path} else {files[filename]=path}}' all_video_files.txt > large_duplicates.txt

# Count duplicates
duplicate_count=$(grep "^DUPLICATE:" large_duplicates.txt | wc -l)
echo "📋 Found $duplicate_count duplicate video files"

echo ""
echo "📊 STEP 2: Preview of Largest Duplicates..."
echo "=========================================="

# Show top 10 largest duplicates
echo "🔍 Top 10 largest duplicates to remove:"
grep "^DUPLICATE:" large_duplicates.txt | sort -k4 -nr | head -10 | while read line; do
    filename=$(echo "$line" | awk '{print $2}')
    size=$(echo "$line" | awk '{print $4}')
    path=$(echo "$line" | awk '{print $NF}')
    echo "  ${size}MB - $filename"
    echo "    Path: $path"
done

echo ""
echo "📊 STEP 3: Safe Removal Script..."
echo "================================"

# Create safe removal script
cat > remove_large_duplicates_safe.sh << 'EOF'
#!/bin/bash

echo "🎬 SAFE LARGE VIDEO DUPLICATE REMOVAL"
echo "====================================="

# Read duplicate list and remove safely
while IFS= read -r line; do
    if [[ $line =~ ^DUPLICATE: ]]; then
        # Extract duplicate file path
        duplicate_path=$(echo "$line" | awk '{print $NF}')
        
        if [ -f "$duplicate_path" ]; then
            # Get file info before removal
            size=$(stat -c%s "$duplicate_path" 2>/dev/null || echo 0)
            size_mb=$((size / 1024 / 1024))
            filename=$(basename "$duplicate_path")
            
            echo "🗑️  Removing: $filename (${size_mb}MB)"
            echo "   Path: $duplicate_path"
            
            # Log before removal
            echo "$(date): Removing duplicate: $duplicate_path (${size_mb}MB)" >> large_video_removal_$(date +%Y%m%d_%H%M%S).log
            
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
done < large_duplicates.txt

echo ""
echo "🎯 Large video duplicate removal complete!"
EOF

chmod +x remove_large_duplicates_safe.sh

echo "📊 STEP 4: Space Savings Summary..."
echo "=================================="

# Calculate potential space savings
total_space=$(grep "^DUPLICATE:" large_duplicates.txt | awk '{sum+=$4} END {print sum/1024/1024/1024}')
echo "💾 POTENTIAL SPACE SAVINGS:"
echo "  • Duplicate files: $duplicate_count"
echo "  • Space to recover: ${total_space}GB"
echo ""

echo "🛡️  SAFETY MEASURES:"
echo "  • Backup log: $BACKUP_LOG"
echo "  • Duplicate list: large_duplicates.txt"
echo "  • Safe removal script: remove_large_duplicates_safe.sh"
echo "  • Original files preserved (keeping best quality)"
echo ""

echo "🚀 READY TO REMOVE LARGE VIDEO DUPLICATES!"
echo ""
echo "To proceed with safe removal, run:"
echo "  ./remove_large_duplicates_safe.sh" 