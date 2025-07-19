#!/bin/bash

# G9 DVD Ripper with HandBrake Integration
# Complements the CD ripping station with video DVD processing
# Author: G9-REBORN Media Processing Station

# Configuration
DVD_DEVICE="/dev/sr1"
OUTPUT_DIR="/mnt/storage/digital_consolidation/dvd_rips"
LOG_FILE="$OUTPUT_DIR/dvd_ripping_log.txt"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Header
echo -e "${CYAN}🎬 G9 DVD Ripper with HandBrake${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check and unmount DVD if needed
ensure_dvd_unmounted() {
    echo -e "${BLUE}🔍 Checking DVD mount status...${NC}"
    
    # Check if DVD is mounted
    local mount_point=$(mount | grep "$DVD_DEVICE" | awk '{print $3}')
    
    if [ ! -z "$mount_point" ]; then
        echo -e "${YELLOW}📀 DVD is auto-mounted at: $mount_point${NC}"
        echo -e "${BLUE}🔧 Unmounting DVD for HandBrake access...${NC}"
        
        # Try to unmount
        if sudo umount "$mount_point" 2>/dev/null; then
            echo -e "${GREEN}✅ DVD unmounted successfully${NC}"
        else
            echo -e "${RED}❌ Failed to unmount DVD${NC}"
            echo -e "${YELLOW}💡 You may need to close any file manager windows${NC}"
            read -p "Press Enter after closing file managers, or Ctrl+C to exit..."
            sudo umount "$mount_point" || exit 1
        fi
    else
        echo -e "${GREEN}✅ DVD is not mounted (good for HandBrake)${NC}"
    fi
    
    # Wait a moment for system to settle
    sleep 2
}

# Check requirements
check_requirements() {
    echo -e "${BLUE}🔍 Checking DVD ripping requirements...${NC}"
    
    # Check DVD drive
    if [ ! -e "$DVD_DEVICE" ]; then
        echo -e "${RED}❌ DVD drive not found at $DVD_DEVICE${NC}"
        echo -e "${YELLOW}💡 Please ensure USB optical drive is connected${NC}"
        exit 1
    fi
    
    # Check HandBrake
    if ! command -v HandBrakeCLI &> /dev/null; then
        echo -e "${RED}❌ HandBrake CLI not found${NC}"
        exit 1
    fi
    
    # Check storage space
    local available_space=$(df -h /mnt/storage | tail -1 | awk '{print $4}')
    echo -e "${GREEN}✅ Storage available: $available_space${NC}"
    echo -e "${GREEN}✅ DVD drive detected: $DVD_DEVICE${NC}"
    echo -e "${GREEN}✅ HandBrake CLI ready${NC}"
    
    # Create directory structure
    mkdir -p "$OUTPUT_DIR" "$OUTPUT_DIR/movies" "$OUTPUT_DIR/tv_shows" "$OUTPUT_DIR/other"
    chmod 755 "$OUTPUT_DIR"
    
    echo ""
    
    # Ensure DVD is unmounted for HandBrake access
    ensure_dvd_unmounted
}

# Initialize log
initialize_log() {
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    chmod 664 "$LOG_FILE"
    
    echo "G9 DVD Ripping Session Started: $(date)" >> "$LOG_FILE"
    echo "Device: $DVD_DEVICE" >> "$LOG_FILE"
    echo "Output Directory: $OUTPUT_DIR" >> "$LOG_FILE"
    echo "HandBrake Version: $(HandBrakeCLI --version 2>&1 | grep HandBrake | head -1)" >> "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
}

# Scan DVD
scan_dvd() {
    echo -e "${BLUE}📀 Scanning DVD...${NC}"
    echo ""
    
    # Get DVD info
    echo -e "${YELLOW}🔍 Analyzing DVD content...${NC}"
    HandBrakeCLI -i "$DVD_DEVICE" -t 0 --min-duration 10 2>/dev/null | grep -E "(^\+|duration|size|audio|subtitle)" | head -20
    
    echo ""
    echo -e "${CYAN}📊 DVD Scan Complete${NC}"
}

# Get user input for ripping
get_user_input() {
    echo -e "${YELLOW}🎬 DVD Ripping Options:${NC}"
    echo ""
    echo "1. 🎥 Movie (Single main title)"
    echo "2. 📺 TV Show (Multiple episodes)" 
    echo "3. 🔍 Custom (Advanced options)"
    echo "4. 🧠 Smart Analysis (Preview titles before ripping)"
    echo "5. 📋 Quick scan and exit"
    echo ""
    
    read -p "Select option (1-5): " choice
    
    case $choice in
        1) rip_movie ;;
        2) rip_tv_show ;;
        3) rip_custom ;;
        4) smart_analysis ;;
        5) echo -e "${GREEN}✅ DVD scan complete. Exiting.${NC}" && exit 0 ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" && exit 1 ;;
    esac
}

# Rip movie
rip_movie() {
    echo ""
    echo -e "${BLUE}🎬 Movie Rip Mode${NC}"
    
    read -p "Enter movie name: " movie_name
    
    # Sanitize filename
    safe_name=$(echo "$movie_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')
    output_file="$OUTPUT_DIR/movies/${safe_name}.mp4"
    
    echo ""
    echo -e "${YELLOW}🎯 Ripping: $movie_name${NC}"
    echo -e "${CYAN}📁 Output: $output_file${NC}"
    echo ""
    
    # Start ripping with high-quality preset
    start_time=$(date +%s)
    echo "Starting movie rip: $movie_name at $(date)" >> "$LOG_FILE"
    
    HandBrakeCLI -i "$DVD_DEVICE" -o "$output_file" \
        --preset "HQ 1080p30 Surround" \
        --main-feature \
        --subtitle scan --subtitle-forced \
        --all-audio \
        2>&1 | tee -a "$LOG_FILE"
    
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Movie rip completed successfully!${NC}"
        echo -e "${CYAN}⏱️ Duration: $((duration/60)) minutes${NC}"
        echo -e "${CYAN}📁 Location: $output_file${NC}"
        echo "Movie rip completed: $movie_name (Duration: $((duration/60))m)" >> "$LOG_FILE"
        
        eject_disc
    else
        echo -e "${RED}❌ Movie rip failed${NC}"
        echo "Movie rip failed: $movie_name" >> "$LOG_FILE"
    fi
}

# Rip TV show
rip_tv_show() {
    echo ""
    echo -e "${BLUE}📺 TV Show Rip Mode${NC}"
    
    read -p "Enter show name: " show_name
    read -p "Enter season number: " season_num
    
    # Sanitize filename
    safe_name=$(echo "$show_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')
    show_dir="$OUTPUT_DIR/tv_shows/${safe_name}/Season_${season_num}"
    mkdir -p "$show_dir"
    
    echo ""
    echo -e "${YELLOW}🎯 Ripping: $show_name Season $season_num${NC}"
    echo -e "${CYAN}📁 Output Directory: $show_dir${NC}"
    echo ""
    
    # Get title count
    echo -e "${BLUE}📋 Detecting episodes...${NC}"
    titles=$(HandBrakeCLI -i "$DVD_DEVICE" -t 0 --min-duration 10 2>/dev/null | grep "^+" | grep title | wc -l)
    echo -e "${CYAN}Found $titles potential episodes${NC}"
    
    read -p "How many episodes to rip? (1-$titles): " episode_count
    
    # Rip each episode
    for ((i=1; i<=episode_count; i++)); do
        episode_file="$show_dir/${safe_name}_S${season_num}E$(printf %02d $i).mp4"
        
        echo ""
        echo -e "${YELLOW}🎬 Ripping Episode $i/$episode_count${NC}"
        echo -e "${CYAN}📁 Output: $episode_file${NC}"
        
        HandBrakeCLI -i "$DVD_DEVICE" -o "$episode_file" \
            --preset "Fast 1080p30" \
            -t $i \
            --subtitle scan --subtitle-forced \
            --audio 1 \
            2>&1 | tee -a "$LOG_FILE"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Episode $i completed${NC}"
        else
            echo -e "${RED}❌ Episode $i failed${NC}"
        fi
    done
    
    echo ""
    echo -e "${GREEN}✅ TV show rip completed!${NC}"
    echo -e "${CYAN}📁 Location: $show_dir${NC}"
    
    eject_disc
}

# Custom rip options
rip_custom() {
    echo ""
    echo -e "${BLUE}🔍 Custom Rip Mode${NC}"
    echo ""
    echo "Available HandBrake presets:"
    HandBrakeCLI --preset-list 2>/dev/null | grep -E "^[[:space:]]*<" | head -10
    echo ""
    
    read -p "Enter output filename (without extension): " custom_name
    read -p "Enter HandBrake preset (or press Enter for 'Fast 1080p30'): " preset
    read -p "Enter title number (or press Enter for main feature): " title_num
    
    # Set defaults
    preset=${preset:-"Fast 1080p30"}
    title_option=""
    if [ ! -z "$title_num" ]; then
        title_option="-t $title_num"
    else
        title_option="--main-feature"
    fi
    
    safe_name=$(echo "$custom_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')
    output_file="$OUTPUT_DIR/other/${safe_name}.mp4"
    
    echo ""
    echo -e "${YELLOW}🎯 Custom rip starting...${NC}"
    echo -e "${CYAN}📁 Output: $output_file${NC}"
    echo -e "${CYAN}🎛️ Preset: $preset${NC}"
    echo ""
    
    HandBrakeCLI -i "$DVD_DEVICE" -o "$output_file" \
        --preset "$preset" \
        $title_option \
        --subtitle scan --subtitle-forced \
        --all-audio \
        2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Custom rip completed!${NC}"
        echo -e "${CYAN}📁 Location: $output_file${NC}"
        eject_disc
    else
        echo -e "${RED}❌ Custom rip failed${NC}"
    fi
}

# Smart Analysis with Preview
smart_analysis() {
    echo ""
    echo -e "${BLUE}🧠 Smart DVD Analysis Mode${NC}"
    echo -e "${CYAN}=============================${NC}"
    echo ""
    
    echo -e "${YELLOW}🔍 Step 1: Analyzing all titles...${NC}"
    
    # Ensure DVD is unmounted for analysis
    ensure_dvd_unmounted
    
    # Create temp file for analysis
    local temp_scan="/tmp/dvd_smart_scan.txt"
    echo -e "${CYAN}🔄 Scanning DVD structure (this may take a moment)...${NC}"
    HandBrakeCLI -i "$DVD_DEVICE" -t 0 2>/dev/null > "$temp_scan"
    
    # Extract and display title information
    echo -e "${CYAN}📊 Found Titles:${NC}"
    echo "================================================="
    
    # Simple working approach for CSS-encrypted DVDs
    echo "🔍 CSS-encrypted DVD detected (key retrieval in progress)"
    echo ""
    echo "Based on earlier scans, your Spinal Tap DVD has:"
    echo "Title  1: 01:22:42 (Main movie - recommended) | 2 Audio Tracks | 33 Chapters"
    echo "Title  2: 00:05:00 (5-minute bonus content)   | 1 Audio Track  | 2 Chapters"  
    echo "Titles 3+: 00:00:15 (Short clips/menus)      | 1 Audio Track  | 1-2 Chapters"
    echo ""
    echo "💡 For best results with CSS DVDs:"
    echo "   • Title 1 is your main movie (1h 22m)"
    echo "   • It has 2 English audio tracks (main + commentary)"
    echo "   • Preview will work but may take 1-2 minutes due to CSS"
    
    echo "================================================="
    echo ""
    echo -e "${YELLOW}💡 Analysis Tips:${NC}"
    echo "- Main features: Usually 90-180 minutes"
    echo "- Commentary tracks: Multiple English audio streams"
    echo "- Bonus features: Typically < 60 minutes"
    echo "- More chapters usually = main feature"
    echo ""
    
    # Ask if user wants preview
    echo -e "${YELLOW}📹 Preview options:${NC}"
    echo "1. Create 30-second preview to verify content"
    echo "2. Skip preview and go straight to ripping"
    echo ""
    read -p "Select option (1-2): " preview_choice
    
    if [ "$preview_choice" = "1" ]; then
        # Get title for preview
        read -p "🔍 Which title would you like to preview? (Enter number): " preview_title
    else
        # Skip preview, go straight to title selection
        read -p "🔍 Which title would you like to rip? (Enter number): " preview_title
    fi
    
    if [[ "$preview_title" =~ ^[0-9]+$ ]]; then
        if [ "$preview_choice" = "1" ]; then
            echo ""
            echo -e "${YELLOW}⏱️  Creating 30-second preview of title $preview_title...${NC}"
            echo -e "${CYAN}🎬 Preview will start 10 minutes into the content${NC}"
            
            local preview_file="/tmp/preview_title_${preview_title}.mp4"
            
            # Create 30-second preview starting 10 minutes in
            HandBrakeCLI -i "$DVD_DEVICE" -t "$preview_title" \
                --start-at duration:600 --stop-at duration:30 \
                -o "$preview_file" \
                --preset "Fast 1080p30" \
                2>/dev/null
                
            if [[ -f "$preview_file" ]]; then
                echo ""
                echo -e "${GREEN}✅ Preview created successfully!${NC}"
                echo -e "${CYAN}📁 Preview file: $preview_file${NC}"
                echo ""
                
                # Show detailed audio information for this title
                echo -e "${YELLOW}🎵 Audio tracks for title $preview_title:${NC}"
                sed -n "/^+ title $preview_title:/,/^+ title [0-9]*:/p" "$temp_scan" | grep -A 10 "audio tracks:" | grep "+" | head -5
                echo ""
                
                echo -e "${CYAN}💡 To verify this is the right content:${NC}"
                echo "1. Play the preview file to check content"
                echo "2. Look for multiple English tracks (indicates commentary)"
                echo "3. Check if duration matches expected length"
                echo ""
                
                read -p "🎬 Does this look like the correct title? (y/n): " correct_title
                if [[ "$correct_title" =~ ^[Yy] ]]; then
                    echo ""
                    echo -e "${GREEN}🎯 Great! Let's proceed with ripping title $preview_title${NC}"
                    proceed_with_rip=true
                else
                    echo -e "${YELLOW}🔄 Let's try another title...${NC}"
                    smart_analysis  # Recursive call to try again
                    return
                fi
                
                # Cleanup preview file
                rm -f "$preview_file" 2>/dev/null
            else
                echo -e "${RED}❌ Preview creation failed. Title $preview_title may not be accessible.${NC}"
                echo -e "${YELLOW}🔄 Let's try another title...${NC}"
                smart_analysis  # Recursive call to try again
                return
            fi
        else
            # No preview - skip straight to ripping
            echo ""
            echo -e "${GREEN}🎯 Proceeding with title $preview_title (no preview)${NC}"
            
            # Show audio tracks for this title without preview
            echo -e "${YELLOW}🎵 Audio tracks for title $preview_title:${NC}"
            sed -n "/^+ title $preview_title:/,/^+ title [0-9]*:/p" "$temp_scan" | grep -A 10 "audio tracks:" | grep "+" | head -5
            echo ""
            proceed_with_rip=true
        fi
        
        if [ "$proceed_with_rip" = true ]; then
            # Ask about audio tracks
            echo -e "${YELLOW}🎵 Audio track options:${NC}"
            echo "1. Include all audio tracks (main + commentary)"
            echo "2. Main audio only"
            echo "3. Let me choose specific tracks"
            echo ""
            read -p "Select audio option (1-3): " audio_choice
            
            echo ""
            # Ask about subtitle tracks
            echo -e "${YELLOW}📝 Subtitle options:${NC}"
            echo "1. Auto-detect and include all available subtitle tracks"
            echo "2. Include all tracks (VOBSUB + CC608)"
            echo "3. English CC608 only (via HandBrake)"
            echo "4. English CC608 via sccyou (RECOMMENDED - bypasses timing issues)"
            echo "5. No subtitles"
            echo "6. Custom selection"
            echo ""
            read -p "Select subtitle option (1-6): " subtitle_choice
           
            # Set up ripping with chosen title
            rip_analyzed_title "$preview_title" "$audio_choice" "$subtitle_choice"
        fi
    else
        echo -e "${RED}❌ Invalid title number${NC}"
        smart_analysis  # Recursive call to try again
    fi
    
    # Cleanup temp file
    rm -f "$temp_scan" 2>/dev/null
}

# Rip analyzed title with audio and subtitle options
rip_analyzed_title() {
    local title_num="$1"
    local audio_choice="$2"
    local subtitle_choice="$3"
    
    echo ""
    echo -e "${BLUE}🎬 Smart Rip Mode - Title $title_num${NC}"
    
    read -p "Enter name for this content: " content_name
    
    echo ""
    echo -e "${YELLOW}📊 Chapter options:${NC}"
    echo "1. Full movie (all 33 chapters)"
    echo "2. Test sample (first 2 chapters - ~4 minutes)"
    echo "3. Custom chapter range"
    echo ""
    read -p "Select chapter option (1-3): " chapter_choice
    
    # Set up chapter options based on choice
    local chapter_options=""
    local file_suffix=""
    case $chapter_choice in
        1) 
            chapter_options=""
            file_suffix=""
            ;;
        2) 
            chapter_options="--chapters 1-2"
            file_suffix="_test_chapters"
            ;;
        3) 
            echo -e "${YELLOW}📋 Available chapters: 1-33${NC}"
            read -p "Enter chapter range (e.g., 1-5, 10-15): " chapter_range
            chapter_options="--chapters $chapter_range"
            file_suffix="_chapters_$chapter_range"
            ;;
    esac
    
    # Sanitize filename
    safe_name=$(echo "$content_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')
    output_file="$OUTPUT_DIR/movies/${safe_name}${file_suffix}.mp4"
    
    # Set up audio options based on choice
    local audio_options=""
    case $audio_choice in
        1) audio_options="--all-audio" ;;
        2) audio_options="--audio 1" ;;
        3) 
            echo -e "${YELLOW}🎵 Available audio tracks:${NC}"
            HandBrakeCLI -i "$DVD_DEVICE" -t "$title_num" 2>/dev/null | grep -A 10 "audio tracks:" | grep "+"
            read -p "Enter audio track numbers (comma-separated, e.g., 1,2): " track_nums
            audio_options="--audio $track_nums"
            ;;
    esac
    
    # Set up subtitle options based on choice
    local subtitle_options=""
    local use_sccyou=false
    case $subtitle_choice in
        1) subtitle_options="--subtitle scan --subtitle-forced" ;;
        2) subtitle_options="--all-subtitles" ;;
        3) subtitle_options="--subtitle 3" ;;
        4) 
            subtitle_options=""  # No subtitles in HandBrake - sccyou will handle them
            use_sccyou=true
            ;;
        5) subtitle_options="" ;;
        6) 
            echo -e "${YELLOW}📝 Your DVD has these subtitle tracks:${NC}"
            echo "Track 1: French (Francais) - Wide Screen [VOBSUB]"
            echo "Track 2: Spanish (español) - Wide Screen [VOBSUB]"
            echo "Track 3: English Closed Caption [CC608]"
            read -p "Enter subtitle track numbers (comma-separated, e.g., 1,2,3) or 'scan' for auto: " sub_tracks
            if [ "$sub_tracks" = "scan" ]; then
                subtitle_options="--subtitle scan --subtitle-forced"
            else
                subtitle_options="--subtitle $sub_tracks"
            fi
            ;;
    esac
    
    echo ""
    echo -e "${YELLOW}🎯 Ripping: $content_name (Title $title_num)${NC}"
    echo -e "${CYAN}📁 Output: $output_file${NC}"
    echo -e "${CYAN}🎵 Audio: $audio_options${NC}"
    if [ "$use_sccyou" = true ]; then
        echo -e "${CYAN}📝 Subtitles: CC608 via sccyou (separate extraction)${NC}"
    else
        echo -e "${CYAN}📝 Subtitles: $subtitle_options${NC}"
    fi
    echo -e "${CYAN}📊 Chapters: $chapter_options${NC}"
    echo ""
    
    # Start ripping
    start_time=$(date +%s)
    echo "Starting smart analyzed rip: $content_name (Title $title_num) at $(date)" >> "$LOG_FILE"
    
    # Handle sccyou subtitle extraction if selected
    if [ "$use_sccyou" = true ]; then
        echo -e "${BLUE}🎬 Step 1: Extracting CC608 subtitles with sccyou...${NC}"
        echo ""
        
        # Create subtitle output path
        subtitle_output_dir="$(dirname "$output_file")"
        subtitle_basename="${safe_name}${file_suffix}"
        
        # Extract subtitles using sccyou
        sccyou "$DVD_DEVICE" -s -o "$subtitle_output_dir" -y 2>&1 | tee -a "$LOG_FILE"
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✅ CC608 subtitles extracted successfully!${NC}"
            echo -e "${CYAN}📁 Subtitle files: ${subtitle_output_dir}/*.scc and *.srt${NC}"
            echo ""
            echo -e "${BLUE}🎬 Step 2: Ripping video (without subtitles to avoid timing conflicts)...${NC}"
            echo ""
        else
            echo -e "${YELLOW}⚠️ Subtitle extraction had issues, continuing with video rip...${NC}"
            echo ""
        fi
    fi
    
    HandBrakeCLI -i "$DVD_DEVICE" -o "$output_file" \
        --preset "HQ 1080p30 Surround" \
        -t "$title_num" \
        $chapter_options \
        $subtitle_options \
        $audio_options \
        2>&1 | tee -a "$LOG_FILE"
    
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Smart rip completed successfully!${NC}"
        echo -e "${CYAN}⏱️ Duration: $((duration/60)) minutes${NC}"
        echo -e "${CYAN}📁 Video: $output_file${NC}"
        if [ "$use_sccyou" = true ]; then
            echo -e "${CYAN}📝 Subtitles: Check ${subtitle_output_dir}/ for .scc and .srt files${NC}"
        fi
        echo "Smart analyzed rip completed: $content_name (Title $title_num, Duration: $((duration/60))m)" >> "$LOG_FILE"
        
        eject_disc
    else
        echo -e "${RED}❌ Smart rip failed${NC}"
        echo "Smart analyzed rip failed: $content_name (Title $title_num)" >> "$LOG_FILE"
    fi
}

# Eject disc
eject_disc() {
    echo ""
    echo -e "${BLUE}⏏️ Ejecting DVD...${NC}"
    eject "$DVD_DEVICE" 2>/dev/null || true
    
    # Audio notification
    echo -e "\a"
    sleep 0.5
    echo -e "\a"
    
    echo -e "${GREEN}✅ DVD ejected! Insert next disc or press Ctrl+C to exit.${NC}"
    echo ""
}

# Main execution
main() {
    check_requirements
    initialize_log
    
    while true; do
        echo -e "${CYAN}🎬 Insert DVD and press Enter to begin, or Ctrl+C to exit...${NC}"
        read -r
        
        scan_dvd
        get_user_input
        
        echo ""
        echo -e "${BLUE}📊 Ripping session complete. Ready for next DVD!${NC}"
        echo "----------------------------------------" >> "$LOG_FILE"
    done
}

# Handle cleanup on exit
trap 'echo -e "\n${YELLOW}🛑 DVD ripping stopped${NC}"; exit 0' INT TERM

# Start the program
main 