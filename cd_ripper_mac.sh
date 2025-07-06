#!/bin/bash

# CD-R Batch Ripper for Mac OS X 10.8
# Automates the process of ripping multiple CD-Rs with proper naming and organization
# Compatible with OS X 10.8 Mountain Lion
# Updated: USB Optical Drive support for aging Mac mini A1347 hardware

# Configuration - Updated for G9-Reborn destination
# Note: Script updated for USB optical drive compatibility due to Mac mini A1347 aging hardware
OUTPUT_DIR="/Users/$(whoami)/Desktop/CD_Rips"  # Local staging before network transfer
LOG_FILE="$OUTPUT_DIR/ripping_log.txt"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎵 CD-R Batch Ripper v2.0 - USB Optical Drive Compatible${NC}"
echo -e "${YELLOW}Hardware: Mac mini A1347 + USB Optical Drive (addressing internal drive reliability)${NC}"
echo -e "${YELLOW}Destination: Local staging for G9-Reborn network transfer${NC}"
echo ""

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Initialize log file
echo "CD-R Ripping Session Started: $(date)" >> "$LOG_FILE"
echo "Platform: Mac mini A1347 with USB Optical Drive" >> "$LOG_FILE"
echo "Target: G9-Reborn 4TB M.2 storage via network transfer" >> "$LOG_FILE"

echo -e "${GREEN}✅ Output directory ready: $OUTPUT_DIR${NC}"
echo -e "${YELLOW}Log File: $LOG_FILE${NC}"

# Check available space on local drive
LOCAL_SPACE=$(df -h "$HOME" 2>/dev/null | tail -1 | awk '{print $4}' || echo "Unknown")
echo -e "${BLUE}💽 Available local space: $LOCAL_SPACE${NC}"
echo -e "${YELLOW}💡 Note: Files will transfer to G9-Reborn 4TB M.2 after ripping${NC}"
echo ""

# Function to get disc info
get_disc_info() {
    local volume_path="/Volumes/*"
    local disc_name=""
    local disc_path=""
    
    # Find mounted CD/DVD volumes
    for vol in $volume_path; do
        if [ -d "$vol" ]; then
            # Check if it's a CD/DVD by looking for typical disc characteristics
            if diskutil info "$vol" 2>/dev/null | grep -q "CD\|DVD"; then
                disc_name=$(basename "$vol")
                disc_path="$vol"
                break
            fi
        fi
    done
    
    echo "$disc_name|$disc_path"
}

# Function to sanitize filename
sanitize_filename() {
    echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g'
}

# Function to copy disc contents
copy_disc() {
    local disc_name="$1"
    local disc_path="$2"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local sanitized_name=$(sanitize_filename "$disc_name")
    local folder_name="${sanitized_name}_${timestamp}"
    local target_path="$OUTPUT_DIR/$folder_name"
    
    echo -e "${BLUE}📀 Processing disc: '$disc_name'${NC}"
    echo "Processing disc: '$disc_name' at $(date)" >> "$LOG_FILE"
    
    # Create target directory
    mkdir -p "$target_path"
    
    # Get disc size info
    local disc_size=$(du -sh "$disc_path" 2>/dev/null | cut -f1)
    echo -e "${YELLOW}💾 Disc size: $disc_size${NC}"
    
    # Copy all files with metadata preservation
    echo -e "${YELLOW}🔄 Copying files...${NC}"
    if cp -R "$disc_path"/* "$target_path/" 2>/dev/null; then
        echo -e "${GREEN}✅ Copy completed successfully${NC}"
        echo "SUCCESS: Copied '$disc_name' to '$folder_name'" >> "$LOG_FILE"
        
        # Count files copied
        local file_count=$(find "$target_path" -type f | wc -l | tr -d ' ')
        echo -e "${GREEN}📁 Files copied: $file_count${NC}"
        echo "Files copied: $file_count" >> "$LOG_FILE"
        
        # Create disc info file
        cat > "$target_path/_DISC_INFO.txt" << EOF
Disc Name: $disc_name
Ripped On: $(date)
Original Path: $disc_path
Disc Size: $disc_size
Files Count: $file_count
Ripping Script: CD-R Batch Ripper v1.0
EOF
        
        return 0
    else
        echo -e "${RED}❌ Copy failed${NC}"
        echo "ERROR: Failed to copy '$disc_name'" >> "$LOG_FILE"
        return 1
    fi
}

# Function to eject disc
eject_disc() {
    local disc_path="$1"
    echo -e "${YELLOW}⏏️ Ejecting disc...${NC}"
    
    if diskutil eject "$disc_path" 2>/dev/null; then
        echo -e "${GREEN}✅ Disc ejected successfully${NC}"
        # Audio notification
        osascript -e "beep 2"
        return 0
    else
        echo -e "${RED}❌ Failed to eject disc${NC}"
        return 1
    fi
}

# Main processing loop
process_current_disc() {
    local disc_info=$(get_disc_info)
    local disc_name=$(echo "$disc_info" | cut -d'|' -f1)
    local disc_path=$(echo "$disc_info" | cut -d'|' -f2)
    
    if [ -n "$disc_name" ] && [ -d "$disc_path" ]; then
        echo -e "${GREEN}🎵 Disc detected: '$disc_name'${NC}"
        
        if copy_disc "$disc_name" "$disc_path"; then
            eject_disc "$disc_path"
            echo -e "${GREEN}🎉 Disc '$disc_name' processed successfully!${NC}"
            echo "----------------------------------------" >> "$LOG_FILE"
            return 0
        else
            echo -e "${RED}⚠️ Processing failed for disc '$disc_name'${NC}"
            return 1
        fi
    else
        return 1
    fi
}

# Interactive mode
echo -e "${BLUE}🚀 Ready to rip CD-Rs!${NC}"
echo -e "${YELLOW}Instructions:${NC}"
echo "1. Insert a CD-R into the drive"
echo "2. Press ENTER when ready to process"
echo "3. Type 'quit' or 'exit' to stop"
echo ""

while true; do
    echo -e "${BLUE}💿 Insert next CD-R and press ENTER (or 'quit' to exit):${NC}"
    read -r input
    
    case "$input" in
        quit|exit|q)
            echo -e "${YELLOW}👋 Exiting CD-R ripper...${NC}"
            echo "Session ended: $(date)" >> "$LOG_FILE"
            break
            ;;
        *)
            if process_current_disc; then
                echo -e "${GREEN}✨ Ready for next disc!${NC}"
                echo ""
            else
                echo -e "${RED}⚠️ No disc detected or processing failed${NC}"
                echo -e "${YELLOW}Please insert a CD-R and try again${NC}"
                echo ""
            fi
            ;;
    esac
done

echo -e "${BLUE}📊 Ripping session complete!${NC}"
echo -e "${YELLOW}Check output directory: $OUTPUT_DIR${NC}"
echo -e "${YELLOW}Check log file: $LOG_FILE${NC}" 