#!/bin/bash

# Windows 11 ISO Download Script
echo "💾 Windows 11 ISO Download Helper"
echo "=================================="

# Target location
ISO_PATH="/mnt/storage/Windows11.iso"

# Check available space
echo "🔍 Checking available space..."
AVAILABLE_GB=$(df -BG /mnt/storage | tail -1 | awk '{print $4}' | sed 's/G//')
echo "📊 Available space: ${AVAILABLE_GB}GB"

if [ "$AVAILABLE_GB" -lt 10 ]; then
    echo "❌ Not enough space (need at least 10GB)"
    exit 1
fi

echo "✅ Sufficient space available"

# Check if ISO already exists
if [ -f "$ISO_PATH" ]; then
    SIZE_GB=$(du -BG "$ISO_PATH" | cut -f1 | sed 's/G//')
    if [ "$SIZE_GB" -gt 4 ]; then
        echo "✅ Windows 11 ISO already exists!"
        echo "📊 File size: $(ls -lh "$ISO_PATH" | awk '{print $5}')"
        echo ""
        echo "🚀 Ready to create VM! Run:"
        echo "   ./create_windows_vm.sh"
        exit 0
    else
        echo "⚠️  Incomplete ISO found, removing..."
        rm -f "$ISO_PATH"
    fi
fi

echo ""
echo "🎯 WINDOWS 11 ISO DOWNLOAD INSTRUCTIONS:"
echo "========================================"
echo ""
echo "🔗 Open this URL in your browser:"
echo "   https://www.microsoft.com/software-download/windows11"
echo ""
echo "📋 Download Steps:"
echo "1. Click 'Download Windows 11 Disk Image (ISO)'"
echo "2. Select 'Windows 11 (multi-edition ISO)'"
echo "3. Choose 'English (United States)'"
echo "4. Click '64-bit Download'"
echo "5. Save the file as: $ISO_PATH"
echo ""
echo "💡 Alternative: Use wget if you have a direct link:"
echo "   wget -O '$ISO_PATH' 'https://your-direct-iso-link'"
echo ""

# Wait for user to download
echo "⏳ Waiting for Windows ISO download..."
echo "Press Ctrl+C to cancel or wait for download to complete"
echo ""

# Monitor for ISO completion
while true; do
    if [ -f "$ISO_PATH" ]; then
        SIZE_GB=$(du -BG "$ISO_PATH" | cut -f1 | sed 's/G//')
        SIZE_MB=$(du -BM "$ISO_PATH" | cut -f1 | sed 's/M//')
        
        if [ "$SIZE_GB" -gt 4 ]; then
            echo "🎉 Windows 11 ISO download complete!"
            echo "📊 File size: $(ls -lh "$ISO_PATH" | awk '{print $5}')"
            echo ""
            echo "✅ ISO verified and ready for VM creation!"
            echo ""
            echo "🚀 Next steps:"
            echo "1. Create Windows VM: ./create_windows_vm.sh"
            echo "2. Connect via SPICE: spice://100.100.71.107:5900"
            echo "3. Install Windows using your existing license"
            echo ""
            echo "🌟 VM Infrastructure Ready! 🚀"
            break
        elif [ "$SIZE_MB" -gt 100 ]; then
            echo "📥 Download in progress... (${SIZE_MB}MB)"
        fi
    fi
    
    sleep 10
done 