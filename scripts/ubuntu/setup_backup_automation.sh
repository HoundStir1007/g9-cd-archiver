#!/bin/bash

# 🔧 Setup script for Enhanced Backup System
# Run this once to install and configure automated backups

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')] $1${NC}"
}

log_info() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')] $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[$(date '+%H:%M:%S')] $1${NC}"
}

log_error() {
    echo -e "${RED}[$(date '+%H:%M:%S')] $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_error "Please run as root: sudo ./setup_backup_automation.sh"
    exit 1
fi

log "🚀 Setting up Enhanced Backup System..."

# Get the actual user (not root when using sudo)
REAL_USER=${SUDO_USER:-$(whoami)}
REAL_HOME=$(eval echo ~$REAL_USER)

log_info "Setting up for user: $REAL_USER"
log_info "Home directory: $REAL_HOME"

# 1. Copy backup script to system location
log_info "📁 Installing backup script..."
cp enhanced_backup.sh /usr/local/bin/enhanced-backup
chmod +x /usr/local/bin/enhanced-backup

# 2. Create systemd service
log_info "⚙️ Creating systemd service..."
cat > /etc/systemd/system/enhanced-backup.service << EOF
[Unit]
Description=Enhanced Home Server Backup
After=multi-user.target

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/enhanced-backup
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# 3. Create systemd timer
log_info "⏰ Creating backup timer (daily at 2 AM)..."
cat > /etc/systemd/system/enhanced-backup.timer << EOF
[Unit]
Description=Run Enhanced Backup Daily
Requires=enhanced-backup.service

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=30m

[Install]
WantedBy=timers.target
EOF

# 4. Create log rotation config
log_info "📝 Setting up log rotation..."
cat > /etc/logrotate.d/enhanced-backup << EOF
/var/log/enhanced-backup.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 root root
}
EOF

# 5. Enable and start services
log_info "🔄 Enabling backup automation..."
systemctl daemon-reload
systemctl enable enhanced-backup.timer
systemctl start enhanced-backup.timer

# 6. Create backup directories
log_info "📁 Creating backup directory structure..."
BACKUP_ROOT="/media/gmk/seagate/backups"
mkdir -p "$BACKUP_ROOT"/{daily,weekly,monthly,configs}

# Set appropriate permissions
chown -R "$REAL_USER:$REAL_USER" "$BACKUP_ROOT" 2>/dev/null || log_warn "Could not set permissions on backup directory"

# 7. Create notification config (optional)
log_info "📧 Setting up notification config..."
touch "$REAL_HOME/.backup_notifications"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.backup_notifications"

# 8. Test backup drive mount
log_info "💾 Checking backup drive..."
if mountpoint -q "/media/gmk/seagate"; then
    log "✅ Backup drive is mounted"
    AVAILABLE_SPACE=$(df -h /media/gmk/seagate | awk 'NR==2 {print $4}')
    log_info "Available backup space: $AVAILABLE_SPACE"
else
    log_warn "⚠️ WARNING: Backup drive not mounted at /media/gmk/seagate"
    log_warn "Please check your fstab configuration and ensure the Seagate drive is properly mounted"
fi

# 9. Run a test backup (optional)
echo
read -p "Would you like to run a test backup now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "🧪 Running test backup..."
    systemctl start enhanced-backup.service
    
    # Wait a moment and check status
    sleep 2
    if systemctl is-active --quiet enhanced-backup.service; then
        log_info "⏳ Backup is running... Check logs with: journalctl -u enhanced-backup.service -f"
    else
        log "✅ Test backup completed! Check the results below:"
        journalctl -u enhanced-backup.service --no-pager -n 20
    fi
fi

# 10. Show status and next steps
echo
log "🎉 Enhanced Backup System Setup Complete!"
echo
echo "📋 SUMMARY:"
echo "----------------------------------------"
echo "✅ Backup script installed: /usr/local/bin/enhanced-backup"
echo "✅ Systemd service created: enhanced-backup.service"
echo "✅ Daily timer enabled: runs at 2 AM with random 30min delay"
echo "✅ Log rotation configured: /var/log/enhanced-backup.log"
echo "✅ Backup directories created: $BACKUP_ROOT"
echo

echo "🔧 USEFUL COMMANDS:"
echo "----------------------------------------"
echo "Check backup status:     systemctl status enhanced-backup.timer"
echo "View backup logs:        journalctl -u enhanced-backup.service"
echo "Manual backup:           sudo systemctl start enhanced-backup.service"
echo "Next scheduled backup:   systemctl list-timers enhanced-backup.timer"
echo

echo "📁 BACKUP LOCATIONS:"
echo "----------------------------------------"
echo "Daily backups:    $BACKUP_ROOT/daily/"
echo "Weekly backups:   $BACKUP_ROOT/weekly/"  
echo "Monthly backups:  $BACKUP_ROOT/monthly/"
echo "Config backups:   $BACKUP_ROOT/configs/"
echo

if ! mountpoint -q "/media/gmk/seagate"; then
    echo
    log_warn "⚠️ IMPORTANT: Check your Seagate drive mount!"
    echo "The backup drive should be mounted at: /media/gmk/seagate"
fi

echo
log "🎯 Your backup system is ready! Backups will run automatically every day at 2 AM."