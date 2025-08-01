#!/bin/bash

# Archive Cleanup Script - Organize completed/old files
# Safely moves completed projects to archive structure

echo "🗂️ Starting Main Directory Archive Cleanup"
echo "=========================================="

ARCHIVE_BASE="archive"

# Create archive directory structure
echo "📁 Creating archive directory structure..."
mkdir -p "$ARCHIVE_BASE/completed_scripts"
mkdir -p "$ARCHIVE_BASE/completed_guides" 
mkdir -p "$ARCHIVE_BASE/logs"
mkdir -p "$ARCHIVE_BASE/deprecated"
mkdir -p "$ARCHIVE_BASE/one_time_setup"

echo "✅ Archive structure created"

# Function to move files with confirmation
move_files() {
    local category="$1"
    local target_dir="$2"
    shift 2
    local files=("$@")
    
    echo ""
    echo "📦 Moving $category files to $target_dir/"
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            mv "$file" "$target_dir/"
            echo "  ✅ $file"
        else
            echo "  ⚠️  $file (not found)"
        fi
    done
}

# 1. XML/Chapter Management (COMPLETED)
XML_FILES=(
    "archive_xml_chapters.py"
    "update_xml_chapters.py"
    "create_handbrake_chapters.py"
    "update_handbrake_chapters.py"
    "XML_CHAPTER_UPDATE_GUIDE.md"
    "XML_CHAPTER_TROUBLESHOOTING_GUIDE.md"
    "XML_CLEANUP_SUMMARY.md"
    "xml_requirements.txt"
    "chapter_titles_template.txt"
)

move_files "XML/Chapter Management" "$ARCHIVE_BASE/completed_scripts" "${XML_FILES[@]}"

# 2. Display/Monitor Fixes (COMPLETED)
DISPLAY_FILES=(
    "fix_primary_display.sh"
    "fix_gdm3_login.sh"
    "safe_display_fix.sh"
    "gdm3_display_fix.sh"
    "nuclear_display_fix.sh"
    "force_fix_primary_display.sh"
    "force_monitor_primary.sh"
    "simple_display_fix.sh"
    "wayland_display_fix.sh"
    "x11_display_fix.sh"
    "simple_gdm3_fix.sh"
    "monitor-primary.service"
)

move_files "Display/Monitor Fixes" "$ARCHIVE_BASE/completed_scripts" "${DISPLAY_FILES[@]}"

# 3. Windows VM Setup (ONE-TIME COMPLETED)
VM_FILES=(
    "create_windows_vm.sh"
    "create_windows_vm_fixed.sh"
    "create_windows_vm_no_secureboot.sh"
    "create_windows_vm_sata.sh"
    "download_windows_iso.sh"
    "get_windows_iso_manual.sh"
    "fix_vm_hardware_id.sh"
    "reconfigure_vm_vnc.sh"
    "repair_windows_boot.sh"
    "remove_cdrom_boot_hdd.sh"
)

move_files "Windows VM Setup" "$ARCHIVE_BASE/one_time_setup" "${VM_FILES[@]}"

# 4. Desktop/Shortcuts Setup (COMPLETED)
DESKTOP_FILES=(
    "create_desktop_shortcuts.sh"
    "setup_keyboard_shortcuts.sh"
    "set_browser_preference.sh"
    "update_shortcuts_to_chrome.sh"
    "Quick Launcher.desktop"
    "DESKTOP_SHORTCUTS_GUIDE.md"
    "SHORTCUTS_SETUP_COMPLETE.md"
    "BROWSER_OPTIONS_GUIDE.md"
)

move_files "Desktop/Shortcuts Setup" "$ARCHIVE_BASE/completed_scripts" "${DESKTOP_FILES[@]}"

# 5. Old Cleanup/Migration Scripts
OLD_MIGRATION_FILES=(
    "cleanup_empty_directories.sh"
    "cleanup_old_backups.sh"
    "check_cleanup_status.sh"
    "migrate_movies_later.sh"
    "migrate_jellyfin_to_large_drive.sh"
    "migrate_all_tv_shows_to_jellyfin.sh"
    "background_migration.sh"
    "safe_jellyfin_migration.sh"
)

move_files "Old Cleanup/Migration Scripts" "$ARCHIVE_BASE/deprecated" "${OLD_MIGRATION_FILES[@]}"

# 6. Log Files & Reports
LOG_FILES=(
    "migration_background.log"
    "empty_directories_cleanup_20250723_013727.log"
    "movie_cleanup_20250724_215551.log"
    "movie_cleanup_20250724_215620.log"
    "movie_cleanup_20250724_215651.log"
    "full_cleanup_output.txt"
    "cleanup_summary_20250719_221423.md"
    "CLEANUP_SUCCESS_SUMMARY.md"
    "STORAGE_REPORT_20250719.md"
)

move_files "Log Files & Reports" "$ARCHIVE_BASE/logs" "${LOG_FILES[@]}"

# 7. Old Guides & Documentation
OLD_GUIDES=(
    "JELLYFIN_STORAGE_MIGRATION_GUIDE.md"
    "MEDIA_CONSOLIDATION_ARCHIVE_RETRIEVAL.md"
    "DIGITAL_CONSOLIDATION_DEDUP_PLAN.md"
    "PROJECT_STRUCTURE.md"
    "NCDU_USAGE_GUIDE.md"
    "ROOT_DRIVE_VISUALIZATION.md"
)

move_files "Old Guides & Documentation" "$ARCHIVE_BASE/completed_guides" "${OLD_GUIDES[@]}"

# 8. Specific Problem-Solving (COMPLETED)
PROBLEM_SOLVING_FILES=(
    "fix_paula_poundstone_subtitles.sh"
    "finalize_paula_fix.sh"
    "quarantine_problematic_music.sh"
    "restore_and_fix_quarantine.sh"
)

move_files "Specific Problem-Solving" "$ARCHIVE_BASE/completed_scripts" "${PROBLEM_SOLVING_FILES[@]}"

# 9. Old Testing Scripts
TEST_FILES=(
    "test_dual_display.sh"
    "test_jellyfin_positioning.sh"
    "test_problematic_dvd.sh"
    "dual_sided_dvd_test.sh"
)

move_files "Old Testing Scripts" "$ARCHIVE_BASE/completed_scripts" "${TEST_FILES[@]}"

# 10. Old System Setup (COMPLETED)
SYSTEM_SETUP_FILES=(
    "analyze_current_setup.sh"
    "setup_4tb_ssd.sh"
    "mount_drive.sh"
    "verify_new_ssd.sh"
    "verify_canvio_transfer.sh"
)

move_files "Old System Setup" "$ARCHIVE_BASE/one_time_setup" "${SYSTEM_SETUP_FILES[@]}"

echo ""
echo "🎉 Archive cleanup completed!"
echo ""
echo "📊 Archive Summary:"
ls -la "$ARCHIVE_BASE"/*/ | head -20

echo ""
echo "🚀 Active files remaining in main directory:"
echo "   - Current project files (baton.md, smart_migration.sh)"
echo "   - Active DVD/CD ripping tools"
echo "   - Current Jellyfin configuration"
echo "   - Active media processing scripts"
echo ""
echo "✅ Main directory is now organized and clean!" 