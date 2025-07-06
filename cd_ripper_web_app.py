#!/usr/bin/env python3
"""
G9-Reborn Advanced CD-R Archiving System
Comprehensive disc processing with vintage CD-R specialization
"""

import os
import sys
import json
import time
import hashlib
import subprocess
import threading
import logging
from datetime import datetime
from pathlib import Path
from flask import Flask, render_template, request, jsonify, send_file
import requests
import mutagen
from mutagen.flac import FLAC
from mutagen.id3 import ID3, TIT2, TPE1, TALB, TDRC, TCON, APIC
import musicbrainzngs
import discid

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
CONFIG = {
    'BASE_PATH': '/mnt/paperless-ssd/digital_consolidation/cd_rips',
    'TEMP_PATH': '/tmp/cd_rip_temp',
    'USB_DEVICE': '/dev/sr0',  # USB optical drive
    'NOTIFICATION_URL': None,  # Webhook for mobile notifications
    'JELLYFIN_STRUCTURE': True,  # Optimize for Jellyfin media server
    'VINTAGE_MODE': True,  # Special handling for 1990s CD-Rs
    'C2_ERROR_DETECTION': True,
    'MAX_RETRY_ATTEMPTS': 4,
    'QUALITY_THRESHOLD': 0.95  # AccurateRip confidence threshold
}

# Global state
current_job = {
    'status': 'idle',
    'disc_info': {},
    'progress': 0,
    'tracks_completed': 0,
    'total_tracks': 0,
    'errors': [],
    'retry_count': 0,
    'quality_metrics': {}
}

class AdvancedCDRipper:
    def __init__(self):
        self.setup_musicbrainz()
        self.ensure_directories()
        
    def setup_musicbrainz(self):
        """Initialize MusicBrainz client for superior metadata"""
        musicbrainzngs.set_useragent(
            "G9-CD-Archiver", "1.0", "https://github.com/user/g9-cd-archiver"
        )
        
    def ensure_directories(self):
        """Create directory structure optimized for Jellyfin"""
        dirs = [
            CONFIG['BASE_PATH'],
            CONFIG['TEMP_PATH'],
            f"{CONFIG['BASE_PATH']}/Music",
            f"{CONFIG['BASE_PATH']}/Retry_Queue",
            f"{CONFIG['BASE_PATH']}/Data_Discs",
            f"{CONFIG['BASE_PATH']}/Mixed_Mode",
            f"{CONFIG['BASE_PATH']}/Quality_Issues"
        ]
        for dir_path in dirs:
            Path(dir_path).mkdir(parents=True, exist_ok=True)
    
    def detect_disc(self):
        """Advanced disc detection with hardware capability assessment"""
        try:
            # Check if disc is present
            result = subprocess.run(['lsblk', CONFIG['USB_DEVICE']], 
                                  capture_output=True, text=True)
            if result.returncode != 0:
                return None
                
            # Get disc information using libcdio
            disc_info = self.get_disc_technical_info()
            
            # Determine disc type and capabilities
            disc_info['type'] = self.classify_disc_type(disc_info)
            disc_info['vintage_indicators'] = self.assess_vintage_disc(disc_info)
            disc_info['drive_capabilities'] = self.assess_drive_capabilities()
            
            return disc_info
            
        except Exception as e:
            logger.error(f"Disc detection error: {e}")
            return None
    
    def get_disc_technical_info(self):
        """Extract comprehensive disc technical metadata"""
        info = {
            'disc_id': None,
            'manufacturer': 'Unknown',
            'capacity': 'Unknown',
            'sessions': 1,
            'tracks': [],
            'atip_data': {},
            'burn_date': None,
            'media_type': 'Unknown'
        }
        
        try:
            # Get disc ID for AccurateRip
            disc = discid.read(CONFIG['USB_DEVICE'])
            info['disc_id'] = disc.id
            info['tracks'] = [{'number': i+1, 'length': disc.tracks[i].length} 
                            for i in range(len(disc.tracks))]
            
            # Extract ATIP data (Advanced Track Information Protocol)
            atip_result = subprocess.run([
                'cd-info', '--no-header', '--atip', CONFIG['USB_DEVICE']
            ], capture_output=True, text=True)
            
            if atip_result.returncode == 0:
                info['atip_data'] = self.parse_atip_data(atip_result.stdout)
                info['manufacturer'] = self.identify_manufacturer(info['atip_data'])
                info['burn_date'] = self.extract_burn_date(info['atip_data'])
            
            # Session information
            session_result = subprocess.run([
                'isoinfo', '-d', '-i', CONFIG['USB_DEVICE']
            ], capture_output=True, text=True)
            
            if session_result.returncode == 0:
                info['sessions'] = self.count_sessions(session_result.stdout)
                
        except Exception as e:
            logger.warning(f"Technical info extraction failed: {e}")
            
        return info
    
    def assess_vintage_disc(self, disc_info):
        """Identify indicators of 1990s CD-R discs requiring special handling"""
        vintage_indicators = {
            'is_vintage': False,
            'fragility_score': 0,
            'special_handling_required': False,
            'estimated_age': None
        }
        
        # Manufacturer-based vintage detection
        vintage_manufacturers = ['TDK', 'Sony', 'Verbatim', 'Maxell', 'Memorex']
        if disc_info.get('manufacturer', '').upper() in [m.upper() for m in vintage_manufacturers]:
            vintage_indicators['fragility_score'] += 2
            
        # Capacity-based age estimation (650MB = older)
        if 'capacity' in disc_info and '650' in str(disc_info['capacity']):
            vintage_indicators['fragility_score'] += 3
            vintage_indicators['estimated_age'] = '1990s-early 2000s'
            
        # ATIP data analysis for age
        if 'atip_data' in disc_info:
            vintage_indicators.update(self.analyze_atip_for_age(disc_info['atip_data']))
            
        # Final assessment
        if vintage_indicators['fragility_score'] >= 3:
            vintage_indicators['is_vintage'] = True
            vintage_indicators['special_handling_required'] = True
            
        return vintage_indicators
    
    def assess_drive_capabilities(self):
        """Assess USB drive capabilities for error detection"""
        capabilities = {
            'c2_support': False,
            'accurate_stream': False, 
            'max_speed': '24x',
            'error_recovery': 'basic'
        }
        
        try:
            # Test C2 error pointer support
            c2_test = subprocess.run([
                'cdparanoia', '-v', '-q', '--force-cdrom-device', CONFIG['USB_DEVICE'], 
                '--test-c2'
            ], capture_output=True, text=True)
            
            if 'C2 error correction' in c2_test.stderr:
                capabilities['c2_support'] = True
                capabilities['error_recovery'] = 'advanced'
                
            # Test for AccurateRip database entry
            # This would check against the AccurateRip drive offset database
            capabilities['accurate_stream'] = self.check_accuraterip_support()
            
        except Exception as e:
            logger.warning(f"Drive capability assessment failed: {e}")
            
        return capabilities
    
    def rip_disc_with_advanced_quality(self, disc_info):
        """Multi-strategy ripping with quality assessment"""
        global current_job
        
        current_job['status'] = 'ripping'
        current_job['disc_info'] = disc_info
        current_job['total_tracks'] = len(disc_info['tracks'])
        
        # Generate unique session ID
        session_id = self.generate_session_id(disc_info)
        temp_dir = f"{CONFIG['TEMP_PATH']}/{session_id}"
        Path(temp_dir).mkdir(parents=True, exist_ok=True)
        
        try:
            # Strategy selection based on disc assessment
            strategy = self.select_ripping_strategy(disc_info)
            logger.info(f"Using ripping strategy: {strategy['name']}")
            
            # Execute multi-pass ripping
            rip_results = self.execute_multi_pass_rip(disc_info, temp_dir, strategy)
            
            # Quality assessment and AccurateRip verification
            quality_results = self.assess_rip_quality(rip_results, disc_info)
            
            # Metadata enhancement
            if quality_results['acceptable']:
                enhanced_metadata = self.fetch_enhanced_metadata(disc_info, rip_results)
                final_files = self.apply_metadata_and_organize(
                    rip_results, enhanced_metadata, disc_info
                )
                
                # Final organization for Jellyfin
                jellyfin_path = self.organize_for_jellyfin(final_files, enhanced_metadata)
                
                current_job['status'] = 'completed'
                current_job['output_path'] = jellyfin_path
                
                self.send_completion_notification(disc_info, quality_results, jellyfin_path)
                
            else:
                # Handle quality issues
                self.handle_quality_issues(rip_results, quality_results, disc_info)
                
        except Exception as e:
            logger.error(f"Ripping failed: {e}")
            current_job['status'] = 'error'
            current_job['errors'].append(str(e))
            
        finally:
            # Cleanup temp directory
            self.cleanup_temp_files(temp_dir)
    
    def select_ripping_strategy(self, disc_info):
        """Select optimal ripping strategy based on disc assessment"""
        strategies = {
            'vintage_gentle': {
                'name': 'Vintage Gentle Mode',
                'speed': '1x',
                'passes': 3,
                'c2_enabled': False,  # C2 can be unreliable on old drives
                'paranoia_level': 'maximum',
                'timeout_per_track': 1800,  # 30 minutes max per track
                'retry_logic': 'conservative'
            },
            'modern_fast': {
                'name': 'Modern Fast Mode', 
                'speed': '8x',
                'passes': 2,
                'c2_enabled': True,
                'paranoia_level': 'normal',
                'timeout_per_track': 600,
                'retry_logic': 'aggressive'
            },
            'problem_disc': {
                'name': 'Problem Disc Recovery',
                'speed': '1x',
                'passes': 5,
                'c2_enabled': False,
                'paranoia_level': 'maximum',
                'timeout_per_track': 3600,  # 1 hour max
                'retry_logic': 'exhaustive'
            }
        }
        
        # Strategy selection logic
        if disc_info.get('vintage_indicators', {}).get('is_vintage', False):
            return strategies['vintage_gentle']
        elif disc_info.get('drive_capabilities', {}).get('c2_support', False):
            return strategies['modern_fast'] 
        else:
            return strategies['problem_disc']
    
    def execute_multi_pass_rip(self, disc_info, temp_dir, strategy):
        """Execute multi-pass ripping with different strategies per pass"""
        results = {
            'tracks': {},
            'passes_completed': 0,
            'total_errors': 0,
            'interpolation_detected': False
        }
        
        for pass_num in range(strategy['passes']):
            logger.info(f"Starting pass {pass_num + 1}/{strategy['passes']}")
            
            pass_strategy = self.adjust_strategy_for_pass(strategy, pass_num)
            
            for track_num in range(1, len(disc_info['tracks']) + 1):
                current_job['tracks_completed'] = track_num - 1
                current_job['progress'] = (current_job['tracks_completed'] / current_job['total_tracks']) * 100
                
                track_result = self.rip_single_track(
                    track_num, temp_dir, pass_strategy, pass_num
                )
                
                if track_num not in results['tracks']:
                    results['tracks'][track_num] = []
                results['tracks'][track_num].append(track_result)
                
                # Interpolation detection
                if self.detect_interpolation_in_track(track_result['file_path']):
                    results['interpolation_detected'] = True
                    track_result['interpolation_detected'] = True
                    
                results['total_errors'] += track_result.get('error_count', 0)
                
        results['passes_completed'] = strategy['passes']
        return results
    
    def detect_interpolation_in_track(self, file_path):
        """Detect if drive inserted silence to mask read errors"""
        try:
            # Use sox to analyze audio for suspicious patterns
            analysis_result = subprocess.run([
                'sox', file_path, '-n', 'stat'
            ], capture_output=True, text=True, stderr=subprocess.STDOUT)
            
            # Look for indicators of interpolation
            if 'DC offset' in analysis_result.stdout:
                dc_offset = float(analysis_result.stdout.split('DC offset')[1].split('\n')[0].strip())
                if abs(dc_offset) < 0.0001:  # Suspiciously perfect DC offset
                    return True
                    
            # Check for unusual silence blocks
            silence_result = subprocess.run([
                'sox', file_path, '-n', 'silence', '1', '0.1', '0.1%', 
                '1', '2.0', '0.1%', ': newfile : restart'
            ], capture_output=True, text=True)
            
            # If silence detection creates many segments, interpolation likely
            return len(silence_result.stderr.split('newfile')) > 5
            
        except Exception as e:
            logger.warning(f"Interpolation detection failed for {file_path}: {e}")
            return False
    
    def fetch_enhanced_metadata(self, disc_info, rip_results):
        """Fetch comprehensive metadata from multiple sources"""
        metadata = {
            'musicbrainz': {},
            'coverart': None,
            'tags': {},
            'jellyfin_optimized': {}
        }
        
        try:
            # MusicBrainz lookup (superior to CDDB)
            if disc_info.get('disc_id'):
                mb_data = self.lookup_musicbrainz(disc_info['disc_id'])
                if mb_data:
                    metadata['musicbrainz'] = mb_data
                    
                    # Download high-resolution cover art
                    cover_art = self.download_cover_art(mb_data)
                    if cover_art:
                        metadata['coverart'] = cover_art
                        
                    # Generate smart tags
                    metadata['tags'] = self.generate_smart_tags(mb_data)
                    
                    # Optimize for Jellyfin structure
                    metadata['jellyfin_optimized'] = self.optimize_for_jellyfin(mb_data)
                    
        except Exception as e:
            logger.warning(f"Metadata fetch failed: {e}")
            # Fallback to basic disc info
            metadata = self.generate_fallback_metadata(disc_info)
            
        return metadata
    
    def lookup_musicbrainz(self, disc_id):
        """Lookup disc in MusicBrainz database"""
        try:
            result = musicbrainzngs.get_releases_by_discid(
                disc_id, 
                includes=['artists', 'recordings', 'release-groups', 'genres']
            )
            
            if 'disc' in result and 'release-list' in result['disc']:
                releases = result['disc']['release-list']
                if releases:
                    # Return the most complete release
                    return self.select_best_release(releases)
                    
        except musicbrainzngs.NetworkError:
            logger.warning("MusicBrainz network error")
        except Exception as e:
            logger.warning(f"MusicBrainz lookup failed: {e}")
            
        return None
    
    def download_cover_art(self, mb_data, min_resolution=500):
        """Download high-resolution album artwork"""
        try:
            if 'release' in mb_data:
                release_id = mb_data['release']['id']
                
                # Try Cover Art Archive
                cover_art_url = f"https://coverartarchive.org/release/{release_id}/front-500"
                
                response = requests.get(cover_art_url, timeout=10)
                if response.status_code == 200:
                    return {
                        'data': response.content,
                        'format': 'JPEG',
                        'resolution': '500x500'
                    }
                    
        except Exception as e:
            logger.warning(f"Cover art download failed: {e}")
            
        return None
    
    def organize_for_jellyfin(self, final_files, metadata):
        """Organize files in Jellyfin-optimized structure"""
        
        # Jellyfin-optimized directory structure
        if metadata.get('musicbrainz', {}).get('release'):
            mb_release = metadata['musicbrainz']['release']
            
            artist = self.sanitize_filename(mb_release.get('artist-credit-phrase', 'Unknown Artist'))
            album = self.sanitize_filename(mb_release.get('title', 'Unknown Album'))
            year = mb_release.get('date', '')[:4] if mb_release.get('date') else 'Unknown'
            
            # Jellyfin Music Structure: /Music/Artist/Album (Year)/
            jellyfin_path = f"{CONFIG['BASE_PATH']}/Music/{artist}/{album} ({year})"
            
        else:
            # Fallback structure for unknown discs
            session_id = datetime.now().strftime("%Y%m%d_%H%M%S")
            jellyfin_path = f"{CONFIG['BASE_PATH']}/Music/Unknown Artist/CD Rip {session_id}"
        
        Path(jellyfin_path).mkdir(parents=True, exist_ok=True)
        
        # Move files to final location
        final_paths = []
        for file_info in final_files:
            filename = f"{file_info['track_number']:02d} - {file_info['title']}.flac"
            final_path = f"{jellyfin_path}/{self.sanitize_filename(filename)}"
            
            # Move file
            os.rename(file_info['temp_path'], final_path)
            final_paths.append(final_path)
            
        # Save cover art
        if metadata.get('coverart'):
            cover_path = f"{jellyfin_path}/folder.jpg"
            with open(cover_path, 'wb') as f:
                f.write(metadata['coverart']['data'])
                
        # Create album-level metadata files
        self.create_album_metadata_files(jellyfin_path, metadata)
        
        return jellyfin_path
    
    def generate_session_id(self, disc_info):
        """Generate unique session identifier"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        if disc_info.get('disc_id'):
            disc_hash = hashlib.md5(disc_info['disc_id'].encode()).hexdigest()[:8]
            return f"CD_{timestamp}_{disc_hash}"
        else:
            # For retry/problem discs
            return f"RETRY_{timestamp}_{os.urandom(4).hex().upper()}"
    
    def send_completion_notification(self, disc_info, quality_results, output_path):
        """Send mobile notification when disc is complete"""
        if not CONFIG.get('NOTIFICATION_URL'):
            return
            
        notification = {
            'title': '📀 CD Rip Complete',
            'message': f"Disc processed successfully\nQuality: {quality_results.get('accuraterip_confidence', 'Unknown')}\nLocation: {output_path}",
            'disc_info': {
                'manufacturer': disc_info.get('manufacturer', 'Unknown'),
                'tracks': len(disc_info.get('tracks', [])),
                'quality_score': quality_results.get('overall_score', 0)
            }
        }
        
        try:
            requests.post(CONFIG['NOTIFICATION_URL'], json=notification, timeout=5)
        except Exception as e:
            logger.warning(f"Notification failed: {e}")

# Flask Routes
@app.route('/')
def index():
    return render_template('cd_ripper.html', config=CONFIG, status=current_job)

@app.route('/api/detect')
def api_detect():
    ripper = AdvancedCDRipper()
    disc_info = ripper.detect_disc()
    return jsonify(disc_info)

@app.route('/api/rip', methods=['POST'])
def api_rip():
    if current_job['status'] != 'idle':
        return jsonify({'error': 'Rip already in progress'}), 400
        
    ripper = AdvancedCDRipper()
    disc_info = ripper.detect_disc()
    
    if not disc_info:
        return jsonify({'error': 'No disc detected'}), 400
        
    # Start ripping in background thread
    thread = threading.Thread(target=ripper.rip_disc_with_advanced_quality, args=(disc_info,))
    thread.daemon = True
    thread.start()
    
    return jsonify({'status': 'started', 'session_id': ripper.generate_session_id(disc_info)})

@app.route('/api/status')
def api_status():
    return jsonify(current_job)

@app.route('/api/eject', methods=['POST'])
def api_eject():
    try:
        subprocess.run(['eject', CONFIG['USB_DEVICE']], check=True)
        return jsonify({'status': 'ejected'})
    except subprocess.CalledProcessError as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True) 