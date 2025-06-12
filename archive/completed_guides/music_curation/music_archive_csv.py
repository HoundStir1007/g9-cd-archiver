#!/usr/bin/env python3
"""
Music Collection Archiver (CSV-based)
Moves easily-found tracks to archive, keeps rare tracks in Jellyfin
"""

import csv
import os
from pathlib import Path
from datetime import datetime

def load_rare_tracks_csv(csv_file):
    """Load the rare tracks from CSV"""
    rare_tracks = []
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            rare_tracks.append(row)
    return rare_tracks

def load_detailed_analysis_csv(csv_file):
    """Load the full detailed analysis from CSV"""
    all_tracks = []
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            all_tracks.append(row)
    return all_tracks

def categorize_tracks(all_tracks, rare_tracks):
    """Separate rare tracks from common tracks"""
    
    # Create set of rare filenames for quick lookup
    rare_filenames = {track['Filename'] for track in rare_tracks}
    
    common_tracks = []
    rare_track_details = []
    
    for track in all_tracks:
        filename = track.get('Filename', '')
        if filename in rare_filenames:
            rare_track_details.append(track)
        else:
            # This is a common track (found easily on YouTube)
            common_tracks.append(track)
    
    return common_tracks, rare_track_details

def generate_archive_structure_script():
    """Generate script to create archive directories"""
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    script_path = f"create_archive_structure_{timestamp}.sh"
    
    with open(script_path, 'w') as f:
        f.write("#!/bin/bash\n")
        f.write("# Create Music Archive Structure\n")
        f.write(f"# Generated: {datetime.now()}\n\n")
        
        f.write("# Navigate to G9 Jellyfin directory\n")
        f.write("cd /mnt/paperless-ssd/jellyfin/\n\n")
        
        f.write("# Create archive directories\n")
        f.write("mkdir -p music_archive_common/found_on_youtube\n")
        f.write("mkdir -p music_archive_common/reports\n")
        f.write("mkdir -p music_rare_collection/very_rare\n")
        f.write("mkdir -p music_rare_collection/potentially_rare\n")
        f.write("mkdir -p music_rare_collection/reports\n\n")
        
        f.write("echo 'Archive structure created successfully!'\n")
        f.write("ls -la music_*\n")
    
    os.chmod(script_path, 0o755)
    return script_path

def generate_move_script(common_tracks, rare_tracks, base_music_path="/mnt/paperless-ssd/jellyfin/media/music"):
    """Generate script to move files"""
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    script_path = f"archive_music_files_{timestamp}.sh"
    
    with open(script_path, 'w') as f:
        f.write("#!/bin/bash\n")
        f.write("# Music Archiving Script - Move common files, keep rare ones\n")
        f.write(f"# Generated: {datetime.now()}\n")
        f.write(f"# Common tracks to archive: {len(common_tracks)}\n")
        f.write(f"# Rare tracks to keep: {len(rare_tracks)}\n\n")
        
        f.write("set -e  # Exit on any error\n")
        f.write("set -x  # Show commands being executed\n\n")
        
        f.write("echo 'Starting music archiving process...'\n")
        f.write(f"echo 'Working directory: {base_music_path}'\n")
        f.write(f"cd '{base_music_path}'\n\n")
        
        f.write(f"# Archive {len(common_tracks)} common files\n")
        f.write("echo 'Moving common files to archive...'\n")
        
        move_count = 0
        for track in common_tracks:
            filename = track.get('Filename', '').strip()
            if filename and filename != 'Filename':  # Skip header row if present
                # Create safe path with quotes
                source = f"'{filename}'"
                
                # Create destination path preserving directory structure
                dest_dir = "../music_archive_common/found_on_youtube"
                dest = f"'{dest_dir}/{filename}'"
                
                f.write(f"# Moving: {filename}\n")
                f.write(f"if [ -f {source} ]; then\n")
                f.write(f"  mkdir -p $(dirname {dest})\n")
                f.write(f"  mv {source} {dest}\n")
                f.write(f"  echo 'Moved: {filename}'\n")
                f.write(f"else\n")
                f.write(f"  echo 'File not found: {filename}'\n")
                f.write(f"fi\n\n")
                
                move_count += 1
                
                # Add progress indicator every 100 files
                if move_count % 100 == 0:
                    f.write(f"echo 'Progress: {move_count}/{len(common_tracks)} files moved'\n\n")
        
        f.write("echo 'Archiving complete!'\n")
        f.write(f"echo 'Files archived: {len(common_tracks)}'\n")
        f.write(f"echo 'Rare files remaining in music/: {len(rare_tracks)}'\n")
        f.write("echo 'Checking final status...'\n")
        f.write("ls -la | head -20\n")
        f.write("echo '... (showing first 20 files)'\n")
        f.write(f"echo 'Total files remaining: '$(ls -1 | wc -l)\n")
    
    os.chmod(script_path, 0o755)
    return script_path

def generate_reports(common_tracks, rare_tracks):
    """Generate detailed reports"""
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Common tracks report
    common_report = f"common_tracks_to_archive_{timestamp}.csv"
    with open(common_report, 'w', newline='', encoding='utf-8') as f:
        if common_tracks:
            fieldnames = common_tracks[0].keys()
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(common_tracks)
    
    # Rare tracks report
    rare_report = f"rare_tracks_collection_{timestamp}.csv"
    with open(rare_report, 'w', newline='', encoding='utf-8') as f:
        if rare_tracks:
            fieldnames = rare_tracks[0].keys()
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rare_tracks)
    
    return common_report, rare_report

def main():
    """Main archiving process"""
    
    print("🎵 Music Collection Archiver (CSV Edition)")
    print("=" * 55)
    
    # File paths
    rare_tracks_csv = "jellyfin_music_analysis/potentially_rare_tracks_20250608_022717.csv"
    detailed_csv = "jellyfin_music_analysis/music_analysis_detailed_20250608_022717.csv"
    
    # Load data
    print("Loading rare tracks list...")
    rare_tracks = load_rare_tracks_csv(rare_tracks_csv)
    print(f"Found {len(rare_tracks)} rare tracks")
    
    print("Loading detailed analysis...")
    all_tracks = load_detailed_analysis_csv(detailed_csv)
    print(f"Loaded {len(all_tracks)} total analyzed tracks")
    
    # Categorize
    print("Categorizing tracks...")
    common_tracks, rare_track_details = categorize_tracks(all_tracks, rare_tracks)
    
    print(f"\n📊 Final Results:")
    print(f"  • Common tracks (to archive): {len(common_tracks)}")
    print(f"  • Rare tracks (to keep): {len(rare_track_details)}")
    print(f"  • Unprocessed files: {38375 - len(all_tracks)}")
    
    # Generate scripts and reports
    print("\nGenerating archive structure script...")
    structure_script = generate_archive_structure_script()
    
    print("Generating move script...")
    move_script = generate_move_script(common_tracks, rare_track_details)
    
    print("Generating reports...")
    common_report, rare_report = generate_reports(common_tracks, rare_track_details)
    
    print(f"\n✅ Archive preparation complete!")
    print(f"📁 Archive structure script: {structure_script}")
    print(f"📦 Move script: {move_script}")
    print(f"📊 Common tracks report: {common_report}")
    print(f"⭐ Rare tracks report: {rare_report}")
    
    print(f"\n🚀 Execute on G9 server:")
    print(f"1. scp {structure_script} gmk@100.91.157.19:~/")
    print(f"2. scp {move_script} gmk@100.91.157.19:~/")
    print(f"3. ssh gmk@100.91.157.19")
    print(f"4. ./{structure_script}")
    print(f"5. ./{move_script}")
    
    print(f"\n⚠️  This will move {len(common_tracks)} files to archive!")
    print(f"   Your Jellyfin will then have only {len(rare_track_details)} rare tracks")
    print(f"   Plus {38375 - len(all_tracks)} unprocessed files")
    
    # Show some examples
    print(f"\n🎵 Examples of tracks being ARCHIVED (common):")
    for i, track in enumerate(common_tracks[:5]):
        artist = track.get('Artist', 'Unknown')
        title = track.get('Title', 'Unknown')
        print(f"  {i+1}. {artist} - {title}")
    if len(common_tracks) > 5:
        print(f"  ... and {len(common_tracks)-5} more")
        
    print(f"\n⭐ Examples of tracks being KEPT (rare):")
    for i, track in enumerate(rare_track_details[:5]):
        artist = track.get('Artist', 'Unknown')
        title = track.get('Title', 'Unknown')
        print(f"  {i+1}. {artist} - {title}")
    if len(rare_track_details) > 5:
        print(f"  ... and {len(rare_track_details)-5} more")

if __name__ == "__main__":
    main() 