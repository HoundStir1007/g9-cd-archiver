#!/usr/bin/env python3
"""
🎧 Audiobook Detection Script
Finds audio files in the music folder that are likely audiobooks
"""

import os
import re
import subprocess
import json
from pathlib import Path
from collections import defaultdict

# Configuration
MUSIC_DIR = "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/music"
AUDIO_EXTENSIONS = {'.mp3', '.m4a', '.flac', '.wav', '.aac', '.ogg'}

# Audiobook indicators
AUDIOBOOK_KEYWORDS = {
    'audiobook', 'book', 'chapter', 'part', 'volume', 'disc', 'cd',
    'narrated', 'narrator', 'read by', 'author', 'by ', ' - ',
    'chapter 1', 'chapter 2', 'chapter 3', 'chapter 4', 'chapter 5',
    'part 1', 'part 2', 'part 3', 'part 4', 'part 5',
    'disc 1', 'disc 2', 'disc 3', 'disc 4', 'disc 5'
}

# Comedy/Stand-up keywords (often misclassified as music)
COMEDY_KEYWORDS = {
    'comedy', 'stand-up', 'standup', 'stand up', 'comic', 'comedian',
    'live', 'performance', 'show', 'special', 'album'
}

def get_audio_duration(file_path):
    """Get audio file duration using ffprobe"""
    try:
        cmd = [
            'ffprobe', '-v', 'quiet', '-show_entries', 'format=duration',
            '-of', 'json', file_path
        ]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            data = json.loads(result.stdout)
            return float(data['format']['duration'])
        return None
    except:
        return None

def analyze_directory(directory):
    """Analyze directory for potential audiobooks"""
    potential_audiobooks = []
    comedy_albums = []
    long_tracks = []
    
    print(f"🔍 Analyzing music directory: {directory}")
    print("=" * 60)
    
    # Walk through all directories
    for root, dirs, files in os.walk(directory):
        audio_files = [f for f in files if Path(f).suffix.lower() in AUDIO_EXTENSIONS]
        
        if not audio_files:
            continue
            
        dir_path = Path(root)
        dir_name = dir_path.name.lower()
        parent_name = dir_path.parent.name.lower()
        
        # Check for audiobook indicators in directory name
        audiobook_score = 0
        comedy_score = 0
        
        # Check directory name for keywords
        for keyword in AUDIOBOOK_KEYWORDS:
            if keyword in dir_name or keyword in parent_name:
                audiobook_score += 1
                
        for keyword in COMEDY_KEYWORDS:
            if keyword in dir_name or keyword in parent_name:
                comedy_score += 1
        
        # Analyze file names and durations
        total_duration = 0
        long_files = 0
        chapter_files = 0
        
        for audio_file in audio_files:
            file_path = Path(root) / audio_file
            file_name = audio_file.lower()
            
            # Check file name for keywords
            for keyword in AUDIOBOOK_KEYWORDS:
                if keyword in file_name:
                    audiobook_score += 1
                    if 'chapter' in keyword:
                        chapter_files += 1
                        
            for keyword in COMEDY_KEYWORDS:
                if keyword in file_name:
                    comedy_score += 1
            
            # Get file duration
            duration = get_audio_duration(str(file_path))
            if duration:
                total_duration += duration
                # Files longer than 10 minutes might be audiobook chapters
                if duration > 600:  # 10 minutes
                    long_files += 1
        
        # Calculate average duration
        avg_duration = total_duration / len(audio_files) if audio_files else 0
        
        # Determine if this looks like an audiobook
        is_audiobook = False
        is_comedy = False
        
        # Audiobook indicators
        if (audiobook_score > 0 or 
            chapter_files > 0 or 
            (len(audio_files) > 5 and avg_duration > 1800) or  # 30+ min average
            (len(audio_files) > 10 and avg_duration > 900)):   # 15+ min average, many files
            is_audiobook = True
            
        # Comedy indicators
        if comedy_score > 0 and len(audio_files) > 1:
            is_comedy = True
        
        # Long tracks (potential audiobooks)
        if len(audio_files) == 1 and avg_duration > 3600:  # Single file > 1 hour
            long_tracks.append({
                'path': str(dir_path),
                'file': audio_files[0],
                'duration': avg_duration,
                'size': len(audio_files)
            })
        
        if is_audiobook or is_comedy:
            result = {
                'path': str(dir_path),
                'files': len(audio_files),
                'avg_duration': avg_duration,
                'total_duration': total_duration,
                'audiobook_score': audiobook_score,
                'comedy_score': comedy_score,
                'chapter_files': chapter_files,
                'long_files': long_files,
                'type': 'audiobook' if is_audiobook else 'comedy'
            }
            
            if is_audiobook:
                potential_audiobooks.append(result)
            elif is_comedy:
                comedy_albums.append(result)
    
    return potential_audiobooks, comedy_albums, long_tracks

def format_duration(seconds):
    """Format duration in human readable format"""
    if seconds is None:
        return "Unknown"
    
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    
    if hours > 0:
        return f"{hours}h {minutes}m"
    else:
        return f"{minutes}m"

def main():
    print("🎧 Audiobook Detection in Music Directory")
    print("=" * 50)
    
    if not os.path.exists(MUSIC_DIR):
        print(f"❌ Music directory not found: {MUSIC_DIR}")
        return
    
    # Analyze the directory
    audiobooks, comedy, long_tracks = analyze_directory(MUSIC_DIR)
    
    # Display results
    print(f"\n📚 POTENTIAL AUDIOBOOKS ({len(audiobooks)} found):")
    print("-" * 50)
    
    for item in sorted(audiobooks, key=lambda x: x['audiobook_score'], reverse=True):
        print(f"📖 {item['path']}")
        print(f"   Files: {item['files']} | Avg Duration: {format_duration(item['avg_duration'])}")
        print(f"   Total: {format_duration(item['total_duration'])} | Score: {item['audiobook_score']}")
        print(f"   Chapters: {item['chapter_files']} | Long files: {item['long_files']}")
        print()
    
    print(f"\n🎭 COMEDY/STAND-UP ALBUMS ({len(comedy)} found):")
    print("-" * 50)
    
    for item in sorted(comedy, key=lambda x: x['comedy_score'], reverse=True):
        print(f"🎤 {item['path']}")
        print(f"   Files: {item['files']} | Avg Duration: {format_duration(item['avg_duration'])}")
        print(f"   Total: {format_duration(item['total_duration'])} | Score: {item['comedy_score']}")
        print()
    
    print(f"\n⏰ LONG TRACKS (>1 hour) ({len(long_tracks)} found):")
    print("-" * 50)
    
    for item in long_tracks:
        print(f"⏱️  {item['path']}")
        print(f"   File: {item['file']} | Duration: {format_duration(item['duration'])}")
        print()
    
    # Summary
    print("=" * 50)
    print(f"📊 SUMMARY:")
    print(f"   Potential Audiobooks: {len(audiobooks)}")
    print(f"   Comedy Albums: {len(comedy)}")
    print(f"   Long Tracks: {len(long_tracks)}")
    print(f"   Total Items to Review: {len(audiobooks) + len(comedy) + len(long_tracks)}")
    
    # Save results to file
    results = {
        'audiobooks': audiobooks,
        'comedy': comedy,
        'long_tracks': long_tracks,
        'summary': {
            'audiobooks': len(audiobooks),
            'comedy': len(comedy),
            'long_tracks': len(long_tracks)
        }
    }
    
    with open('audiobook_analysis_results.json', 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"\n💾 Results saved to: audiobook_analysis_results.json")

if __name__ == "__main__":
    main() 