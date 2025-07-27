#!/bin/bash

# 🧹 Cleanup Empty Directories After Migration
# Safely removes empty directories left behind from media migrations
# Created: January 28, 2025

echo "🧹 Cleanup Empty Directories After Migration"
echo "============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Log file for tracking
LOG_FILE="empty_directories_cleanup_$(date +%Y%m%d_%H%M%S).log"
echo "📝 Creating cleanup log: $LOG_FILE"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to count empty directories
count_empty_dirs() {
    local path="$1"
    local count=$(find "$path" -type d -empty 2>/dev/null | wc -l)
    echo "$count"
}

# Function to safely remove empty directories
clean_empty_dirs() {
    local base_path="$1"
    local description="$2"
    
    echo -e "${BLUE}🔍 Cleaning empty directories in: $description${NC}"
    echo "   Path: $base_path"
    
    if [ ! -d "$base_path" ]; then
        echo -e "${YELLOW}⚠️  Directory doesn't exist: $base_path${NC}"
        log_message "SKIP: Directory doesn't exist - $base_path"
        return
    fi
    
    # Count empty directories before cleanup
    local before_count=$(count_empty_dirs "$base_path")
    echo -e "${CYAN}   Found: $before_count empty directories${NC}"
    
    if [ "$before_count" -eq 0 ]; then
        echo -e "${GREEN}   ✅ No empty directories to clean${NC}"
        log_message "CLEAN: $description - No empty directories found"
        echo ""
        return
    fi
    
    # Log the cleanup
    log_message "START: Cleaning $before_count empty directories in $description"
    
    # Remove empty directories (this will run multiple times to catch nested empties)
    local removed_total=0
    for attempt in {1..5}; do
        echo -e "${CYAN}   Attempt $attempt: Removing empty directories...${NC}"
        
        # Find and remove empty directories
        local removed_this_round=0
        while IFS= read -r -d '' empty_dir; do
            if [ -d "$empty_dir" ] && [ -z "$(ls -A "$empty_dir" 2>/dev/null)" ]; then
                echo "     Removing: $(basename "$empty_dir")"
                if rmdir "$empty_dir" 2>/dev/null; then
                    ((removed_this_round++))
                    ((removed_total++))
                fi
            fi
        done < <(find "$base_path" -type d -empty -print0 2>/dev/null)
        
        echo -e "${CYAN}     Removed: $removed_this_round directories${NC}"
        
        # If no directories were removed this round, we're done
        if [ "$removed_this_round" -eq 0 ]; then
            break
        fi
    done
    
    # Count remaining empty directories
    local after_count=$(count_empty_dirs "$base_path")
    
    echo -e "${GREEN}   ✅ Results: Removed $removed_total directories${NC}"
    if [ "$after_count" -gt 0 ]; then
        echo -e "${YELLOW}   ⚠️  $after_count empty directories remain (may contain hidden files)${NC}"
    fi
    
    log_message "COMPLETE: $description - Removed $removed_total directories, $after_count remain"
    echo ""
}

# Main cleanup process
echo -e "${BLUE}🚀 Starting comprehensive empty directory cleanup...${NC}"
echo ""

# 1. Clean CD rips area
clean_empty_dirs "/media/mark/paperless-ssd1/digital_consolidation/cd_rips" "CD Rips"

# 2. Clean thunderbolt transfer area
clean_empty_dirs "/media/mark/paperless-ssd1/digital_consolidation/thunderbolt_transfer" "Thunderbolt Transfer"

# 3. Clean canvio transfer area  
clean_empty_dirs "/media/mark/paperless-ssd1/digital_consolidation/canvio_transfer" "Canvio Transfer"

# 4. Clean Jellyfin cache/config areas
clean_empty_dirs "/media/mark/paperless-ssd1/jellyfin" "Jellyfin Configuration"

# 5. Clean any other areas on paperless-ssd1
clean_empty_dirs "/media/mark/paperless-ssd1/.Trash-1000" "Trash Directory"

# Final summary
echo -e "${BLUE}📊 Final Summary${NC}"
echo "================"

echo -e "${CYAN}Checking final empty directory counts:${NC}"
for area in "cd_rips" "thunderbolt_transfer" "canvio_transfer"; do
    path="/media/mark/paperless-ssd1/digital_consolidation/$area"
    if [ -d "$path" ]; then
        count=$(count_empty_dirs "$path")
        echo "   $area: $count empty directories remaining"
    fi
done

# Check overall space freed
echo ""
echo -e "${CYAN}Disk space status:${NC}"
df -h /media/mark/paperless-ssd1 | tail -1

echo ""
echo -e "${GREEN}🎉 Empty directory cleanup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "✅ Empty directories removed from migration areas"
echo "✅ CD rips, thunderbolt, and canvio areas cleaned"
echo "✅ Jellyfin cache/config areas cleaned"
echo "📝 Full log available: $LOG_FILE"
echo ""
echo -e "${BLUE}🔧 Next steps:${NC}"
echo "1. Review log file for any issues"
echo "2. Verify important data is still accessible"
echo "3. Test Jellyfin functionality"
echo "4. Consider running storage analysis to see space freed" 