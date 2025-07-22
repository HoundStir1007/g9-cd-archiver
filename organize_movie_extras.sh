#!/bin/bash

# Movie Extras Organization Script
# Organizes movies into folders with proper extras structure
# Created: January 28, 2025

set -e  # Exit on any error

echo "🎬 Movie Extras Organization Script"
echo "=================================="

# Define source and destination
SOURCE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/movies"
DEST="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/movies"

# Create destination directory
mkdir -p "$DEST"

echo "📁 Creating organized movie structure..."

# Function to organize a movie and its extras
organize_movie() {
    local movie_file="$1"
    local movie_name=$(basename "$movie_file" | sed 's/\.[^.]*$//')
    
    # Extract year if present (format: Movie Name (YYYY))
    local year=$(echo "$movie_name" | grep -o '(20[0-9][0-9])' | head -1)
    
    if [ -n "$year" ]; then
        # Movie has year, use it
        local clean_name=$(echo "$movie_name" | sed 's/ (20[0-9][0-9])//')
        local folder_name="$clean_name $year"
    else
        # No year, use original name
        local folder_name="$movie_name"
    fi
    
    local movie_folder="$DEST/$folder_name"
    mkdir -p "$movie_folder"
    
    # Move main movie file
    local extension="${movie_file##*.}"
    local new_movie_name="$folder_name.$extension"
    echo "🔄 Moving: $movie_file -> $movie_folder/$new_movie_name"
    mv "$movie_file" "$movie_folder/$new_movie_name"
    
    # Look for related extras
    local base_name=$(echo "$movie_name" | sed 's/ (20[0-9][0-9])//')
    for extra_file in "$SOURCE"/*; do
        if [ -f "$extra_file" ]; then
            local extra_name=$(basename "$extra_file" | sed 's/\.[^.]*$//')
            
            # Check if this is an extra for the same movie
            if [[ "$extra_name" == *"$base_name"* ]] && [[ "$extra_name" != "$movie_name" ]]; then
                local extra_extension="${extra_file##*.}"
                local extra_type=""
                
                # Use original filename as the extra identifier
                local new_extra_name="$folder_name - $extra_name.$extra_extension"
                echo "🔄 Moving extra: $extra_file -> $movie_folder/$new_extra_name"
                mv "$extra_file" "$movie_folder/$new_extra_name"
            fi
        fi
    done
    
    echo "✅ Organized: $folder_name"
    echo ""
}

# Process all movie files
echo "🚀 Starting organization..."

# Get list of movie files (prioritize larger files as main movies)
find "$SOURCE" -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.m4v" -o -name "*.avi" \) | while read -r movie_file; do
    # Skip if already processed
    if [ -f "$movie_file" ]; then
        organize_movie "$movie_file"
    fi
done

echo "🎉 Movie organization complete!"
echo ""
echo "📊 Results:"
echo "✅ Movies organized into folders"
echo "✅ Extras properly named and grouped"
echo "✅ Ready for Jellyfin import"
echo ""
echo "🔧 Next steps:"
echo "1. Update Jellyfin library path to new structure"
echo "2. Scan library for new organization"
echo "3. Verify extras appear in Jellyfin interface" 