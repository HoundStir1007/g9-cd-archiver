#!/bin/bash

# 🛡️ Toshiba Canvio Drive Conversion Script
# Safely converts HFS+ to ext4 and sets up dual-drive backup system
# Drives: Black (Toshiba) and Silver (Seagate)

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
TOSHIBA_DEVICE="/dev/sdb2"
TOSHIBA_MOUNT="/media/mark/Canvio"
SEAGATE_MOUNT="/media/mark/paperless-storag"
BACKUP_ROOT_SILVER="$SEAGATE_MOUNT/backups"
BACKUP_ROOT_BLACK="/media/mark/Black/backups"
LOG_FILE="/tmp/toshiba_conversion_$(date +%Y%m%d_%H%M%S).log"
DATE=$(date +%Y%m%d_%H%M%S)

# Function to log with timestamp
log_color() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] $message${NC}" | tee -a "$LOG_FILE"
}

# Function to get directory size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_color "$RED" "❌ This script must be run as root (use sudo)"
        exit 1
    fi
}

# Function to check drive status
check_drives() {
    log_color "$BLUE" "🔍 Checking drive status..."
    
    # Check Toshiba drive
    if ! mountpoint -q "$TOSHIBA_MOUNT"; then
        log_color "$RED" "❌ Toshiba drive not mounted at $TOSHIBA_MOUNT"
        return 1
    fi
    
    # Check Seagate drive
    if ! mountpoint -q "$SEAGATE_MOUNT"; then
        log_color "$RED" "❌ Seagate drive not mounted at $SEAGATE_MOUNT"
        return 1
    fi
    
    local toshiba_space=$(df -h "$TOSHIBA_MOUNT" | awk 'NR==2 {print $4}')
    local seagate_space=$(df -h "$SEAGATE_MOUNT" | awk 'NR==2 {print $4}')
    
    log_color "$GREEN" "✅ Toshiba drive mounted - $toshiba_space available"
    log_color "$GREEN" "✅ Seagate drive mounted - $seagate_space available"
    return 0
}

# Function to backup Toshiba data to Seagate
backup_toshiba_data() {
    log_color "$BLUE" "📦 Backing up Toshiba data to Seagate before conversion..."
    
    local backup_dir="$SEAGATE_MOUNT/toshiba_backup_$DATE"
    mkdir -p "$backup_dir"
    
    local toshiba_size=$(get_size "$TOSHIBA_MOUNT")
    log_color "$CYAN" "📤 Copying $toshiba_size from Toshiba to Seagate..."
    
    # Use rsync for safe copying
    rsync -av --progress "$TOSHIBA_MOUNT/" "$backup_dir/" | while IFS= read -r line; do
        if [[ "$line" == *"/"* ]] && [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
            printf "\r  Copying: $(basename "$line")"
        fi
    done
    
    printf "\n"
    local backup_size=$(get_size "$backup_dir")
    log_color "$GREEN" "✅ Toshiba data backed up: $backup_size"
    
    # Verify backup
    local source_files=$(find "$TOSHIBA_MOUNT" -type f 2>/dev/null | wc -l)
    local backup_files=$(find "$backup_dir" -type f 2>/dev/null | wc -l)
    
    if [ "$source_files" -eq "$backup_files" ] && [ "$source_files" -gt 0 ]; then
        log_color "$GREEN" "✅ Backup verification passed: $backup_files files"
        return 0
    else
        log_color "$RED" "❌ Backup verification failed"
        return 1
    fi
}

# Function to unmount and convert drive
convert_drive() {
    log_color "$BLUE" "🔄 Converting Toshiba drive from HFS+ to ext4..."
    
    # Unmount drive
    log_color "$CYAN" "📤 Unmounting Toshiba drive..."
    umount "$TOSHIBA_MOUNT" 2>/dev/null || true
    
    # Wait a moment
    sleep 2
    
    # Check if unmounted
    if mountpoint -q "$TOSHIBA_MOUNT"; then
        log_color "$RED" "❌ Failed to unmount Toshiba drive"
        return 1
    fi
    
    log_color "$GREEN" "✅ Toshiba drive unmounted successfully"
    
    # Create new ext4 filesystem
    log_color "$CYAN" "🔧 Creating ext4 filesystem on Toshiba drive..."
    mkfs.ext4 "$TOSHIBA_DEVICE"
    
    if [ $? -eq 0 ]; then
        log_color "$GREEN" "✅ ext4 filesystem created successfully"
    else
        log_color "$RED" "❌ Failed to create ext4 filesystem"
        return 1
    fi
}

# Function to mount and restore data
restore_data() {
    log_color "$BLUE" "📥 Restoring data to converted Toshiba drive..."
    
    # Create mount point for Black drive
    mkdir -p "/media/mark/Black"
    
    # Mount the converted drive
    log_color "$CYAN" "📌 Mounting converted Toshiba drive..."
    mount "$TOSHIBA_DEVICE" "/media/mark/Black"
    
    if ! mountpoint -q "/media/mark/Black"; then
        log_color "$RED" "❌ Failed to mount converted drive"
        return 1
    fi
    
    log_color "$GREEN" "✅ Converted drive mounted at /media/mark/Black"
    
    # Restore data from backup
    local backup_dir="$SEAGATE_MOUNT/toshiba_backup_$DATE"
    if [ -d "$backup_dir" ]; then
        log_color "$CYAN" "📤 Restoring data from backup..."
        rsync -av --progress "$backup_dir/" "/media/mark/Black/" | while IFS= read -r line; do
            if [[ "$line" == *"/"* ]] && [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
                printf "\r  Restoring: $(basename "$line")"
            fi
        done
        
        printf "\n"
        local restored_size=$(get_size "/media/mark/Black")
        log_color "$GREEN" "✅ Data restored: $restored_size"
    else
        log_color "$YELLOW" "⚠️ No backup found, starting fresh"
    fi
}

# Function to set up backup structure
setup_backup_structure() {
    log_color "$BLUE" "📁 Setting up backup directory structure..."
    
    # Create backup directories on both drives
    mkdir -p "$BACKUP_ROOT_SILVER"/{daily,weekly,monthly,configs}
    mkdir -p "$BACKUP_ROOT_BLACK"/{daily,weekly,monthly,configs}
    
    log_color "$GREEN" "✅ Backup directories created on both drives"
    
    # Set proper permissions
    chown -R mark:mark "$BACKUP_ROOT_SILVER" 2>/dev/null || true
    chown -R mark:mark "$BACKUP_ROOT_BLACK" 2>/dev/null || true
    
    log_color "$GREEN" "✅ Permissions set correctly"
}

# Function to update fstab for automatic mounting
update_fstab() {
    log_color "$BLUE" "⚙️ Updating fstab for automatic mounting..."
    
    # Get UUID of converted drive
    local uuid=$(blkid "$TOSHIBA_DEVICE" | grep -o 'UUID="[^"]*"' | cut -d'"' -f2)
    
    if [ -n "$uuid" ]; then
        # Create backup of fstab
        cp /etc/fstab /etc/fstab.backup.$DATE
        
        # Add entry for Black drive
        echo "# Black backup drive (converted from Toshiba Canvio)" >> /etc/fstab
        echo "UUID=$uuid /media/mark/Black ext4 defaults,noatime 0 2" >> /etc/fstab
        
        log_color "$GREEN" "✅ fstab updated with Black drive entry"
    else
        log_color "$YELLOW" "⚠️ Could not get UUID, manual fstab update may be needed"
    fi
}

# Function to create dual-drive backup script
create_backup_script() {
    log_color "$BLUE" "📝 Creating dual-drive backup script..."
    
    cat > /usr/local/bin/dual-drive-backup << 'EOF'
#!/bin/bash

# 🛡️ Dual-Drive Off-Site Backup Script
# Backs up to both Black (Toshiba) and Silver (Seagate) drives

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
BACKUP_ROOT_BLACK="/media/mark/Black/backups"
BACKUP_ROOT_SILVER="/media/mark/paperless-storag/backups"
SOURCE_ROOT="/media/mark/paperless-ssd2"
LOG_FILE="/var/log/dual-drive-backup.log"
DATE=$(date +%Y%m%d_%H%M%S)

# Function to log with timestamp
log_color() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] $message${NC}" | tee -a "$LOG_FILE"
}

# Function to get directory size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
}

# Function to check drives
check_drives() {
    local drives_ok=true
    
    if ! mountpoint -q "$BACKUP_ROOT_BLACK"; then
        log_color "$RED" "❌ Black drive not mounted"
        drives_ok=false
    fi
    
    if ! mountpoint -q "$BACKUP_ROOT_SILVER"; then
        log_color "$RED" "❌ Silver drive not mounted"
        drives_ok=false
    fi
    
    if [ "$drives_ok" = true ]; then
        local black_space=$(df -h "$BACKUP_ROOT_BLACK" | awk 'NR==2 {print $4}')
        local silver_space=$(df -h "$BACKUP_ROOT_SILVER" | awk 'NR==2 {print $4}')
        log_color "$GREEN" "✅ Black drive: $black_space available"
        log_color "$GREEN" "✅ Silver drive: $silver_space available"
    fi
    
    return $([ "$drives_ok" = true ] && echo 0 || echo 1)
}

# Function to backup data
backup_data() {
    local source_dir=$1
    local backup_type=$2
    local description=$3
    
    if [ ! -d "$source_dir" ]; then
        log_color "$YELLOW" "⚠️ Source directory $source_dir not found, skipping"
        return 0
    fi
    
    local source_size=$(get_size "$source_dir")
    log_color "$BLUE" "📦 Backing up $description ($source_size) to both drives..."
    
    # Backup to Black drive
    local black_backup_dir="$BACKUP_ROOT_BLACK/$backup_type/$(basename "$source_dir")_$DATE"
    log_color "$CYAN" "📤 Copying to Black drive..."
    rsync -av --progress "$source_dir/" "$black_backup_dir/" 2>&1 | tee -a "$LOG_FILE"
    
    # Backup to Silver drive
    local silver_backup_dir="$BACKUP_ROOT_SILVER/$backup_type/$(basename "$source_dir")_$DATE"
    log_color "$CYAN" "📤 Copying to Silver drive..."
    rsync -av --progress "$source_dir/" "$silver_backup_dir/" 2>&1 | tee -a "$LOG_FILE"
    
    local black_size=$(get_size "$black_backup_dir")
    local silver_size=$(get_size "$silver_backup_dir")
    log_color "$GREEN" "✅ Black backup: $black_size"
    log_color "$GREEN" "✅ Silver backup: $silver_size"
}

# Main backup function
main() {
    log_color "$GREEN" "🚀 Starting dual-drive backup process..."
    log_color "$BLUE" "Backup date: $DATE"
    
    # Check drives
    if ! check_drives; then
        log_color "$RED" "❌ One or both drives not available"
        exit 1
    fi
    
    # Determine backup type
    local backup_type="daily"
    if [ "$(date +%u)" = "7" ]; then
        backup_type="weekly"
    elif [ "$(date +%d)" = "01" ]; then
        backup_type="monthly"
    fi
    
    log_color "$BLUE" "📅 Creating $backup_type backup"
    
    # Backup critical data to both drives
    backup_data "$SOURCE_ROOT/paperless" "$backup_type" "Paperless-ngx Documents"
    backup_data "$SOURCE_ROOT/retro-gaming" "$backup_type" "Retro Gaming"
    backup_data "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/home_server_research" "$backup_type" "Home Server Research"
    
    # Final status
    local black_total=$(get_size "$BACKUP_ROOT_BLACK")
    local silver_total=$(get_size "$BACKUP_ROOT_SILVER")
    
    log_color "$GREEN" "🎉 Dual-drive backup completed successfully!"
    log_color "$GREEN" "Black drive total: $black_total"
    log_color "$GREEN" "Silver drive total: $silver_total"
}

# Run main function
main "$@"
EOF

    chmod +x /usr/local/bin/dual-drive-backup
    log_color "$GREEN" "✅ Dual-drive backup script created: /usr/local/bin/dual-drive-backup"
}

# Function to show final summary
show_summary() {
    log_color "$CYAN" "📊 Conversion Summary"
    echo "=========================================="
    
    echo "DRIVE STATUS:"
    echo "  Black (Toshiba): $(df -h /media/mark/Black | tail -1 | awk '{print $4 " available"}')"
    echo "  Silver (Seagate): $(df -h /media/mark/paperless-storag | tail -1 | awk '{print $4 " available"}')"
    
    echo ""
    echo "BACKUP LOCATIONS:"
    echo "  Black backups: $BACKUP_ROOT_BLACK"
    echo "  Silver backups: $BACKUP_ROOT_SILVER"
    
    echo ""
    echo "BACKUP SCRIPT:"
    echo "  Location: /usr/local/bin/dual-drive-backup"
    echo "  Usage: sudo /usr/local/bin/dual-drive-backup"
    
    echo ""
    echo "AUTOMATIC MOUNTING:"
    echo "  Black drive will mount automatically on boot"
    echo "  Mount point: /media/mark/Black"
    
    echo "=========================================="
}

# Main execution
main() {
    log_color "$GREEN" "🔄 Starting Toshiba Canvio drive conversion..."
    log_color "$BLUE" "Conversion date: $DATE"
    log_color "$BLUE" "Log file: $LOG_FILE"
    echo ""
    
    # Check if running as root
    check_root
    
    # Check drives
    if ! check_drives; then
        log_color "$RED" "❌ Drive check failed"
        exit 1
    fi
    
    echo ""
    
    # Backup Toshiba data
    if ! backup_toshiba_data; then
        log_color "$RED" "❌ Failed to backup Toshiba data"
        exit 1
    fi
    
    echo ""
    
    # Convert drive
    if ! convert_drive; then
        log_color "$RED" "❌ Failed to convert drive"
        exit 1
    fi
    
    echo ""
    
    # Restore data
    if ! restore_data; then
        log_color "$RED" "❌ Failed to restore data"
        exit 1
    fi
    
    echo ""
    
    # Set up backup structure
    setup_backup_structure
    
    # Update fstab
    update_fstab
    
    # Create backup script
    create_backup_script
    
    echo ""
    show_summary
    
    log_color "$GREEN" "🎉 Toshiba drive conversion completed successfully!"
    log_color "$GREEN" "🚀 Dual-drive backup system ready!"
}

# Run main function
main "$@" 