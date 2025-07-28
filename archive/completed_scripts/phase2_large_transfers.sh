#!/bin/bash

# 🚀 PHASE 2: LARGE TRANSFERS MIGRATION
# Moves Thunderbolt (701GB) and Canvio (312GB) transfers for massive space savings

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

# Log file
LOG_FILE="/home/mark/Desktop/home_server_research/phase2_migration_log_$(date +%Y%m%d_%H%M%S).log"

echo -e "${CYAN}🚀 PHASE 2: LARGE TRANSFERS MIGRATION${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to get directory size
get_size() {
    local path="$1"
    du -sh "$path" 2>/dev/null | cut -f1 || echo "0B"
}

# Pre-flight checks
echo -e "${BLUE}🔍 PRE-FLIGHT CHECKS${NC}"
echo "=========================="

# Check available space
storage_available=$(df -h "$STORAGE_DRIVE" | tail -1 | awk '{print $4}')
paperless_available=$(df -h "$PAPERLESS_SSD" | tail -1 | awk '{print $4}')

echo -e "${GREEN}✅ Storage drive available: $storage_available${NC}"
echo -e "${YELLOW}⚠️ Paperless-SSD available: $paperless_available${NC}"
echo ""

# Show current disk usage
echo -e "${BLUE}📊 CURRENT DISK USAGE${NC}"
echo "========================"
df -h | grep -E "(Filesystem|/dev/)" | while read line; do
    echo "  $line"
done
echo ""

# Show transfer targets
echo -e "${BLUE}🎯 TRANSFER TARGETS${NC}"
echo "====================="
thunderbolt_size=$(get_size "$PAPERLESS_SSD/digital_consolidation/thunderbolt_transfer")
canvio_size=$(get_size "$PAPERLESS_SSD/digital_consolidation/canvio_transfer")

echo -e "${YELLOW}📁 Thunderbolt Transfer: $thunderbolt_size${NC}"
echo -e "${YELLOW}📁 Canvio Transfer: $canvio_size${NC}"
echo -e "${CYAN}📊 Total to transfer: ~1TB+${NC}"
echo ""

# Confirm before starting
echo -e "${YELLOW}⚠️ This will transfer over 1TB of data${NC}"
echo -e "${YELLOW}⚠️ Estimated time: 30-60 minutes${NC}"
read -p "🚀 Start Phase 2 large transfers? (yes/NO): " confirm
if [[ $confirm != "yes" ]]; then
    echo -e "${RED}❌ Phase 2 cancelled${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🚀 STARTING PHASE 2: LARGE TRANSFERS${NC}"
echo "============================================="
echo ""

# PHASE 2A: THUNDERBOLT TRANSFER (701GB)
echo -e "${YELLOW}📁 PHASE 2A: THUNDERBOLT TRANSFER${NC}"
echo "=========================================="

thunderbolt_path="$PAPERLESS_SSD/digital_consolidation/thunderbolt_transfer"
if [ -d "$thunderbolt_path" ]; then
    thunderbolt_size=$(get_size "$thunderbolt_path")
    echo -e "${CYAN}📋 Moving Thunderbolt transfer ($thunderbolt_size)...${NC}"
    log_message "Starting Thunderbolt transfer: $thunderbolt_size"
    
    # Start transfer with progress monitoring
    rsync -avh --progress "$thunderbolt_path/" "$STORAGE_DRIVE/archives/thunderbolt_transfer/" 2>&1 | tee -a "$LOG_FILE" &
    THUNDERBOLT_PID=$!
    
    echo -e "${GREEN}✅ Thunderbolt transfer started (PID: $THUNDERBOLT_PID)${NC}"
    echo -e "${CYAN}📊 Monitor progress with: tail -f $LOG_FILE${NC}"
else
    echo -e "${RED}❌ Thunderbolt transfer directory not found${NC}"
fi

echo ""

# PHASE 2B: CANVIO TRANSFER (312GB)
echo -e "${YELLOW}📁 PHASE 2B: CANVIO TRANSFER${NC}"
echo "====================================="

canvio_path="$PAPERLESS_SSD/digital_consolidation/canvio_transfer"
if [ -d "$canvio_path" ]; then
    canvio_size=$(get_size "$canvio_path")
    echo -e "${CYAN}📋 Moving Canvio transfer ($canvio_size)...${NC}"
    log_message "Starting Canvio transfer: $canvio_size"
    
    # Start transfer with progress monitoring
    rsync -avh --progress "$canvio_path/" "$STORAGE_DRIVE/archives/canvio_transfer/" 2>&1 | tee -a "$LOG_FILE" &
    CANVIO_PID=$!
    
    echo -e "${GREEN}✅ Canvio transfer started (PID: $CANVIO_PID)${NC}"
    echo -e "${CYAN}📊 Monitor progress with: tail -f $LOG_FILE${NC}"
else
    echo -e "${RED}❌ Canvio transfer directory not found${NC}"
fi

echo ""
echo -e "${GREEN}🎉 PHASE 2 TRANSFERS STARTED!${NC}"
echo "====================================="
echo ""
echo -e "${CYAN}📋 TRANSFER STATUS:${NC}"
echo "  • Thunderbolt: PID $THUNDERBOLT_PID"
echo "  • Canvio: PID $CANVIO_PID"
echo ""
echo -e "${YELLOW}📊 MONITORING COMMANDS:${NC}"
echo "  • Check progress: tail -f $LOG_FILE"
echo "  • Check disk usage: df -h"
echo "  • Check processes: ps aux | grep rsync"
echo ""
echo -e "${BLUE}📝 Log file: $LOG_FILE${NC}"
echo ""
echo -e "${GREEN}🚀 Transfers running in background...${NC}" 