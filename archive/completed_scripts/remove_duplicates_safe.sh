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
