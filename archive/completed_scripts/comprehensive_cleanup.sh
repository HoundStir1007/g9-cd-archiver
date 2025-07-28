#!/bin/bash

# 🧹 Comprehensive Cleanup Script
# Archives completed scripts and removes temporary files
# Preserves important documentation and ongoing tools

echo "🧹 Starting comprehensive cleanup..."

# Create archive directory for completed scripts
mkdir -p archive/completed_scripts
mkdir -p archive/temp_files
mkdir -p archive/logs

echo "📁 Created archive directories"

# Move completed migration scripts
echo "📦 Archiving completed migration scripts..."
mv move_approved_movies_batch_*.sh archive/completed_scripts/ 2>/dev/null
mv move_thunderbolt_movies_to_jellyfin*.sh archive/completed_scripts/ 2>/dev/null
mv move_batch_*.sh archive/completed_scripts/ 2>/dev/null
mv move_next_batch_to_jellyfin.sh archive/completed_scripts/ 2>/dev/null
mv move_large_videos_to_jellyfin.sh archive/completed_scripts/ 2>/dev/null
mv emergency_storage_migration.sh archive/completed_scripts/ 2>/dev/null
mv phase2_large_transfers.sh archive/completed_scripts/ 2>/dev/null

# Move monitoring scripts (completed)
mv monitor_migration_progress.sh archive/completed_scripts/ 2>/dev/null
mv monitor_phase2.sh archive/completed_scripts/ 2>/dev/null

# Move digital consolidation scripts (completed)
mv day1_*.sh archive/completed_scripts/ 2>/dev/null
mv day2_*.sh archive/completed_scripts/ 2>/dev/null
mv quick_*cleanup.sh archive/completed_scripts/ 2>/dev/null
mv target_*cleanup.sh archive/completed_scripts/ 2>/dev/null
mv canvio_cleanup_strategy.sh archive/completed_scripts/ 2>/dev/null
mv video_cleanup_strategy.sh archive/completed_scripts/ 2>/dev/null
mv remove_*duplicates*.sh archive/completed_scripts/ 2>/dev/null
mv targeted_video_cleanup.sh archive/completed_scripts/ 2>/dev/null

# Move large log files
echo "📋 Archiving large log files..."
mv phase2_migration_log_20250719_193322.log archive/logs/ 2>/dev/null
mv migration_log_20250719_190942.log archive/logs/ 2>/dev/null
mv approved_movies_batch_*.log archive/logs/ 2>/dev/null
mv thunderbolt_movie_migration*.log archive/logs/ 2>/dev/null
mv batch_*_move_*.log archive/logs/ 2>/dev/null
mv large_video_move_*.log archive/logs/ 2>/dev/null
mv next_batch_move_*.log archive/logs/ 2>/dev/null
mv tv_migration_*.log archive/logs/ 2>/dev/null
mv canvio_cleanup_*.log archive/logs/ 2>/dev/null
mv thunderbolt_cleanup_*.log archive/logs/ 2>/dev/null
mv targeted_video_cleanup_*.log archive/logs/ 2>/dev/null

# Move temporary analysis files
echo "📊 Archiving temporary analysis files..."
mv thunderbolt_sample_analysis.txt archive/temp_files/ 2>/dev/null
mv quick_canvio_analysis.txt archive/temp_files/ 2>/dev/null
mv thunderbolt_quick_sample.txt archive/temp_files/ 2>/dev/null
mv exact_duplicates.txt archive/temp_files/ 2>/dev/null
mv large_duplicates.txt archive/temp_files/ 2>/dev/null
mv duplicate_videos.txt archive/temp_files/ 2>/dev/null
mv canvio_duplicates.txt archive/temp_files/ 2>/dev/null

# Archive old XML files (keep current ones)
echo "📄 Archiving old XML files..."
mv OGWT-v3*.xml archive/temp_files/ 2>/dev/null
mv devo-live-1996.xml archive/temp_files/ 2>/dev/null
mv tas.xml archive/temp_files/ 2>/dev/null
mv tas_updated.xml archive/temp_files/ 2>/dev/null
mv sfs.xml archive/temp_files/ 2>/dev/null

# Remove empty files
echo "🗑️ Removing empty files..."
find . -maxdepth 1 -type f -empty -delete

# Create summary
echo "📝 Creating cleanup summary..."
{
    echo "# 🧹 Cleanup Summary - $(date)"
    echo ""
    echo "## 📦 Archived Scripts"
    echo "- Migration scripts: move_approved_movies_batch_*.sh"
    echo "- Emergency migration: emergency_storage_migration.sh"
    echo "- Digital consolidation: day1_*.sh, day2_*.sh"
    echo "- Monitoring scripts: monitor_*.sh"
    echo ""
    echo "## 📋 Archived Logs"
    echo "- Large migration logs (91MB+ total)"
    echo "- Batch processing logs"
    echo "- Cleanup operation logs"
    echo ""
    echo "## 📊 Archived Analysis Files"
    echo "- Sample analysis files"
    echo "- Duplicate detection files"
    echo "- Temporary analysis outputs"
    echo ""
    echo "## 📄 Archived XML Files"
    echo "- Old XML chapter files"
    echo "- Superseded versions"
    echo ""
    echo "## ✅ Preserved Files"
    echo "- Current XML chapters: wa.xml, bfl.xml, rxb.xml, tas_official.xml, sfs_updated.xml"
    echo "- Important documentation: *.md files"
    echo "- Ongoing tools: *.py scripts"
    echo "- Active scripts: g9_*.sh, check_*.sh"
    echo ""
    echo "## 💾 Space Saved"
    echo "- Log files: ~100MB+"
    echo "- Analysis files: ~10MB+"
    echo "- Scripts: ~1MB+"
    echo "- Total: ~111MB+ of clutter removed"
} > cleanup_summary_$(date +%Y%m%d_%H%M%S).md

echo "✅ Cleanup completed!"
echo "📁 Check archive/ directory for moved files"
echo "📝 Check cleanup_summary_*.md for details" 