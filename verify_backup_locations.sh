#!/bin/bash

# Backup Verification Script
# Checks if old backup data exists in safe locations
# Created: January 28, 2025

echo "🔍 Backup Verification Script"
echo "============================"

# Define backup directories to check
BACKUP_DIRS=(
    "thunderbolt_transfer"
    "canvio_transfer"
)

# Define backup verification locations
VERIFICATION_LOCATIONS=(
    "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/archives"
    "/mnt/storage/digital_consolidation"
    "/media/gmk/seagate/backups"
)

echo "📊 Checking backup verification locations..."
echo ""

for location in "${VERIFICATION_LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        echo "✅ Found backup location: $location"
        local_size=$(du -sh "$location" 2>/dev/null || echo "unknown")
        echo "   Size: $local_size"
        
        # List subdirectories
        echo "   Contents:"
        find "$location" -maxdepth 2 -type d 2>/dev/null | head -10 | while read -r dir; do
            if [ "$dir" != "$location" ]; then
                echo "     - $(basename "$dir")"
            fi
        done
        echo ""
    else
        echo "⚠️  Backup location not found: $location"
        echo ""
    fi
done

echo "🔍 Checking for specific backup directories..."
echo ""

for backup_name in "${BACKUP_DIRS[@]}"; do
    echo "Looking for: $backup_name"
    found=false
    
    for location in "${VERIFICATION_LOCATIONS[@]}"; do
        if [ -d "$location" ]; then
            # Check for exact match
            if [ -d "$location/$backup_name" ]; then
                echo "   ✅ Found exact match in: $location"
                local_size=$(du -sh "$location/$backup_name" 2>/dev/null || echo "unknown")
                echo "   Size: $local_size"
                found=true
            fi
            
            # Check for similar names
            similar_dirs=$(find "$location" -maxdepth 2 -type d -name "*$backup_name*" 2>/dev/null)
            if [ -n "$similar_dirs" ]; then
                echo "   🔍 Found similar directories in: $location"
                echo "$similar_dirs" | while read -r dir; do
                    if [ "$dir" != "$location" ]; then
                        echo "     - $(basename "$dir")"
                    fi
                done
                found=true
            fi
        fi
    done
    
    if [ "$found" = false ]; then
        echo "   ⚠️  WARNING: $backup_name not found in any backup location!"
    fi
    echo ""
done

echo "📋 Verification Summary:"
echo "======================="
echo "✅ This script checks if old backup data exists in safe locations"
echo "✅ Only proceed with cleanup if backups are verified elsewhere"
echo "✅ The cleanup script will skip removal if backups aren't found"
echo ""
echo "🔧 Next steps:"
echo "1. Review the verification results above"
echo "2. If backups are confirmed, run cleanup_old_backups.sh"
echo "3. If backups are missing, investigate before cleanup" 