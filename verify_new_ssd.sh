#!/bin/bash

echo "🔍 Verifying 4TB M.2 SSD Installation..."
echo "========================================"

echo ""
echo "📋 All Storage Devices:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

echo ""
echo "🆔 NVMe Devices Specifically:"
ls -la /dev/nvme* 2>/dev/null || echo "No NVMe devices found"

echo ""
echo "💾 Disk Information:"
sudo fdisk -l | grep -E "(Disk /dev|GB|TB)"

echo ""
echo "🌡️ SSD Temperature (if available):"
sudo smartctl -a /dev/nvme0n1 2>/dev/null | grep -i temperature || echo "Temperature monitoring not available"

echo ""
echo "✅ Installation verification complete!"
echo "Look for your 4TB (~3.7TB actual) drive in the output above" 