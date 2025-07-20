#!/bin/bash

echo "📊 DIGITAL CONSOLIDATION CLEANUP STATUS"
echo "======================================="
echo ""

# Check if cleanup is still running
if ps aux | grep day1_aggressive_cleanup | grep -v grep > /dev/null; then
    echo "🔄 STATUS: Cleanup still running"
    echo ""
    
    # Show progress
    if [ -f "digital_consolidation_cleanup/deleted_files_log.txt" ]; then
        deleted_count=$(wc -l < digital_consolidation_cleanup/deleted_files_log.txt)
        echo "📊 PROGRESS:"
        echo "  • Files deleted: $deleted_count"
        echo "  • Original duplicates found: 4,808"
        echo "  • Progress: $(($deleted_count * 100 / 4808))% through duplicates"
        echo ""
        
        echo "🎯 RECENT ACTIVITY:"
        tail -3 digital_consolidation_cleanup/deleted_files_log.txt | sed 's/^/  /'
    fi
    
    echo ""
    echo "⏳ Estimated time remaining: A few more minutes..."
    echo "💡 The script is working through all those duplicates - this is great!"
    
else
    echo "✅ STATUS: Cleanup completed!"
    
    if [ -f "digital_consolidation_cleanup/cleanup_summary.txt" ]; then
        echo ""
        cat digital_consolidation_cleanup/cleanup_summary.txt
    fi
    
    echo ""
    echo "🚀 Ready for Day 2: Auto-sorting!"
    echo "   → bash day2_auto_sort.sh"
fi

echo ""
echo "📋 To check again: bash check_cleanup_status.sh" 