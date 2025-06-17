# 🛡️ Enhanced Backup System - Deployment Guide

## Quick Start (15 minutes to full backup protection!) 🚀

### 1. Transfer Files to Ubuntu Server
```bash
# On your MacBook, copy files to the Ubuntu server
scp scripts/ubuntu/enhanced_backup.sh gmk@100.91.157.19:~/
scp scripts/ubuntu/setup_backup_automation.sh gmk@100.91.157.19:~/  
scp scripts/ubuntu/backup_status.sh gmk@100.91.157.19:~/
```

### 2. Install and Configure (On Ubuntu Server)
```bash
# SSH into your Ubuntu server
ssh gmk@100.91.157.19

# Make scripts executable
chmod +x enhanced_backup.sh setup_backup_automation.sh backup_status.sh

# Run the setup (installs everything automatically)
sudo ./setup_backup_automation.sh

# Test the status checker
./backup_status.sh
```

## What You Get 🎯

### ✅ **Automated Daily Backups**
- **Runs at 2 AM** every night (with random 30-minute delay)
- **Incremental backups** - only changes are copied (fast + space efficient)
- **Multiple retention periods**:
  - 7 daily backups
  - 4 weekly backups (every Sunday)
  - 12 monthly backups (1st of month)

### ✅ **What Gets Backed Up**
- **Paperless-ngx documents** - All your scanned documents and metadata
- **Jellyfin media library** - Your entire media collection
- **System configurations** - Docker configs, network settings, package lists
- **User data** - Cron jobs, application settings

### ✅ **Smart Features**
- **Space management** - Automatically removes old backups
- **Verification** - Checks backup integrity after each run
- **Progress reporting** - Shows what's being copied
- **Error handling** - Robust error recovery and logging
- **Email notifications** - Success/failure alerts (when configured)

## Using Your New Backup System 📋

### **Check Backup Status**
```bash
./backup_status.sh
```
**Shows:** Last backup time, disk usage, backup inventory, health status

### **Manual Backup (if needed)**
```bash
sudo systemctl start enhanced-backup.service
```

### **Watch Live Backup Progress**
```bash
journalctl -u enhanced-backup.service -f
```

### **Check Backup Schedule**
```bash
systemctl status enhanced-backup.timer
```

## Backup Locations 📁

Your backups are stored in: `/media/paperless-storage/backups/`

```
backups/
├── daily/          # 7 most recent daily backups
│   ├── paperless_20241227_020000/
│   ├── jellyfin_20241227_020000/
│   └── ...
├── weekly/         # 4 most recent Sunday backups  
├── monthly/        # 12 most recent 1st-of-month backups
└── configs/        # System configuration archives
    ├── config_backup_20241227_020000.tar.gz
    └── ...
```

## Recovery Examples 🔧

### **Restore Single Document**
```bash
# Find the file in backup
find /media/paperless-storage/backups/daily/paperless_*/media/ -name "*invoice*"

# Copy back to Paperless-ngx
cp /path/to/backup/file /mnt/paperless-ssd/paperless/media/
```

### **Full Paperless-ngx Restore**
```bash
# Stop Paperless-ngx
cd /path/to/paperless/docker-compose
docker-compose down

# Restore from most recent backup
latest_backup=$(find /media/paperless-storage/backups -name "paperless_*" | sort | tail -1)
rsync -av "$latest_backup/" /mnt/paperless-ssd/paperless/

# Restart Paperless-ngx
docker-compose up -d
```

### **System Configuration Restore**
```bash
# Extract configuration backup
cd /tmp
tar -xzf /media/paperless-storage/backups/configs/config_backup_20241227_020000.tar.gz

# Review and selectively restore configs as needed
```

## Monitoring & Maintenance 📊

### **Weekly Health Check**
Run `./backup_status.sh` once a week to verify:
- ✅ Backups are running automatically
- ✅ Sufficient disk space available
- ✅ No recent backup failures

### **Monthly Cleanup (if needed)**
The system automatically manages retention, but you can manually clean up if needed:
```bash
# Check disk usage
df -h /media/paperless-storage

# Remove old backups manually (if really needed)
rm -rf /media/paperless-storage/backups/daily/oldest_backup_folder
```

### **Backup Drive Maintenance**
- **Check drive health** occasionally with `sudo smartctl -a /dev/sdX`
- **Keep drive connected** and mounted for automatic backups
- **Consider drive replacement** every 3-5 years

## Advanced Features 🚀

### **Email Notifications Setup**
To enable backup notifications:
```bash
# Configure email settings (integrate with existing Tailscale monitoring)
echo "your_email@gmail.com" > ~/.backup_notifications

# Test notification
echo "Test backup notification" | mail -s "Backup Test" your_email@gmail.com
```

### **Backup to Multiple Locations**
Add cloud backup (Phase 2):
```bash
# Install rclone for cloud backup
sudo apt install rclone

# Configure Google Drive/Dropbox (one-time setup)
rclone config

# Add cloud backup to weekly schedule
# (Would require additional script modification)
```

### **Performance Optimization**
For large media libraries:
```bash
# Exclude certain file types from Jellyfin backup
# Edit enhanced_backup.sh and add to rsync excludes:
--exclude='*.tmp' 
--exclude='*.part'
--exclude='cache/'
```

## Troubleshooting 🔍

### **Backup Drive Not Mounted**
```bash
# Check if drive is connected
lsblk

# Mount manually if needed
sudo mount /dev/sdX1 /media/paperless-storage

# Add to /etc/fstab for automatic mounting
```

### **Backup Failed**
```bash
# Check recent errors
journalctl -u enhanced-backup.service -n 50

# Check disk space
df -h

# Run manual backup with verbose output
sudo /usr/local/bin/enhanced-backup
```

### **Restore Test**
Periodically test restores:
```bash
# Create test restore directory
mkdir -p /tmp/restore_test

# Restore a single file to test location
cp /media/paperless-storage/backups/daily/paperless_*/media/document.pdf /tmp/restore_test/

# Verify file integrity
file /tmp/restore_test/document.pdf
```

## Success Indicators ✅

After deployment, you should see:
- ✅ **Daily automated backups** running at 2 AM
- ✅ **Backup status shows recent activity** (< 24 hours old)
- ✅ **Multiple backup generations** (daily, weekly, monthly)
- ✅ **System configurations included** in backups
- ✅ **Backup verification** passing
- ✅ **Disk space management** working automatically

## Next Steps (Optional Enhancements) 🎯

1. **Cloud Backup Integration** - Add offsite backup to Google Drive/Dropbox
2. **Backup Monitoring Dashboard** - Web interface for backup status
3. **Automated Recovery Testing** - Monthly restore verification
4. **Performance Monitoring** - Track backup duration and data growth
5. **Multi-site Backup** - Backup to second location via Tailscale

---

## 🎉 Congratulations!

You now have a **professional-grade backup system** protecting your digital life:

- **📄 Documents**: All Paperless-ngx content safely backed up
- **🎬 Media**: Jellyfin library protected  
- **⚙️ Configurations**: System settings preserved
- **🔄 Automated**: Runs without your attention
- **📊 Monitored**: Easy status checking
- **🛡️ Reliable**: Multiple backup generations

**Your data is now protected against hardware failure, accidental deletion, and system corruption!** 🛡️✨