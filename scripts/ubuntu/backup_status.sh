#!/bin/bash

# 📊 Backup Status Checker
# Quick status overview of your backup system

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

BACKUP_ROOT="/media/paperless-storage/backups"

# Function to get human readable size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
}

# Function to get file count
get_file_count() {
    find "$1" -type f 2>/dev/null | wc -l || echo "0"
}

# Header
echo -e "${CYAN}🛡️ Enhanced Backup System Status${NC}"
echo -e "${CYAN}=================================${NC}"
echo

# Check if backup drive is mounted
if ! mountpoint -q "$BACKUP_ROOT" 2>/dev/null; then
    echo -e "${RED}❌ ERROR: Backup drive not mounted at $BACKUP_ROOT${NC}"
    echo
    exit 1
fi

echo -e "${GREEN}✅ Backup drive mounted${NC}"

# Show disk usage
echo -e "${BLUE}💾 Backup Drive Space:${NC}"
df -h "$BACKUP_ROOT" | tail -1 | awk '{printf "   Used: %s / %s (%s full)\n   Available: %s\n", $3, $2, $5, $4}'
echo

# Check systemd timer status
echo -e "${BLUE}⏰ Backup Schedule Status:${NC}"
if systemctl is-enabled enhanced-backup.timer >/dev/null 2>&1; then
    echo -e "   ${GREEN}✅ Timer enabled${NC}"
    
    # Get next run time
    NEXT_RUN=$(systemctl status enhanced-backup.timer 2>/dev/null | grep "Trigger:" | awk '{print $2, $3, $4, $5}' || echo "Unknown")
    echo "   Next backup: $NEXT_RUN"
    
    # Check if backup is currently running
    if systemctl is-active enhanced-backup.service >/dev/null 2>&1; then
        echo -e "   ${YELLOW}🔄 Backup currently running${NC}"
    fi
else
    echo -e "   ${RED}❌ Timer not enabled${NC}"
fi
echo

# Show recent backup activity
echo -e "${BLUE}📅 Recent Backup Activity:${NC}"

# Check last backup in logs
LAST_SUCCESS=$(journalctl -u enhanced-backup.service --no-pager -q | grep "Backup completed successfully" | tail -1 | awk '{print $1, $2, $3}' 2>/dev/null || echo "Never")
LAST_FAILURE=$(journalctl -u enhanced-backup.service --no-pager -q | grep "Backup failed" | tail -1 | awk '{print $1, $2, $3}' 2>/dev/null || echo "Never")

echo "   Last successful backup: $LAST_SUCCESS"
if [ "$LAST_FAILURE" != "Never" ]; then
    echo -e "   ${YELLOW}Last failure: $LAST_FAILURE${NC}"
fi
echo

# Show backup inventory
echo -e "${BLUE}📦 Backup Inventory:${NC}"

for backup_type in daily weekly monthly; do
    backup_dir="$BACKUP_ROOT/$backup_type"
    if [ -d "$backup_dir" ]; then
        count=$(find "$backup_dir" -maxdepth 1 -type d -name "*_*" 2>/dev/null | wc -l || echo "0")
        size=$(get_size "$backup_dir")
        
        if [ "$count" -gt 0 ]; then
            echo -e "   ${GREEN}$backup_type:${NC} $count backups ($size)"
            
            # Show most recent backup
            recent=$(find "$backup_dir" -maxdepth 1 -type d -name "*_*" 2>/dev/null | sort | tail -1)
            if [ -n "$recent" ]; then
                recent_name=$(basename "$recent")
                recent_date=${recent_name##*_}
                # Convert date format for display
                if [[ $recent_date =~ ^([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})$ ]]; then
                    formatted_date="${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-${BASH_REMATCH[3]} ${BASH_REMATCH[4]}:${BASH_REMATCH[5]}:${BASH_REMATCH[6]}"
                    recent_size=$(get_size "$recent")
                    echo "      Latest: $formatted_date ($recent_size)"
                fi
            fi
        else
            echo -e "   ${YELLOW}$backup_type:${NC} No backups found"
        fi
    fi
done

# Configuration backups
config_dir="$BACKUP_ROOT/configs"
if [ -d "$config_dir" ]; then
    config_count=$(find "$config_dir" -name "*.tar.gz" 2>/dev/null | wc -l || echo "0")
    config_size=$(get_size "$config_dir")
    echo -e "   ${GREEN}configs:${NC} $config_count backups ($config_size)"
fi

echo

# Data source status
echo -e "${BLUE}📂 Data Source Status:${NC}"

sources=(
    "/mnt/paperless-ssd/paperless:Paperless-ngx Documents"
    "/mnt/paperless-ssd/jellyfin:Jellyfin Media Library"
)

for source_info in "${sources[@]}"; do
    IFS=':' read -r source_path source_name <<< "$source_info"
    
    if [ -d "$source_path" ]; then
        source_size=$(get_size "$source_path")
        source_files=$(get_file_count "$source_path")
        echo -e "   ${GREEN}✅ $source_name:${NC} $source_size ($source_files files)"
    else
        echo -e "   ${RED}❌ $source_name:${NC} Directory not found at $source_path"
    fi
done

echo

# Recent log entries
echo -e "${BLUE}📝 Recent Log Entries:${NC}"
if [ -f "/var/log/enhanced-backup.log" ]; then
    echo "   (Last 5 entries from backup log)"
    tail -5 /var/log/enhanced-backup.log | while read -r line; do
        echo "   $line"
    done
else
    echo "   No backup log file found"
fi

echo

# Health recommendations
echo -e "${BLUE}💡 Recommendations:${NC}"

# Check backup age
if [ -d "$BACKUP_ROOT/daily" ]; then
    latest_daily=$(find "$BACKUP_ROOT/daily" -maxdepth 1 -type d -name "*_*" 2>/dev/null | sort | tail -1)
    if [ -n "$latest_daily" ]; then
        latest_timestamp=$(stat -c %Y "$latest_daily" 2>/dev/null || echo "0")
        current_timestamp=$(date +%s)
        hours_since=$((($current_timestamp - $latest_timestamp) / 3600))
        
        if [ "$hours_since" -gt 25 ]; then
            echo -e "   ${YELLOW}⚠️ Latest backup is $hours_since hours old - check backup system${NC}"
        else
            echo -e "   ${GREEN}✅ Backups are current (last: $hours_since hours ago)${NC}"
        fi
    else
        echo -e "   ${YELLOW}⚠️ No daily backups found - run initial backup${NC}"
    fi
fi

# Check disk space
backup_usage=$(df "$BACKUP_ROOT" | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$backup_usage" -gt 85 ]; then
    echo -e "   ${YELLOW}⚠️ Backup drive is $backup_usage% full - consider cleanup${NC}"
elif [ "$backup_usage" -gt 95 ]; then
    echo -e "   ${RED}❌ Backup drive is $backup_usage% full - cleanup required${NC}"
fi

echo

# Quick commands
echo -e "${CYAN}🔧 Quick Commands:${NC}"
echo "   Manual backup:       sudo systemctl start enhanced-backup.service"
echo "   View live logs:      journalctl -u enhanced-backup.service -f"
echo "   Check timer:         systemctl status enhanced-backup.timer"
echo "   Disable backups:     sudo systemctl stop enhanced-backup.timer"
echo "   Enable backups:      sudo systemctl start enhanced-backup.timer"

echo