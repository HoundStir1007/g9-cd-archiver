#!/bin/bash

# ANALYZE CURRENT G9 SETUP - Before Nuclear Rebuild
echo "🔍 ANALYZING CURRENT G9 SETUP"
echo "Checking drives, Windows license, and optimal configuration options"
echo ""

# 1. Current disk layout
echo "💾 CURRENT DISK LAYOUT:"
echo "========================"
lsblk -f
echo ""

# 2. Detailed partition information
echo "🗂️ PARTITION DETAILS:"
echo "====================="
sudo fdisk -l | grep -E "(Disk|Windows|Microsoft|NTFS|FAT)" || sudo fdisk -l

echo ""

# 3. Check for Windows EFI entries
echo "🪟 WINDOWS BOOT ENTRIES:"
echo "========================"
if [ -d /sys/firmware/efi ]; then
    echo "EFI system detected"
    sudo efibootmgr | grep -i windows || echo "No Windows boot entries found"
else
    echo "Legacy BIOS system"
fi

echo ""

# 4. Current Ubuntu installation details
echo "🐧 UBUNTU INSTALLATION:"
echo "======================="
echo "OS Version: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Install Date: $(ls -lact /var/log/installer/ 2>/dev/null | tail -1 | awk '{print $6, $7, $8}' || echo "Unknown")"

echo ""

# 5. Current storage usage
echo "📊 STORAGE USAGE:"
echo "================"
df -h | grep -E "(Filesystem|/dev/)"

echo ""

# 6. Check if Windows partition exists and is accessible
echo "🔍 WINDOWS PARTITION CHECK:"
echo "==========================="
WINDOWS_PARTITIONS=$(sudo blkid | grep -i ntfs || echo "No NTFS partitions found")
echo "$WINDOWS_PARTITIONS"

if echo "$WINDOWS_PARTITIONS" | grep -q ntfs; then
    echo ""
    echo "🎯 WINDOWS PARTITION FOUND!"
    echo "Attempting to mount and check license..."
    
    # Try to mount Windows partition temporarily
    WINDOWS_PART=$(echo "$WINDOWS_PARTITIONS" | head -1 | cut -d: -f1)
    sudo mkdir -p /mnt/windows_temp
    if sudo mount -t ntfs-3g "$WINDOWS_PART" /mnt/windows_temp 2>/dev/null; then
        echo "Windows partition mounted successfully"
        
        # Check Windows version
        if [ -f /mnt/windows_temp/Windows/System32/config/SOFTWARE ]; then
            echo "Windows system files detected"
        fi
        
        # Check for OEM license info
        if [ -d /mnt/windows_temp/Windows/System32/oem ]; then
            echo "OEM directory found - likely came with pre-installed Windows"
        fi
        
        sudo umount /mnt/windows_temp 2>/dev/null
        sudo rmdir /mnt/windows_temp 2>/dev/null
    else
        echo "Could not mount Windows partition (might be BitLocker encrypted)"
    fi
fi

echo ""

# 7. Hardware info for license verification
echo "🖥️ HARDWARE INFO (for license verification):"
echo "============================================="
echo "Motherboard: $(sudo dmidecode -s baseboard-manufacturer) $(sudo dmidecode -s baseboard-product-name)"
echo "System: $(sudo dmidecode -s system-manufacturer) $(sudo dmidecode -s system-product-name)"
echo "Serial: $(sudo dmidecode -s system-serial-number)"

echo ""

# 8. Current service status
echo "⚙️ CURRENT UBUNTU SERVICES:"
echo "============================"
systemctl status lightdm --no-pager -l | head -3
systemctl status xrdp --no-pager -l | head -3
systemctl status ssh --no-pager -l | head -3

echo ""
echo "🎯 ANALYSIS COMPLETE!"
echo ""
echo "📋 RECOMMENDATIONS:"
echo "==================="
echo ""
echo "🔥 NUCLEAR OPTION BENEFITS:"
echo "   ✅ Complete fresh Ubuntu install on new 4TB SSD"
echo "   ✅ Preserve Windows partition untouched"
echo "   ✅ Clean slate for optimal configuration"
echo "   ✅ Move current Ubuntu data to external storage"
echo ""
echo "⚠️ WINDOWS LICENSE STATUS:"
if echo "$WINDOWS_PARTITIONS" | grep -q ntfs; then
    echo "   ✅ Windows partition detected - license likely tied to hardware"
    echo "   ✅ Can probably reinstall Windows on this G9 anytime"
    echo "   ✅ Recommend backing up Windows partition before major changes"
else
    echo "   ❓ No Windows partition found - check other drives"
fi

echo ""
echo "🚀 PROPOSED OPTIMAL SETUP:"
echo "=========================="
echo "1. 📀 Original drive: Keep Windows partition untouched"
echo "2. 💾 4TB M.2 SSD: Fresh Ubuntu 24.04 LTS install"
echo "3. 🗄️ 2TB SSD: Data storage and backup"
echo "4. 🔄 Migrate current Ubuntu data to data drive"
echo "5. ⚡ Set Ubuntu as primary boot, Windows as secondary"
echo ""
echo "🎯 Ready to proceed with nuclear Ubuntu reinstall while preserving Windows?" 