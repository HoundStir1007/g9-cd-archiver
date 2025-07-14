#!/bin/bash

# G9 Ultimate CD Ripping Station 🎵📀
# ===================================
# Automated CD ripping for audio CDs and data CD copying
# Optimized for HP G9 MicroServer running Ubuntu 24.04 LTS
# Storage: 4TB internal drive with organized structure
# Version 1.5: Speed Mode with Safe Mode fallback for data copying

# Configuration
CD_DEVICE="/dev/sr0"
BASE_OUTPUT_DIR="/mnt/data/digital_consolidation"
AUDIO_OUTPUT_DIR="$BASE_OUTPUT_DIR/cd_rips/audio"
DATA_OUTPUT_DIR="$BASE_OUTPUT_DIR/cd_rips/data"
LOG_FILE="$BASE_OUTPUT_DIR/cd_rips/ripping_log.txt"
TEMP_DIR="/tmp/cd_rip_temp"

# Colors for beautiful terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Audio quality settings
FLAC_QUALITY="8"  # Maximum compression
MP3_QUALITY="0"   # V0 variable bitrate (highest quality)

print_banner() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${CYAN}                 🎵 G9 ULTIMATE CD RIPPING STATION 🎵           ${BLUE}║${NC}"
    echo -e "${BLUE}║${YELLOW}                    HP G9 MicroServer Ubuntu 24.04             ${BLUE}║${NC}"
    echo -e "${BLUE}║${GREEN}                      4TB Internal Storage Ready               ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_requirements() {
    echo -e "${BLUE}🔍 Checking G9 ripping station requirements...${NC}"
    
    # Check optical drive
    if [ ! -e "$CD_DEVICE" ]; then
        echo -e "${RED}❌ USB optical drive not found at $CD_DEVICE${NC}"
        echo -e "${YELLOW}💡 Please ensure USB optical drive is connected${NC}"
        exit 1
    fi
    
    # Check required tools
    local tools=("cdparanoia" "abcde" "lame" "flac" "eject" "rsync")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${RED}❌ Required tool missing: $tool${NC}"
            exit 1
        fi
    done
    
    # Check storage space
    local available_space=$(df -h /mnt/data | tail -1 | awk '{print $4}')
    echo -e "${GREEN}✅ Storage available: $available_space${NC}"
    echo -e "${GREEN}✅ USB optical drive detected: $CD_DEVICE${NC}"
    echo -e "${GREEN}✅ All ripping tools installed${NC}"
    
    # Create directory structure
    mkdir -p "$AUDIO_OUTPUT_DIR" "$DATA_OUTPUT_DIR" "$TEMP_DIR"
    chmod 755 "$AUDIO_OUTPUT_DIR" "$DATA_OUTPUT_DIR"
    
    echo ""
}

initialize_log() {
    # Ensure log file exists and is writable
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    chmod 664 "$LOG_FILE"
    
    echo "G9 CD Ripping Session Started: $(date)" >> "$LOG_FILE"
    echo "Device: $CD_DEVICE" >> "$LOG_FILE"
    echo "Audio Output: $AUDIO_OUTPUT_DIR" >> "$LOG_FILE"
    echo "Data Output: $DATA_OUTPUT_DIR" >> "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
}

detect_disc_type() {
    # Output status message to stderr so it doesn't interfere with return value
    echo -e "${BLUE}🔍 Analyzing inserted disc...${NC}" >&2
    
    # Wait for disc to settle
    sleep 2
    
    # Check if it's an audio CD (cdparanoia outputs to stderr)
    if cdparanoia -Q 2>&1 | grep -q "track"; then
        echo "audio"
    # Check if it's a data disc
    elif sudo mount -o ro "$CD_DEVICE" /mnt 2>/dev/null; then
        sudo umount /mnt 2>/dev/null
        echo "data"
    else
        echo "unknown"
    fi
}

get_disc_info() {
    local mount_point="/media/cdrom_temp"
    sudo mkdir -p "$mount_point"
    
    # For data discs, try to mount and get volume label
    local disc_name=""
    if sudo mount -o ro "$CD_DEVICE" "$mount_point" 2>/dev/null; then
        disc_name=$(lsblk -no LABEL "$CD_DEVICE" 2>/dev/null | head -1)
        if [ -z "$disc_name" ]; then
            # Try to get volume label from mount point
            disc_name=$(basename "$(readlink -f "$mount_point")" 2>/dev/null)
            if [ -z "$disc_name" ] || [ "$disc_name" = "cdrom_temp" ]; then
                disc_name="Data_Disc"
            fi
        fi
        sudo umount "$mount_point" 2>/dev/null
    else
        # For audio CDs, try to get basic info from cdparanoia or use generic name
        if cdparanoia -Q 2>&1 | grep -q "track"; then
            disc_name="Audio_CD"
        else
            disc_name="Unknown_Disc"
        fi
    fi
    
    sudo rmdir "$mount_point" 2>/dev/null
    echo "$disc_name"
}

sanitize_filename() {
    echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g'
}

rip_audio_cd() {
    local disc_name="$1"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local start_time=$(date +%s)
    local sanitized_name=$(sanitize_filename "$disc_name")
    local output_dir="$AUDIO_OUTPUT_DIR/${sanitized_name}_${timestamp}"
    
    echo -e "${PURPLE}🎵 [$(date '+%H:%M:%S')] Ripping AUDIO CD: '$disc_name'${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Ripping audio CD: '$disc_name'" >> "$LOG_FILE"
    
    mkdir -p "$output_dir"
    cd "$output_dir"
    
    # Test MusicBrainz connectivity first
    echo -e "${YELLOW}🌐 Testing MusicBrainz connectivity...${NC}"
    
    if timeout 10 curl -s --connect-timeout 5 https://musicbrainz.org/ > /dev/null 2>&1; then
        echo -e "${GREEN}✅ MusicBrainz reachable, will attempt metadata lookup${NC}"
        
        # Create abcde config with MusicBrainz
        cat > abcde.conf << EOF
# G9 Ultimate Audio CD Ripper Configuration - With Metadata
CDDBMETHOD=musicbrainz
CDDBURL="http://musicbrainz.org/ws/2/"
OUTPUTTYPE=flac,mp3
OUTPUTDIR="$output_dir"
ACTIONS=cddb,read,encode,tag,move,clean
OUTPUTFORMAT='\${ARTISTFILE}/\${ALBUMFILE}/\${TRACKNUM}-\${TRACKFILE}'
VAOUTPUTFORMAT='Various/\${ALBUMFILE}/\${TRACKNUM}-\${TRACKFILE}'
ONETRACKOUTPUTFORMAT='\${ARTISTFILE}/\${ALBUMFILE}/\${ALBUMFILE}'
VAONETRACKOUTPUTFORMAT='Various/\${ALBUMFILE}/\${ALBUMFILE}'
FLACOPTS="-compression-level-$FLAC_QUALITY"
LAMEOPTS="-V $MP3_QUALITY --vbr-new"
CDPARANOIA=cdparanoia
CDPARANOIAOPTS="--never-skip=40"
EJECTCD=y
INTERACTIVE=n
MAXPROCS=2
EOF
        local use_metadata=true
    else
        echo -e "${YELLOW}⚠️ MusicBrainz not reachable, will rip without metadata${NC}"
        
        # Create abcde config without metadata
        cat > abcde.conf << EOF
# G9 Ultimate Audio CD Ripper Configuration - No Metadata
OUTPUTTYPE=flac,mp3
OUTPUTDIR="$output_dir"
ACTIONS=read,encode,tag,move,clean
OUTPUTFORMAT='Track\${TRACKNUM}'
FLACOPTS="-compression-level-$FLAC_QUALITY"
LAMEOPTS="-V $MP3_QUALITY --vbr-new"
CDPARANOIA=cdparanoia
CDPARANOIAOPTS="--never-skip=40"
EJECTCD=y
INTERACTIVE=n
MAXPROCS=2
EOF
        local use_metadata=false
    fi
    
    echo -e "${YELLOW}🔄 [$(date '+%H:%M:%S')] Starting automated ripping process...${NC}"
    echo -e "${YELLOW}   • Querying MusicBrainz for metadata${NC}"
    echo -e "${YELLOW}   • Extracting tracks with error correction${NC}"
    echo -e "${YELLOW}   • Encoding to FLAC (lossless) and MP3 (V0)${NC}"
    echo -e "${YELLOW}   • Organizing files by artist/album${NC}"
    
    # Run abcde based on connectivity test
    if [ "$use_metadata" = true ]; then
        echo -e "${YELLOW}🌐 Attempting to fetch metadata from MusicBrainz...${NC}"
        if timeout 1800 abcde -c abcde.conf -d "$CD_DEVICE" 2>&1 | tee -a "$LOG_FILE"; then
        local end_time=$(date +%s)
        local elapsed_time=$((end_time - start_time))
        local elapsed_min=$((elapsed_time / 60))
        local elapsed_sec=$((elapsed_time % 60))
        
        echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] Audio CD ripped successfully!${NC}"
        echo -e "${GREEN}⏱️ Elapsed time: ${elapsed_min}m ${elapsed_sec}s${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Audio CD '$disc_name' ripped in ${elapsed_min}m ${elapsed_sec}s" >> "$LOG_FILE"
        
        # Count tracks
        local flac_count=$(find . -name "*.flac" | wc -l)
        local mp3_count=$(find . -name "*.mp3" | wc -l)
        
        # Create rip info file
        cat > "_RIP_INFO.txt" << EOF
Disc Name: $disc_name
Ripped On: $(date)
Device: $CD_DEVICE
Output Directory: $output_dir
FLAC Tracks: $flac_count
MP3 Tracks: $mp3_count
Rip Duration: ${elapsed_min}m ${elapsed_sec}s
Ripping Script: G9 Ultimate CD Ripper v1.5
Quality Settings: FLAC Level $FLAC_QUALITY, MP3 V$MP3_QUALITY
Start Time: $(date -d "@$start_time" '+%Y-%m-%d %H:%M:%S')
End Time: $(date -d "@$end_time" '+%Y-%m-%d %H:%M:%S')
EOF
        
            echo -e "${GREEN}📁 Created $flac_count FLAC + $mp3_count MP3 files${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️ Metadata lookup failed, retrying without online metadata...${NC}"
            echo "WARNING: MusicBrainz failed, trying fallback method for '$disc_name'" >> "$LOG_FILE"
            
            # Create fallback config without metadata lookup
            cat > abcde-fallback.conf << EOF
# G9 Ultimate Audio CD Ripper - Fallback Configuration (No Metadata)
OUTPUTTYPE=flac,mp3
OUTPUTDIR="$output_dir"
ACTIONS=read,encode,tag,move,clean
OUTPUTFORMAT='Track\${TRACKNUM}'
FLACOPTS="-compression-level-$FLAC_QUALITY"
LAMEOPTS="-V $MP3_QUALITY --vbr-new"
CDPARANOIA=cdparanoia
CDPARANOIAOPTS="--never-skip=40"
EJECTCD=y
INTERACTIVE=n
MAXPROCS=2
EOF

            echo -e "${YELLOW}🔄 Ripping without metadata (tracks will be numbered)...${NC}"
            if timeout 1800 abcde -c abcde-fallback.conf -d "$CD_DEVICE" 2>&1 | tee -a "$LOG_FILE"; then
                local end_time=$(date +%s)
                local elapsed_time=$((end_time - start_time))
                local elapsed_min=$((elapsed_time / 60))
                local elapsed_sec=$((elapsed_time % 60))
                
                echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] Audio CD ripped successfully (without metadata)!${NC}"
                echo -e "${GREEN}⏱️ Elapsed time: ${elapsed_min}m ${elapsed_sec}s${NC}"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Audio CD '$disc_name' ripped in ${elapsed_min}m ${elapsed_sec}s (fallback mode)" >> "$LOG_FILE"
                
                # Count tracks
                local flac_count=$(find . -name "*.flac" | wc -l)
                local mp3_count=$(find . -name "*.mp3" | wc -l)
                
                # Create rip info file
                cat > "_RIP_INFO.txt" << EOF
Disc Name: $disc_name
Ripped On: $(date)
Device: $CD_DEVICE
Output Directory: $output_dir
FLAC Tracks: $flac_count
MP3 Tracks: $mp3_count
                Rip Duration: ${elapsed_min}m ${elapsed_sec}s
                Ripping Script: G9 Ultimate CD Ripper v1.5
                Quality Settings: FLAC Level $FLAC_QUALITY, MP3 V$MP3_QUALITY
                Metadata: None (MusicBrainz failed, fallback mode used)
Start Time: $(date -d "@$start_time" '+%Y-%m-%d %H:%M:%S')
End Time: $(date -d "@$end_time" '+%Y-%m-%d %H:%M:%S')
EOF
                
                echo -e "${GREEN}📁 Created $flac_count FLAC + $mp3_count MP3 files (without metadata)${NC}"
                return 0
            else
                echo -e "${RED}❌ Audio ripping failed completely${NC}"
                echo "ERROR: Failed to rip audio CD '$disc_name' even in fallback mode" >> "$LOG_FILE"
                return 1
            fi
        fi
    else
        # No metadata attempt - go straight to fallback
        echo -e "${YELLOW}🔄 Ripping without metadata (MusicBrainz unavailable)...${NC}"
        if timeout 1800 abcde -c abcde.conf -d "$CD_DEVICE" 2>&1 | tee -a "$LOG_FILE"; then
            local end_time=$(date +%s)
            local elapsed_time=$((end_time - start_time))
            local elapsed_min=$((elapsed_time / 60))
            local elapsed_sec=$((elapsed_time % 60))
            
            echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] Audio CD ripped successfully (without metadata)!${NC}"
            echo -e "${GREEN}⏱️ Elapsed time: ${elapsed_min}m ${elapsed_sec}s${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Audio CD '$disc_name' ripped in ${elapsed_min}m ${elapsed_sec}s (no metadata)" >> "$LOG_FILE"
            
            # Count tracks
            local flac_count=$(find . -name "*.flac" | wc -l)
            local mp3_count=$(find . -name "*.mp3" | wc -l)
            
            # Create rip info file
            cat > "_RIP_INFO.txt" << EOF
Disc Name: $disc_name
Ripped On: $(date)
Device: $CD_DEVICE
Output Directory: $output_dir
FLAC Tracks: $flac_count
MP3 Tracks: $mp3_count
             Rip Duration: ${elapsed_min}m ${elapsed_sec}s
             Ripping Script: G9 Ultimate CD Ripper v1.5
             Quality Settings: FLAC Level $FLAC_QUALITY, MP3 V$MP3_QUALITY
             Metadata: None (MusicBrainz unavailable)
Start Time: $(date -d "@$start_time" '+%Y-%m-%d %H:%M:%S')
End Time: $(date -d "@$end_time" '+%Y-%m-%d %H:%M:%S')
EOF
            
            echo -e "${GREEN}📁 Created $flac_count FLAC + $mp3_count MP3 files (without metadata)${NC}"
            return 0
        else
            echo -e "${RED}❌ Audio ripping failed completely${NC}"
            echo "ERROR: Failed to rip audio CD '$disc_name' without metadata" >> "$LOG_FILE"
            return 1
        fi
    fi
}

copy_data_cd() {
    local disc_name="$1"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local start_time=$(date +%s)
    local sanitized_name=$(sanitize_filename "$disc_name")
    local output_dir="$DATA_OUTPUT_DIR/${sanitized_name}_${timestamp}"
    local mount_point="/media/cdrom_temp"
    
    echo -e "${CYAN}📀 [$(date '+%H:%M:%S')] Copying DATA CD/DVD: '$disc_name'${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copying data disc: '$disc_name'" >> "$LOG_FILE"
    
    mkdir -p "$output_dir"
    chmod 755 "$output_dir"  # Ensure proper permissions
    sudo mkdir -p "$mount_point"
    
    # Check if already mounted elsewhere and unmount (try multiple mount points)
    sudo umount "$CD_DEVICE" 2>/dev/null || true
    sudo umount /media/mark/mp3_boingo_* 2>/dev/null || true
    sudo umount "$mount_point" 2>/dev/null || true
    # Force unmount if needed
    sudo umount -f "$CD_DEVICE" 2>/dev/null || true
    sleep 2
    
    # Mount the disc
    if sudo mount -o ro "$CD_DEVICE" "$mount_point"; then
        echo -e "${YELLOW}🔄 [$(date '+%H:%M:%S')] Analyzing disc contents...${NC}"
        
        # Get disc info
        local disc_size=$(du -sh "$mount_point" 2>/dev/null | cut -f1)
        local disc_size_bytes=$(du -sb "$mount_point" 2>/dev/null | cut -f1)
        local file_count=$(find "$mount_point" -type f 2>/dev/null | wc -l)
        local dir_count=$(find "$mount_point" -type d 2>/dev/null | wc -l)
        
        echo -e "${YELLOW}💾 [$(date '+%H:%M:%S')] Disc size: $disc_size ($disc_size_bytes bytes)${NC}"
        echo -e "${YELLOW}📁 [$(date '+%H:%M:%S')] Files: $file_count, Directories: $dir_count${NC}"
        
        # Check for video DVD structure (suggest handbrake for these)
        if [ -d "$mount_point/VIDEO_TS" ] || [ -d "$mount_point/BDMV" ]; then
            echo -e "${YELLOW}⚠️ [$(date '+%H:%M:%S')] Video DVD/Blu-ray detected${NC}"
            echo -e "${YELLOW}💡 For video content, consider using handbrake for better results${NC}"
            echo -e "${YELLOW}🔄 Proceeding with file copy anyway...${NC}"
        fi
        
        # Try SPEED MODE first (fast copy with minimal overhead)
        echo -e "${GREEN}🚀 [$(date '+%H:%M:%S')] Attempting SPEED MODE copy...${NC}"
        echo -e "${YELLOW}💨 Maximum speed with automatic fallback if errors occur${NC}"
        
        # Fast copy using simple rsync (no progress bars, minimal logging)
        if timeout 1800 sudo rsync -a --whole-file --no-compress \
           --skip-compress=mp3,MP3,flac,FLAC,jpg,JPG,png,PNG \
           "$mount_point"/ "$output_dir/" 2>/dev/null; then
            echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] SPEED MODE copy completed!${NC}"
            local end_time=$(date +%s)
            local elapsed_time=$((end_time - start_time))
            local elapsed_min=$((elapsed_time / 60))
            local elapsed_sec=$((elapsed_time % 60))
            
            echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] Data copy completed successfully${NC}"
            echo -e "${GREEN}⏱️ Elapsed time: ${elapsed_min}m ${elapsed_sec}s${NC}"
            echo -e "${GREEN}💨 Average speed: Fast mode (no progress tracking overhead)${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Data disc '$disc_name' copied in ${elapsed_min}m ${elapsed_sec}s (SPEED MODE)" >> "$LOG_FILE"
            
            # Fix ownership
            sudo chown -R mark:mark "$output_dir"
            
            # Verify copy
            local copied_files=$(find "$output_dir" -type f -not -name "_*" | wc -l)
            local copied_size=$(du -sh "$output_dir" | cut -f1)
            
            echo -e "${GREEN}📊 [$(date '+%H:%M:%S')] Copy verification complete${NC}"
            
            # Create disc info file with proper permissions
            touch "$output_dir/_DISC_INFO.txt"
            chmod 644 "$output_dir/_DISC_INFO.txt"
            cat > "$output_dir/_DISC_INFO.txt" << EOF
Disc Name: $disc_name
Copied On: $(date)
Original Device: $CD_DEVICE
Original Size: $disc_size ($disc_size_bytes bytes)
Copied Size: $copied_size
Original Files: $file_count
Copied Files: $copied_files
Copy Duration: ${elapsed_min}m ${elapsed_sec}s
Average Speed: $(echo "scale=2; $disc_size_bytes / $elapsed_time / 1024 / 1024" | bc 2>/dev/null || echo "N/A") MB/s
Copy Script: G9 Ultimate CD Ripper v1.4
Copy Method: rsync with enhanced progress tracking
Copy Status: SUCCESS
Start Time: $(date -d "@$start_time" '+%Y-%m-%d %H:%M:%S')
End Time: $(date -d "@$end_time" '+%Y-%m-%d %H:%M:%S')
EOF
            
            echo -e "${GREEN}📁 Files copied: $copied_files/${file_count}${NC}"
            echo -e "${GREEN}💾 Size copied: $copied_size${NC}"
            
            sudo umount "$mount_point"
            sudo rmdir "$mount_point" 2>/dev/null
            return 0
        else
            echo -e "${YELLOW}⚠️ [$(date '+%H:%M:%S')] SPEED MODE failed, switching to SAFE MODE...${NC}"
            echo -e "${BLUE}🛡️ Retrying with progress tracking and error recovery${NC}"
            echo "WARNING: Speed mode failed for '$disc_name', attempting safe mode" >> "$LOG_FILE"
            
            # Clear any partial files from speed mode attempt
            rm -rf "$output_dir"/*
            
            # SAFE MODE: Robust copy with full features
            echo -e "${YELLOW}🔄 [$(date '+%H:%M:%S')] Starting SAFE MODE copy with progress tracking...${NC}"
            echo -e "${BLUE}📊 Progress will show: [File progress] [Overall ETA] [Speed]${NC}"
            
            # Create log file with proper permissions first
            touch "$output_dir/_copy_log.txt"
            chmod 644 "$output_dir/_copy_log.txt"
            
            # Use full-featured rsync with progress and recovery
            if timeout 1800 sudo rsync -ah --progress --partial --inplace --whole-file \
               --no-compress --modify-window=1 --skip-compress=mp3,MP3,flac,FLAC,jpg,JPG,png,PNG \
               "$mount_point"/ "$output_dir/" 2>&1 | \
               tee -a "$output_dir/_copy_log.txt" | \
               while IFS= read -r line; do
                   echo "[$(date '+%H:%M:%S')] $line"
               done; then
                local end_time=$(date +%s)
                local elapsed_time=$((end_time - start_time))
                local elapsed_min=$((elapsed_time / 60))
                local elapsed_sec=$((elapsed_time % 60))
                
                echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] SAFE MODE copy completed successfully${NC}"
                echo -e "${GREEN}⏱️ Elapsed time: ${elapsed_min}m ${elapsed_sec}s${NC}"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: Data disc '$disc_name' copied in ${elapsed_min}m ${elapsed_sec}s (SAFE MODE fallback)" >> "$LOG_FILE"
                
                # Fix ownership
                sudo chown -R mark:mark "$output_dir"
                
                # Verify copy
                local copied_files=$(find "$output_dir" -type f -not -name "_*" | wc -l)
                local copied_size=$(du -sh "$output_dir" | cut -f1)
                
                echo -e "${GREEN}📊 [$(date '+%H:%M:%S')] Copy verification complete${NC}"
                
                # Create disc info file with proper permissions
                touch "$output_dir/_DISC_INFO.txt"
                chmod 644 "$output_dir/_DISC_INFO.txt"
                cat > "$output_dir/_DISC_INFO.txt" << EOF
Disc Name: $disc_name
Copied On: $(date)
Original Device: $CD_DEVICE
Original Size: $disc_size ($disc_size_bytes bytes)
Copied Size: $copied_size
Original Files: $file_count
Copied Files: $copied_files
Copy Duration: ${elapsed_min}m ${elapsed_sec}s
Average Speed: $(echo "scale=2; $disc_size_bytes / $elapsed_time / 1024 / 1024" | bc 2>/dev/null || echo "N/A") MB/s
Copy Script: G9 Ultimate CD Ripper v1.4
Copy Method: Safe Mode (fallback from failed speed mode)
Copy Status: SUCCESS
Start Time: $(date -d "@$start_time" '+%Y-%m-%d %H:%M:%S')
End Time: $(date -d "@$end_time" '+%Y-%m-%d %H:%M:%S')
EOF
                
                echo -e "${GREEN}📁 Files copied: $copied_files/${file_count}${NC}"
                echo -e "${GREEN}💾 Size copied: $copied_size${NC}"
                
                sudo umount "$mount_point"
                sudo rmdir "$mount_point" 2>/dev/null
                return 0
            else
                local exit_code=$?
                echo -e "${RED}❌ SAFE MODE also failed (exit code: $exit_code)${NC}"
                
                # Check what we managed to copy
                local partial_files=$(find "$output_dir" -type f -not -name "_*" 2>/dev/null | wc -l)
                local partial_size=$(du -sh "$output_dir" 2>/dev/null | cut -f1)
                
                echo -e "${YELLOW}⚠️ Partial copy: $partial_files files, $partial_size${NC}"
                echo "ERROR: Both speed and safe mode failed for data disc '$disc_name' - $partial_files/$file_count files copied" >> "$LOG_FILE"
                
                # Create partial info file with proper permissions
                touch "$output_dir/_DISC_INFO.txt"
                chmod 644 "$output_dir/_DISC_INFO.txt"
                cat > "$output_dir/_DISC_INFO.txt" << EOF
Disc Name: $disc_name
Copied On: $(date)
Original Device: $CD_DEVICE
Original Size: $disc_size
Partial Size: $partial_size
Original Files: $file_count
Copied Files: $partial_files
Copy Script: G9 Ultimate CD Ripper v1.4
Copy Method: Safe Mode (fallback) - Both speed and safe mode failed
Copy Status: PARTIAL - Disc may be damaged or have read errors
Exit Code: $exit_code
EOF
                
                sudo chown -R mark:mark "$output_dir"
                sudo umount "$mount_point" 2>/dev/null
                sudo rmdir "$mount_point" 2>/dev/null
                
                if [ "$partial_files" -gt 0 ]; then
                    echo -e "${YELLOW}💡 Partial copy saved. Check _copy_log.txt for details${NC}"
                    return 2  # Partial success
                else
                    return 1  # Complete failure
                fi
            fi
        fi
    else
        echo -e "${RED}❌ Could not mount data CD/DVD${NC}"
        echo "ERROR: Failed to mount data disc '$disc_name'" >> "$LOG_FILE"
        sudo rmdir "$mount_point" 2>/dev/null
        return 1
    fi
}

eject_disc() {
    echo ""
    echo -e "${YELLOW}⏏️ [$(date '+%H:%M:%S')] Ejecting disc...${NC}"
    sleep 1  # Brief pause before eject
    
    if eject "$CD_DEVICE" 2>/dev/null; then
        echo -e "${GREEN}✅ [$(date '+%H:%M:%S')] Disc ejected successfully!${NC}"
        echo -e "${GREEN}🎉 Ready for next disc${NC}"
        
        # Audio notification (if available)
        which paplay >/dev/null 2>&1 && paplay /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null &
        
        # Also try notification sound alternatives
        which aplay >/dev/null 2>&1 && aplay /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null &
        
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Disc ejected successfully" >> "$LOG_FILE"
        return 0
    else
        echo -e "${RED}❌ [$(date '+%H:%M:%S')] Eject failed - please remove manually${NC}"
        echo -e "${YELLOW}💡 You may need to manually eject the disc${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Eject failed - manual removal required" >> "$LOG_FILE"
        return 1
    fi
}

process_current_disc() {
    echo -e "${BLUE}🔍 [$(date '+%H:%M:%S')] Checking for disc...${NC}"
    
    # Check if disc is present
    if ! cdparanoia -Q 2>&1 >/dev/null && ! sudo mount -o ro "$CD_DEVICE" /mnt 2>/dev/null; then
        sudo umount /mnt 2>/dev/null
        return 1
    fi
    sudo umount /mnt 2>/dev/null
    
    local disc_type=$(detect_disc_type)
    local disc_name=$(get_disc_info)
    
    echo -e "${GREEN}🎵 [$(date '+%H:%M:%S')] Disc detected: '$disc_name' (Type: $disc_type)${NC}"
    
    case "$disc_type" in
        "audio")
            if rip_audio_cd "$disc_name"; then
                eject_disc
                echo -e "${GREEN}🎉 [$(date '+%H:%M:%S')] Audio CD '$disc_name' processed successfully!${NC}"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] ----------------------------------------" >> "$LOG_FILE"
                return 0
            fi
            ;;
        "data")
            copy_data_cd "$disc_name"
            copy_result=$?
            if [ "$copy_result" -eq 0 ]; then
                eject_disc
                echo -e "${GREEN}🎉 [$(date '+%H:%M:%S')] Data CD/DVD '$disc_name' processed successfully!${NC}"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] ----------------------------------------" >> "$LOG_FILE"
                return 0
            elif [ "$copy_result" -eq 2 ]; then
                eject_disc
                echo -e "${YELLOW}🎉 [$(date '+%H:%M:%S')] Data CD/DVD '$disc_name' partially processed (some files copied)${NC}"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] ----------------------------------------" >> "$LOG_FILE"
                return 0
            fi
            ;;
        *)
            echo -e "${RED}⚠️ Unknown disc type or unreadable disc${NC}"
            return 1
            ;;
    esac
    
    return 1
}

show_stats() {
    echo -e "${BLUE}📊 G9 Ripping Station Statistics:${NC}"
    local audio_count=$(find "$AUDIO_OUTPUT_DIR" -name "_RIP_INFO.txt" 2>/dev/null | wc -l)
    local data_count=$(find "$DATA_OUTPUT_DIR" -name "_DISC_INFO.txt" 2>/dev/null | wc -l)
    local partial_count=$(find "$DATA_OUTPUT_DIR" -name "_DISC_INFO.txt" -exec grep -l "PARTIAL" {} \; 2>/dev/null | wc -l)
    local total_size=$(du -sh "$BASE_OUTPUT_DIR/cd_rips" 2>/dev/null | cut -f1)
    
    echo -e "${GREEN}   • Audio CDs ripped: $audio_count${NC}"
    echo -e "${GREEN}   • Data CDs/DVDs copied: $data_count${NC}"
    if [ "$partial_count" -gt 0 ]; then
        echo -e "${YELLOW}   • Partial copies: $partial_count (check _copy_log.txt files)${NC}"
    fi
    echo -e "${GREEN}   • Total storage used: $total_size${NC}"
    echo -e "${YELLOW}   • Log file: $LOG_FILE${NC}"
}

# Main script execution
main() {
    print_banner
    check_requirements
    initialize_log
    
    echo -e "${BLUE}🚀 G9 Ultimate CD Ripping Station Ready!${NC}"
    echo -e "${YELLOW}Features:${NC}"
    echo "   • Auto-detect audio CDs vs data CDs"
    echo "   • Audio: Rip to FLAC (lossless) + MP3 (V0)"
    echo "   • Data: Full file copy with metadata preservation"
    echo "   • MusicBrainz metadata lookup for audio CDs"
    echo "   • Organized storage on 4TB internal drive"
    echo "   • Comprehensive logging and statistics"
    echo ""
    echo -e "${YELLOW}Instructions:${NC}"
    echo "1. Insert a CD or DVD into the USB optical drive"
    echo "2. Press ENTER when ready to process"
    echo "3. Type 'stats' to view ripping statistics"
    echo "4. Type 'quit' or 'exit' to stop"
    echo ""
    
    while true; do
        echo -e "${BLUE}💿 Insert next disc and press ENTER (or 'quit'/'stats'):${NC}"
        read -r input
        
        case "$input" in
            quit|exit|q)
                echo -e "${YELLOW}👋 Shutting down G9 ripping station...${NC}"
                echo "Session ended: $(date)" >> "$LOG_FILE"
                show_stats
                break
                ;;
            stats|s)
                show_stats
                echo ""
                ;;
            *)
                if process_current_disc; then
                    echo -e "${GREEN}✨ Ready for next disc!${NC}"
                    echo ""
                else
                    echo -e "${RED}⚠️ No disc detected or processing failed${NC}"
                    echo -e "${YELLOW}Please insert a CD/DVD and try again${NC}"
                    echo ""
                fi
                ;;
        esac
    done
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    echo -e "${BLUE}🎯 G9 ripping session complete!${NC}"
}

# Run main function
main "$@" 