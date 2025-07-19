#!/usr/bin/env python3
"""
🗂️ XML Chapter Archiver
Periodically archives old XML chapter files when they're likely completed
"""

import os
import shutil
import glob
from datetime import datetime, timedelta
import xml.etree.ElementTree as ET

def find_xml_files():
    """Find all XML chapter files in the current directory"""
    xml_files = []
    for file in glob.glob("*.xml"):
        # Skip files that are clearly not chapter files
        if any(skip in file.lower() for skip in ['test', 'backup', 'temp']):
            continue
        xml_files.append(file)
    return xml_files

def get_file_age(filepath):
    """Get the age of a file in days"""
    try:
        modified_time = os.path.getmtime(filepath)
        file_date = datetime.fromtimestamp(modified_time)
        return (datetime.now() - file_date).days
    except:
        return 0

def has_backup_files(xml_file):
    """Check if this XML file has recent backup files (indicating recent editing)"""
    backup_pattern = f"{xml_file}.backup_*"
    backup_files = glob.glob(backup_pattern)
    
    if not backup_files:
        return False
    
    # Check if any backups are recent (within last 7 days)
    recent_backups = []
    for backup in backup_files:
        if get_file_age(backup) <= 7:
            recent_backups.append(backup)
    
    return len(recent_backups) > 0

def is_likely_completed(xml_file):
    """Determine if an XML file is likely completed and ready for archiving"""
    age_days = get_file_age(xml_file)
    has_recent_backups = has_backup_files(xml_file)
    
    # Criteria for archiving:
    # 1. File is older than 7 days AND has no recent backups (likely finished)
    # 2. OR file is older than 30 days (probably forgotten)
    # 3. AND file has meaningful content (not just "Chapter 1", "Chapter 2")
    
    if age_days < 7:
        return False  # Too recent
    
    if age_days > 30:
        return True  # Old enough to archive regardless
    
    if age_days >= 7 and not has_recent_backups:
        # Check if chapters have meaningful titles
        try:
            tree = ET.parse(xml_file)
            chapter_strings = tree.findall('.//ChapterString')
            
            meaningful_titles = 0
            for chapter in chapter_strings:
                title = chapter.text or ""
                # Check if title looks meaningful (not just "Chapter X")
                if not title.lower().startswith('chapter') and len(title) > 5:
                    meaningful_titles += 1
            
            # If most chapters have meaningful titles, it's probably done
            if len(chapter_strings) > 0:
                completion_ratio = meaningful_titles / len(chapter_strings)
                return completion_ratio > 0.7  # 70% of chapters have meaningful titles
                
        except:
            pass
    
    return False

def create_archive_directory():
    """Create archive directory if it doesn't exist"""
    archive_dir = "archive/chapter_files"
    os.makedirs(archive_dir, exist_ok=True)
    return archive_dir

def archive_file(xml_file, archive_dir):
    """Archive a single XML file with all its backup files"""
    timestamp = datetime.now().strftime("%Y%m%d")
    
    try:
        # Archive the main file
        archived_name = f"{xml_file}.archived_{timestamp}"
        archive_path = os.path.join(archive_dir, archived_name)
        shutil.move(xml_file, archive_path)
        print(f"📁 Archived: {xml_file} → {archived_name}")
        
        # Archive any backup files
        backup_pattern = f"{xml_file}.backup_*"
        backup_files = glob.glob(backup_pattern)
        
        for backup in backup_files:
            backup_archive_name = f"{backup}.archived_{timestamp}"
            backup_archive_path = os.path.join(archive_dir, backup_archive_name)
            shutil.move(backup, backup_archive_path)
            print(f"  💾 Also archived backup: {os.path.basename(backup)}")
        
        return True
        
    except Exception as e:
        print(f"❌ Failed to archive {xml_file}: {e}")
        return False

def update_readme(archive_dir, archived_files):
    """Update the README in the archive directory"""
    readme_path = os.path.join(archive_dir, "README.md")
    timestamp = datetime.now().strftime("%B %d, %Y")
    
    # Read existing README or create new one
    existing_content = ""
    if os.path.exists(readme_path):
        with open(readme_path, 'r') as f:
            existing_content = f.read()
    
    # Add new entries
    new_entries = []
    for xml_file in archived_files:
        entry = f"- `{xml_file}` - Archived on {timestamp} (auto-archived after completion detection)"
        new_entries.append(entry)
    
    # Update or create README
    if "## Files Archived:" in existing_content:
        # Insert after the "## Files Archived:" section
        lines = existing_content.split('\n')
        insert_index = None
        for i, line in enumerate(lines):
            if line.startswith("## Files Archived:"):
                insert_index = i + 1
                break
        
        if insert_index:
            for entry in new_entries:
                lines.insert(insert_index, entry)
                insert_index += 1
            
            updated_content = '\n'.join(lines)
        else:
            updated_content = existing_content + '\n\n' + '\n'.join(new_entries)
    else:
        # Create new README
        updated_content = f"""# Archived Chapter Files 📁

This directory contains XML chapter files that are no longer needed in the main project directory.

## Files Archived:

### **Auto-Archived Files** ({timestamp})
{chr(10).join(new_entries)}

## Notes:
- Files are automatically archived when they appear to be completed
- Completion is detected based on file age and meaningful chapter titles
- All backup files are preserved alongside the main XML files
- Archive process runs when you use the XML chapter updater

---
*Archived as part of home server media organization project* 
"""
    
    with open(readme_path, 'w') as f:
        f.write(updated_content)

def interactive_archive():
    """Interactive mode - ask user about each file"""
    xml_files = find_xml_files()
    
    if not xml_files:
        print("📁 No XML files found to archive.")
        return
    
    archive_dir = create_archive_directory()
    archived_files = []
    
    print("🗂️ XML Chapter Archiver - Interactive Mode")
    print("=" * 50)
    
    for xml_file in xml_files:
        age = get_file_age(xml_file)
        has_backups = has_backup_files(xml_file)
        
        print(f"\n📄 File: {xml_file}")
        print(f"   Age: {age} days")
        print(f"   Recent backups: {'Yes' if has_backups else 'No'}")
        
        try:
            # Show chapter count and sample titles
            tree = ET.parse(xml_file)
            chapters = tree.findall('.//ChapterString')
            print(f"   Chapters: {len(chapters)}")
            
            # Show first few chapter titles
            for i, chapter in enumerate(chapters[:3]):
                title = chapter.text or f"Chapter {i+1}"
                print(f"     {i+1}. {title}")
            
            if len(chapters) > 3:
                print(f"     ... and {len(chapters) - 3} more")
                
        except:
            print("   (Unable to parse file)")
        
        try:
            response = input(f"\n🗂️ Archive {xml_file}? (y/n/q to quit): ").strip().lower()
            if response == 'q':
                break
            elif response in ['y', 'yes']:
                if archive_file(xml_file, archive_dir):
                    archived_files.append(xml_file)
        except KeyboardInterrupt:
            print("\n👋 Cancelled.")
            break
    
    if archived_files:
        update_readme(archive_dir, archived_files)
        print(f"\n✅ Archived {len(archived_files)} files to {archive_dir}")
    else:
        print("\n📁 No files were archived.")

def auto_archive():
    """Automatic mode - archive files that appear completed"""
    xml_files = find_xml_files()
    
    if not xml_files:
        return []
    
    archive_dir = create_archive_directory()
    archived_files = []
    
    for xml_file in xml_files:
        if is_likely_completed(xml_file):
            print(f"🤖 Auto-archiving completed file: {xml_file}")
            if archive_file(xml_file, archive_dir):
                archived_files.append(xml_file)
    
    if archived_files:
        update_readme(archive_dir, archived_files)
        print(f"🗂️ Auto-archived {len(archived_files)} completed files")
    
    return archived_files

def main():
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == '--auto':
        # Auto mode for integration with main script
        auto_archive()
    else:
        # Interactive mode
        interactive_archive()

if __name__ == "__main__":
    main() 