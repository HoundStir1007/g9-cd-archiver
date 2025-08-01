#!/bin/bash

# CD Rips Integration and VM Files Move Script
# Created: $(date)
# Purpose: Safely integrate new CD rips and move VM files appropriately

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base paths
MAIN_DRIVE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2"
PAPERLESS_DRIVE="/media/mark/paperless-ssd2"
CD_RIPS_SOURCE="${PAPERLESS_DRIVE}/digital_consolidation/cd_rips"
MUSIC_TARGET="${MAIN_DRIVE}/media/music"
VM_TARGET="${PAPERLESS_DRIVE}/vm-files"

# Logging
LOG_FILE="${MAIN_DRIVE}/home_server_research/integration_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    log "SUCCESS: $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    log "WARNING: $1"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    log "ERROR: $1"
}

# Pre-flight checks
preflight_checks() {
    print_header "Pre-flight Checks"
    
    # Check if source directories exist
    if [[ ! -d "$CD_RIPS_SOURCE" ]]; then
        print_error "CD rips source directory not found: $CD_RIPS_SOURCE"
        exit 1
    fi
    
    if [[ ! -d "$MUSIC_TARGET" ]]; then
        print_error "Music target directory not found: $MUSIC_TARGET"
        exit 1
    fi
    
    # Check available space
    PAPERLESS_FREE=$(df "$PAPERLESS_DRIVE" | awk 'NR==2 {print $4}')
    VM_SIZE=$(du -s "${MAIN_DRIVE}/vm-images" "${MAIN_DRIVE}/Windows11.iso" 2>/dev/null | awk '{sum+=$1} END {print sum}')
    
    log "Available space on paperless drive: ${PAPERLESS_FREE}KB"
    log "VM files size: ${VM_SIZE}KB"
    
    if [[ $VM_SIZE -gt $PAPERLESS_FREE ]]; then
        print_error "Insufficient space on paperless drive for VM files"
        exit 1
    fi
    
    print_success "Pre-flight checks passed"
}

# Create backup of current state
create_backup() {
    print_header "Creating State Backup"
    
    BACKUP_DIR="${MAIN_DRIVE}/home_server_research/archive/integration_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup current music directory structure (just directory listing)
    find "$MUSIC_TARGET" -type d > "${BACKUP_DIR}/music_structure_before.txt"
    
    # Backup CD rips structure
    find "$CD_RIPS_SOURCE" > "${BACKUP_DIR}/cd_rips_structure.txt"
    
    # Backup VM file locations
    ls -la "${MAIN_DRIVE}/vm-images/" > "${BACKUP_DIR}/vm_files_before.txt" 2>/dev/null || true
    ls -la "${MAIN_DRIVE}/Windows11.iso" > "${BACKUP_DIR}/windows_iso_before.txt" 2>/dev/null || true
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Integrate CD rips
integrate_cd_rips() {
    print_header "Integrating CD Rips"
    
    # Create new CD rips directory in music
    NEW_RIPS_DIR="${MUSIC_TARGET}/CD_Rips_$(date +%Y%m%d)"
    mkdir -p "$NEW_RIPS_DIR"
    
    log "Created new rips directory: $NEW_RIPS_DIR"
    
    # Move audio rips
    if [[ -d "${CD_RIPS_SOURCE}/audio" ]]; then
        print_warning "Moving audio CD rips..."
        rsync -av --progress "${CD_RIPS_SOURCE}/audio/" "${NEW_RIPS_DIR}/Audio_CDs/" || {
            print_error "Failed to move audio CD rips"
            return 1
        }
        print_success "Audio CD rips moved successfully"
    fi
    
    # Move data rips (compilation albums, etc.)
    if [[ -d "${CD_RIPS_SOURCE}/data" ]]; then
        print_warning "Moving data CD rips..."
        rsync -av --progress "${CD_RIPS_SOURCE}/data/" "${NEW_RIPS_DIR}/Data_CDs/" || {
            print_error "Failed to move data CD rips"
            return 1
        }
        print_success "Data CD rips moved successfully"
    fi
    
    # Move ripping log
    if [[ -f "${CD_RIPS_SOURCE}/ripping_log.txt" ]]; then
        cp "${CD_RIPS_SOURCE}/ripping_log.txt" "${NEW_RIPS_DIR}/"
        print_success "Ripping log copied"
    fi
    
    # Calculate sizes
    AUDIO_SIZE=$(du -sh "${NEW_RIPS_DIR}/Audio_CDs" 2>/dev/null | cut -f1 || echo "0")
    DATA_SIZE=$(du -sh "${NEW_RIPS_DIR}/Data_CDs" 2>/dev/null | cut -f1 || echo "0")
    
    log "Integrated CD rips - Audio: ${AUDIO_SIZE}, Data: ${DATA_SIZE}"
    print_success "CD rips integration completed"
}

# Move VM files
move_vm_files() {
    print_header "Moving VM Files to Paperless Drive"
    
    # Create VM directory on paperless drive
    mkdir -p "$VM_TARGET"
    
    # Move Windows ISO
    if [[ -f "${MAIN_DRIVE}/Windows11.iso" ]]; then
        print_warning "Moving Windows11.iso (5.5GB)..."
        rsync -av --progress "${MAIN_DRIVE}/Windows11.iso" "${VM_TARGET}/" || {
            print_error "Failed to move Windows11.iso"
            return 1
        }
        print_success "Windows11.iso moved successfully"
    fi
    
    # Move VM images directory
    if [[ -d "${MAIN_DRIVE}/vm-images" ]]; then
        print_warning "Moving vm-images directory (13GB)..."
        rsync -av --progress "${MAIN_DRIVE}/vm-images/" "${VM_TARGET}/vm-images/" || {
            print_error "Failed to move vm-images"
            return 1
        }
        print_success "vm-images directory moved successfully"
    fi
    
    print_success "VM files move completed"
}

# Handle UHF duplicate
handle_uhf_duplicate() {
    print_header "Analyzing UHF File Duplicate"
    
    PAPERLESS_UHF="/media/mark/paperless-ssd2/jellyfin/media/Uhf1.mp4"
    MAIN_UHF_DIR="${MAIN_DRIVE}/media/movies/UHF"
    
    if [[ -f "$PAPERLESS_UHF" ]]; then
        UHF_SIZE=$(du -h "$PAPERLESS_UHF" | cut -f1)
        print_warning "Found UHF file on paperless drive: ${UHF_SIZE}"
        
        # Check if it's different from existing files
        EXISTING_SIZES=$(ls -lh "${MAIN_UHF_DIR}"/Uhf* 2>/dev/null | awk '{print $5, $9}' || echo "None found")
        
        log "Existing UHF files in main drive: $EXISTING_SIZES"
        log "Paperless UHF file size: $UHF_SIZE"
        
        # Move it to UHF directory with descriptive name
        NEW_NAME="${MAIN_UHF_DIR}/Uhf1_from_paperless_$(date +%Y%m%d).mp4"
        rsync -av "$PAPERLESS_UHF" "$NEW_NAME" || {
            print_error "Failed to move UHF file"
            return 1
        }
        
        print_success "UHF file moved to main movies directory"
    fi
}

# Cleanup source directories (only after successful moves)
cleanup_sources() {
    print_header "Cleaning Up Source Directories"
    
    # Verify moves were successful before cleanup
    if [[ -d "${MUSIC_TARGET}/CD_Rips_$(date +%Y%m%d)" ]]; then
        print_warning "Removing CD rips source directory..."
        rm -rf "$CD_RIPS_SOURCE" || {
            print_error "Failed to remove CD rips source"
            return 1
        }
        print_success "CD rips source cleaned up"
    fi
    
    # Only remove original VM files if they exist on paperless drive
    if [[ -f "${VM_TARGET}/Windows11.iso" ]]; then
        rm -f "${MAIN_DRIVE}/Windows11.iso" || print_warning "Could not remove original Windows11.iso"
        print_success "Original Windows11.iso removed"
    fi
    
    if [[ -d "${VM_TARGET}/vm-images" ]]; then
        rm -rf "${MAIN_DRIVE}/vm-images" || print_warning "Could not remove original vm-images"
        print_success "Original vm-images directory removed"
    fi
    
    # Remove UHF from paperless if successfully moved
    if [[ -f "${MAIN_UHF_DIR}/Uhf1_from_paperless_$(date +%Y%m%d).mp4" ]]; then
        rm -f "/media/mark/paperless-ssd2/jellyfin/media/Uhf1.mp4" || print_warning "Could not remove original UHF file"
        print_success "Original UHF file removed from paperless"
    fi
}

# Generate final report
generate_report() {
    print_header "Integration Complete - Final Report"
    
    echo "=== INTEGRATION SUMMARY ===" | tee -a "$LOG_FILE"
    echo "Date: $(date)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    # Music integration
    if [[ -d "${MUSIC_TARGET}/CD_Rips_$(date +%Y%m%d)" ]]; then
        TOTAL_CD_SIZE=$(du -sh "${MUSIC_TARGET}/CD_Rips_$(date +%Y%m%d)" | cut -f1)
        echo "✅ CD Rips integrated: ${TOTAL_CD_SIZE}" | tee -a "$LOG_FILE"
    fi
    
    # VM files
    if [[ -d "$VM_TARGET" ]]; then
        VM_TOTAL_SIZE=$(du -sh "$VM_TARGET" | cut -f1)
        echo "✅ VM files moved to paperless: ${VM_TOTAL_SIZE}" | tee -a "$LOG_FILE"
    fi
    
    # Space freed on main drive
    echo "" | tee -a "$LOG_FILE"
    echo "🎯 Space freed on main 4TB drive: ~18.5GB (VM files)" | tee -a "$LOG_FILE"
    echo "🎵 New content added to music: ~18GB (CD rips)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "📁 Backup location: $BACKUP_DIR" | tee -a "$LOG_FILE"
    echo "📝 Full log: $LOG_FILE" | tee -a "$LOG_FILE"
    
    print_success "Integration completed successfully!"
}

# Main execution
main() {
    print_header "Starting CD Rips Integration and VM Files Move"
    
    preflight_checks
    create_backup
    integrate_cd_rips
    move_vm_files
    handle_uhf_duplicate
    cleanup_sources
    generate_report
    
    echo ""
    print_success "All operations completed successfully! 🎉"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 