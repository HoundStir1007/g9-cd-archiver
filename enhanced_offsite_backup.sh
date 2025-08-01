#!/bin/bash

# 🛡️ Enhanced Off-Site Backup Script
# Implements comprehensive backup strategy using Seagate drive
# Based on your existing backup infrastructure

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
BACKUP_ROOT="/media/mark/paperless-storag/backups"
SOURCE_ROOT="/media/mark/paperless-ssd2"
LOG_FILE="/var/log/enhanced-offsite-backup.log"
DATE=$(date +%Y%m%d_%H%M%S)
HOSTNAME=$(hostname)

# Retention settings
DAILY_RETENTION=7    # Keep 7 daily backups
WEEKLY_RETENTION=4   # Keep 4 weekly backups  
MONTHLY_RETENTION=12 # Keep 12 monthly backups

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

# Function to check backup drive
check_backup_drive() {
    log_color "$BLUE" "🔍 Checking backup drive..."
    
    if ! mountpoint -q "$BACKUP_ROOT"; then
        log_color "$RED" "❌ Backup drive not mounted at $BACKUP_ROOT"
        return 1
    fi
    
    local available_space=$(df -h "$BACKUP_ROOT" | awk 'NR==2 {print $4}')
    log_color "$GREEN" "✅ Backup drive mounted - $available_space available"
    return 0
}

# Function to create backup structure
create_backup_structure() {
    log_color "$BLUE" "📁 Creating backup directory structure..."
    
    mkdir -p "$BACKUP_ROOT"/{daily,weekly,monthly,configs}
    log_color "$GREEN" "✅ Backup directories ready"
}

# Function to backup system configurations
backup_configurations() {
    log_color "$BLUE" "⚙️ Backing up system configurations..."
    
    local config_backup="$BACKUP_ROOT/configs/config_backup_$DATE"
    mkdir -p "$config_backup"
    
    # Docker configurations
    if [ -d "/home/mark/docker" ]; then
        cp -r /home/mark/docker "$config_backup/" 2>/dev/null || true
    fi
    
    # Copy any docker-compose files
    find /home/mark -name "docker-compose*.yml" -exec cp {} "$config_backup/" \; 2>/dev/null || true
    
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
    
    # Create archive
    tar -czf "$BACKUP_ROOT/configs/config_backup_$DATE.tar.gz" -C "$BACKUP_ROOT/configs" "config_backup_$DATE"
    rm -rf "$config_backup"
    
    log_color "$GREEN" "✅ Configuration backup completed"
}

# Function to backup data with rsync
backup_data() {
    local source_dir=$1
    local backup_type=$2  # daily, weekly, monthly
    local description=$3
    
    if [ ! -d "$source_dir" ]; then
        log_color "$YELLOW" "⚠️ WARNING: Source directory $source_dir not found, skipping"
        return 0
    fi
    
    local source_size=$(get_size "$source_dir")
    log_color "$BLUE" "📦 Backing up $description ($source_size)..."
    
    local backup_dir="$BACKUP_ROOT/$backup_type/$(basename "$source_dir")_$DATE"
    local link_dest=""
    
    # Find most recent backup for incremental
    local latest_backup=$(find "$BACKUP_ROOT/$backup_type" -name "$(basename "$source_dir")_*" -type d | sort | tail -1)
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
    
    log_color "$BLUE" "🗂️ Managing $backup_type backup retention (keep $retention_count)..."
    
    local backup_path="$BACKUP_ROOT/$backup_type"
    
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
        find "$BACKUP_ROOT/configs" -name "*.tar.gz" | sort | head -n -"$retention_count" | while read -r old_config; do
            if [ -n "$old_config" ] && [ -f "$old_config" ]; then
                log_color "$YELLOW" "🗑️ Removing old config: $(basename "$old_config")"
                rm -f "$old_config"
            fi
        done
    fi
}

# Function to check available space
check_space() {
    log_color "$BLUE" "💾 Checking available space on backup drive..."
    
    local available_space=$(df "$BACKUP_ROOT" | awk 'NR==2 {print $4}')
    local source_size=$(du -s "$SOURCE_ROOT" 2>/dev/null | awk '{print $1}' || echo "0")
    
    local available_human=$(df -h "$BACKUP_ROOT" | awk 'NR==2 {print $4}')
    local source_human=$(get_size "$SOURCE_ROOT")
    
    log_color "$BLUE" "Available space: $available_human"
    log_color "$BLUE" "Source data size: $source_human"
    
    if [ "$available_space" -lt $((source_size * 2)) ] && [ "$source_size" -gt 0 ]; then
        log_color "$YELLOW" "⚠️ WARNING: Low disk space on backup drive. Consider cleanup."
    fi
}

# Function to determine backup type
should_create_weekly() {
    [ "$(date +%u)" = "7" ]  # Sunday is day 7
}

should_create_monthly() {
    [ "$(date +%d)" = "01" ]  # First day of month
}

# Main backup function
main() {
    log_color "$GREEN" "🚀 Starting enhanced off-site backup process..."
    log_color "$BLUE" "Backup date: $DATE"
    log_color "$BLUE" "Hostname: $HOSTNAME"
    
    local start_time=$(date +%s)
    
    # Check backup drive
    if ! check_backup_drive; then
        log_color "$RED" "❌ Backup drive not available"
        exit 1
    fi
    
    # Create backup structure
    create_backup_structure
    
    # Check available space
    check_space
    
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
    
    # Backup critical data
    backup_data "$SOURCE_ROOT/paperless" "$backup_type" "Paperless-ngx Documents"
    backup_data "$SOURCE_ROOT/retro-gaming" "$backup_type" "Retro Gaming"
    backup_data "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research" "$backup_type" "Home Server Research"
    
    # Verify the backups
    local latest_paperless_backup=$(find "$BACKUP_ROOT/$backup_type" -name "paperless_*" -type d | sort | tail -1)
    if [ -n "$latest_paperless_backup" ]; then
        verify_backup "$latest_paperless_backup" "Paperless-ngx"
    fi
    
    # Manage retention
    manage_retention "daily" "$DAILY_RETENTION"
    manage_retention "weekly" "$WEEKLY_RETENTION"
    manage_retention "monthly" "$MONTHLY_RETENTION"
    
    # Calculate duration
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local duration_human="${duration}s"
    if [ "$duration" -gt 60 ]; then
        duration_human="$((duration / 60))m $((duration % 60))s"
    fi
    
    # Final status
    local total_backup_size=$(get_size "$BACKUP_ROOT")
    
    log_color "$GREEN" "🎉 Off-site backup completed successfully!"
    log_color "$GREEN" "Duration: $duration_human"
    log_color "$GREEN" "Total backup size: $total_backup_size"
    
    echo
    log_color "$BLUE" "📊 Backup Summary:"
    echo "----------------------------------------"
    echo "BACKUP LOCATION ($BACKUP_ROOT):"
    find "$BACKUP_ROOT" -maxdepth 2 -type d -name "*_*" | while read -r backup_dir; do
        if [ -d "$backup_dir" ]; then
            local size=$(get_size "$backup_dir")
            local backup_name=$(basename "$backup_dir")
            printf "  %-40s %s\n" "$backup_name" "$size"
        fi
    done
    echo "----------------------------------------"
}

# Error handling
trap 'log_color "$RED" "❌ Backup failed with error on line $LINENO"; exit 1' ERR

# Run main function
main "$@" 