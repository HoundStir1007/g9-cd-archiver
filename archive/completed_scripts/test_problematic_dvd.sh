#!/bin/bash

# DVD Diagnostic Script 🎬
# Tests problematic DVDs with multiple methods

echo "🎬 DVD Diagnostic Tool"
echo "======================"

# Check if drive is available
if [ ! -e /dev/sr0 ]; then
    echo "❌ No optical drive detected at /dev/sr0"
    exit 1
fi

echo "✅ Drive detected: /dev/sr0"

# Check if disc is inserted
if ! lsblk | grep -q sr0; then
    echo "❌ No disc detected in drive"
    echo "Please insert a problematic DVD and run again"
    exit 1
fi

echo "✅ Disc detected in drive"

# Test 1: Basic read test
echo ""
echo "🔍 Test 1: Basic Read Test"
echo "---------------------------"
if sudo dd if=/dev/sr0 of=/dev/null bs=1M count=1 2>/dev/null; then
    echo "✅ Basic read successful"
else
    echo "❌ Basic read failed"
fi

# Test 2: Disc format detection
echo ""
echo "📊 Test 2: Disc Format Analysis"
echo "-------------------------------"
sudo file -s /dev/sr0

# Test 3: ddrescue test (non-destructive)
echo ""
echo "🛠️ Test 3: ddrescue Test (1MB sample)"
echo "--------------------------------------"
OUTPUT_FILE="/tmp/dvd_test_$(date +%s).iso"
LOGFILE="/tmp/dvd_test_$(date +%s).log"

if sudo ddrescue -d -n -v /dev/sr0 "$OUTPUT_FILE" "$LOGFILE" 2>&1 | head -20; then
    echo "✅ ddrescue test completed"
    echo "📁 Test file: $OUTPUT_FILE"
    echo "📋 Log file: $LOGFILE"
else
    echo "❌ ddrescue test failed"
fi

# Test 4: Different block sizes
echo ""
echo "🔧 Test 4: Block Size Tests"
echo "---------------------------"
for bs in 2048 4096 8192 16384; do
    echo "Testing block size: $bs"
    if sudo dd if=/dev/sr0 of=/dev/null bs=$bs count=1 2>/dev/null; then
        echo "✅ Block size $bs works"
    else
        echo "❌ Block size $bs failed"
    fi
done

# Test 5: Drive capabilities
echo ""
echo "💾 Test 5: Drive Capabilities"
echo "-----------------------------"
if [ -f /proc/sys/dev/cdrom/info ]; then
    cat /proc/sys/dev/cdrom/info
else
    echo "Drive info not available"
fi

# Test 6: USB power check
echo ""
echo "⚡ Test 6: USB Power Check"
echo "-------------------------"
lsusb -t | grep -A5 -B5 "DVD"

echo ""
echo "🎯 Recommendations:"
echo "=================="
echo "1. If basic read fails: Try ddrescue for recovery"
echo "2. If ddrescue fails: Try different USB ports/cables"
echo "3. If still failing: Consider alternative drive"
echo "4. For valuable content: Use professional disc repair"

echo ""
echo "📋 Next Steps:"
echo "=============="
echo "• Run: sudo ddrescue -d -n -v /dev/sr0 /path/to/output.iso /path/to/logfile.log"
echo "• Try different USB ports"
echo "• Clean disc with microfiber cloth"
echo "• Consider purchasing LG GP60NB60 drive"

# Cleanup test files
rm -f "$OUTPUT_FILE" "$LOGFILE" 2>/dev/null 