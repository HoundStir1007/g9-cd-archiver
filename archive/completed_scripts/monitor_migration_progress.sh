#!/bin/bash

# 📊 MIGRATION PROGRESS MONITOR
# Shows real-time progress of the emergency storage migration

echo "📊 MIGRATION PROGRESS MONITOR"
echo "============================="
echo ""

while true; do
    clear
    echo "📊 MIGRATION PROGRESS MONITOR - $(date)"
    echo "=========================================="
    echo ""
    
    # Show disk usage
    echo "💾 CURRENT DISK USAGE:"
    df -h | grep -E "(Filesystem|/dev/)" | while read line; do
        echo "  $line"
    done
    echo ""
    
    # Show storage drive usage
    echo "📁 STORAGE DRIVE CONTENTS:"
    if [ -d "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb/media" ]; then
        du -sh /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb/media/* 2>/dev/null | while read size path; do
            echo "  $size - $path"
        done
    fi
    echo ""
    
    # Show active rsync processes
    echo "🔄 ACTIVE TRANSFERS:"
    rsync_count=$(ps aux | grep rsync | grep -v grep | wc -l)
    echo "  Active rsync processes: $rsync_count"
    
    if [ $rsync_count -gt 0 ]; then
        ps aux | grep rsync | grep -v grep | while read line; do
            echo "  $line" | awk '{print "    " $11 " " $12 " " $13 " " $14 " " $15}'
        done
    fi
    echo ""
    
    # Show migration script status
    echo "📋 MIGRATION SCRIPT STATUS:"
    if pgrep -f emergency_storage_migration >/dev/null; then
        echo "  ✅ Migration script is running"
    else
        echo "  ❌ Migration script completed or stopped"
    fi
    echo ""
    
    # Show recent log entries
    echo "📝 RECENT LOG ENTRIES:"
    if [ -f "migration_log_20250719_190942.log" ]; then
        tail -3 migration_log_20250719_190942.log | while read line; do
            echo "  $line"
        done
    fi
    echo ""
    
    echo "🔄 Refreshing in 10 seconds... (Ctrl+C to stop)"
    sleep 10
done 