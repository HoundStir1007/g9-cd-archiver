#!/bin/bash

# 🚀 EMERGENCY STORAGE MIGRATION SCRIPT
# Provides immediate relief for critical drives and optimizes storage layout

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
STORAGE_DRIVE="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb"
PAPERLESS_SSD="/media/mark/paperless-ssd"
ROOT_DRIVE="/"

# Log file
LOG_FILE="/home/mark/Desktop/home_server_research/migration_log_$(date +%Y%m%d_%H%M%S).log"

echo -e "${CYAN}🚀 EMERGENCY STORAGE MIGRATION SCRIPT${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check available space
check_space() {
    local path="$1"
    local available=$(df -h "$path" | tail -1 | awk '{print $4}')
    echo "$available"
}

# Function to get directory size
get_size() {
    local path="$1"
    du -sh "$path" 2>/dev/null | cut -f1 || echo "0B"
}

# Pre-flight checks
echo -e "${BLUE}🔍 PRE-FLIGHT CHECKS${NC}"
echo "=========================="

# Check if storage drive is mounted
if [ ! -d "$STORAGE_DRIVE" ]; then
    echo -e "${RED}❌ Storage drive not found at $STORAGE_DRIVE${NC}"
    exit 1
fi

# Check available space
storage_available=$(check_space "$STORAGE_DRIVE")
paperless_available=$(check_space "$PAPERLESS_SSD")
root_available=$(check_space "$ROOT_DRIVE")

echo -e "${GREEN}✅ Storage drive available: $storage_available${NC}"
echo -e "${YELLOW}⚠️ Paperless-SSD available: $paperless_available${NC}"
echo -e "${RED}🚨 Root drive available: $root_available${NC}"
echo ""

# Show current disk usage
echo -e "${BLUE}📊 CURRENT DISK USAGE${NC}"
echo "========================"
df -h | grep -E "(Filesystem|/dev/)" | while read line; do
    echo "  $line"
done
echo ""

# Create organized structure on storage drive
echo -e "${BLUE}📁 CREATING ORGANIZED STRUCTURE${NC}"
echo "=================================="

# Create directories with sudo and change ownership
sudo mkdir -p "$STORAGE_DRIVE"/{media,backups,archives,logs,cache}
sudo mkdir -p "$STORAGE_DRIVE/media"/{cd_rips,dvd_rips,jellyfin,home_videos}
sudo mkdir -p "$STORAGE_DRIVE/archives"/{thunderbolt_transfer,canvio_transfer,digital_consolidation}
sudo mkdir -p "$STORAGE_DRIVE/backups"/{system,documents,vm_images}

# Change ownership to mark user
sudo chown -R mark:mark "$STORAGE_DRIVE"/{media,backups,archives,logs,cache}

echo -e "${GREEN}✅ Directory structure created and ownership set${NC}"
echo ""

# PHASE 1: EMERGENCY ROOT DRIVE RELIEF
echo -e "${YELLOW}🚨 PHASE 1: EMERGENCY ROOT DRIVE RELIEF${NC}"
echo "================================================"

# Move system logs (if large)
log_size=$(get_size "/var/log")
if [ "$log_size" != "0B" ] && [ "$log_size" != "0" ]; then
    echo -e "${CYAN}📋 Moving system logs ($log_size)...${NC}"
    log_message "Moving system logs: $log_size"
    
    sudo rsync -avh --progress /var/log/ "$STORAGE_DRIVE/logs/system_logs/" 2>&1 | tee -a "$LOG_FILE"
    sudo find /var/log -type f -name "*.log" -size +1M -delete 2>/dev/null || true
    
    echo -e "${GREEN}✅ System logs moved${NC}"
else
    echo -e "${BLUE}ℹ️ System logs already small or empty${NC}"
fi

# Move system cache
cache_size=$(get_size "/var/cache")
if [ "$cache_size" != "0B" ] && [ "$cache_size" != "0" ]; then
    echo -e "${CYAN}📋 Moving system cache ($cache_size)...${NC}"
    log_message "Moving system cache: $cache_size"
    
    sudo rsync -avh --progress /var/cache/ "$STORAGE_DRIVE/cache/system_cache/" 2>&1 | tee -a "$LOG_FILE"
    sudo find /var/cache -type f -size +10M -delete 2>/dev/null || true
    
    echo -e "${GREEN}✅ System cache moved${NC}"
else
    echo -e "${BLUE}ℹ️ System cache already small or empty${NC}"
fi

# Clean up apt cache
echo -e "${CYAN}🧹 Cleaning apt cache...${NC}"
sudo apt clean 2>&1 | tee -a "$LOG_FILE"
sudo apt autoclean 2>&1 | tee -a "$LOG_FILE"

echo -e "${GREEN}✅ Root drive emergency relief completed${NC}"
echo ""

# PHASE 2: PAPERLESS-SSD EMERGENCY RELIEF
echo -e "${YELLOW}🚨 PHASE 2: PAPERLESS-SSD EMERGENCY RELIEF${NC}"
echo "================================================="

# Move CD rips (18GB)
cd_rips_path="$PAPERLESS_SSD/digital_consolidation/cd_rips"
if [ -d "$cd_rips_path" ]; then
    cd_rips_size=$(get_size "$cd_rips_path")
    echo -e "${CYAN}📀 Moving CD rips ($cd_rips_size)...${NC}"
    log_message "Moving CD rips: $cd_rips_size"
    
    rsync -avh --progress "$cd_rips_path/" "$STORAGE_DRIVE/media/cd_rips/" 2>&1 | tee -a "$LOG_FILE"
    
    # Verify transfer
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ CD rips moved successfully${NC}"
        # Remove original after successful transfer
        rm -rf "$cd_rips_path"
        echo -e "${GREEN}✅ Original CD rips removed${NC}"
    else
        echo -e "${RED}❌ CD rips transfer failed${NC}"
    fi
else
    echo -e "${BLUE}ℹ️ CD rips directory not found${NC}"
fi

# Move DVD rips if they exist
dvd_rips_path="$PAPERLESS_SSD/digital_consolidation/dvd_rips"
if [ -d "$dvd_rips_path" ]; then
    dvd_rips_size=$(get_size "$dvd_rips_path")
    echo -e "${CYAN}📀 Moving DVD rips ($dvd_rips_size)...${NC}"
    log_message "Moving DVD rips: $dvd_rips_size"
    
    rsync -avh --progress "$dvd_rips_path/" "$STORAGE_DRIVE/media/dvd_rips/" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ DVD rips moved successfully${NC}"
        rm -rf "$dvd_rips_path"
        echo -e "${GREEN}✅ Original DVD rips removed${NC}"
    else
        echo -e "${RED}❌ DVD rips transfer failed${NC}"
    fi
else
    echo -e "${BLUE}ℹ️ DVD rips directory not found${NC}"
fi

echo -e "${GREEN}✅ Paperless-SSD emergency relief completed${NC}"
echo ""

# PHASE 3: DIGITAL CONSOLIDATION MIGRATION
echo -e "${YELLOW}📦 PHASE 3: DIGITAL CONSOLIDATION MIGRATION${NC}"
echo "====================================================="

# Move Thunderbolt transfer (701GB)
thunderbolt_path="$PAPERLESS_SSD/digital_consolidation/thunderbolt_transfer"
if [ -d "$thunderbolt_path" ]; then
    thunderbolt_size=$(get_size "$thunderbolt_path")
    echo -e "${CYAN}📁 Moving Thunderbolt transfer ($thunderbolt_size)...${NC}"
    log_message "Moving Thunderbolt transfer: $thunderbolt_size"
    
    rsync -avh --progress "$thunderbolt_path/" "$STORAGE_DRIVE/archives/thunderbolt_transfer/" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Thunderbolt transfer moved successfully${NC}"
        # Keep original for now (large transfer, verify first)
        echo -e "${YELLOW}⚠️ Original kept for verification - remove manually after confirming${NC}"
    else
        echo -e "${RED}❌ Thunderbolt transfer failed${NC}"
    fi
else
    echo -e "${BLUE}ℹ️ Thunderbolt transfer directory not found${NC}"
fi

# Move Canvio transfer (312GB)
canvio_path="$PAPERLESS_SSD/digital_consolidation/canvio_transfer"
if [ -d "$canvio_path" ]; then
    canvio_size=$(get_size "$canvio_path")
    echo -e "${CYAN}📁 Moving Canvio transfer ($canvio_size)...${NC}"
    log_message "Moving Canvio transfer: $canvio_size"
    
    rsync -avh --progress "$canvio_path/" "$STORAGE_DRIVE/archives/canvio_transfer/" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Canvio transfer moved successfully${NC}"
        echo -e "${YELLOW}⚠️ Original kept for verification - remove manually after confirming${NC}"
    else
        echo -e "${RED}❌ Canvio transfer failed${NC}"
    fi
else
    echo -e "${BLUE}ℹ️ Canvio transfer directory not found${NC}"
fi

echo -e "${GREEN}✅ Digital consolidation migration completed${NC}"
echo ""

# PHASE 4: FINAL CLEANUP AND OPTIMIZATION
echo -e "${YELLOW}🧹 PHASE 4: FINAL CLEANUP AND OPTIMIZATION${NC}"
echo "=================================================="

# Clean up system files
echo -e "${CYAN}🧹 Cleaning up system files...${NC}"
sudo journalctl --vacuum-time=7d 2>&1 | tee -a "$LOG_FILE"
sudo find /tmp -type f -atime +7 -delete 2>/dev/null || true
sudo find /var/tmp -type f -atime +7 -delete 2>/dev/null || true

# Update Jellyfin configuration if needed
echo -e "${CYAN}🎬 Checking Jellyfin configuration...${NC}"
if [ -f "jellyfin-docker-compose.yml" ]; then
    echo -e "${GREEN}✅ Jellyfin configuration found${NC}"
    echo -e "${YELLOW}💡 Consider updating Jellyfin paths after migration${NC}"
fi

# Final disk usage report
echo ""
echo -e "${BLUE}📊 FINAL DISK USAGE REPORT${NC}"
echo "=============================="
df -h | grep -E "(Filesystem|/dev/)" | while read line; do
    echo "  $line"
done

echo ""
echo -e "${GREEN}🎉 MIGRATION COMPLETED SUCCESSFULLY!${NC}"
echo "====================================="
echo ""
echo -e "${CYAN}📋 SUMMARY:${NC}"
echo "  • Root drive: Emergency relief applied"
echo "  • Paperless-SSD: CD/DVD rips moved to storage drive"
echo "  • Digital consolidation: Large transfers initiated"
echo "  • Storage drive: Organized structure created"
echo ""
echo -e "${YELLOW}⚠️ NEXT STEPS:${NC}"
echo "  1. Verify large transfers completed successfully"
echo "  2. Remove original directories after verification"
echo "  3. Update Jellyfin configuration if needed"
echo "  4. Monitor system performance"
echo ""
echo -e "${BLUE}📝 Log file: $LOG_FILE${NC}" 