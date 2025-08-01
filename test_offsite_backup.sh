#!/bin/bash

# 🧪 Test Off-Site Backup Strategy
# Tests backup to both Seagate and Toshiba drives with small segment

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
SEAGATE_BACKUP="/media/mark/paperless-storag/backups"
TOSHIBA_BACKUP="/media/mark/Canvio/backups"
TEST_SOURCE="/media/mark/paperless-ssd2/paperless"
LOG_FILE="/tmp/test_backup_$(date +%Y%m%d_%H%M%S).log"
DATE=$(date +%Y%m%d_%H%M%S)

# Function to log with timestamp
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_color() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] $message${NC}" | tee -a "$LOG_FILE"
}

# Function to get directory size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
}

# Function to check drive status
check_drive() {
    local drive_path=$1
    local drive_name=$2
    
    log_color "$BLUE" "🔍 Checking $drive_name..."
    
    if ! mountpoint -q "$drive_path"; then
        log_color "$RED" "❌ $drive_name not mounted at $drive_path"
        return 1
    fi
    
    local available_space=$(df -h "$drive_path" | awk 'NR==2 {print $4}')
    log_color "$GREEN" "✅ $drive_name mounted - $available_space available"
    return 0
}

# Function to create backup structure
create_backup_structure() {
    log_color "$BLUE" "📁 Creating backup directory structure..."
    
    for backup_root in "$SEAGATE_BACKUP" "$TOSHIBA_BACKUP"; do
        mkdir -p "$backup_root"/{test,configs}
        log_color "$GREEN" "✅ Created structure in $(basename "$backup_root")"
    done
}

# Function to backup small test segment
backup_test_segment() {
    local source_dir="$TEST_SOURCE"
    local description="Paperless-ngx Test Backup"
    
    if [ ! -d "$source_dir" ]; then
        log_color "$YELLOW" "⚠️ Test source directory not found, using home_server_research instead"
        source_dir="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research"
    fi
    
    local source_size=$(get_size "$source_dir")
    log_color "$BLUE" "📦 Backing up $description ($source_size) to both drives..."
    
    # Backup to Seagate
    local seagate_backup_dir="$SEAGATE_BACKUP/test/paperless_test_$DATE"
    log_color "$CYAN" "📤 Copying to Seagate drive..."
    rsync -av --progress "$source_dir/" "$seagate_backup_dir/" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        local seagate_size=$(get_size "$seagate_backup_dir")
        log_color "$GREEN" "✅ Seagate backup completed: $seagate_size"
    else
        log_color "$RED" "❌ Seagate backup failed"
        return 1
    fi
    
    # Backup to Toshiba
    local toshiba_backup_dir="$TOSHIBA_BACKUP/test/paperless_test_$DATE"
    log_color "$CYAN" "📤 Copying to Toshiba drive..."
    rsync -av --progress "$source_dir/" "$toshiba_backup_dir/" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        local toshiba_size=$(get_size "$toshiba_backup_dir")
        log_color "$GREEN" "✅ Toshiba backup completed: $toshiba_size"
    else
        log_color "$RED" "❌ Toshiba backup failed"
        return 1
    fi
    
    return 0
}

# Function to verify backups
verify_backups() {
    log_color "$BLUE" "🔍 Verifying backups..."
    
    local seagate_backup_dir="$SEAGATE_BACKUP/test/paperless_test_$DATE"
    local toshiba_backup_dir="$TOSHIBA_BACKUP/test/paperless_test_$DATE"
    
    # Check if both backups exist
    if [ -d "$seagate_backup_dir" ] && [ -d "$toshiba_backup_dir" ]; then
        local seagate_files=$(find "$seagate_backup_dir" -type f 2>/dev/null | wc -l)
        local toshiba_files=$(find "$toshiba_backup_dir" -type f 2>/dev/null | wc -l)
        
        log_color "$GREEN" "✅ Seagate backup verified: $seagate_files files"
        log_color "$GREEN" "✅ Toshiba backup verified: $toshiba_files files"
        
        if [ "$seagate_files" -eq "$toshiba_files" ] && [ "$seagate_files" -gt 0 ]; then
            log_color "$GREEN" "🎉 Both backups match and contain data!"
            return 0
        else
            log_color "$YELLOW" "⚠️ Backup file counts don't match - manual verification needed"
            return 1
        fi
    else
        log_color "$RED" "❌ One or both backup directories missing"
        return 1
    fi
}

# Function to show backup summary
show_summary() {
    log_color "$CYAN" "📊 Test Backup Summary"
    echo "=========================================="
    
    echo "SEAGATE BACKUP ($SEAGATE_BACKUP):"
    if [ -d "$SEAGATE_BACKUP" ]; then
        df -h "$SEAGATE_BACKUP" | tail -1 | awk '{print "  Used: " $3 " / " $2 " (" $5 " full)"}'
        echo "  Available: $(df -h "$SEAGATE_BACKUP" | tail -1 | awk '{print $4}')"
        echo "  Test backup: $(get_size "$SEAGATE_BACKUP/test/paperless_test_$DATE" 2>/dev/null || echo "N/A")"
    else
        echo "  ❌ Not mounted"
    fi
    
    echo ""
    echo "TOSHIBA BACKUP ($TOSHIBA_BACKUP):"
    if [ -d "$TOSHIBA_BACKUP" ]; then
        df -h "$TOSHIBA_BACKUP" | tail -1 | awk '{print "  Used: " $3 " / " $2 " (" $5 " full)"}'
        echo "  Available: $(df -h "$TOSHIBA_BACKUP" | tail -1 | awk '{print $4}')"
        echo "  Test backup: $(get_size "$TOSHIBA_BACKUP/test/paperless_test_$DATE" 2>/dev/null || echo "N/A")"
    else
        echo "  ❌ Not mounted"
    fi
    
    echo ""
    echo "LOG FILE: $LOG_FILE"
    echo "=========================================="
}

# Main execution
main() {
    log_color "$GREEN" "🧪 Starting Off-Site Backup Test..."
    log_color "$BLUE" "Test date: $DATE"
    log_color "$BLUE" "Log file: $LOG_FILE"
    echo ""
    
    # Check both drives
    local drives_ok=true
    
    if ! check_drive "$SEAGATE_BACKUP" "Seagate drive"; then
        drives_ok=false
    fi
    
    if ! check_drive "$TOSHIBA_BACKUP" "Toshiba drive"; then
        drives_ok=false
    fi
    
    if [ "$drives_ok" = false ]; then
        log_color "$RED" "❌ One or both drives not available. Please check connections."
        exit 1
    fi
    
    echo ""
    
    # Create backup structure
    create_backup_structure
    echo ""
    
    # Perform test backup
    if backup_test_segment; then
        log_color "$GREEN" "✅ Test backup completed successfully!"
        echo ""
        
        # Verify backups
        if verify_backups; then
            log_color "$GREEN" "🎉 Off-site backup test PASSED!"
        else
            log_color "$YELLOW" "⚠️ Backup verification had issues - check manually"
        fi
    else
        log_color "$RED" "❌ Test backup failed"
        exit 1
    fi
    
    echo ""
    show_summary
    
    log_color "$GREEN" "🚀 Ready to implement full off-site backup strategy!"
}

# Run main function
main "$@" 