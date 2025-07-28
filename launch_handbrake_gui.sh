#!/bin/bash

# HandBrake GUI Launcher with DVD Support
# For G9 DVD Ripping Station

echo "🎬 LAUNCHING HANDBRAKE GUI WITH DVD SUPPORT"
echo "==========================================="
echo ""

# Set DVD decoder environment variables
export DVDCSS_METHOD=title
export DVDCSS_VERBOSE=2

# Check if DVD is present
if [ -e /dev/sr0 ]; then
    echo "✅ DVD drive detected: /dev/sr0"
else
    echo "⚠️  DVD drive not detected at /dev/sr0"
fi

echo ""
echo "📀 DVD Access Instructions:"
echo "1. In HandBrake GUI: Click 'Source' or 'Open Source'"
echo "2. Select '/dev/sr0' (your DVD drive)"
echo "3. libdvdcss2 will automatically decrypt CSS protection"
echo "4. Choose your title from the dropdown menu"
echo ""
echo "🚀 Launching HandBrake GUI..."

# Launch HandBrake GUI
/usr/bin/ghb &

echo ""
echo "✅ HandBrake GUI launched!"
echo "💡 Access via Remote Desktop: 100.100.71.107:3389"
echo "" 