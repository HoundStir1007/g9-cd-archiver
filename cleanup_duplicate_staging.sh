#!/bin/bash

# 🧹 Cleanup Duplicate Staging Directories 
# Removes leftover staging areas from completed migration

echo "🧹 Cleanup Duplicate Staging Areas"
echo "=================================="

SSD_STAGING="/media/mark/paperless-ssd2/digital_consolidation"
MAIN_ARCHIVES="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/archives"

echo "🔍 Duplicate Analysis:"
echo ""

# Check thunderbolt_transfer
echo "📁 thunderbolt_transfer:"
SSD_TB_SIZE=$(du -sb "$SSD_STAGING/thunderbolt_transfer" 2>/dev/null | cut -f1)
MAIN_TB_SIZE=$(du -sb "$MAIN_ARCHIVES/thunderbolt_transfer" 2>/dev/null | cut -f1)
echo "  📦 paperless-ssd2: $(du -sh "$SSD_STAGING/thunderbolt_transfer" 2>/dev/null | cut -f1)"
echo "  📦 4.1TB archives: $(du -sh "$MAIN_ARCHIVES/thunderbolt_transfer" 2>/dev/null | cut -f1)"
if [[ "$SSD_TB_SIZE" == "$MAIN_TB_SIZE" ]]; then
    echo "  ✅ SIZES MATCH - Safe to delete staging copy"
    TB_DUPLICATE=true
else
    echo "  ❌ SIZES DIFFER - Manual review needed"
    TB_DUPLICATE=false
fi

echo ""

# Check canvio_transfer  
echo "📁 canvio_transfer:"
SSD_CV_SIZE=$(du -sb "$SSD_STAGING/canvio_transfer" 2>/dev/null | cut -f1)
MAIN_CV_SIZE=$(du -sb "$MAIN_ARCHIVES/canvio_transfer" 2>/dev/null | cut -f1)
echo "  📦 paperless-ssd2: $(du -sh "$SSD_STAGING/canvio_transfer" 2>/dev/null | cut -f1)"
echo "  📦 4.1TB archives: $(du -sh "$MAIN_ARCHIVES/canvio_transfer" 2>/dev/null | cut -f1)"
if [[ "$SSD_CV_SIZE" == "$MAIN_CV_SIZE" ]]; then
    echo "  ✅ SIZES MATCH - Safe to delete staging copy"
    CV_DUPLICATE=true
else
    echo "  ❌ SIZES DIFFER - Manual review needed"
    CV_DUPLICATE=false
fi

echo ""

# Calculate space to free
TOTAL_FREE="0"
if [[ "$TB_DUPLICATE" == true ]]; then
    TB_FREE=$(du -sb "$SSD_STAGING/thunderbolt_transfer" 2>/dev/null | cut -f1)
    TOTAL_FREE=$((TOTAL_FREE + TB_FREE))
fi
if [[ "$CV_DUPLICATE" == true ]]; then
    CV_FREE=$(du -sb "$SSD_STAGING/canvio_transfer" 2>/dev/null | cut -f1)
    TOTAL_FREE=$((TOTAL_FREE + CV_FREE))
fi

echo "💾 Space Analysis:"
echo "  🗑️  Can free: $(numfmt --to=iec $TOTAL_FREE)"
echo "  📊 Current SSD free: $(df -h "$SSD_STAGING" | tail -1 | awk '{print $4}')"

echo ""
if [[ "$TB_DUPLICATE" == true ]] || [[ "$CV_DUPLICATE" == true ]]; then
    echo "🎯 SAFE CLEANUP CANDIDATES:"
    [[ "$TB_DUPLICATE" == true ]] && echo "  ✅ thunderbolt_transfer (already archived)"
    [[ "$CV_DUPLICATE" == true ]] && echo "  ✅ canvio_transfer (already archived)"
    
    echo ""
    read -p "🗑️  Delete confirmed duplicates? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "🧹 Cleaning up duplicates..."
        
        if [[ "$TB_DUPLICATE" == true ]]; then
            echo "  🗑️  Removing thunderbolt_transfer staging..."
            rm -rf "$SSD_STAGING/thunderbolt_transfer"
            echo "     ✅ Deleted"
        fi
        
        if [[ "$CV_DUPLICATE" == true ]]; then
            echo "  🗑️  Removing canvio_transfer staging..."
            rm -rf "$SSD_STAGING/canvio_transfer"
            echo "     ✅ Deleted"
        fi
        
        echo ""
        echo "✅ Cleanup complete!"
        echo "📊 New SSD free space: $(df -h "$SSD_STAGING" | tail -1 | awk '{print $4}')"
        echo "🎉 Freed: $(numfmt --to=iec $TOTAL_FREE)"
    else
        echo "❌ Cleanup cancelled"
    fi
else
    echo "⚠️  No confirmed duplicates found for cleanup"
fi 