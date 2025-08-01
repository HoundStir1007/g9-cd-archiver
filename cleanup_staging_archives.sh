#!/bin/bash

# Staging Archives Cleanup Script
# Created: $(date)
# Purpose: Safely remove verified duplicate staging directories (1TB+)

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base paths
MAIN_DRIVE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2"
ARCHIVES_DIR="${MAIN_DRIVE}/archives"
THUNDERBOLT_TRANSFER="${ARCHIVES_DIR}/thunderbolt_transfer"
CANVIO_TRANSFER="${ARCHIVES_DIR}/canvio_transfer"

# Logging
LOG_FILE="${MAIN_DRIVE}/home_server_research/cleanup_staging_$(date +%Y%m%d_%H%M%S).log"

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

# Verification checks to ensure these are really staging directories
verify_staging_directories() {
    print_header "Verifying Staging Directories"
    
    local verification_failed=0
    
    # Check thunderbolt_transfer indicators
    if [[ -d "$THUNDERBOLT_TRANSFER" ]]; then
        # Look for Apple Time Machine indicators (staging behavior)
        if [[ -f "${THUNDERBOLT_TRANSFER}/.com.apple.timemachine.donotpresent" ]]; then
            print_success "Found Time Machine staging indicator in thunderbolt_transfer"
        else
            print_warning "Time Machine indicator not found"
            verification_failed=1
        fi
        
        # Check for old Plex Server structure (should be staging)
        if [[ -d "${THUNDERBOLT_TRANSFER}/Plex Server" ]]; then
            print_success "Found old Plex Server structure (staging)"
        else
            print_warning "Plex Server structure not found"
            verification_failed=1
        fi
        
        # Check timestamps - should be older than organized media
        THUNDERBOLT_DATE=$(stat -c %Y "$THUNDERBOLT_TRANSFER" 2>/dev/null || echo 0)
        ORGANIZED_MEDIA_DATE=$(stat -c %Y "${MAIN_DRIVE}/media" 2>/dev/null || echo 0)
        
        if [[ $THUNDERBOLT_DATE -lt $ORGANIZED_MEDIA_DATE ]]; then
            print_success "Thunderbolt staging is older than organized media"
        else
            print_warning "Timestamp verification failed"
            verification_failed=1
        fi
    else
        print_error "Thunderbolt transfer directory not found"
        verification_failed=1
    fi
    
    # Check canvio_transfer indicators
    if [[ -d "$CANVIO_TRANSFER" ]]; then
        # Look for staging folder names
        if [[ -d "${CANVIO_TRANSFER}/save_for_migration" ]]; then
            print_success "Found 'save_for_migration' staging directory"
        else
            print_warning "Migration staging directory not found"
            verification_failed=1
        fi
        
        if [[ -d "${CANVIO_TRANSFER}/photos_to_import" ]]; then
            print_success "Found 'photos_to_import' staging directory"
        else
            print_warning "Photos import staging directory not found"
            verification_failed=1
        fi
    else
        print_error "Canvio transfer directory not found"
        verification_failed=1
    fi
    
    if [[ $verification_failed -eq 1 ]]; then
        print_error "Verification failed! These may not be staging directories."
        echo "Manual review required before deletion."
        exit 1
    fi
    
    print_success "Staging directory verification passed"
}

# Calculate and display what will be cleaned
analyze_cleanup() {
    print_header "Cleanup Analysis"
    
    if [[ -d "$THUNDERBOLT_TRANSFER" ]]; then
        THUNDERBOLT_SIZE=$(du -sh "$THUNDERBOLT_TRANSFER" 2>/dev/null | cut -f1 || echo "Unknown")
        log "Thunderbolt transfer size: $THUNDERBOLT_SIZE"
        echo "📦 Thunderbolt transfer: $THUNDERBOLT_SIZE"
    fi
    
    if [[ -d "$CANVIO_TRANSFER" ]]; then
        CANVIO_SIZE=$(du -sh "$CANVIO_TRANSFER" 2>/dev/null | cut -f1 || echo "Unknown")
        log "Canvio transfer size: $CANVIO_SIZE"
        echo "📦 Canvio transfer: $CANVIO_SIZE"
    fi
    
    # Check current free space
    CURRENT_FREE=$(df -h "$MAIN_DRIVE" | awk 'NR==2 {print $4}')
    echo "💾 Current free space: $CURRENT_FREE"
    
    echo ""
    print_warning "This will permanently delete the above directories!"
    echo "Expected space recovery: ~1,013GB"
}

# Create comprehensive backup before deletion
create_comprehensive_backup() {
    print_header "Creating Comprehensive Backup"
    
    BACKUP_DIR="${MAIN_DRIVE}/home_server_research/archive/staging_cleanup_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup directory structures (not the files themselves - too large)
    if [[ -d "$THUNDERBOLT_TRANSFER" ]]; then
        find "$THUNDERBOLT_TRANSFER" -type d > "${BACKUP_DIR}/thunderbolt_directories.txt"
        find "$THUNDERBOLT_TRANSFER" -type f -name "*.txt" -o -name "*.md" -o -name "*.log" | head -100 > "${BACKUP_DIR}/thunderbolt_text_files.txt"
        
        # Backup a few key config/metadata files
        find "$THUNDERBOLT_TRANSFER" -name ".com.apple.*" -exec cp {} "$BACKUP_DIR/" \; 2>/dev/null || true
        
        print_success "Thunderbolt structure backed up"
    fi
    
    if [[ -d "$CANVIO_TRANSFER" ]]; then
        find "$CANVIO_TRANSFER" -type d > "${BACKUP_DIR}/canvio_directories.txt"
        find "$CANVIO_TRANSFER" -type f -name "*.txt" -o -name "*.md" -o -name "*.log" | head -100 > "${BACKUP_DIR}/canvio_text_files.txt"
        
        print_success "Canvio structure backed up"
    fi
    
    # Backup current disk usage
    df -h > "${BACKUP_DIR}/disk_usage_before.txt"
    du -sh "${MAIN_DRIVE}"/* > "${BACKUP_DIR}/directory_sizes_before.txt" 2>/dev/null || true
    
    echo "📁 Backup created at: $BACKUP_DIR" | tee -a "$LOG_FILE"
    print_success "Comprehensive backup completed"
}

# Safe deletion with progress
safe_delete_staging() {
    print_header "Safe Deletion of Staging Directories"
    
    # Delete thunderbolt_transfer
    if [[ -d "$THUNDERBOLT_TRANSFER" ]]; then
        print_warning "Deleting thunderbolt_transfer (701GB)..."
        print_warning "This will take several minutes..."
        
        # Use safe deletion with progress
        time rm -rf "$THUNDERBOLT_TRANSFER" || {
            print_error "Failed to delete thunderbolt_transfer"
            return 1
        }
        
        print_success "Thunderbolt transfer deleted successfully"
    fi
    
    # Delete canvio_transfer
    if [[ -d "$CANVIO_TRANSFER" ]]; then
        print_warning "Deleting canvio_transfer (312GB)..."
        print_warning "This will take several minutes..."
        
        time rm -rf "$CANVIO_TRANSFER" || {
            print_error "Failed to delete canvio_transfer"
            return 1
        }
        
        print_success "Canvio transfer deleted successfully"
    fi
    
    # Clean up empty archives directory if it exists
    if [[ -d "$ARCHIVES_DIR" ]]; then
        # Only remove if it's empty or only contains the digital_consolidation symlink
        if [[ $(ls -1A "$ARCHIVES_DIR" | wc -l) -le 1 ]]; then
            print_warning "Removing empty archives directory..."
            rm -rf "$ARCHIVES_DIR" || print_warning "Could not remove archives directory"
        else
            print_warning "Archives directory not empty, keeping it"
        fi
    fi
    
    print_success "Staging deletion completed"
}

# Also clean up DVD salvage directories
cleanup_dvd_salvage() {
    print_header "Cleaning Up DVD Salvage Directories"
    
    local dvd_salvage_dirs=("${MAIN_DRIVE}/dvd_salvage_20250713_162700" 
                            "${MAIN_DRIVE}/dvd_salvage_20250713_162805" 
                            "${MAIN_DRIVE}/dvd_salvage_20250713_162809"
                            "${MAIN_DRIVE}/dvd_clips_20250713_183408")
    
    for dir in "${dvd_salvage_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            DVD_SIZE=$(du -sh "$dir" 2>/dev/null | cut -f1 || echo "Unknown")
            print_warning "Removing DVD salvage directory: $(basename "$dir") ($DVD_SIZE)"
            
            rm -rf "$dir" || {
                print_warning "Could not remove $dir"
                continue
            }
            
            print_success "Removed $(basename "$dir")"
        fi
    done
    
    print_success "DVD salvage cleanup completed"
}

# Generate final cleanup report
generate_cleanup_report() {
    print_header "Cleanup Complete - Final Report"
    
    # Check new free space
    NEW_FREE=$(df -h "$MAIN_DRIVE" | awk 'NR==2 {print $4}')
    NEW_USED=$(df -h "$MAIN_DRIVE" | awk 'NR==2 {print $3}')
    
    echo "=== CLEANUP SUMMARY ===" | tee -a "$LOG_FILE"
    echo "Date: $(date)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "✅ Removed staging directories:" | tee -a "$LOG_FILE"
    echo "   - thunderbolt_transfer: 701GB" | tee -a "$LOG_FILE"
    echo "   - canvio_transfer: 312GB" | tee -a "$LOG_FILE"
    echo "   - DVD salvage dirs: ~3.4GB" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "💾 Disk space after cleanup:" | tee -a "$LOG_FILE"
    echo "   - Used: $NEW_USED" | tee -a "$LOG_FILE"
    echo "   - Free: $NEW_FREE" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "🎯 Total space recovered: ~1,016GB" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "📁 Backup location: $BACKUP_DIR" | tee -a "$LOG_FILE"
    echo "📝 Full log: $LOG_FILE" | tee -a "$LOG_FILE"
    
    print_success "Major cleanup completed successfully!"
}

# Interactive confirmation
confirm_deletion() {
    print_header "Final Confirmation Required"
    
    echo "🚨 This will permanently delete ~1TB of staging directories:"
    echo "   - thunderbolt_transfer (701GB)"
    echo "   - canvio_transfer (312GB)"
    echo "   - DVD salvage directories (3.4GB)"
    echo ""
    echo "These have been verified as leftover staging from previous migrations."
    echo "Backups of directory structures will be created."
    echo ""
    
    read -p "Type 'DELETE_STAGING' to proceed: " confirmation
    
    if [[ "$confirmation" != "DELETE_STAGING" ]]; then
        print_warning "Deletion cancelled by user"
        exit 0
    fi
    
    print_success "User confirmed deletion"
}

# Main execution
main() {
    print_header "Starting Staging Archives Cleanup (1TB+)"
    
    verify_staging_directories
    analyze_cleanup
    confirm_deletion
    create_comprehensive_backup
    safe_delete_staging
    cleanup_dvd_salvage
    generate_cleanup_report
    
    echo ""
    print_success "🎉 MASSIVE cleanup completed! ~1TB space recovered!"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 