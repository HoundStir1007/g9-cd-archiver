#!/bin/bash

echo "🚀 CANVIO TRANSFER RESUME MONITOR"
echo "================================="
echo ""

DEST="/mnt/paperless-ssd/digital_consolidation/canvio_transfer"

while true; do
    clear
    echo "🚀 CANVIO TRANSFER RESUME MONITOR - $(date)"
    echo "================================="
    echo ""
    
    echo "📊 CURRENT PROGRESS:"
    echo ""
    
    # Photos to Import
    PHOTOS_COUNT=$(find "$DEST/photos_to_import" -type f 2>/dev/null | wc -l)
    PHOTOS_SIZE=$(du -sh "$DEST/photos_to_import" 2>/dev/null | cut -f1)
    echo "📸 Photos to Import: $PHOTOS_COUNT files ($PHOTOS_SIZE) - Target: 30,181 files"
    PHOTOS_PERCENT=$((PHOTOS_COUNT * 100 / 30181))
    echo "   Progress: $PHOTOS_PERCENT%"
    echo ""
    
    # iPhoto Library  
    IPHOTO_COUNT=$(find "$DEST/iphoto_library" -type f 2>/dev/null | wc -l)
    IPHOTO_SIZE=$(du -sh "$DEST/iphoto_library" 2>/dev/null | cut -f1)
    echo "📱 iPhoto Library: $IPHOTO_COUNT files ($IPHOTO_SIZE) - Target: 121,472 files"
    IPHOTO_PERCENT=$((IPHOTO_COUNT * 100 / 121472))
    echo "   Progress: $IPHOTO_PERCENT%"
    echo ""
    
    # Save for Migration
    SAVE_COUNT=$(find "$DEST/save_for_migration" -type f 2>/dev/null | wc -l)
    SAVE_SIZE=$(du -sh "$DEST/save_for_migration" 2>/dev/null | cut -f1)
    echo "💾 Save for Migration: $SAVE_COUNT files ($SAVE_SIZE) - Target: 24,593 files"
    SAVE_PERCENT=$((SAVE_COUNT * 100 / 24593))
    echo "   Progress: $SAVE_PERCENT%"
    echo ""
    
    # Total progress
    TOTAL_SIZE=$(du -sh "$DEST" 2>/dev/null | cut -f1)
    echo "📁 Total Transferred: $TOTAL_SIZE"
    echo ""
    
    # Active processes
    RSYNC_COUNT=$(ps aux | grep rsync | grep -v grep | wc -l)
    echo "⚡ Active rsync processes: $RSYNC_COUNT"
    echo ""
    
    # Storage space
    AVAILABLE=$(df -h /mnt/paperless-ssd | tail -1 | awk '{print $4}')
    echo "💽 Available space: $AVAILABLE"
    echo ""
    
    if [ $RSYNC_COUNT -eq 0 ]; then
        echo "🎉 ALL TRANSFERS COMPLETED!"
        break
    fi
    
    echo "Press Ctrl+C to stop monitoring..."
    sleep 30
done 