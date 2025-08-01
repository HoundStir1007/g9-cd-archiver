#!/bin/bash

# 🎬 COMPREHENSIVE TV SHOW MIGRATION TO JELLYFIN
# Migrates ALL TV shows from digital consolidation to Jellyfin media library

echo "🎬 COMPREHENSIVE TV SHOW MIGRATION TO JELLYFIN"
echo "================================================"
echo ""

# Configuration
SOURCE_DIR="/media/mark/paperless-ssd/digital_consolidation/thunderbolt_transfer/Plex Server/TV Shows"
DEST_DIR="/mnt/storage/jellyfin/media/tv"
LOG_FILE="tv_migration_$(date +%Y%m%d_%H%M%S).log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Create destination directory
mkdir -p "$DEST_DIR"

echo -e "${BLUE}📁 Source Directory:${NC} $SOURCE_DIR"
echo -e "${BLUE}📁 Destination Directory:${NC} $DEST_DIR"
echo -e "${BLUE}📝 Log File:${NC} $LOG_FILE"
echo ""

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to get directory size
get_dir_size() {
    du -sh "$1" 2>/dev/null | cut -f1
}

# Function to count files
count_files() {
    find "$1" -type f \( -name "*.mp4" -o -name "*.m4v" -o -name "*.mkv" -o -name "*.avi" \) 2>/dev/null | wc -l
}

# Function to migrate a TV show
migrate_tv_show() {
    local show_dir="$1"
    local show_name="$2"
    local source_size="$3"
    local file_count="$4"
    
    echo ""
    echo -e "${YELLOW}🎬 Migrating: $show_name${NC}"
    echo -e "${CYAN}📁 Source: $show_dir${NC}"
    echo -e "${CYAN}📊 Size: $source_size${NC}"
    echo -e "${CYAN}📄 Files: $file_count${NC}"
    
    # Create destination directory
    local safe_name=$(echo "$show_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')
    local dest_show_dir="$DEST_DIR/$safe_name"
    mkdir -p "$dest_show_dir"
    
    # Copy all video files
    echo -e "${BLUE}📋 Copying files...${NC}"
    
    # Find and copy all video files
    find "$show_dir" -type f \( -name "*.mp4" -o -name "*.m4v" -o -name "*.mkv" -o -name "*.avi" \) -print0 | while IFS= read -r -d '' file; do
        local filename=$(basename "$file")
        local dest_file="$dest_show_dir/$filename"
        
        if [ ! -f "$dest_file" ]; then
            echo -e "${CYAN}  📄 Copying: $filename${NC}"
            cp "$file" "$dest_file"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}  ✅ Copied: $filename${NC}"
            else
                echo -e "${RED}  ❌ Failed: $filename${NC}"
            fi
        else
            echo -e "${YELLOW}  ⚠️  Skipped (exists): $filename${NC}"
        fi
    done
    
    # Verify migration
    local copied_files=$(find "$dest_show_dir" -type f \( -name "*.mp4" -o -name "*.m4v" -o -name "*.mkv" -o -name "*.avi" \) | wc -l)
    local dest_size=$(get_dir_size "$dest_show_dir")
    
    echo -e "${GREEN}✅ Migration Complete: $show_name${NC}"
    echo -e "${CYAN}  📁 Destination: $dest_show_dir${NC}"
    echo -e "${CYAN}  📄 Files Copied: $copied_files${NC}"
    echo -e "${CYAN}  📊 Size: $dest_size${NC}"
    
    log_message "MIGRATED: $show_name - $copied_files files - $dest_size"
}

# Main migration process
echo -e "${BLUE}🔍 Analyzing TV show directories...${NC}"
echo ""

# Get all TV show directories
tv_shows=()
while IFS= read -r -d '' dir; do
    if [ -d "$dir" ] && [ "$(basename "$dir")" != "TV Shows" ]; then
        show_name=$(basename "$dir")
        source_size=$(get_dir_size "$dir")
        file_count=$(count_files "$dir")
        
        if [ "$file_count" -gt 0 ]; then
            tv_shows+=("$dir|$show_name|$source_size|$file_count")
        fi
    fi
done < <(find "$SOURCE_DIR" -maxdepth 1 -type d -print0)

# Sort by size (largest first)
IFS=$'\n' tv_shows=($(sort -t'|' -k3 -hr <<<"${tv_shows[*]}"))
unset IFS

echo -e "${GREEN}📺 Found ${#tv_shows[@]} TV shows to migrate:${NC}"
echo ""

# Display migration plan
total_size=0
total_files=0
for show_info in "${tv_shows[@]}"; do
    IFS='|' read -r dir show_name source_size file_count <<< "$show_info"
    echo -e "${CYAN}  📺 $show_name${NC}"
    echo -e "${YELLOW}    📊 Size: $source_size${NC}"
    echo -e "${YELLOW}    📄 Files: $file_count${NC}"
    echo ""
done

echo -e "${BLUE}🚀 Starting comprehensive TV show migration...${NC}"
echo ""

# Start migration
start_time=$(date +%s)
migrated_count=0
total_migrated_files=0

for show_info in "${tv_shows[@]}"; do
    IFS='|' read -r dir show_name source_size file_count <<< "$show_info"
    
    migrate_tv_show "$dir" "$show_name" "$source_size" "$file_count"
    
    migrated_count=$((migrated_count + 1))
    total_migrated_files=$((total_migrated_files + file_count))
    
    echo -e "${GREEN}✅ Progress: $migrated_count/${#tv_shows[@]} shows migrated${NC}"
    echo ""
done

# Calculate total time
end_time=$(date +%s)
duration=$((end_time - start_time))
hours=$((duration / 3600))
minutes=$(((duration % 3600) / 60))
seconds=$((duration % 60))

# Final summary
echo -e "${GREEN}🎉 COMPREHENSIVE TV SHOW MIGRATION COMPLETE!${NC}"
echo "================================================"
echo -e "${CYAN}📊 Migration Summary:${NC}"
echo -e "${YELLOW}  📺 Shows Migrated: $migrated_count${NC}"
echo -e "${YELLOW}  📄 Total Files: $total_migrated_files${NC}"
echo -e "${YELLOW}  ⏱️  Duration: ${hours}h ${minutes}m ${seconds}s${NC}"
echo -e "${YELLOW}  📁 Destination: $DEST_DIR${NC}"
echo -e "${YELLOW}  📝 Log File: $LOG_FILE${NC}"
echo ""

# Show final directory structure
echo -e "${BLUE}📁 Final Jellyfin TV Directory Structure:${NC}"
ls -la "$DEST_DIR" | head -20

echo ""
echo -e "${GREEN}🎬 All TV shows are now ready for Jellyfin scanning!${NC}"
echo -e "${CYAN}💡 Next step: Add $DEST_DIR to your Jellyfin TV Shows library${NC}" 