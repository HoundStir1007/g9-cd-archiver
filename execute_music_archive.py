#!/usr/bin/env python3
"""
Execute Music Archive via SMB Mount
Move common tracks to archive, keep rare tracks in music folder
"""

import csv
import shutil
import os
from pathlib import Path
from datetime import datetime

def load_csv_data():
    """Load the archiving data from our generated CSV files"""
    base_path = Path("/Users/marksakamoto/Desktop/home server research")
    
    # Load rare tracks to keep
    rare_csv = base_path / "rare_tracks_collection_20250608_152143.csv"
    rare_tracks = []
    with open(rare_csv, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        rare_tracks = [row for row in reader]
    
    # Load common tracks to archive
    common_csv = base_path / "common_tracks_to_archive_20250608_152143.csv"
    common_tracks = []
    with open(common_csv, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        common_tracks = [row for row in reader]
    
    return rare_tracks, common_tracks

def execute_archive(rare_tracks, common_tracks, dry_run=True):
    """Execute the archiving process"""
    
    # Paths
    music_source = Path("/Volumes/jellyfin-media/music")
    archive_dest = Path("/Volumes/jellyfin-media/music_archive_common/found_on_youtube")
    
    print(f"🎵 Music Archive Execution")
    print(f"{'=' * 50}")
    print(f"Mode: {'DRY RUN' if dry_run else 'LIVE EXECUTION'}")
    print(f"Source: {music_source}")
    print(f"Archive: {archive_dest}")
    print(f"Common tracks to move: {len(common_tracks)}")
    print(f"Rare tracks to keep: {len(rare_tracks)}")
    
    if not music_source.exists():
        print("❌ Music source directory not found!")
        return False
    
    # Create archive directory
    archive_dest.mkdir(parents=True, exist_ok=True)
    
    moved_count = 0
    error_count = 0
    
    print(f"\n🚀 Starting archive process...")
    
    for i, track in enumerate(common_tracks):
        # Use the full file path from CSV
        file_path = track.get('File Path', '').strip()
        if not file_path:
            continue
        
        # Convert full path to Path object
        source_file = Path(file_path)
        
        # Create relative path for archive (preserve directory structure)
        relative_path = source_file.relative_to(music_source)
        dest_file = archive_dest / relative_path
        
        # Progress indicator
        if i % 100 == 0:
            print(f"Progress: {i}/{len(common_tracks)} ({i/len(common_tracks)*100:.1f}%)")
        
        if source_file.exists():
            try:
                if dry_run:
                    print(f"[DRY RUN] Would move: {relative_path}")
                else:
                    # Create destination directory if needed
                    dest_file.parent.mkdir(parents=True, exist_ok=True)
                    shutil.move(str(source_file), str(dest_file))
                    if i % 50 == 0:  # Less verbose output for live run
                        print(f"✅ Moved: {relative_path}")
                moved_count += 1
            except Exception as e:
                print(f"❌ Error moving {relative_path}: {e}")
                error_count += 1
        else:
            print(f"⚠️  File not found: {file_path}")
            error_count += 1
    
    print(f"\n📊 Archive Results:")
    print(f"  • Files moved: {moved_count}")
    print(f"  • Errors: {error_count}")
    print(f"  • Rare tracks remaining: {len(rare_tracks)}")
    
    return error_count == 0

def main():
    """Main execution"""
    print("🎵 Music Collection Archiver - Live Execution")
    print("=" * 60)
    
    # Load data
    print("Loading track data...")
    rare_tracks, common_tracks = load_csv_data()
    
    print(f"Loaded {len(rare_tracks)} rare tracks to keep")
    print(f"Loaded {len(common_tracks)} common tracks to archive")
    
    # Ask for confirmation
    response = input(f"\n⚠️  This will move {len(common_tracks)} files to archive. Continue? (yes/no): ")
    if response.lower() != 'yes':
        print("Operation cancelled.")
        return
    
    # Ask for dry run first
    dry_run_response = input(f"Start with dry run to test? (yes/no): ")
    dry_run = dry_run_response.lower() == 'yes'
    
    # Execute
    success = execute_archive(rare_tracks, common_tracks, dry_run=dry_run)
    
    if success and dry_run:
        print(f"\n✅ Dry run completed successfully!")
        real_run = input(f"Execute real archive? (yes/no): ")
        if real_run.lower() == 'yes':
            execute_archive(rare_tracks, common_tracks, dry_run=False)
    
    print(f"\n🎉 Archive process complete!")
    print(f"Your Jellyfin music collection now contains only rare tracks!")

if __name__ == "__main__":
    main() 