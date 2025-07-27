#!/usr/bin/env python3
"""
🎬 AI Media Holding Tank - Smart Media Organization for Jellyfin
Automatically sorts and organizes ripped media using AI analysis
"""

import os
import sys
import json
import shutil
import re
import subprocess
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Tuple
import magic

class MediaHoldingTank:
    def __init__(self):
        self.holding_tank_base = Path("/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media-holding-tank")
        self.jellyfin_base = Path("/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media")
        
        # Holding tank structure
        self.stages = {
            'incoming': self.holding_tank_base / 'incoming',
            'analyzing': self.holding_tank_base / 'analyzing', 
            'processed': self.holding_tank_base / 'processed',
            'ready': self.holding_tank_base / 'ready',
            'failed': self.holding_tank_base / 'failed'
        }
        
        # Jellyfin target directories
        self.jellyfin_targets = {
            'movies': self.jellyfin_base / 'movies',
            'tv': self.jellyfin_base / 'tv',
            'music': self.jellyfin_base / 'music',
            'home-videos': self.jellyfin_base / 'home-videos',
            'comedy': self.jellyfin_base / 'Stand-Up',
            'concerts': self.jellyfin_base / 'Music Videos and Concerts',
            'books': self.jellyfin_base / 'books'
        }
        
        self.setup_directories()
        
    def setup_directories(self):
        """Create holding tank directory structure"""
        print("🏗️ Setting up holding tank directories...")
        for stage_name, stage_path in self.stages.items():
            stage_path.mkdir(parents=True, exist_ok=True)
            print(f"  ✅ {stage_name}: {stage_path}")
            
    def analyze_media_file(self, file_path: Path) -> Dict:
        """AI-powered media file analysis"""
        print(f"🔍 Analyzing: {file_path.name}")
        
        # Get file info
        file_info = {
            'path': str(file_path),
            'name': file_path.name,
            'size_mb': file_path.stat().st_size / (1024 * 1024),
            'extension': file_path.suffix.lower(),
            'timestamp': datetime.now().isoformat()
        }
        
        # Detect file type
        try:
            mime = magic.from_file(str(file_path), mime=True)
            file_info['mime_type'] = mime
        except:
            file_info['mime_type'] = 'unknown'
            
        # Analyze filename for content type and metadata
        content_analysis = self.analyze_filename(file_path.name)
        file_info.update(content_analysis)
        
        # Get media metadata if video/audio
        if self.is_media_file(file_path):
            media_info = self.get_media_metadata(file_path)
            file_info.update(media_info)
            
        return file_info
        
    def analyze_filename(self, filename: str) -> Dict:
        """Extract metadata from filename using AI pattern recognition"""
        analysis = {
            'content_type': 'unknown',
            'title': None,
            'year': None,
            'season': None,
            'episode': None,
            'quality_tags': [],
            'source_tags': [],
            'clean_name': None
        }
        
        # Clean filename 
        clean = filename.replace('_', ' ').replace('.', ' ')
        
        # Extract year
        year_match = re.search(r'\b(19|20)\d{2}\b', clean)
        if year_match:
            analysis['year'] = year_match.group()
            
        # Detect content type patterns
        if re.search(r'\b(s\d+e\d+|season|episode)\b', clean, re.I):
            analysis['content_type'] = 'tv'
            # Extract season/episode
            se_match = re.search(r's(\d+)e(\d+)', clean, re.I)
            if se_match:
                analysis['season'] = int(se_match.group(1))
                analysis['episode'] = int(se_match.group(2))
        elif re.search(r'\b(concert|live|tour|performance)\b', clean, re.I):
            analysis['content_type'] = 'concert'
        elif re.search(r'\b(stand.?up|comedy|comedian)\b', clean, re.I):
            analysis['content_type'] = 'comedy'
        elif re.search(r'\b(album|cd|track|music)\b', clean, re.I):
            analysis['content_type'] = 'music'
        elif re.search(r'\b(audiobook|book|chapter)\b', clean, re.I):
            analysis['content_type'] = 'audiobook'
        else:
            analysis['content_type'] = 'movie'  # Default assumption
            
        # Extract quality/source tags
        quality_tags = re.findall(r'\b(1080p|720p|480p|4k|uhd|hd|bluray|dvd|web|webrip|brrip|x264|x265|h264|h265)\b', clean, re.I)
        analysis['quality_tags'] = [tag.lower() for tag in quality_tags]
        
        # Extract and clean title
        title = clean
        # Remove year, quality tags, file extension
        if analysis['year']:
            title = re.sub(rf'\b{analysis["year"]}\b', '', title)
        for tag in analysis['quality_tags']:
            title = re.sub(rf'\b{re.escape(tag)}\b', '', title, flags=re.I)
        title = re.sub(r'\.(mkv|mp4|avi|mov|m4v|wmv|flv)$', '', title, flags=re.I)
        title = re.sub(r'\s+', ' ', title).strip()
        
        analysis['title'] = title
        analysis['clean_name'] = self.create_clean_name(analysis)
        
        return analysis
        
    def create_clean_name(self, analysis: Dict) -> str:
        """Create properly formatted filename for Jellyfin"""
        title = analysis.get('title', 'Unknown').strip()
        year = analysis.get('year')
        content_type = analysis.get('content_type')
        
        if content_type == 'tv':
            season = analysis.get('season')
            episode = analysis.get('episode')
            if season and episode:
                return f"{title} - S{season:02d}E{episode:02d}"
        
        if year:
            return f"{title} ({year})"
        else:
            return title
            
    def is_media_file(self, file_path: Path) -> bool:
        """Check if file is a media file"""
        media_extensions = {'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.wmv', '.flv', 
                          '.mp3', '.flac', '.wav', '.aac', '.ogg', '.m4a'}
        return file_path.suffix.lower() in media_extensions
        
    def get_media_metadata(self, file_path: Path) -> Dict:
        """Extract technical metadata using ffprobe"""
        try:
            cmd = [
                'ffprobe', '-v', 'quiet', '-print_format', 'json',
                '-show_format', '-show_streams', str(file_path)
            ]
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                metadata = json.loads(result.stdout)
                return {
                    'duration': metadata.get('format', {}).get('duration'),
                    'bitrate': metadata.get('format', {}).get('bit_rate'),
                    'video_codec': self.get_video_codec(metadata),
                    'audio_codec': self.get_audio_codec(metadata),
                    'resolution': self.get_resolution(metadata)
                }
        except Exception as e:
            print(f"  ⚠️ Metadata extraction failed: {e}")
        return {}
        
    def get_video_codec(self, metadata: Dict) -> Optional[str]:
        """Extract video codec from ffprobe metadata"""
        for stream in metadata.get('streams', []):
            if stream.get('codec_type') == 'video':
                return stream.get('codec_name')
        return None
        
    def get_audio_codec(self, metadata: Dict) -> Optional[str]:
        """Extract audio codec from ffprobe metadata"""
        for stream in metadata.get('streams', []):
            if stream.get('codec_type') == 'audio':
                return stream.get('codec_name')
        return None
        
    def get_resolution(self, metadata: Dict) -> Optional[str]:
        """Extract video resolution from ffprobe metadata"""
        for stream in metadata.get('streams', []):
            if stream.get('codec_type') == 'video':
                width = stream.get('width')
                height = stream.get('height')
                if width and height:
                    return f"{width}x{height}"
        return None
        
    def process_incoming_media(self):
        """Process all files in incoming directory"""
        incoming_dir = self.stages['incoming']
        if not any(incoming_dir.iterdir()):
            print("📥 No new media in holding tank")
            return
            
        print(f"🚀 Processing incoming media from: {incoming_dir}")
        
        for item_path in incoming_dir.iterdir():
            if item_path.is_file() and self.is_media_file(item_path):
                self.process_single_file(item_path)
            elif item_path.is_dir():
                self.process_directory(item_path)
                
    def process_single_file(self, file_path: Path):
        """Process a single media file"""
        print(f"\n📁 Processing: {file_path.name}")
        
        # Move to analyzing stage
        analyzing_path = self.stages['analyzing'] / file_path.name
        shutil.move(str(file_path), str(analyzing_path))
        
        try:
            # Analyze the file
            analysis = self.analyze_media_file(analyzing_path)
            
            # Save analysis results (for debugging/review)
            analysis_file = self.stages['ready'] / f"{file_path.stem}_analysis.json" 
            analysis_file.parent.mkdir(exist_ok=True)
            with open(analysis_file, 'w') as f:
                json.dump(analysis, f, indent=2)
                
            # Determine target directory and filename
            target_info = self.get_target_location(analysis)
            
            if target_info:
                # Move to processed with new name
                processed_path = self.stages['processed'] / target_info['clean_filename']
                shutil.move(str(analyzing_path), str(processed_path))
                
                # Create deployment ready file
                self.prepare_for_deployment(processed_path, target_info, analysis)
                
                print(f"  ✅ Processed: {target_info['clean_filename']}")
                print(f"  📍 Target: {target_info['type']} library")
            else:
                # Move to failed
                failed_path = self.stages['failed'] / file_path.name
                shutil.move(str(analyzing_path), str(failed_path))
                print(f"  ❌ Failed to categorize: {file_path.name}")
                
        except Exception as e:
            # Move to failed on error
            failed_path = self.stages['failed'] / file_path.name
            if analyzing_path.exists():
                shutil.move(str(analyzing_path), str(failed_path))
            print(f"  ❌ Processing error: {e}")
            
    def process_directory(self, dir_path: Path):
        """Process a directory of media files (e.g., DVD rip with extras)"""
        print(f"\n📂 Processing directory: {dir_path.name}")
        
        # Move entire directory to analyzing
        analyzing_path = self.stages['analyzing'] / dir_path.name
        shutil.move(str(dir_path), str(analyzing_path))
        
        try:
            # Find main file and extras
            media_files = [f for f in analyzing_path.iterdir() if f.is_file() and self.is_media_file(f)]
            
            if not media_files:
                print(f"  ⚠️ No media files found in {dir_path.name}")
                failed_path = self.stages['failed'] / dir_path.name
                shutil.move(str(analyzing_path), str(failed_path))
                return
                
            # Analyze the directory structure
            main_file, extras = self.identify_main_and_extras(media_files)
            
            if main_file:
                analysis = self.analyze_media_file(main_file)
                target_info = self.get_target_location(analysis)
                
                if target_info:
                    # Create directory structure for movie with extras
                    self.process_movie_with_extras(analyzing_path, main_file, extras, target_info, analysis)
                    print(f"  ✅ Processed movie with {len(extras)} extras")
                else:
                    failed_path = self.stages['failed'] / dir_path.name
                    shutil.move(str(analyzing_path), str(failed_path))
                    print(f"  ❌ Failed to categorize directory")
            
        except Exception as e:
            failed_path = self.stages['failed'] / dir_path.name
            if analyzing_path.exists():
                shutil.move(str(analyzing_path), str(failed_path))
            print(f"  ❌ Directory processing error: {e}")
            
    def identify_main_and_extras(self, media_files: List[Path]) -> Tuple[Optional[Path], List[Path]]:
        """Identify main movie file and extras from a list of media files"""
        if len(media_files) == 1:
            return media_files[0], []
            
        # Sort by file size (main movie usually largest)
        sorted_files = sorted(media_files, key=lambda f: f.stat().st_size, reverse=True)
        
        main_file = sorted_files[0]
        extras = sorted_files[1:]
        
        return main_file, extras
        
    def process_movie_with_extras(self, source_dir: Path, main_file: Path, extras: List[Path], target_info: Dict, analysis: Dict):
        """Process a movie with extras for Jellyfin"""
        movie_name = target_info['clean_filename_no_ext']
        
        # Create movie directory in processed
        movie_dir = self.stages['processed'] / movie_name
        movie_dir.mkdir(exist_ok=True)
        
        # Move main file
        main_target = movie_dir / f"{movie_name}{main_file.suffix}"
        shutil.copy2(str(main_file), str(main_target))
        
        # Move extras with proper naming
        for i, extra_file in enumerate(extras):
            extra_name = f"{movie_name} - extra{i+1:02d}{extra_file.suffix}"
            extra_target = movie_dir / extra_name
            shutil.copy2(str(extra_file), str(extra_target))
            
        # Prepare for deployment
        self.prepare_for_deployment(movie_dir, target_info, analysis)
        
    def get_target_location(self, analysis: Dict) -> Optional[Dict]:
        """Determine target Jellyfin library and clean filename"""
        content_type = analysis.get('content_type', 'unknown')
        clean_name = analysis.get('clean_name', 'Unknown')
        extension = Path(analysis['path']).suffix
        
        type_mapping = {
            'movie': 'movies',
            'tv': 'tv', 
            'concert': 'concerts',
            'comedy': 'comedy',
            'music': 'music',
            'audiobook': 'books'
        }
        
        target_type = type_mapping.get(content_type)
        if not target_type:
            return None
            
        return {
            'type': target_type,
            'target_dir': self.jellyfin_targets[target_type],
            'clean_filename': f"{clean_name}{extension}",
            'clean_filename_no_ext': clean_name
        }
        
    def prepare_for_deployment(self, processed_path: Path, target_info: Dict, analysis: Dict):
        """Prepare processed media for deployment to Jellyfin"""
        ready_dir = self.stages['ready']
        
        # Create metadata file
        deployment_info = {
            'source_path': str(processed_path),
            'target_info': target_info,
            'analysis': analysis,
            'deployment_timestamp': datetime.now().isoformat(),
            'status': 'ready_for_deployment'
        }
        
        metadata_file = ready_dir / f"{target_info['clean_filename_no_ext']}_deployment.json"
        with open(metadata_file, 'w') as f:
            json.dump(deployment_info, f, indent=2)
            
        print(f"  📦 Ready for deployment: {metadata_file}")
        
    def deploy_to_jellyfin(self, metadata_file: Path):
        """Deploy processed media to Jellyfin libraries"""
        print(f"\n🚀 Deploying: {metadata_file.name}")
        
        with open(metadata_file) as f:
            deployment_info = json.load(f)
            
        source_path = Path(deployment_info['source_path'])
        target_info = deployment_info['target_info']
        target_dir = Path(target_info['target_dir'])
        
        try:
            if source_path.is_file():
                # Single file deployment
                target_file = target_dir / target_info['clean_filename']
                shutil.move(str(source_path), str(target_file))
                print(f"  ✅ Deployed file: {target_file}")
            elif source_path.is_dir():
                # Directory deployment (movie with extras)
                target_movie_dir = target_dir / source_path.name
                shutil.move(str(source_path), str(target_movie_dir))
                print(f"  ✅ Deployed directory: {target_movie_dir}")
                
            # Mark as deployed
            deployment_info['status'] = 'deployed'
            deployment_info['deployed_timestamp'] = datetime.now().isoformat()
            with open(metadata_file, 'w') as f:
                json.dump(deployment_info, f, indent=2)
                
        except Exception as e:
            print(f"  ❌ Deployment failed: {e}")
            
    def deploy_all_ready(self):
        """Deploy all ready media to Jellyfin"""
        ready_dir = self.stages['ready']
        deployment_files = list(ready_dir.glob("*_deployment.json"))
        
        if not deployment_files:
            print("📦 No media ready for deployment")
            return
            
        print(f"🚀 Deploying {len(deployment_files)} items to Jellyfin...")
        
        for metadata_file in deployment_files:
            self.deploy_to_jellyfin(metadata_file)
            
    def status_report(self):
        """Generate status report of holding tank"""
        print("\n📊 HOLDING TANK STATUS REPORT")
        print("=" * 50)
        
        for stage_name, stage_path in self.stages.items():
            if stage_path.exists():
                items = list(stage_path.iterdir())
                print(f"{stage_name.upper():>12}: {len(items)} items")
                if items and len(items) <= 5:  # Show details for small counts
                    for item in items:
                        print(f"{'':>15}- {item.name}")
                        
        print("\n🎯 JELLYFIN TARGETS:")
        for lib_name, lib_path in self.jellyfin_targets.items():
            if lib_path.exists():
                count = len([f for f in lib_path.iterdir() if f.is_file() or f.is_dir()])
                print(f"{lib_name.upper():>12}: {count} items")

def main():
    """Main CLI interface"""
    if len(sys.argv) < 2:
        print("🎬 AI Media Holding Tank")
        print("Usage:")
        print("  python media_holding_tank.py process    # Process incoming media")
        print("  python media_holding_tank.py deploy     # Deploy ready media to Jellyfin")  
        print("  python media_holding_tank.py status     # Show status report")
        print("  python media_holding_tank.py setup      # Setup directories only")
        return
        
    tank = MediaHoldingTank()
    command = sys.argv[1].lower()
    
    if command == 'setup':
        print("✅ Holding tank setup complete!")
    elif command == 'process':
        tank.process_incoming_media()
    elif command == 'deploy':
        tank.deploy_all_ready()
    elif command == 'status':
        tank.status_report()
    else:
        print(f"❌ Unknown command: {command}")

if __name__ == "__main__":
    main() 