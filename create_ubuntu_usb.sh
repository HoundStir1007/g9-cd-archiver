#!/bin/bash

# 🚀 G9-REBORN Ubuntu USB Creator
# Based on lessons learned from previous successful attempts
# Updated: January 15, 2025

set -e  # Exit on any error

echo "🌟 G9-REBORN Ubuntu USB Creator Starting..."
echo "📀 ISO File: ubuntu-24.04.2-desktop-amd64.iso"
echo ""

# Check if ISO exists
if [ ! -f "ubuntu-24.04.2-desktop-amd64.iso" ]; then
    echo "❌ ERROR: ubuntu-24.04.2-desktop-amd64.iso not found!"
    exit 1
fi

echo "✅ Ubuntu ISO found (6.3GB)"
echo ""

echo "🔍 Current disk layout:"
diskutil list
echo ""

echo "⚠️  CRITICAL: Please connect your USB drive now!"
echo "📋 Requirements:"
echo "   - USB drive 8GB+ (will be completely erased)"
echo "   - USB 3.0+ recommended for speed"
echo ""
read -p "Press ENTER after connecting USB drive..."

echo ""
echo "🔄 Checking for new USB drive..."
diskutil list | grep -E "(external|USB)"

echo ""
echo "🎯 Please identify your USB drive from the list above"
echo "   Example: disk2, disk3, etc."
echo "   ⚠️  WARNING: This drive will be COMPLETELY ERASED!"
echo ""
read -p "Enter USB disk number (just the number, e.g., '2' for disk2): " DISK_NUM

USB_DISK="/dev/disk${DISK_NUM}"
USB_RDISK="/dev/rdisk${DISK_NUM}"

echo ""
echo "📋 USB Drive Selected: $USB_DISK"
echo "🚀 Using raw device: $USB_RDISK (faster writing)"

# Safety confirmation
echo ""
echo "⚠️  FINAL CONFIRMATION:"
echo "   USB Drive: $USB_DISK"
echo "   This will ERASE ALL DATA on this drive!"
echo ""
diskutil info $USB_DISK | grep -E "(Device Node|Media Name|Total Size)"
echo ""
read -p "Type 'YES' to proceed with USB creation: " CONFIRM

if [ "$CONFIRM" != "YES" ]; then
    echo "❌ Cancelled by user"
    exit 1
fi

echo ""
echo "🔧 Starting USB creation process..."

# Step 1: Unmount the USB drive (critical lesson learned)
echo "1️⃣ Unmounting USB drive..."
if diskutil unmountDisk $USB_DISK; then
    echo "✅ USB drive unmounted successfully"
else
    echo "⚠️  Warning: Unmount failed, but continuing..."
fi

# Step 2: Write ISO to USB using raw device (faster)
echo ""
echo "2️⃣ Writing Ubuntu ISO to USB (this takes 10-15 minutes)..."
echo "   Using raw device $USB_RDISK for maximum speed"
echo "   Progress will show periodically..."

# Use dd with proper block size and raw device (lesson learned)
if sudo dd if=ubuntu-24.04.2-desktop-amd64.iso of=$USB_RDISK bs=1m status=progress; then
    echo ""
    echo "✅ ISO write completed successfully!"
else
    echo ""
    echo "❌ ERROR: ISO write failed!"
    exit 1
fi

# Step 3: Sync and cleanup
echo ""
echo "3️⃣ Syncing and finalizing..."
sync
sleep 2

# Step 4: Eject USB safely
echo ""
echo "4️⃣ Ejecting USB drive..."
if diskutil eject $USB_DISK; then
    echo "✅ USB drive ejected successfully"
else
    echo "⚠️  Manual eject recommended"
fi

echo ""
echo "🎉 SUCCESS! Ubuntu USB boot drive created!"
echo ""
echo "📋 Next Steps:"
echo "   1. ✅ USB drive is ready for G9-REBORN boot"
echo "   2. 🔌 Connect USB to G9 server"
echo "   3. ⚡ Boot from USB and continue UUID repair"
echo "   4. 🚀 Complete G9-REBORN transformation!"
echo ""
echo "🎯 Boot the USB and you'll be back in rescue mode to fix those UUID issues!" 