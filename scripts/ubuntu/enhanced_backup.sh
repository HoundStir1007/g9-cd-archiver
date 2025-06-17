#!/bin/bash

# 🛡️ Enhanced Home Server Backup Script
# Implements 3-2-1 backup strategy:
# - 3 copies of data
# - 2 different storage types
# - 1 off-site backup

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
PRIMARY_BACKUP="/media/gmk/seagate/backups"  # Seagate Drive (auto-mounted)
SECONDARY_BACKUP="/media/backup-drive2/backups"    # USB Drive 2 (optional)
SOURCE_ROOT="/mnt/paperless-ssd"
CONFIG_BACKUP_DIR="/home/gmk/backup-configs"
LOG_FILE="/var/log/enhanced-backup.log"
DATE=$(date +%Y%m%d_%H%M%S)
HOSTNAME=$(hostname)

# Retention settings
DAILY_RETENTION=7    # Keep 7 daily backups
WEEKLY_RETENTION=4   # Keep 4 weekly backups  
MONTHLY_RETENTION=12 # Keep 12 monthly backups

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to log with timestamp
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to log with color and timestamp
log_color() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] $message${NC}" | tee -a "$LOG_FILE"
}

# Function to calculate directory size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
}

# Function to create backup directories
create_backup_structure() {
    log_color "$BLUE" "📁 Creating backup directory structure..."
    
    for backup_root in "$PRIMARY_BACKUP" "$SECONDARY_BACKUP"; do
        mkdir -p "$backup_root"/{daily,weekly,monthly,configs}
    done
    
    mkdir -p "$CONFIG_BACKUP_DIR"
    
    # Ensure primary backup drive is mounted
    if ! mountpoint -q "$PRIMARY_BACKUP"; then
        log_color "$RED" "❌ ERROR: Primary backup drive not mounted at $PRIMARY_BACKUP"
        exit 1
    fi
    
    log_color "$GREEN" "✅ Backup directories ready"
}

# Function to backup system configurations
backup_configurations() {
    log_color "$BLUE" "⚙️ Backing up system configurations..."
    
    local config_backup="$CONFIG_BACKUP_DIR/config_backup_$DATE"
    mkdir -p "$config_backup"
    
    # Docker configurations
    if [ -d "/home/gmk/docker" ]; then
        cp -r /home/gmk/docker "$config_backup/" 2>/dev/null || true
    fi
    
    # Copy any docker-compose files
    find /home/gmk -name "docker-compose*.yml" -exec cp {} "$config_backup/" \; 2>/dev/null || true
    
    # System network configuration
    cp /etc/netplan/*.yaml "$config_backup/" 2>/dev/null || true
    
    # Tailscale configuration
    if [ -d "/var/lib/tailscale" ]; then
        sudo cp -r /var/lib/tailscale "$config_backup/" 2>/dev/null || true
    fi
    
    # Cron jobs
    crontab -l > "$config_backup/crontab.txt" 2>/dev/null || true
    
    # Installed packages list
    dpkg --get-selections > "$config_backup/installed_packages.txt"
    
    # System info
    {
        echo "=== System Info ==="
        uname -a
        echo "=== Disk Usage ==="
        df -h
        echo "=== Memory ==="
        free -h
        echo "=== Docker Containers ==="
        docker ps -a 2>/dev/null || echo "Docker not running"
    } > "$config_backup/system_info.txt"
    
    # Create archives for each backup destination
    for backup_root in "$PRIMARY_BACKUP" "$SECONDARY_BACKUP"; do
        tar -czf "$backup_root/configs/config_backup_$DATE.tar.gz" -C "$CONFIG_BACKUP_DIR" "config_backup_$DATE"
    done
    
    rm -rf "$config_backup"
    
    log_color "$GREEN" "✅ Configuration backup completed"
}

# Function to backup data with rsync
backup_data() {
    local source_dir=$1
    local backup_type=$2  # daily, weekly, monthly
    local description=$3
    local destination_root=$4  # PRIMARY_BACKUP or SECONDARY_BACKUP
    
    if [ ! -d "$source_dir" ]; then
        log_color "$YELLOW" "⚠️ WARNING: Source directory $source_dir not found, skipping"
        return 0
    fi
    
    local source_size=$(get_size "$source_dir")
    log_color "$BLUE" "📦 Backing up $description to $(basename "$destination_root") ($source_size)..."
    
    local backup_dir="$destination_root/$backup_type/$(basename "$source_dir")_$DATE"
    local link_dest=""
    
    # Find most recent backup for incremental
    local latest_backup=$(find "$destination_root/$backup_type" -name "$(basename "$source_dir")_*" -type d | sort | tail -1)
    if [ -n "$latest_backup" ] && [ -d "$latest_backup" ]; then
        link_dest="--link-dest=$latest_backup"
    fi
    
    # Perform backup with progress
    rsync -av --progress $link_dest \
        --exclude='*.tmp' \
        --exclude='*.log' \
        --exclude='.DS_Store' \
        "$source_dir/" "$backup_dir/" | while IFS= read -r line; do
        if [[ "$line" == *"/"* ]] && [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
            printf "\r  Copying: $(basename "$line")"
        fi
    done
    
    printf "\n"
    local backup_size=$(get_size "$backup_dir")
    log_color "$GREEN" "✅ $description backup completed: $backup_size"
}

# Function to verify backup integrity
verify_backup() {
    local backup_dir=$1
    local description=$2
    
    log_color "$BLUE" "🔍 Verifying $description backup..."
    
    if [ ! -d "$backup_dir" ] || [ -z "$(ls -A "$backup_dir" 2>/dev/null)" ]; then
        log_color "$RED" "❌ ERROR: Backup verification failed - directory empty or missing"
        return 1
    fi
    
    local source_files=$(find "$SOURCE_ROOT" -type f 2>/dev/null | wc -l || echo "0")
    local backup_files=$(find "$backup_dir" -type f 2>/dev/null | wc -l || echo "0")
    
    log_color "$GREEN" "✅ Backup verified: $backup_files files backed up"
    
    if [ "$source_files" -gt 0 ] && [ "$backup_files" -lt $((source_files / 2)) ]; then
        log_color "$YELLOW" "⚠️ WARNING: Backup has significantly fewer files than source"
    fi
}

# Function to manage retention
manage_retention() {
    local backup_type=$1
    local retention_count=$2
    local backup_root=$3
    
    log_color "$BLUE" "🗂️ Managing $backup_type backup retention in $(basename "$backup_root") (keep $retention_count)..."
    
    local backup_path="$backup_root/$backup_type"
    
    # Find and remove old backups
    find "$backup_path" -type d -name "*_*" | sort | head -n -"$retention_count" | while read -r old_backup; do
        if [ -n "$old_backup" ] && [ -d "$old_backup" ]; then
            local backup_size=$(get_size "$old_backup")
            log_color "$YELLOW" "🗑️ Removing old backup: $(basename "$old_backup") ($backup_size)"
            rm -rf "$old_backup"
        fi
    done
    
    # Clean up old config backups
    if [ "$backup_type" = "daily" ]; then
        find "$backup_root/configs" -name "*.tar.gz" | sort | head -n -"$retention_count" | while read -r old_config; do
            if [ -n "$old_config" ] && [ -f "$old_config" ]; then
                log_color "$YELLOW" "🗑️ Removing old config: $(basename "$old_config")"
                rm -f "$old_config"
            fi
        done
    fi
}

# Function to check available space
check_space() {
    local backup_root=$1
    log_color "$BLUE" "💾 Checking available space on $(basename "$backup_root")..."
    
    local available_space=$(df "$backup_root" | awk 'NR==2 {print $4}')
    local source_size=$(du -s "$SOURCE_ROOT" 2>/dev/null | awk '{print $1}' || echo "0")
    
    local available_human=$(df -h "$backup_root" | awk 'NR==2 {print $4}')
    local source_human=$(get_size "$SOURCE_ROOT")
    
    log_color "$BLUE" "Available space: $available_human"
    log_color "$BLUE" "Source data size: $source_human"
    
    if [ "$available_space" -lt $((source_size * 2)) ] && [ "$source_size" -gt 0 ]; then
        log_color "$YELLOW" "⚠️ WARNING: Low disk space on $(basename "$backup_root"). Consider cleanup."
    fi
}

# Function to create weekly backup (if it's Sunday)
should_create_weekly() {
    [ "$(date +%u)" = "7" ]  # Sunday is day 7
}

# Function to create monthly backup (if it's the 1st)  
should_create_monthly() {
    [ "$(date +%d)" = "01" ]  # First day of month
}

# Function to send notification
send_notification() {
    local status=$1
    local message=$2
    
    if [ -f "/home/gmk/.backup_notifications" ]; then
        echo "$message" | mail -s "Backup $status" "msakamoto+homelab@gmail.com" 2>/dev/null || true
    fi
}

# Main backup function
main() {
    log_color "$GREEN" "🚀 Starting enhanced dual-drive backup process..."
    log_color "$BLUE" "Backup date: $DATE"
    log_color "$BLUE" "Hostname: $HOSTNAME"
    
    if [ "$EUID" -eq 0 ]; then
        log_color "$YELLOW" "⚠️ Running as root - this is OK for system access"
    fi
    
    local start_time=$(date +%s)
    
    # Create backup structure
    create_backup_structure
    
    # Check available space on backup destinations
    check_space "$PRIMARY_BACKUP"
    [ -d "$SECONDARY_BACKUP" ] && check_space "$SECONDARY_BACKUP"
    
    # Always backup configurations
    backup_configurations
    
    # Determine backup type
    local backup_type="daily"
    if should_create_monthly; then
        backup_type="monthly"
    elif should_create_weekly; then
        backup_type="weekly"
    fi
    
    log_color "$BLUE" "📅 Creating $backup_type backup"
    
    # Backup to primary USB drive
    backup_data "$SOURCE_ROOT/paperless" "$backup_type" "Paperless-ngx Documents" "$PRIMARY_BACKUP"
    backup_data "$SOURCE_ROOT/jellyfin" "$backup_type" "Jellyfin Media Library" "$PRIMARY_BACKUP"
    
    # Backup to secondary USB drive (if available)
    if [ -d "$SECONDARY_BACKUP" ] && mountpoint -q "$SECONDARY_BACKUP"; then
        backup_data "$SOURCE_ROOT/paperless" "$backup_type" "Paperless-ngx Documents" "$SECONDARY_BACKUP"
        backup_data "$SOURCE_ROOT/jellyfin" "$backup_type" "Jellyfin Media Library" "$SECONDARY_BACKUP"
    else
        log_color "$YELLOW" "⚠️ Secondary backup drive not available"
    fi
    
    # Verify the backups
    local latest_paperless_backup=$(find "$PRIMARY_BACKUP/$backup_type" -name "paperless_*" -type d | sort | tail -1)
    if [ -n "$latest_paperless_backup" ]; then
        verify_backup "$latest_paperless_backup" "Paperless-ngx"
    fi
    
    # Manage retention for all backup locations
    for backup_root in "$PRIMARY_BACKUP" "$SECONDARY_BACKUP"; do
        if [ -d "$backup_root" ]; then
            manage_retention "daily" "$DAILY_RETENTION" "$backup_root"
            manage_retention "weekly" "$WEEKLY_RETENTION" "$backup_root"
            manage_retention "monthly" "$MONTHLY_RETENTION" "$backup_root"
        fi
    done
    
    # Calculate duration
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local duration_human="${duration}s"
    if [ "$duration" -gt 60 ]; then
        duration_human="$((duration / 60))m $((duration % 60))s"
    fi
    
    # Final status
    local total_primary_size=$(get_size "$PRIMARY_BACKUP")
    local total_secondary_size=$([ -d "$SECONDARY_BACKUP" ] && get_size "$SECONDARY_BACKUP" || echo "N/A")
    
    log_color "$GREEN" "🎉 Dual-drive backup completed successfully!"
    log_color "$GREEN" "Duration: $duration_human"
    log_color "$GREEN" "Primary backup size: $total_primary_size"
    log_color "$GREEN" "Secondary backup size: $total_secondary_size"
    
    # Send success notification
    send_notification "Success" "Dual-drive backup completed in $duration_human. Primary: $total_primary_size, Secondary: $total_secondary_size"
    
    echo
    log_color "$BLUE" "📊 Backup Summary:"
    echo "----------------------------------------"
    echo "PRIMARY BACKUP ($PRIMARY_BACKUP):"
    find "$PRIMARY_BACKUP" -maxdepth 2 -type d -name "*_*" | while read -r backup_dir; do
        if [ -d "$backup_dir" ]; then
            local size=$(get_size "$backup_dir")
            local backup_name=$(basename "$backup_dir")
            printf "  %-40s %s\n" "$backup_name" "$size"
        fi
    done
    
    if [ -d "$SECONDARY_BACKUP" ]; then
        echo
        echo "SECONDARY BACKUP ($SECONDARY_BACKUP):"
        find "$SECONDARY_BACKUP" -maxdepth 2 -type d -name "*_*" | while read -r backup_dir; do
            if [ -d "$backup_dir" ]; then
                local size=$(get_size "$backup_dir")
                local backup_name=$(basename "$backup_dir")
                printf "  %-40s %s\n" "$backup_name" "$size"
            fi
        done
    fi
    echo "----------------------------------------"
}

# Error handling
trap 'log_color "$RED" "❌ Backup failed with error on line $LINENO"; send_notification "Failed" "Backup script failed"; exit 1' ERR

# Run main function
main "$@"