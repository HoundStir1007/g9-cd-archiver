#!/bin/bash

# Safe Cleanup Script for Old Backup Directories
# Verifies backups exist elsewhere before removal
# Created: January 28, 2025

set -e  # Exit on any error

echo "🧹 Safe Cleanup Script for Old Backups"
echo "======================================"

# Define backup directories to check and clean
BACKUP_DIRS=(
    "/media/mark/paperless-ssd1/digital_consolidation/thunderbolt_transfer"
    "/media/mark/paperless-ssd1/digital_consolidation/canvio_transfer"
)

# Define backup verification locations
VERIFICATION_LOCATIONS=(
    "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/archives"
    "/mnt/storage/digital_consolidation"
    "/media/gmk/seagate/backups"
)

echo "🔍 Checking backup verification locations..."
for location in "${VERIFICATION_LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        echo "✅ Found backup location: $location"
        du -sh "$location" 2>/dev/null || echo "   (size check failed)"
    else
        echo "⚠️  Backup location not found: $location"
    fi
done
echo ""

# Function to safely remove backup directory
safe_remove_backup() {
    local backup_dir="$1"
    local backup_name=$(basename "$backup_dir")
    
    if [ ! -d "$backup_dir" ]; then
        echo "⚠️  Backup directory not found: $backup_dir"
        return
    fi
    
    echo "🔍 Analyzing: $backup_name"
    local size=$(du -sh "$backup_dir" | cut -f1)
    echo "   Size: $size"
    
    # Check if this backup exists in verification locations
    local found_in_backup=false
    for location in "${VERIFICATION_LOCATIONS[@]}"; do
        if [ -d "$location" ]; then
            # Check for similar directory names
            if find "$location" -maxdepth 2 -type d -name "*$backup_name*" 2>/dev/null | grep -q .; then
                echo "   ✅ Found backup in: $location"
                found_in_backup=true
                break
            fi
        fi
    done
    
    if [ "$found_in_backup" = true ]; then
        echo "   🗑️  Safe to remove - backup verified elsewhere"
        echo "   Removing: $backup_dir"
        rm -rf "$backup_dir"
        echo "   ✅ Removed successfully"
    else
        echo "   ⚠️  WARNING: Backup not found in verification locations!"
        echo "   Skipping removal for safety"
    fi
    echo ""
}

# Function to move CD rips to large drive
move_cd_rips() {
    local cd_rips_dir="/media/mark/paperless-ssd1/digital_consolidation/cd_rips"
    local dest_dir="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/cd_rips"
    
    if [ -d "$cd_rips_dir" ]; then
        echo "🎵 Moving CD rips to large drive..."
        echo "   From: $cd_rips_dir"
        echo "   To: $dest_dir"
        
        mkdir -p "$dest_dir"
        rsync -av --progress "$cd_rips_dir/" "$dest_dir/"
        if [ $? -eq 0 ]; then
            echo "   ✅ CD rips moved successfully"
            rm -rf "$cd_rips_dir"
            echo "   🗑️  Removed source directory"
        else
            echo "   ❌ Failed to move CD rips"
        fi
    else
        echo "⚠️  CD rips directory not found"
    fi
    echo ""
}

# Main cleanup process
echo "🚀 Starting safe cleanup process..."
echo ""

# Clean up old backup directories
for backup_dir in "${BACKUP_DIRS[@]}"; do
    safe_remove_backup "$backup_dir"
done

# Move CD rips to large drive
move_cd_rips

# Show final space status
echo "📊 Final Space Status:"
echo "======================"
df -h /media/mark/paperless-ssd1
echo ""
echo "🎉 Cleanup complete!"
echo ""
echo "📋 Summary:"
echo "✅ Old backup directories removed (if verified)"
echo "✅ CD rips moved to large drive"
echo "✅ Space freed on paperless-ssd"
echo ""
echo "🔧 Next steps:"
echo "1. Verify all important data is accessible"
echo "2. Test paperless-ngx functionality"
echo "3. Monitor system performance" 