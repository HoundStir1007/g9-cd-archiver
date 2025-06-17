#!/bin/bash

# 🛠️ Enhanced Backup System Setup Script
# Sets up the 3-2-1 backup system with proper permissions and scheduling

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PRIMARY_BACKUP="/media/paperless-storage/backups"
SECONDARY_BACKUP="/media/backup-drive2/backups"
SCRIPTS_DIR="/home/gmk/scripts/ubuntu"
BACKUP_SCRIPT="$SCRIPTS_DIR/enhanced_backup.sh"
LOG_DIR="/var/log"
LOG_FILE="$LOG_DIR/enhanced-backup.log"

# Function to log with color
log() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] $message${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log "$RED" "❌ This script must be run as root"
    exit 1
fi

# Create necessary directories
log "$BLUE" "📁 Creating backup directories..."
mkdir -p "$PRIMARY_BACKUP"
mkdir -p "$SECONDARY_BACKUP"
mkdir -p "$SCRIPTS_DIR"
touch "$LOG_FILE"

# Set proper permissions
log "$BLUE" "🔒 Setting permissions..."
chown -R gmk:gmk "$PRIMARY_BACKUP"
chown -R gmk:gmk "$SECONDARY_BACKUP"
chown -R gmk:gmk "$SCRIPTS_DIR"
chown gmk:gmk "$LOG_FILE"
chmod 755 "$PRIMARY_BACKUP"
chmod 755 "$SECONDARY_BACKUP"
chmod 755 "$SCRIPTS_DIR"
chmod 644 "$LOG_FILE"

# Make backup script executable
chmod +x "$BACKUP_SCRIPT"

# Install required packages
log "$BLUE" "📦 Installing required packages..."
apt-get update
apt-get install -y rsync mailutils

# Create backup notification flag file
touch /home/gmk/.backup_notifications
chown gmk:gmk /home/gmk/.backup_notifications

# Configure email notifications (using existing Gmail setup)
if [ ! -f "/home/gmk/.backup_notifications" ]; then
    log "$YELLOW" "⚠️ Email notifications not configured. Create /home/gmk/.backup_notifications to enable."
fi

# Set up cron jobs
log "$BLUE" "⏰ Setting up cron jobs..."

# Remove any existing backup cron jobs
crontab -u gmk -l 2>/dev/null | grep -v "$BACKUP_SCRIPT" | crontab -u gmk -

# Add new cron job for daily backups at 2 AM
(crontab -u gmk -l 2>/dev/null; echo "0 2 * * * $BACKUP_SCRIPT >> $LOG_FILE 2>&1") | crontab -u gmk -

# Set up log rotation
cat > /etc/logrotate.d/enhanced-backup << EOF
$LOG_FILE {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 gmk gmk
}
EOF

# Verify setup
log "$BLUE" "🔍 Verifying setup..."

# Check directories
for dir in "$PRIMARY_BACKUP" "$SECONDARY_BACKUP" "$SCRIPTS_DIR"; do
    if [ ! -d "$dir" ]; then
        log "$RED" "❌ Directory $dir not created"
        exit 1
    fi
done

# Check script
if [ ! -x "$BACKUP_SCRIPT" ]; then
    log "$RED" "❌ Backup script not executable"
    exit 1
fi

# Check cron job
if ! crontab -u gmk -l | grep -q "$BACKUP_SCRIPT"; then
    log "$RED" "❌ Cron job not installed"
    exit 1
fi

# Success
log "$GREEN" "✅ Enhanced backup system setup completed successfully!"
echo
log "$BLUE" "📋 Setup Summary:"
echo "----------------------------------------"
echo "Primary Backup Location: $PRIMARY_BACKUP"
echo "Secondary Backup Location: $SECONDARY_BACKUP"
echo "Backup Script: $BACKUP_SCRIPT"
echo "Log File: $LOG_FILE"
echo "Cron Schedule: Daily at 2 AM"
echo "----------------------------------------"
echo
log "$YELLOW" "⚠️ Important Notes:"
echo "1. Ensure both USB drives are properly mounted"
echo "2. Test the backup system by running: sudo -u gmk $BACKUP_SCRIPT"
echo "3. Monitor $LOG_FILE for backup status"
echo "4. Email notifications will be sent to msakamoto+homelab@gmail.com" 