#!/bin/bash

# Manual Windows 11 ISO Download Helper
echo "📥 Manual Windows 11 ISO Download"
echo "=================================="

ISO_PATH="/mnt/storage/Windows11.iso"

echo ""
echo "🎯 STEP 1: Download Windows 11 ISO"
echo "   👉 Open: https://www.microsoft.com/software-download/windows11"
echo ""
echo "📋 Instructions:"
echo "   1. Scroll down to 'Download Windows 11 Disk Image (ISO)'"
echo "   2. Select 'Windows 11 (multi-edition ISO)'"
echo "   3. Click 'Confirm'"
echo "   4. Select 'English (United States)'"
echo "   5. Click 'Confirm'"
echo "   6. Click '64-bit Download'"
echo "   7. Save the file to your Downloads folder"
echo ""
echo "🔄 STEP 2: Transfer to Server"
echo "   Option A - If downloading on this machine:"
echo "     mv ~/Downloads/Win11_*.iso $ISO_PATH"
echo ""
echo "   Option B - If downloading on another machine:"
echo "     scp Win11_*.iso mark@100.100.71.107:$ISO_PATH"
echo ""
echo "🚀 STEP 3: Verify and Create VM"
echo "   ./get_windows_iso_manual.sh verify"
echo ""

if [ "$1" == "verify" ]; then
    echo "🔍 Verifying Windows ISO..."
    
    if [ -f "$ISO_PATH" ]; then
        SIZE_GB=$(du -BG "$ISO_PATH" | cut -f1 | sed 's/G//')
        SIZE_MB=$(du -BM "$ISO_PATH" | cut -f1 | sed 's/M//')
        
        if [ "$SIZE_GB" -gt 4 ]; then
            echo "✅ Windows 11 ISO verified successfully!"
            echo "📊 File size: $(ls -lh "$ISO_PATH" | awk '{print $5}')"
            echo ""
            echo "🎉 Ready to create Windows VM!"
            echo "🚀 Run: ./create_windows_vm.sh"
            echo ""
            echo "🔗 VM will be accessible at: spice://100.100.71.107:5900"
        else
            echo "⚠️  File too small (${SIZE_MB}MB). Download may be incomplete."
            echo "Please re-download the ISO."
        fi
    else
        echo "❌ ISO not found at: $ISO_PATH"
        echo "Please download and place the ISO file there."
    fi
else
    echo "⏳ Waiting for you to download the ISO..."
    echo "💡 Run './get_windows_iso_manual.sh verify' when ready"
fi

echo ""
echo "🎯 Alternative: Use existing Windows license from encrypted drive"
echo "   Your G9 has a valid Windows license that can be reused!"
echo "" 