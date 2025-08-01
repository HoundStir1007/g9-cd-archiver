#!/bin/bash

# 🎬 Paula Poundstone Subtitle Timing Fix
# Shifts subtitles 2 seconds later to sync with video

echo "🎬 Fixing Paula Poundstone subtitle timing..."

# File paths
ORIGINAL_FILE="/media/mark/paperless-ssd/jellyfin/media/movies/Paula Poundstone Cats Cops and Stuff (INCOMPLETE).mp4"
BACKUP_FILE="/media/mark/paperless-ssd/jellyfin/media/movies/Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_BACKUP.mp4"
FIXED_FILE="/media/mark/paperless-ssd/jellyfin/media/movies/Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_FIXED.mp4"

# Check if original file exists
if [ ! -f "$ORIGINAL_FILE" ]; then
    echo "❌ Error: Original file not found"
    exit 1
fi

# Create backup if it doesn't exist
if [ ! -f "$BACKUP_FILE" ]; then
    echo "💾 Creating backup..."
    cp "$ORIGINAL_FILE" "$BACKUP_FILE"
    echo "✅ Backup created: Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_BACKUP.mp4"
fi

echo "🔧 Fixing subtitle timing (adding 2 seconds delay)..."

# Method 1: Extract, fix timing, and re-embed subtitles
echo "📄 Step 1: Extracting current subtitles..."
ffmpeg -i "$ORIGINAL_FILE" -map 0:3 -c:s srt temp_subtitles.srt -y

if [ ! -f "temp_subtitles.srt" ]; then
    echo "❌ Failed to extract subtitles as SRT. Trying alternative method..."
    
    # Alternative: Use filter to shift timing directly
    echo "🔧 Using direct timing shift method..."
    ffmpeg -i "$ORIGINAL_FILE" \
        -map 0:v -map 0:a:0 -map 0:a:1 -map 0:s:0 -map 0:d:0 \
        -c:v copy -c:a copy \
        -c:s mov_text \
        -filter:s:0 "setpts=PTS+2/TB" \
        -y "$FIXED_FILE"
else
    echo "📝 Step 2: Adjusting subtitle timing..."
    # Shift SRT timing by +2 seconds using awk
    awk '
    /^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}$/ {
        # Parse start time
        split($1, start, "[:,]")
        start_ms = start[1]*3600000 + start[2]*60000 + start[3]*1000 + start[4]
        start_ms += 2000  # Add 2 seconds (2000ms)
        
        # Parse end time  
        split($3, end, "[:,]")
        end_ms = end[1]*3600000 + end[2]*60000 + end[3]*1000 + end[4]
        end_ms += 2000  # Add 2 seconds (2000ms)
        
        # Convert back to timestamp format
        printf "%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d\n", 
            int(start_ms/3600000), int((start_ms%3600000)/60000), 
            int((start_ms%60000)/1000), start_ms%1000,
            int(end_ms/3600000), int((end_ms%3600000)/60000), 
            int((end_ms%60000)/1000), end_ms%1000
        next
    }
    { print }
    ' temp_subtitles.srt > temp_subtitles_fixed.srt
    
    echo "🎬 Step 3: Re-embedding corrected subtitles..."
    ffmpeg -i "$ORIGINAL_FILE" -i temp_subtitles_fixed.srt \
        -map 0:v -map 0:a:0 -map 0:a:1 -map 1:s:0 -map 0:d:0 \
        -c:v copy -c:a copy -c:s mov_text \
        -y "$FIXED_FILE"
    
    # Clean up temp files
    rm -f temp_subtitles.srt temp_subtitles_fixed.srt
fi

if [ $? -eq 0 ] && [ -f "$FIXED_FILE" ]; then
    echo ""
    echo "✅ SUCCESS! Subtitle timing fixed!"
    echo "📁 Files created:"
    echo "   💾 Backup: Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_BACKUP.mp4"
    echo "   🎬 Fixed: Paula Poundstone Cats Cops and Stuff (INCOMPLETE)_FIXED.mp4"
    echo ""
    echo "🎯 Test the fixed file in Jellyfin to confirm subtitles are synchronized."
    echo "💡 If satisfied, you can replace the original with the fixed version."
    echo ""
    echo "🔄 To replace original (after testing):"
    echo "   mv \"$FIXED_FILE\" \"$ORIGINAL_FILE\""
    echo ""
    echo "📊 File sizes:"
    ls -lh "$BACKUP_FILE" "$FIXED_FILE" | awk '{print "   " $9 ": " $5}'
else
    echo "❌ Error during subtitle timing fix"
    exit 1
fi 