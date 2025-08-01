# 🗂️ Main Directory Archive Plan

## 📊 **Archive Categories**

### 1. **XML/Chapter Management (COMPLETED)**
- `archive_xml_chapters.py`
- `update_xml_chapters.py` 
- `create_handbrake_chapters.py`
- `update_handbrake_chapters.py`
- `XML_CHAPTER_UPDATE_GUIDE.md`
- `XML_CHAPTER_TROUBLESHOOTING_GUIDE.md`
- `XML_CLEANUP_SUMMARY.md`
- `xml_requirements.txt`
- `chapter_titles_template.txt`

### 2. **Display/Monitor Fixes (COMPLETED)**
- `fix_primary_display.sh`
- `fix_gdm3_login.sh`
- `safe_display_fix.sh`
- `gdm3_display_fix.sh` 
- `nuclear_display_fix.sh`
- `force_fix_primary_display.sh`
- `force_monitor_primary.sh`
- `simple_display_fix.sh`
- `wayland_display_fix.sh`
- `x11_display_fix.sh`
- `simple_gdm3_fix.sh`
- `monitor-primary.service`

### 3. **Windows VM Setup (ONE-TIME COMPLETED)**
- `create_windows_vm.sh`
- `create_windows_vm_fixed.sh`
- `create_windows_vm_no_secureboot.sh`
- `create_windows_vm_sata.sh`
- `download_windows_iso.sh`
- `get_windows_iso_manual.sh`
- `fix_vm_hardware_id.sh`
- `reconfigure_vm_vnc.sh`
- `repair_windows_boot.sh`
- `remove_cdrom_boot_hdd.sh`

### 4. **Desktop/Shortcuts Setup (COMPLETED)**
- `create_desktop_shortcuts.sh`
- `setup_keyboard_shortcuts.sh`
- `set_browser_preference.sh`
- `update_shortcuts_to_chrome.sh`
- `Quick Launcher.desktop`
- `DESKTOP_SHORTCUTS_GUIDE.md`
- `SHORTCUTS_SETUP_COMPLETE.md`
- `BROWSER_OPTIONS_GUIDE.md`

### 5. **Old Cleanup/Migration Scripts**
- `cleanup_empty_directories.sh`
- `cleanup_old_backups.sh`
- `check_cleanup_status.sh`
- `migrate_movies_later.sh`
- `migrate_jellyfin_to_large_drive.sh`
- `migrate_all_tv_shows_to_jellyfin.sh`
- `background_migration.sh` (replaced by smart_migration)
- `safe_jellyfin_migration.sh` (replaced by smart_migration)

### 6. **Log Files & Reports**
- `migration_background.log`
- `empty_directories_cleanup_20250723_013727.log`
- `movie_cleanup_*.log` (all 3 files)
- `full_cleanup_output.txt`
- `cleanup_summary_20250719_221423.md`
- `CLEANUP_SUCCESS_SUMMARY.md`
- `STORAGE_REPORT_20250719.md`

### 7. **Old Guides & Documentation**
- `JELLYFIN_STORAGE_MIGRATION_GUIDE.md` (replaced by current baton)
- `MEDIA_CONSOLIDATION_ARCHIVE_RETRIEVAL.md`
- `DIGITAL_CONSOLIDATION_DEDUP_PLAN.md`
- `PROJECT_STRUCTURE.md`
- `NCDU_USAGE_GUIDE.md`
- `ROOT_DRIVE_VISUALIZATION.md`

### 8. **Specific Problem-Solving (COMPLETED)**
- `fix_paula_poundstone_subtitles.sh`
- `finalize_paula_fix.sh`
- `quarantine_problematic_music.sh`
- `restore_and_fix_quarantine.sh`

### 9. **Old Testing Scripts**
- `test_dual_display.sh`
- `test_jellyfin_positioning.sh`
- `test_problematic_dvd.sh`
- `dual_sided_dvd_test.sh`

### 10. **Old System Setup (COMPLETED)**
- `analyze_current_setup.sh`
- `setup_4tb_ssd.sh`
- `mount_drive.sh`
- `verify_new_ssd.sh`
- `verify_canvio_transfer.sh`

## 🚀 **Files to KEEP Active**

### Current Projects:
- `baton.md` - Current project tracking
- `smart_migration.sh` - Active migration
- `smart_migration.log` - Active log
- `smart_migration_complete.flag` - Status flag

### DVD/Media Ripping:
- `g9_dvd_ripper.sh` - Current DVD ripper
- `g9_cd_ripper.sh` - Current CD ripper  
- `enhanced_ripper_integration.py` - Current enhancement
- `media_holding_tank.py` - Current media processing
- `organize_rip.sh` - Current organization
- `setup_holding_tank.sh` - Current setup

### Active Jellyfin:
- `jellyfin-docker-compose.yml` - Current config
- `optimize_jellyfin_scanning.sh` - Current optimization
- `jellyfin_movie_name_cleanup.sh` - Current cleanup
- `JELLYFIN_TROUBLESHOOTING_QUICK_REFERENCE.md` - Current reference
- `JELLYFIN_MEDIA_ACCESS_SOLUTION.md` - Current solution guide

### Current Audiobook Processing:
- `find_audiobooks_in_music.py` - Current processing
- `move_audiobooks_from_music.sh` - Current organization  
- `quick_audiobook_finder.sh` - Current utility
- `audiobook_analysis_results.json` - Current results

## 📂 **Archive Structure**
```
archive/
├── completed_scripts/           # All completed automation
├── completed_guides/           # All completed documentation  
├── logs/                      # All old logs and reports
├── deprecated/               # Old/replaced files
└── one_time_setup/          # One-time setup scripts
``` 