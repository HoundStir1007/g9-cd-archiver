#!/usr/bin/env python3
"""
Music YouTube Availability Checker
==================================

Scans a music collection and checks YouTube for availability of each track.
Identifies potentially rare or hard-to-find music based on search results.

Requirements:
    pip install mutagen youtube-search-python fuzzywuzzy python-levenshtein colorama

Usage:
    python music_youtube_checker.py /path/to/music/folder
"""

import os
import sys
import json
import csv
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import argparse
from datetime import datetime

try:
    from mutagen import File as MutagenFile
    from mutagen.id3 import ID3NoHeaderError
except ImportError:
    print("❌ Missing required library: pip install mutagen")
    sys.exit(1)

try:
    from youtubesearchpython import VideosSearch
except ImportError:
    print("❌ Missing required library: pip install youtube-search-python")
    sys.exit(1)

try:
    from fuzzywuzzy import fuzz
except ImportError:
    print("❌ Missing required library: pip install fuzzywuzzy python-levenshtein")
    sys.exit(1)

try:
    from colorama import init, Fore, Style
    init()  # Initialize colorama for cross-platform colored output
except ImportError:
    print("❌ Missing required library: pip install colorama")
    sys.exit(1)

class MusicYouTubeChecker:
    def __init__(self, music_folder: str, output_dir: str = "music_analysis"):
        self.music_folder = Path(music_folder)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
        # Supported audio formats
        self.audio_extensions = {'.mp3', '.flac', '.m4a', '.aac', '.ogg', '.wav', '.wma'}
        
        # Results storage
        self.results = []
        self.stats = {
            'total_files': 0,
            'processed_files': 0,
            'no_metadata': 0,
            'youtube_found': 0,
            'youtube_not_found': 0,
            'potential_rare': 0,
            'errors': 0
        }

    def extract_metadata(self, file_path: Path) -> Optional[Dict[str, str]]:
        """Extract artist, title, and other metadata from audio file."""
        try:
            audio_file = MutagenFile(file_path)
            if audio_file is None:
                return None
            
            metadata = {}
            
            # Try to get common tags from different formats
            if hasattr(audio_file, 'tags') and audio_file.tags:
                tags = audio_file.tags
                
                # Common tag mappings for different formats
                artist_tags = ['TPE1', 'ARTIST', '\xa9ART', 'Artist']
                title_tags = ['TIT2', 'TITLE', '\xa9nam', 'Title']
                album_tags = ['TALB', 'ALBUM', '\xa9alb', 'Album']
                date_tags = ['TDRC', 'DATE', '\xa9day', 'Date']
                
                # Extract artist
                for tag in artist_tags:
                    if tag in tags:
                        artist = str(tags[tag][0]) if isinstance(tags[tag], list) else str(tags[tag])
                        metadata['artist'] = artist.strip()
                        break
                
                # Extract title
                for tag in title_tags:
                    if tag in tags:
                        title = str(tags[tag][0]) if isinstance(tags[tag], list) else str(tags[tag])
                        metadata['title'] = title.strip()
                        break
                
                # Extract album
                for tag in album_tags:
                    if tag in tags:
                        album = str(tags[tag][0]) if isinstance(tags[tag], list) else str(tags[tag])
                        metadata['album'] = album.strip()
                        break
                
                # Extract year
                for tag in date_tags:
                    if tag in tags:
                        date = str(tags[tag][0]) if isinstance(tags[tag], list) else str(tags[tag])
                        metadata['year'] = date.strip()[:4]  # Get just the year
                        break
            
            # Fallback to filename if no metadata
            if not metadata.get('artist') or not metadata.get('title'):
                filename = file_path.stem
                # Try to parse "Artist - Title" format
                if ' - ' in filename:
                    parts = filename.split(' - ', 1)
                    if not metadata.get('artist'):
                        metadata['artist'] = parts[0].strip()
                    if not metadata.get('title'):
                        metadata['title'] = parts[1].strip()
                else:
                    if not metadata.get('title'):
                        metadata['title'] = filename
            
            return metadata if metadata.get('artist') or metadata.get('title') else None
            
        except Exception as e:
            print(f"⚠️  Error reading {file_path.name}: {e}")
            return None

    def search_youtube(self, artist: str, title: str, max_results: int = 5) -> List[Dict]:
        """Search YouTube for the given artist and title."""
        try:
            # Create search query
            query = f"{artist} {title}".strip()
            if not query:
                return []
            
            # Search YouTube
            search = VideosSearch(query, limit=max_results)
            results = search.result()
            
            youtube_results = []
            for video in results.get('result', []):
                youtube_results.append({
                    'title': video.get('title', ''),
                    'channel': video.get('channel', {}).get('name', ''),
                    'duration': video.get('duration', ''),
                    'views': video.get('viewCount', {}).get('short', '0'),
                    'url': video.get('link', ''),
                    'published': video.get('publishedTime', '')
                })
            
            return youtube_results
            
        except Exception as e:
            print(f"⚠️  YouTube search error for '{artist} - {title}': {e}")
            return []

    def calculate_match_score(self, original_artist: str, original_title: str, 
                            youtube_result: Dict) -> Tuple[int, str]:
        """Calculate how well a YouTube result matches the original track."""
        yt_title = youtube_result.get('title', '').lower()
        yt_channel = youtube_result.get('channel', '').lower()
        
        original_artist_lower = original_artist.lower()
        original_title_lower = original_title.lower()
        
        # Check for exact matches
        if (original_artist_lower in yt_title or original_artist_lower in yt_channel) and \
           original_title_lower in yt_title:
            return 95, "Excellent match"
        
        # Calculate fuzzy matching scores
        title_score = fuzz.partial_ratio(original_title_lower, yt_title)
        artist_in_title = fuzz.partial_ratio(original_artist_lower, yt_title)
        artist_in_channel = fuzz.partial_ratio(original_artist_lower, yt_channel)
        
        # Best artist match (either in title or channel)
        artist_score = max(artist_in_title, artist_in_channel)
        
        # Combined score
        combined_score = (title_score * 0.6) + (artist_score * 0.4)
        
        # Determine match quality
        if combined_score >= 85:
            return int(combined_score), "Very good match"
        elif combined_score >= 70:
            return int(combined_score), "Good match"
        elif combined_score >= 50:
            return int(combined_score), "Possible match"
        else:
            return int(combined_score), "Poor match"

    def analyze_track(self, file_path: Path, metadata: Dict) -> Dict:
        """Analyze a single track for YouTube availability."""
        artist = metadata.get('artist', 'Unknown Artist')
        title = metadata.get('title', 'Unknown Title')
        
        print(f"🔍 Searching: {artist} - {title}")
        
        # Search YouTube
        youtube_results = self.search_youtube(artist, title)
        
        # Analyze results
        best_match_score = 0
        best_match_quality = "No results"
        analysis = "❌ Not found on YouTube"
        
        if youtube_results:
            # Find best matching result
            for result in youtube_results:
                score, quality = self.calculate_match_score(artist, title, result)
                if score > best_match_score:
                    best_match_score = score
                    best_match_quality = quality
            
            # Determine overall analysis
            if best_match_score >= 85:
                analysis = "✅ Readily available"
                self.stats['youtube_found'] += 1
            elif best_match_score >= 50:
                analysis = "⚠️  Available but might be different version"
                self.stats['youtube_found'] += 1
            else:
                analysis = "❓ Poor matches - potentially rare"
                self.stats['potential_rare'] += 1
        else:
            analysis = "❌ Not found - likely rare"
            self.stats['potential_rare'] += 1
            self.stats['youtube_not_found'] += 1
        
        return {
            'file_path': str(file_path),
            'filename': file_path.name,
            'artist': artist,
            'title': title,
            'album': metadata.get('album', ''),
            'year': metadata.get('year', ''),
            'youtube_results': len(youtube_results),
            'best_match_score': best_match_score,
            'match_quality': best_match_quality,
            'analysis': analysis,
            'youtube_details': youtube_results[:3]  # Keep top 3 results
        }

    def scan_music_folder(self) -> None:
        """Scan the music folder and analyze all audio files."""
        print(f"🎵 Scanning music folder: {self.music_folder}")
        print(f"📁 Results will be saved to: {self.output_dir}")
        print("=" * 60)
        
        audio_files = []
        for ext in self.audio_extensions:
            audio_files.extend(self.music_folder.rglob(f"*{ext}"))
        
        self.stats['total_files'] = len(audio_files)
        print(f"📊 Found {len(audio_files)} audio files to analyze\n")
        
        for i, file_path in enumerate(audio_files, 1):
            print(f"[{i}/{len(audio_files)}] Processing: {file_path.name}")
            
            # Extract metadata
            metadata = self.extract_metadata(file_path)
            if not metadata:
                print(f"❌ No metadata found for {file_path.name}")
                self.stats['no_metadata'] += 1
                continue
            
            try:
                # Analyze track
                result = self.analyze_track(file_path, metadata)
                self.results.append(result)
                self.stats['processed_files'] += 1
                
                # Print result
                color = Fore.GREEN if "✅" in result['analysis'] else \
                       Fore.YELLOW if "⚠️" in result['analysis'] else Fore.RED
                print(f"   {color}{result['analysis']}{Style.RESET_ALL}")
                
            except Exception as e:
                print(f"❌ Error processing {file_path.name}: {e}")
                self.stats['errors'] += 1
            
            print()  # Add spacing

    def generate_reports(self) -> None:
        """Generate comprehensive reports of the analysis."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # 1. Detailed CSV Report
        csv_file = self.output_dir / f"music_analysis_detailed_{timestamp}.csv"
        with open(csv_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow([
                'File Path', 'Filename', 'Artist', 'Title', 'Album', 'Year',
                'YouTube Results', 'Best Match Score', 'Match Quality', 'Analysis'
            ])
            
            for result in self.results:
                writer.writerow([
                    result['file_path'], result['filename'], result['artist'],
                    result['title'], result['album'], result['year'],
                    result['youtube_results'], result['best_match_score'],
                    result['match_quality'], result['analysis']
                ])
        
        # 2. Rare/Hard-to-Find Report
        rare_tracks = [r for r in self.results if "rare" in r['analysis'].lower() or "not found" in r['analysis'].lower()]
        rare_file = self.output_dir / f"potentially_rare_tracks_{timestamp}.csv"
        with open(rare_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['Artist', 'Title', 'Album', 'Year', 'Filename', 'Analysis'])
            
            for track in sorted(rare_tracks, key=lambda x: x['artist']):
                writer.writerow([
                    track['artist'], track['title'], track['album'],
                    track['year'], track['filename'], track['analysis']
                ])
        
        # 3. JSON Report with Full Details
        json_file = self.output_dir / f"music_analysis_full_{timestamp}.json"
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump({
                'scan_date': datetime.now().isoformat(),
                'music_folder': str(self.music_folder),
                'statistics': self.stats,
                'results': self.results
            }, f, indent=2, ensure_ascii=False)
        
        # 4. Summary Report
        summary_file = self.output_dir / f"analysis_summary_{timestamp}.txt"
        with open(summary_file, 'w', encoding='utf-8') as f:
            f.write("MUSIC COLLECTION YOUTUBE AVAILABILITY ANALYSIS\n")
            f.write("=" * 50 + "\n\n")
            f.write(f"Scan Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Music Folder: {self.music_folder}\n\n")
            
            f.write("STATISTICS:\n")
            f.write(f"Total Files Found: {self.stats['total_files']}\n")
            f.write(f"Successfully Processed: {self.stats['processed_files']}\n")
            f.write(f"Files with No Metadata: {self.stats['no_metadata']}\n")
            f.write(f"Found on YouTube: {self.stats['youtube_found']}\n")
            f.write(f"Not Found on YouTube: {self.stats['youtube_not_found']}\n")
            f.write(f"Potentially Rare Tracks: {self.stats['potential_rare']}\n")
            f.write(f"Processing Errors: {self.stats['errors']}\n\n")
            
            if rare_tracks:
                f.write("POTENTIALLY RARE OR HARD-TO-FIND TRACKS:\n")
                f.write("-" * 40 + "\n")
                for track in sorted(rare_tracks, key=lambda x: x['artist']):
                    f.write(f"{track['artist']} - {track['title']}\n")
                    if track['album']:
                        f.write(f"  Album: {track['album']}\n")
                    f.write(f"  File: {track['filename']}\n")
                    f.write(f"  Status: {track['analysis']}\n\n")
        
        print(f"\n📊 Reports generated:")
        print(f"   • Detailed CSV: {csv_file}")
        print(f"   • Rare Tracks: {rare_file}")
        print(f"   • Full JSON: {json_file}")
        print(f"   • Summary: {summary_file}")

    def print_summary(self) -> None:
        """Print a summary of the analysis."""
        print("\n" + "=" * 60)
        print("🎵 MUSIC COLLECTION ANALYSIS SUMMARY")
        print("=" * 60)
        
        print(f"📁 Folder Scanned: {self.music_folder}")
        print(f"📊 Total Files: {self.stats['total_files']}")
        print(f"✅ Processed: {self.stats['processed_files']}")
        print(f"❌ No Metadata: {self.stats['no_metadata']}")
        print(f"🎬 Found on YouTube: {self.stats['youtube_found']}")
        print(f"❓ Potentially Rare: {self.stats['potential_rare']}")
        print(f"⚠️  Errors: {self.stats['errors']}")
        
        if self.stats['potential_rare'] > 0:
            print(f"\n🔍 {Fore.YELLOW}Found {self.stats['potential_rare']} potentially rare tracks!{Style.RESET_ALL}")
            print("   Check the 'potentially_rare_tracks_*.csv' file for details.")
        
        print(f"\n📈 YouTube Availability Rate: {(self.stats['youtube_found'] / max(self.stats['processed_files'], 1)) * 100:.1f}%")

def main():
    parser = argparse.ArgumentParser(description="Check music collection against YouTube availability")
    parser.add_argument("music_folder", help="Path to music folder to scan")
    parser.add_argument("--output", "-o", default="music_analysis", 
                       help="Output directory for reports (default: music_analysis)")
    parser.add_argument("--no-reports", action="store_true", 
                       help="Skip generating detailed reports")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.music_folder):
        print(f"❌ Music folder not found: {args.music_folder}")
        sys.exit(1)
    
    print("🎵 Music YouTube Availability Checker")
    print("=" * 40)
    
    # Create checker and run analysis
    checker = MusicYouTubeChecker(args.music_folder, args.output)
    
    try:
        checker.scan_music_folder()
        checker.print_summary()
        
        if not args.no_reports:
            checker.generate_reports()
        
    except KeyboardInterrupt:
        print(f"\n\n⏹️  Analysis interrupted by user")
        print(f"✅ Processed {checker.stats['processed_files']} files before stopping")
        if checker.results and not args.no_reports:
            checker.generate_reports()
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 