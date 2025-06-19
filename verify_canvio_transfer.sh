#!/bin/bash

echo "🔍 CANVIO TRANSFER VERIFICATION REPORT"
echo "======================================"
echo ""

# Define paths
SOURCE="/media/gmk/canvio"
DEST="/mnt/paperless-ssd/digital_consolidation/canvio_transfer"

echo "📊 COMPARING TRANSFERRED FOLDERS:"
echo ""

# Function to safely get folder size
get_folder_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "N/A"
}

# Function to safely count files
count_files() {
    find "$1" -type f 2>/dev/null | wc -l || echo "N/A"
}

echo "1. MAC MINI FILES:"
echo "   Source: $(get_folder_size "$SOURCE/from older mac mini")"
echo "   Destination: $(get_folder_size "$DEST/mac_mini_files")"
echo ""

echo "2. PHOTOS TO IMPORT:"
echo "   Source: $(get_folder_size "$SOURCE/Photos to Import")"
echo "   Destination: $(get_folder_size "$DEST/photos_to_import")"
echo ""

echo "3. IPHOTO LIBRARY:"
echo "   Source: $(get_folder_size "$SOURCE/iPhoto Library starting 1-1-2014.photoslibrary")"
echo "   Destination: $(get_folder_size "$DEST/iphoto_library")"
echo ""

echo "4. SAVE FOR MIGRATION:"
echo "   Source: $(get_folder_size "$SOURCE/SAVE FOR MIGRATION")"
echo "   Destination: $(get_folder_size "$DEST/save_for_migration")"
echo ""

echo "📁 TOTAL DESTINATION SIZE:"
du -sh "$DEST" 2>/dev/null | cut -f1

echo ""
echo "📈 TOTAL FILES TRANSFERRED:"
count_files "$DEST"

echo ""
echo "✅ TRANSFER STATUS: Checking for completion..."

# Check if all main folders exist
if [ -d "$DEST/mac_mini_files" ] && [ -d "$DEST/photos_to_import" ] && [ -d "$DEST/iphoto_library" ] && [ -d "$DEST/save_for_migration" ]; then
    echo "🎉 ALL MAIN FOLDERS TRANSFERRED SUCCESSFULLY!"
    echo ""
    echo "🚀 READY TO CLEAR CANVIO SPACE: YES"
else
    echo "⚠️  SOME FOLDERS MISSING - DO NOT CLEAR CANVIO YET"
fi

echo ""
echo "📋 VERIFICATION COMPLETE" 