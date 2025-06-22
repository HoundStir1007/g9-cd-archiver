#!/bin/bash

# G9-REBORN Bootable USB Creation Script
echo "🚀 G9-REBORN Bootable USB Creation"
echo "================================="

# Wait for Ubuntu ISO to finish downloading
echo "📥 Waiting for Ubuntu ISO download to complete..."
while true; do
    if [[ -f ubuntu-24.04-desktop-amd64.iso ]]; then
        SIZE=$(stat -f%z ubuntu-24.04-desktop-amd64.iso 2>/dev/null)
        if [[ $SIZE -gt 1000000000 ]]; then  # Greater than 1GB = real ISO
            echo "✅ Ubuntu ISO download complete! ($(ls -lh ubuntu-24.04-desktop-amd64.iso | awk '{print $5}'))"
            break
        else
            echo "⏳ Still downloading... (current size: $(ls -lh ubuntu-24.04-desktop-amd64.iso | awk '{print $5}'))"
        fi
    else
        echo "⏳ Download in progress..."
    fi
    sleep 10
done

# Verify USB drive
echo ""
echo "🔍 Verifying USB drive..."
if ! diskutil list | grep -q "UBUNTU"; then
    echo "❌ UBUNTU USB drive not found. Please run:"
    echo "   sudo diskutil eraseDisk FAT32 UBUNTU MBRFormat /dev/disk2"
    exit 1
fi

echo "✅ UBUNTU USB drive found"

# Unmount USB before writing
echo "📤 Unmounting USB drive..."
sudo diskutil unmountDisk /dev/disk2

# Write ISO to USB (this takes 10-15 minutes)
echo ""
echo "💾 Writing Ubuntu ISO to USB drive..."
echo "⚠️  This will take 10-15 minutes - DO NOT INTERRUPT!"
echo ""
sudo dd if=ubuntu-24.04-desktop-amd64.iso of=/dev/rdisk2 bs=1m status=progress

# Verify completion
echo ""
echo "🔍 Verifying USB drive creation..."
sudo diskutil eject /dev/disk2

echo ""
echo "🎉 G9-REBORN BOOTABLE USB CREATED SUCCESSFULLY!"
echo ""
echo "🎯 NEXT STEPS:"
echo "1. 🔌 Insert USB into G9"
echo "2. ⚡ Power on G9"
echo "3. 🔧 Press F9 for boot menu"
echo "4. 💿 Select USB drive"
echo "5. 🚀 Choose 'Try or Install Ubuntu'"
echo "6. 💻 Run G9-Reborn setup script from USB"
echo ""
echo "🌟 Ready for G9-REBORN TRANSFORMATION! 🌟" 