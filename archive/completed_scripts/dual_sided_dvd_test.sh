#!/bin/bash

# Dual-Sided DVD Detection Script
# For discs where CD side works but DVD side doesn't mount

echo "🎬 Dual-Sided Disc DVD Detection"
echo "================================="
echo ""
echo "📀 Make sure DVD side is facing down, then press Enter..."
read

echo "🔍 Testing multiple detection methods..."
echo ""

# Method 1: Basic drive detection
echo "1️⃣ Drive Detection:"
lsblk | grep sr
echo ""

# Method 2: Try to identify file system
echo "2️⃣ File System Detection:"
sudo blkid /dev/sr1
echo ""

# Method 3: Check if it's seen as audio
echo "3️⃣ Audio Track Check:"
if cdparanoia -Q 2>&1 | grep -q "track"; then
    echo "❌ Still detecting as audio CD - DVD side not reading"
else
    echo "✅ No audio tracks - possible DVD detection"
fi
echo ""

# Method 4: Try HandBrake direct device access
echo "4️⃣ HandBrake Detection Test:"
timeout 30 HandBrakeCLI -i /dev/sr1 -t 0 2>&1 | head -10
echo ""

# Method 5: Try manual mount
echo "5️⃣ Manual Mount Test:"
sudo mkdir -p /mnt/dvd_test
if sudo mount /dev/sr1 /mnt/dvd_test 2>/dev/null; then
    echo "✅ DVD mounted successfully!"
    echo "Contents:"
    ls -la /mnt/dvd_test/
    sudo umount /mnt/dvd_test
else
    echo "❌ Manual mount failed"
    echo "Trying different mount types..."
    
    # Try UDF format
    if sudo mount -t udf /dev/sr1 /mnt/dvd_test 2>/dev/null; then
        echo "✅ Mounted as UDF format!"
        ls -la /mnt/dvd_test/
        sudo umount /mnt/dvd_test
    elif sudo mount -t iso9660 /dev/sr1 /mnt/dvd_test 2>/dev/null; then
        echo "✅ Mounted as ISO9660!"
        ls -la /mnt/dvd_test/
        sudo umount /mnt/dvd_test
    else
        echo "❌ All mount attempts failed"
    fi
fi

sudo rmdir /mnt/dvd_test 2>/dev/null

echo ""
echo "🎯 DIAGNOSIS COMPLETE"
echo ""
echo "If all tests failed, the DVD side may be:"
echo "   • Physically damaged"
echo "   • Using unsupported format"
echo "   • Have incompatible copy protection"
echo "   • Manufacturing defect"
echo ""
echo "💡 Try cleaning the disc and testing again" 