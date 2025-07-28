#!/bin/bash

# 🎬 Jellyfin Movie Name Cleanup Script
# Fixes common naming issues that prevent Jellyfin from recognizing movies

MOVIES_DIR="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies"
LOG_FILE="movie_cleanup_$(date +%Y%m%d_%H%M%S).log"

echo "🎬 Starting Jellyfin Movie Name Cleanup..." | tee "$LOG_FILE"
echo "Movies directory: $MOVIES_DIR" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

cd "$MOVIES_DIR" || exit 1

# Function to clean movie name
clean_movie_name() {
    local original="$1"
    local cleaned="$original"
    
    # Remove common release tags and quality info
    cleaned=$(echo "$cleaned" | sed -E 's/\.(1080p|720p|480p|BRRip|DVDRip|BluRay|x264|XviD|DTS|AC3|YIFY|Feel-Free|IMAGiNE|MAXSPEED).*$//')
    cleaned=$(echo "$cleaned" | sed -E 's/\s+(1080p|720p|480p|BRRip|DVDRip|BluRay|x264|XviD|DTS|AC3|YIFY|Feel-Free|IMAGiNE|MAXSPEED).*$//')
    
    # Remove website/torrent tags
    cleaned=$(echo "$cleaned" | sed -E 's/\s+www\.[^[:space:]]+//')
    cleaned=$(echo "$cleaned" | sed -E 's/\[[^]]*\]//')
    
    # Replace underscores with spaces
    cleaned=$(echo "$cleaned" | sed 's/_/ /g')
    
    # Fix common title case issues
    cleaned=$(echo "$cleaned" | sed 's/BEASTSOFTHESOUTHERNWILD/Beasts of the Southern Wild/')
    cleaned=$(echo "$cleaned" | sed 's/ASTRO BOY/Astro Boy/')
    cleaned=$(echo "$cleaned" | sed 's/A MONSTER IN PARIS/A Monster in Paris/')
    
    # Clean up extra spaces
    cleaned=$(echo "$cleaned" | sed 's/  */ /g' | sed 's/^ *//' | sed 's/ *$//')
    
    echo "$cleaned"
}

# Function to add year if missing (basic detection)
add_year_if_missing() {
    local name="$1"
    
    # If already has year in parentheses, return as-is
    if [[ "$name" =~ \([0-9]{4}\) ]]; then
        echo "$name"
        return
    fi
    
    # Check if year exists in name and add parentheses
    if [[ "$name" =~ (19|20)[0-9]{2} ]]; then
        year=$(echo "$name" | grep -oE '(19|20)[0-9]{2}' | head -1)
        name_without_year=$(echo "$name" | sed -E "s/\s*(19|20)[0-9]{2}\s*/ /g" | sed 's/  */ /g' | sed 's/^ *//' | sed 's/ *$//')
        echo "$name_without_year ($year)"
    else
        # No year found, return as-is for manual review
        echo "$name"
    fi
}

# Process directories
processed=0
renamed=0

echo "Processing directories..." | tee -a "$LOG_FILE"

for dir in */; do
    if [[ "$dir" == "*/" ]]; then
        break
    fi
    
    dir_name="${dir%/}"  # Remove trailing slash
    processed=$((processed + 1))
    
    # Clean the name
    cleaned_name=$(clean_movie_name "$dir_name")
    final_name=$(add_year_if_missing "$cleaned_name")
    
    # Check if rename is needed
    if [[ "$dir_name" != "$final_name" ]]; then
        echo "RENAME: '$dir_name' -> '$final_name'" | tee -a "$LOG_FILE"
        
        # Perform rename
        mv "$dir_name" "$final_name" 2>&1 | tee -a "$LOG_FILE"
        if [[ $? -eq 0 ]]; then
            renamed=$((renamed + 1))
            echo "  ✅ SUCCESS" | tee -a "$LOG_FILE"
        else
            echo "  ❌ FAILED" | tee -a "$LOG_FILE"
        fi
    fi
done

echo "----------------------------------------" | tee -a "$LOG_FILE"
echo "📊 Summary:" | tee -a "$LOG_FILE"
echo "  Processed: $processed directories" | tee -a "$LOG_FILE"
echo "  Need renaming: $renamed directories" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "⚠️  SAFETY MODE: Renames are currently disabled" | tee -a "$LOG_FILE"
echo "    Review the log file, then uncomment the mv lines in the script" | tee -a "$LOG_FILE"
echo "    to perform actual renames." | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "🔧 To apply changes:" | tee -a "$LOG_FILE"
echo "    1. Review this log file" | tee -a "$LOG_FILE"
echo "    2. Edit the script to uncomment the 'mv' lines" | tee -a "$LOG_FILE"
echo "    3. Run the script again" | tee -a "$LOG_FILE"
echo "    4. Rescan Jellyfin libraries" | tee -a "$LOG_FILE"

echo "✅ Cleanup analysis complete! Check $LOG_FILE for details." 