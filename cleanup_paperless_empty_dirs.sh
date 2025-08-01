#!/bin/bash

# 🧹 Paperless-SSD2 Empty Directory Cleanup Script
# Safely removes empty directories while preserving structure

echo "🧹 Cleaning up empty directories in paperless-ssd2..."
echo "=================================================="

BASE_PATH="/media/mark/paperless-ssd2"

# Count empty directories before cleanup
BEFORE_COUNT=$(find "$BASE_PATH" -type d -empty 2>/dev/null | wc -l)
echo "📊 Found $BEFORE_COUNT empty directories"

echo ""
echo "🗑️  SAFE TO CLEAN:"

# 1. Clean up trash directories (always safe)
echo "  • Trash directories..."
find "$BASE_PATH/.Trash-1000" -type d -empty -delete 2>/dev/null || true

# 2. Clean up photo extraction empty directories
echo "  • Photo extraction empty directories..."
find "$BASE_PATH/digital_consolidation" -type d -empty -path "*/My Pictures/*" -delete 2>/dev/null || true
find "$BASE_PATH/digital_consolidation" -type d -empty -path "*/Adobe/*" -delete 2>/dev/null || true
find "$BASE_PATH/digital_consolidation" -type d -empty -path "*/Kodak Pictures/*" -delete 2>/dev/null || true
find "$BASE_PATH/digital_consolidation" -type d -empty -path "*/low_res" -delete 2>/dev/null || true
find "$BASE_PATH/digital_consolidation" -type d -empty -path "*/previews/*" -delete 2>/dev/null || true

# 3. Clean up paperless empty directories
echo "  • Paperless empty directories..."
find "$BASE_PATH/paperless" -type d -empty -name "export" -delete 2>/dev/null || true
find "$BASE_PATH/paperless" -type d -empty -name "consume" -delete 2>/dev/null || true

echo ""
echo "⚠️  KEEPING (Structure directories):"
echo "  • Retro-gaming ROM folders (may be intentional placeholders)"
echo "  • Jellyfin cache directories (needed for operation)"

# Count after cleanup
AFTER_COUNT=$(find "$BASE_PATH" -type d -empty 2>/dev/null | wc -l)
CLEANED=$(($BEFORE_COUNT - $AFTER_COUNT))

echo ""
echo "✅ Cleanup complete!"
echo "📊 Cleaned up: $CLEANED empty directories"
echo "📊 Remaining: $AFTER_COUNT empty directories"

if [[ $AFTER_COUNT -gt 0 ]]; then
    echo ""
    echo "🔍 Remaining empty directories:"
    find "$BASE_PATH" -type d -empty 2>/dev/null | head -10
    if [[ $AFTER_COUNT -gt 10 ]]; then
        echo "   ... and $(($AFTER_COUNT - 10)) more"
    fi
fi 