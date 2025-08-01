#!/bin/bash

# 🔥 Aggressive Paperless-SSD2 Empty Directory Cleanup
# Removes ALL empty directories from photo extractions

echo "🔥 AGGRESSIVE cleanup of remaining empty directories..."
echo "===================================================="

BASE_PATH="/media/mark/paperless-ssd2"

# Count before
BEFORE_COUNT=$(find "$BASE_PATH" -type d -empty 2>/dev/null | wc -l)
echo "📊 Found $BEFORE_COUNT empty directories to clean"

echo ""
echo "🗑️  AGGRESSIVELY CLEANING:"

# Clean ALL empty directories in digital_consolidation (photo extraction leftovers)
echo "  • ALL photo extraction empty directories..."
find "$BASE_PATH/digital_consolidation" -type d -empty -delete 2>/dev/null || true

# Optionally clean retro-gaming placeholders (uncomment if you want)
# echo "  • Retro-gaming placeholder directories..."
# find "$BASE_PATH/retro-gaming" -type d -empty -delete 2>/dev/null || true

AFTER_COUNT=$(find "$BASE_PATH" -type d -empty 2>/dev/null | wc -l)
CLEANED=$(($BEFORE_COUNT - $AFTER_COUNT))

echo ""
echo "✅ Aggressive cleanup complete!"
echo "📊 Cleaned up: $CLEANED empty directories"
echo "📊 Remaining: $AFTER_COUNT empty directories"

if [[ $AFTER_COUNT -gt 0 ]]; then
    echo ""
    echo "🔍 Still remaining:"
    find "$BASE_PATH" -type d -empty 2>/dev/null
fi 