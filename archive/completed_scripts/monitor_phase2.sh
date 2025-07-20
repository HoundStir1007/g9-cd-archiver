#!/bin/bash

# 📊 PHASE 2 TRANSFER MONITOR
# Monitors the large Thunderbolt and Canvio transfers

echo "📊 PHASE 2 TRANSFER MONITOR"
echo "==========================="
echo ""

while true; do
    clear
    echo "📊 PHASE 2 TRANSFER MONITOR - $(date)"
    echo "=========================================="
    echo ""
    
    # Show disk usage
    echo "💾 CURRENT DISK USAGE:"
    df -h | grep -E "(Filesystem|/dev/)" | while read line; do
        echo "  $line"
    done
    echo ""
    
    # Show transfer progress
    echo "🔄 ACTIVE TRANSFERS:"
    rsync_count=$(ps aux | grep rsync | grep -v grep | wc -l)
    echo "  Active rsync processes: $rsync_count"
    
    if [ $rsync_count -gt 0 ]; then
        echo ""
        echo "📋 TRANSFER DETAILS:"
        ps aux | grep rsync | grep -v grep | while read line; do
            pid=$(echo "$line" | awk '{print $2}')
            cpu=$(echo "$line" | awk '{print $3}')
            cmd=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf $i" "; print ""}')
            echo "  PID $pid (CPU: ${cpu}%) - $cmd"
        done
    fi
    echo ""
    
    # Show storage drive usage
    echo "📁 STORAGE DRIVE CONTENTS:"
    if [ -d "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb/archives" ]; then
        du -sh /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb/archives/* 2>/dev/null | while read size path; do
            echo "  $size - $path"
        done
    fi
    echo ""
    
    # Show recent log entries
    echo "📝 RECENT TRANSFER LOG:"
    if [ -f "phase2_migration_log_20250719_193322.log" ]; then
        tail -3 phase2_migration_log_20250719_193322.log | while read line; do
            echo "  $line"
        done
    fi
    echo ""
    
    # Calculate progress
    echo "📈 PROGRESS ESTIMATE:"
    storage_used=$(df -h /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb | tail -1 | awk '{print $3}')
    echo "  Storage drive used: $storage_used"
    echo "  Target: ~1TB+ total transfer"
    echo ""
    
    echo "🔄 Refreshing in 15 seconds... (Ctrl+C to stop)"
    sleep 15
done 