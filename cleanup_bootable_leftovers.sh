#!/bin/bash

# Bootable Drive Cleanup Script
# Created: $(date)
# Purpose: Remove leftover Linux system directories from data drive

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base paths
DRIVE_ROOT="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2"

# Logging
LOG_FILE="${DRIVE_ROOT}/home_server_research/bootable_cleanup_$(date +%Y%m%d_%H%M%S).log"

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

# Define what to keep (user content)
KEEP_DIRS=(
    "media"
    "home_server_research"
    "vm-images"
    "jellyfin"
    "logs"
    "cache"
    "backups"
    "archives"
    "digital_consolidation"
)

# Define system directories to remove
SYSTEM_DIRS=(
    "usr"
    "var" 
    "boot"
    "etc"
    "dev"
    "run"
    "snap"
    "cdrom"
    "proc"
    "sys"
    "tmp"
    "home"
    "mnt"
    "opt"
    "srv"
    "root"
    "bin.usr-is-merged"
    "lib.usr-is-merged"
    "sbin.usr-is-merged"
)

# Define system symlinks to remove
SYSTEM_SYMLINKS=(
    "bin"
    "lib"
    "lib64" 
    "sbin"
)

# Verification check
verify_user_content() {
    print_header "Verifying User Content Safety"
    
    local all_safe=1
    
    for dir in "${KEEP_DIRS[@]}"; do
        if [[ -d "${DRIVE_ROOT}/${dir}" ]]; then
            SIZE=$(du -sh "${DRIVE_ROOT}/${dir}" 2>/dev/null | cut -f1 || echo "Unknown")
            print_success "Protected: ${dir}/ (${SIZE})"
        elif [[ -f "${DRIVE_ROOT}/${dir}" ]]; then
            print_success "Protected: ${dir} (file)"
        else
            print_warning "${dir} not found (may not exist)"
        fi
    done
    
    # Check that our main content is safe
    if [[ ! -d "${DRIVE_ROOT}/media" ]]; then
        print_error "CRITICAL: media/ directory not found!"
        all_safe=0
    fi
    
    if [[ ! -d "${DRIVE_ROOT}/home_server_research" ]]; then
        print_error "CRITICAL: home_server_research/ directory not found!"
        all_safe=0
    fi
    
    if [[ $all_safe -eq 0 ]]; then
        print_error "Safety verification failed! Aborting."
        exit 1
    fi
    
    print_success "User content verification passed"
}

# Analyze what will be removed
analyze_cleanup() {
    print_header "Cleanup Analysis"
    
    local total_size=0
    
    echo "📦 System directories to remove:"
    for dir in "${SYSTEM_DIRS[@]}"; do
        if [[ -d "${DRIVE_ROOT}/${dir}" ]]; then
            SIZE=$(du -sh "${DRIVE_ROOT}/${dir}" 2>/dev/null | cut -f1 || echo "Unknown")
            SIZE_BYTES=$(du -sb "${DRIVE_ROOT}/${dir}" 2>/dev/null | cut -f1 || echo "0")
            total_size=$((total_size + SIZE_BYTES))
            echo "  • ${dir}/ (${SIZE})"
            log "Will remove: ${dir}/ (${SIZE})"
        fi
    done
    
    echo ""
    echo "🔗 System symlinks to remove:"
    for link in "${SYSTEM_SYMLINKS[@]}"; do
        if [[ -L "${DRIVE_ROOT}/${link}" ]]; then
            TARGET=$(readlink "${DRIVE_ROOT}/${link}")
            echo "  • ${link} → ${TARGET}"
            log "Will remove symlink: ${link} → ${TARGET}"
        fi
    done
    
    echo ""
    TOTAL_GB=$(echo "scale=2; $total_size / 1024 / 1024 / 1024" | bc -l)
    print_warning "Estimated space recovery: ~${TOTAL_GB}GB"
    
    # Check current free space
    CURRENT_FREE=$(df -h "$DRIVE_ROOT" | awk 'NR==2 {print $4}')
    echo "💾 Current free space: $CURRENT_FREE"
}

# Create backup of directory structure
create_backup() {
    print_header "Creating Backup"
    
    BACKUP_DIR="${DRIVE_ROOT}/home_server_research/archive/bootable_cleanup_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup root directory listing
    ls -la "${DRIVE_ROOT}/" > "${BACKUP_DIR}/root_directory_before.txt"
    
    # Backup key system file lists (not the files themselves)
    for dir in "${SYSTEM_DIRS[@]}"; do
        if [[ -d "${DRIVE_ROOT}/${dir}" ]]; then
            find "${DRIVE_ROOT}/${dir}" -type f -name "*.conf" -o -name "*.cfg" -o -name "*.txt" 2>/dev/null | head -20 > "${BACKUP_DIR}/${dir}_key_files.txt" || true
        fi
    done
    
    # Backup current disk usage
    df -h > "${BACKUP_DIR}/disk_usage_before.txt"
    du -sh "${DRIVE_ROOT}"/* > "${BACKUP_DIR}/directory_sizes_before.txt" 2>/dev/null || true
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Remove system directories
cleanup_system_dirs() {
    print_header "Removing System Directories"
    
    # Remove system directories
    for dir in "${SYSTEM_DIRS[@]}"; do
        if [[ -d "${DRIVE_ROOT}/${dir}" ]]; then
            print_warning "Removing ${dir}/..."
            sudo rm -rf "${DRIVE_ROOT}/${dir}" || {
                print_error "Failed to remove ${dir}/"
                continue
            }
            print_success "Removed ${dir}/"
        fi
    done
    
    # Remove system symlinks
    for link in "${SYSTEM_SYMLINKS[@]}"; do
        if [[ -L "${DRIVE_ROOT}/${link}" ]]; then
            print_warning "Removing symlink ${link}..."
            sudo rm "${DRIVE_ROOT}/${link}" || {
                print_error "Failed to remove symlink ${link}"
                continue
            }
            print_success "Removed symlink ${link}"
        fi
    done
    
    print_success "System directory cleanup completed"
}

# Generate final report
generate_report() {
    print_header "Cleanup Complete - Final Report"
    
    # Check new free space
    NEW_FREE=$(df -h "$DRIVE_ROOT" | awk 'NR==2 {print $4}')
    NEW_USED=$(df -h "$DRIVE_ROOT" | awk 'NR==2 {print $3}')
    
    echo "=== BOOTABLE CLEANUP SUMMARY ===" | tee -a "$LOG_FILE"
    echo "Date: $(date)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "✅ Removed Linux system directories:" | tee -a "$LOG_FILE"
    for dir in "${SYSTEM_DIRS[@]}"; do
        if [[ ! -d "${DRIVE_ROOT}/${dir}" ]]; then
            echo "   - ${dir}/" | tee -a "$LOG_FILE"
        fi
    done
    
    echo "" | tee -a "$LOG_FILE"
    echo "✅ Removed system symlinks:" | tee -a "$LOG_FILE"
    for link in "${SYSTEM_SYMLINKS[@]}"; do
        if [[ ! -L "${DRIVE_ROOT}/${link}" ]]; then
            echo "   - ${link}" | tee -a "$LOG_FILE"
        fi
    done
    
    echo "" | tee -a "$LOG_FILE"
    echo "💾 Final disk usage:" | tee -a "$LOG_FILE"
    echo "   - Used: $NEW_USED" | tee -a "$LOG_FILE"
    echo "   - Free: $NEW_FREE" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "📁 Preserved user content:" | tee -a "$LOG_FILE"
    for dir in "${KEEP_DIRS[@]}"; do
        if [[ -d "${DRIVE_ROOT}/${dir}" ]]; then
            SIZE=$(du -sh "${DRIVE_ROOT}/${dir}" 2>/dev/null | cut -f1 || echo "Unknown")
            echo "   ✅ ${dir}/ (${SIZE})" | tee -a "$LOG_FILE"
        fi
    done
    
    echo "" | tee -a "$LOG_FILE"
    echo "📁 Backup location: $BACKUP_DIR" | tee -a "$LOG_FILE"
    echo "📝 Full log: $LOG_FILE" | tee -a "$LOG_FILE"
    
    print_success "Bootable cleanup completed successfully!"
}

# Interactive confirmation
confirm_cleanup() {
    print_header "Final Confirmation Required"
    
    echo "🚨 This will permanently remove Linux system directories:"
    echo "   • usr/, var/, boot/, etc/ (4GB+)"
    echo "   • All other system directories and symlinks"
    echo ""
    echo "✅ Your content will be preserved:"
    echo "   • media/ (768GB)"
    echo "   • home_server_research/"
    echo "   • vm-images/, jellyfin/, logs/, etc."
    echo ""
    echo "This will convert the drive from bootable to data-only."
    echo ""
    
    read -p "Type 'CLEANUP_BOOTABLE' to proceed: " confirmation
    
    if [[ "$confirmation" != "CLEANUP_BOOTABLE" ]]; then
        print_warning "Cleanup cancelled by user"
        exit 0
    fi
    
    print_success "User confirmed bootable cleanup"
}

# Main execution
main() {
    print_header "Starting Bootable Drive Cleanup"
    
    verify_user_content
    analyze_cleanup
    confirm_cleanup
    create_backup
    cleanup_system_dirs
    generate_report
    
    echo ""
    print_success "🎉 Bootable cleanup completed! Drive optimized for data-only use!"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 