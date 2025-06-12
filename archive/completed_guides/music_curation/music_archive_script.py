#!/usr/bin/env python3
"""
Music Collection Archiver
Moves easily-found tracks to archive, keeps rare tracks in Jellyfin
"""

import json
import csv
import os
import shutil
from pathlib import Path
from datetime import datetime

def load_analysis_data(json_file):
    """Load the music analysis data"""
    with open(json_file, 'r', encoding='utf-8') as f:
        return json.load(f)

def create_archive_structure(base_path):
    """Create archive directory structure"""
    archive_base = Path(base_path) / "music_archive_common"
    rare_base = Path(base_path) / "music_rare_collection"
    
    # Create main directories
    archive_base.mkdir(parents=True, exist_ok=True)
    rare_base.mkdir(parents=True, exist_ok=True)
    
    # Create subdirectories
    (archive_base / "found_on_youtube").mkdir(exist_ok=True)
    (archive_base / "reports").mkdir(exist_ok=True)
    
    (rare_base / "not_found_youtube").mkdir(exist_ok=True)
    (rare_base / "potentially_rare").mkdir(exist_ok=True)
    (rare_base / "reports").mkdir(exist_ok=True)
    
    return archive_base, rare_base

def categorize_files(analysis_data):
    """Categorize files based on YouTube availability"""
    found_on_youtube = []
    not_found = []
    potentially_rare = []
    
    for item in analysis_data:
        youtube_status = item.get('youtube_status', '').lower()
        
        if 'found on youtube' in youtube_status:
            found_on_youtube.append(item)
        elif 'not found' in youtube_status:
            not_found.append(item)
        elif 'poor matches' in youtube_status or 'potentially rare' in youtube_status:
            potentially_rare.append(item)
    
    return found_on_youtube, not_found, potentially_rare

def generate_move_script(source_base, archive_base, rare_base, found_files, not_found_files, rare_files):
    """Generate bash script to perform the actual file moves"""
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    script_path = f"music_archive_moves_{timestamp}.sh"
    
    with open(script_path, 'w') as f:
        f.write("#!/bin/bash\n")
        f.write("# Music Archive Script - Generated automatically\n")
        f.write(f"# Created: {datetime.now()}\n\n")
        f.write("set -e  # Exit on any error\n\n")
        
        f.write("echo 'Starting music archiving process...'\n\n")
        
        # Create directory structure
        f.write(f"# Create archive structure\n")
        f.write(f"mkdir -p '{archive_base}/found_on_youtube'\n")
        f.write(f"mkdir -p '{archive_base}/reports'\n")
        f.write(f"mkdir -p '{rare_base}/not_found_youtube'\n")
        f.write(f"mkdir -p '{rare_base}/potentially_rare'\n")
        f.write(f"mkdir -p '{rare_base}/reports'\n\n")
        
        # Move common files to archive
        f.write(f"# Moving {len(found_files)} common files to archive\n")
        f.write("echo 'Moving common files to archive...'\n")
        for item in found_files:
            file_path = item.get('file_path', '')
            if file_path:
                rel_path = os.path.relpath(file_path, source_base)
                dest_path = f"{archive_base}/found_on_youtube/{rel_path}"
                dest_dir = os.path.dirname(dest_path)
                f.write(f"mkdir -p '{dest_dir}'\n")
                f.write(f"mv '{file_path}' '{dest_path}'\n")
        
        f.write("\n# Moving rare files to curated collection\n")
        f.write("echo 'Organizing rare files...'\n")
        
        # Organize not found files
        for item in not_found_files:
            file_path = item.get('file_path', '')
            if file_path:
                rel_path = os.path.relpath(file_path, source_base)
                dest_path = f"{rare_base}/not_found_youtube/{rel_path}"
                dest_dir = os.path.dirname(dest_path)
                f.write(f"mkdir -p '{dest_dir}'\n")
                f.write(f"cp '{file_path}' '{dest_path}'\n")  # Copy, don't move
        
        # Organize potentially rare files
        for item in rare_files:
            file_path = item.get('file_path', '')
            if file_path:
                rel_path = os.path.relpath(file_path, source_base)
                dest_path = f"{rare_base}/potentially_rare/{rel_path}"
                dest_dir = os.path.dirname(dest_path)
                f.write(f"mkdir -p '{dest_dir}'\n")
                f.write(f"cp '{file_path}' '{dest_path}'\n")  # Copy, don't move
        
        f.write("\necho 'Archive process complete!'\n")
        f.write(f"echo 'Common files archived: {len(found_files)}'\n")
        f.write(f"echo 'Rare files preserved: {len(not_found_files + rare_files)}'\n")
    
    # Make script executable
    os.chmod(script_path, 0o755)
    return script_path

def generate_reports(archive_base, rare_base, found_files, not_found_files, rare_files):
    """Generate detailed reports"""
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Archive report
    archive_report = archive_base / "reports" / f"archived_files_{timestamp}.csv"
    with open(archive_report, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['Artist', 'Title', 'Album', 'File Path', 'YouTube Status'])
        for item in found_files:
            writer.writerow([
                item.get('artist', ''),
                item.get('title', ''),
                item.get('album', ''),
                item.get('file_path', ''),
                item.get('youtube_status', '')
            ])
    
    # Rare collection report
    rare_report = rare_base / "reports" / f"rare_collection_{timestamp}.csv"
    with open(rare_report, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['Artist', 'Title', 'Album', 'File Path', 'Rarity Level', 'YouTube Status'])
        
        for item in not_found_files:
            writer.writerow([
                item.get('artist', ''),
                item.get('title', ''),
                item.get('album', ''),
                item.get('file_path', ''),
                'Very Rare (Not Found)',
                item.get('youtube_status', '')
            ])
        
        for item in rare_files:
            writer.writerow([
                item.get('artist', ''),
                item.get('title', ''),
                item.get('album', ''),
                item.get('file_path', ''),
                'Potentially Rare',
                item.get('youtube_status', '')
            ])
    
    return archive_report, rare_report

def main():
    """Main archiving process"""
    
    # Configuration
    analysis_file = "jellyfin_music_analysis/music_analysis_full_20250608_022717.json"
    source_music_path = "/Volumes/jellyfin-media/music"  # Adjust as needed
    archive_base_path = "/Volumes/jellyfin-media"  # Will create subdirs here
    
    print("🎵 Music Collection Archiver")
    print("=" * 50)
    
    # Load analysis data
    print("Loading analysis data...")
    analysis_data = load_analysis_data(analysis_file)
    print(f"Loaded {len(analysis_data)} tracks")
    
    # Categorize files
    print("Categorizing files by rarity...")
    found_files, not_found_files, rare_files = categorize_files(analysis_data)
    
    print(f"📊 Results:")
    print(f"  • Found on YouTube (common): {len(found_files)}")
    print(f"  • Not found (very rare): {len(not_found_files)}")
    print(f"  • Potentially rare: {len(rare_files)}")
    print(f"  • Total rare to keep: {len(not_found_files) + len(rare_files)}")
    
    # Create archive structure
    print("Creating archive structure...")
    archive_base, rare_base = create_archive_structure(archive_base_path)
    
    # Generate move script
    print("Generating move script...")
    script_path = generate_move_script(
        source_music_path, archive_base, rare_base,
        found_files, not_found_files, rare_files
    )
    
    # Generate reports
    print("Generating reports...")
    archive_report, rare_report = generate_reports(
        archive_base, rare_base,
        found_files, not_found_files, rare_files
    )
    
    print(f"\n✅ Archive preparation complete!")
    print(f"📋 Move script: {script_path}")
    print(f"📊 Archive report: {archive_report}")
    print(f"⭐ Rare collection report: {rare_report}")
    print(f"\n🚀 Next steps:")
    print(f"1. Review the generated reports")
    print(f"2. Run: chmod +x {script_path}")
    print(f"3. Execute: ./{script_path}")
    print(f"\n⚠️  Always backup before running the move script!")

if __name__ == "__main__":
    main() 