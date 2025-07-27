#!/usr/bin/env python3
"""
🎬 Enhanced Ripper Integration with Browser MCP
Adds AI-powered metadata lookup using your browser MCP tools
"""

import json
import requests
import subprocess
from pathlib import Path
from datetime import datetime
from typing import Dict, Optional
import re

class EnhancedMediaProcessor:
    def __init__(self):
        self.holding_tank_base = Path("/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media-holding-tank")
        
    def lookup_movie_metadata(self, title: str, year: Optional[str] = None) -> Dict:
        """Use browser MCP to lookup movie metadata from IMDb/TMDb"""
        print(f"🔍 Looking up metadata for: {title} ({year})")
        
        # Construct search query
        search_query = title
        if year:
            search_query += f" {year}"
            
        metadata = {
            'title': title,
            'year': year,
            'imdb_id': None,
            'tmdb_id': None,
            'genre': [],
            'director': None,
            'cast': [],
            'plot': None,
            'poster_url': None,
            'rating': None
        }
        
        try:
            # Use browser MCP to search IMDb
            # This would integrate with your existing browser MCP setup
            # For now, we'll simulate the lookup
            
            # Example of how this could work with your browser MCP:
            # 1. Navigate to IMDb search
            # 2. Search for the movie
            # 3. Extract metadata from the first result
            # 4. Return structured data
            
            print(f"  🌐 Browser MCP lookup for: {search_query}")
            # Placeholder for actual browser MCP integration
            
        except Exception as e:
            print(f"  ⚠️ Metadata lookup failed: {e}")
            
        return metadata
        
    def lookup_music_metadata(self, artist: str, album: str) -> Dict:
        """Use browser MCP to lookup music metadata from Discogs/MusicBrainz"""
        print(f"🎵 Looking up music metadata: {artist} - {album}")
        
        metadata = {
            'artist': artist,
            'album': album,
            'year': None,
            'genre': [],
            'label': None,
            'discogs_id': None,
            'musicbrainz_id': None,
            'tracks': []
        }
        
        try:
            # This integrates with your existing Discogs browser MCP workflow
            # Similar to your chapter file processing
            print(f"  🌐 Discogs lookup for: {artist} - {album}")
            # Placeholder for actual integration
            
        except Exception as e:
            print(f"  ⚠️ Music metadata lookup failed: {e}")
            
        return metadata
        
    def enhance_movie_analysis(self, analysis: Dict) -> Dict:
        """Enhance movie analysis with online metadata"""
        title = analysis.get('title')
        year = analysis.get('year')
        
        if title:
            online_metadata = self.lookup_movie_metadata(title, year)
            analysis['enhanced_metadata'] = online_metadata
            
            # Update analysis with enhanced data
            if online_metadata.get('year') and not analysis.get('year'):
                analysis['year'] = online_metadata['year']
                
            if online_metadata.get('genre'):
                analysis['genre'] = online_metadata['genre']
                
        return analysis
        
    def enhance_music_analysis(self, analysis: Dict) -> Dict:
        """Enhance music analysis with online metadata"""
        title = analysis.get('title', '')
        
        # Try to extract artist and album from title
        # This could be enhanced with better parsing
        artist = None
        album = None
        
        # Common patterns for music files
        if ' - ' in title:
            parts = title.split(' - ')
            if len(parts) >= 2:
                artist = parts[0].strip()
                album = parts[1].strip()
                
        if artist and album:
            online_metadata = self.lookup_music_metadata(artist, album)
            analysis['enhanced_metadata'] = online_metadata
            
        return analysis
        
    def process_with_enhancement(self, file_path: Path) -> Dict:
        """Process a file with enhanced metadata lookup"""
        print(f"🎯 Enhanced processing: {file_path.name}")
        
        # First, do basic analysis (reuse existing logic)
        from media_holding_tank import MediaHoldingTank
        tank = MediaHoldingTank()
        analysis = tank.analyze_media_file(file_path)
        
        # Then enhance with online metadata
        content_type = analysis.get('content_type')
        
        if content_type == 'movie':
            analysis = self.enhance_movie_analysis(analysis)
        elif content_type in ['music', 'concert']:
            analysis = self.enhance_music_analysis(analysis)
            
        # Save enhanced analysis
        enhanced_file = self.holding_tank_base / 'ready' / f"{file_path.stem}_enhanced.json"
        enhanced_file.parent.mkdir(exist_ok=True)
        with open(enhanced_file, 'w') as f:
            json.dump(analysis, f, indent=2)
            
        return analysis
        
    def create_jellyfin_nfo(self, analysis: Dict, output_path: Path):
        """Create Jellyfin-compatible .nfo file with metadata"""
        content_type = analysis.get('content_type')
        enhanced_metadata = analysis.get('enhanced_metadata', {})
        
        if content_type == 'movie' and enhanced_metadata:
            # Create movie.nfo file
            nfo_content = self.create_movie_nfo(enhanced_metadata)
            nfo_file = output_path.parent / f"{output_path.stem}.nfo"
            with open(nfo_file, 'w') as f:
                f.write(nfo_content)
            print(f"  📄 Created NFO file: {nfo_file}")
            
    def create_movie_nfo(self, metadata: Dict) -> str:
        """Create movie NFO content"""
        nfo = ['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>']
        nfo.append('<movie>')
        
        if metadata.get('title'):
            nfo.append(f'  <title>{metadata["title"]}</title>')
        if metadata.get('year'):
            nfo.append(f'  <year>{metadata["year"]}</year>')
        if metadata.get('plot'):
            nfo.append(f'  <plot>{metadata["plot"]}</plot>')
        if metadata.get('director'):
            nfo.append(f'  <director>{metadata["director"]}</director>')
        if metadata.get('rating'):
            nfo.append(f'  <rating>{metadata["rating"]}</rating>')
            
        for genre in metadata.get('genre', []):
            nfo.append(f'  <genre>{genre}</genre>')
            
        for actor in metadata.get('cast', []):
            nfo.append(f'  <actor><name>{actor}</name></actor>')
            
        nfo.append('</movie>')
        return '\n'.join(nfo)

def main():
    """CLI interface for enhanced processing"""
    import sys
    
    if len(sys.argv) < 2:
        print("🎬 Enhanced Media Processor")
        print("Usage:")
        print("  python3 enhanced_ripper_integration.py process <file>   # Process single file")
        print("  python3 enhanced_ripper_integration.py enhance <dir>    # Enhance directory")
        return
        
    processor = EnhancedMediaProcessor()
    command = sys.argv[1].lower()
    
    if command == 'process' and len(sys.argv) > 2:
        file_path = Path(sys.argv[2])
        if file_path.exists():
            analysis = processor.process_with_enhancement(file_path)
            print(f"✅ Enhanced processing complete")
        else:
            print(f"❌ File not found: {file_path}")
            
    elif command == 'enhance' and len(sys.argv) > 2:
        dir_path = Path(sys.argv[2])
        if dir_path.exists() and dir_path.is_dir():
            for file_path in dir_path.iterdir():
                if file_path.is_file() and processor.is_media_file(file_path):
                    processor.process_with_enhancement(file_path)
            print(f"✅ Enhanced processing complete for directory")
        else:
            print(f"❌ Directory not found: {dir_path}")
    else:
        print(f"❌ Unknown command or missing arguments")

if __name__ == "__main__":
    main() 