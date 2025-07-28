#!/usr/bin/env python3
"""
🎬 XML Chapter Updater
Automatically updates HandBrake XML chapter files with titles from web sources
Includes proper XML character escaping and backup functionality
"""

import os
import re
import requests
import xml.etree.ElementTree as ET
from xml.dom import minidom
from datetime import datetime
from bs4 import BeautifulSoup
import glob
from urllib.parse import urlparse

def find_xml_files():
    """Find all XML chapter files in the current directory"""
    # Look for XML files that aren't in subdirectories or venv
    xml_files = []
    for file in glob.glob("*.xml"):
        # Skip files that are clearly not chapter files
        if any(skip in file.lower() for skip in ['test', 'backup', 'temp']):
            continue
        xml_files.append(file)
    
    return sorted(xml_files)

def select_xml_file(xml_files):
    """Select XML file - auto-select if only one, otherwise show menu"""
    if not xml_files:
        print("❌ No XML files found in current directory!")
        return None
    
    if len(xml_files) == 1:
        print(f"📁 Found XML file: {xml_files[0]}")
        return xml_files[0]
    
    print("📁 Multiple XML files found:")
    for i, file in enumerate(xml_files, 1):
        # Try to get basic info about the file
        try:
            tree = ET.parse(file)
            chapters = tree.findall('.//ChapterAtom')
            print(f"  {i}. {file} ({len(chapters)} chapters)")
        except:
            print(f"  {i}. {file} (unable to parse)")
    
    while True:
        try:
            choice = input("\n🎯 Select file number: ").strip()
            index = int(choice) - 1
            if 0 <= index < len(xml_files):
                return xml_files[index]
            else:
                print("❌ Invalid selection. Try again.")
        except ValueError:
            print("❌ Please enter a number.")
        except KeyboardInterrupt:
            print("\n👋 Cancelled.")
            return None

def extract_titles_from_url(url):
    """Extract chapter titles from various URL formats"""
    print(f"🌐 Fetching content from: {url}")
    
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        
        content = response.text
        soup = BeautifulSoup(content, 'html.parser')
        
        # Try different extraction methods based on URL
        domain = urlparse(url).netloc.lower()
        
        if 'wikipedia' in domain:
            return extract_from_wikipedia(soup)
        elif 'discogs' in domain:
            return extract_from_discogs(soup)
        elif 'allmusic' in domain:
            return extract_from_allmusic(soup)
        else:
            return extract_generic_tracklist(soup, content)
            
    except requests.RequestException as e:
        print(f"❌ Error fetching URL: {e}")
        return None
    except Exception as e:
        print(f"❌ Error parsing content: {e}")
        return None

def extract_from_wikipedia(soup):
    """Extract track listing from Wikipedia pages"""
    titles = []
    
    # Look for tracklist tables or ordered lists
    track_patterns = [
        'table.tracklist tr',
        'ol li',
        '.tracklist tr',
        '.track-listing tr'
    ]
    
    for pattern in track_patterns:
        elements = soup.select(pattern)
        if elements:
            for element in elements:
                # Get text and clean it up
                text = element.get_text(strip=True)
                # Skip headers and empty rows
                if text and not text.lower().startswith(('track', 'no.', '#')):
                    # Clean up common prefixes
                    text = re.sub(r'^\d+\.?\s*', '', text)  # Remove track numbers
                    text = re.sub(r'^"([^"]*)"$', r'\1', text)  # Remove quotes
                    if len(text) > 3:  # Skip very short entries
                        titles.append(text)
            
            if titles:
                break
    
    return titles

def extract_from_discogs(soup):
    """Extract track listing from Discogs pages"""
    titles = []
    
    # Discogs track listing patterns
    track_elements = soup.select('.tracklist_track_title') or soup.select('[data-track-title]')
    
    for element in track_elements:
        title = element.get_text(strip=True)
        if title:
            titles.append(title)
    
    return titles

def extract_from_allmusic(soup):
    """Extract track listing from AllMusic pages"""
    titles = []
    
    # AllMusic patterns
    track_elements = soup.select('.track-title') or soup.select('.song-title')
    
    for element in track_elements:
        title = element.get_text(strip=True)
        if title:
            titles.append(title)
    
    return titles

def extract_generic_tracklist(soup, content):
    """Generic extraction for other sites"""
    titles = []
    
    # Try to find numbered lists or tables
    patterns = [
        'ol li',
        'ul li',
        'tr td',
        '.track',
        '.song',
        '.title'
    ]
    
    for pattern in patterns:
        elements = soup.select(pattern)
        if len(elements) > 5:  # Likely a track listing
            for element in elements:
                text = element.get_text(strip=True)
                # Clean up
                text = re.sub(r'^\d+\.?\s*', '', text)
                if len(text) > 3 and '"' not in text:  # Basic filtering
                    titles.append(text)
            
            if titles:
                break
    
    # Fallback: look for patterns in raw text
    if not titles:
        lines = content.split('\n')
        for line in lines:
            # Look for numbered patterns
            match = re.search(r'\d+\.?\s*(.+)', line.strip())
            if match:
                title = match.group(1).strip()
                if len(title) > 3:
                    titles.append(title)
    
    return titles

def escape_xml_characters(text):
    """Properly escape XML special characters according to troubleshooting guide"""
    if not text:
        return text
    
    # Order matters! Do ampersands first to avoid double-escaping
    text = text.replace('&', '&amp;')  # Do this FIRST
    text = text.replace("'", '&apos;')  # Apostrophes
    text = text.replace('"', '&quot;')  # Quotes
    text = text.replace('<', '&lt;')    # Less than
    text = text.replace('>', '&gt;')    # Greater than
    
    return text

def backup_xml_file(file_path):
    """Create a timestamped backup of the XML file"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"{file_path}.backup_{timestamp}"
    
    try:
        with open(file_path, 'r') as src:
            content = src.read()
        with open(backup_path, 'w') as dst:
            dst.write(content)
        print(f"💾 Backup created: {backup_path}")
        return backup_path
    except Exception as e:
        print(f"⚠️  Backup failed: {e}")
        return None

def update_xml_chapters(xml_file, chapter_titles):
    """Update XML file with new chapter titles"""
    try:
        # Parse the XML
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        # Find all ChapterAtom elements
        chapter_atoms = root.findall('.//ChapterAtom')
        print(f"🎬 Found {len(chapter_atoms)} chapters in XML")
        print(f"📝 Got {len(chapter_titles)} titles from URL")
        
        if len(chapter_titles) > len(chapter_atoms):
            print("⚠️  More titles than chapters - will use first chapters only")
        elif len(chapter_titles) < len(chapter_atoms):
            print("⚠️  Fewer titles than chapters - some chapters will remain unchanged")
        
        updated_count = 0
        
        # Update each chapter
        for i, chapter_atom in enumerate(chapter_atoms):
            if i < len(chapter_titles):
                # Find the ChapterString element
                chapter_display = chapter_atom.find('ChapterDisplay')
                if chapter_display is not None:
                    chapter_string = chapter_display.find('ChapterString')
                    
                    if chapter_string is not None:
                        old_title = chapter_string.text or f"Chapter {i+1}"
                        new_title = escape_xml_characters(chapter_titles[i])
                        chapter_string.text = new_title
                        print(f"  {i+1:2d}. {old_title} → {new_title}")
                        updated_count += 1
        
        # Write the updated XML with proper formatting
        xml_str = ET.tostring(root, encoding='unicode')
        
        # Add the DOCTYPE declaration back
        xml_with_doctype = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Chapters SYSTEM "matroskachapters.dtd">
''' + xml_str
        
        # Pretty print
        dom = minidom.parseString(xml_with_doctype)
        pretty_xml = dom.toprettyxml(indent="  ")
        
        # Clean up extra blank lines
        lines = [line for line in pretty_xml.split('\n') if line.strip()]
        final_xml = '\n'.join(lines)
        
        # Write to file
        with open(xml_file, 'w', encoding='utf-8') as f:
            f.write(final_xml)
        
        return updated_count
        
    except Exception as e:
        print(f"❌ Error updating XML: {e}")
        return 0

def preview_titles(titles):
    """Show a preview of extracted titles"""
    if not titles:
        return False
    
    print(f"\n📋 Found {len(titles)} chapter titles:")
    for i, title in enumerate(titles[:10], 1):  # Show first 10
        print(f"  {i:2d}. {title}")
    
    if len(titles) > 10:
        print(f"  ... and {len(titles) - 10} more")
    
    while True:
        try:
            response = input(f"\n🎯 Use these titles? (y/n): ").strip().lower()
            if response in ['y', 'yes']:
                return True
            elif response in ['n', 'no']:
                return False
            else:
                print("Please enter 'y' or 'n'")
        except KeyboardInterrupt:
            print("\n👋 Cancelled.")
            return False

def main():
    print("🎬 XML Chapter Updater")
    print("=" * 50)
    
    # Find XML files
    xml_files = find_xml_files()
    selected_file = select_xml_file(xml_files)
    
    if not selected_file:
        return
    
    # Get URL from user
    print(f"\n📁 Selected: {selected_file}")
    print("\n🌐 Please paste the URL containing chapter titles:")
    print("   (Wikipedia, Discogs, AllMusic, or any page with a track listing)")
    
    try:
        url = input("\n🔗 URL: ").strip()
        if not url:
            print("❌ No URL provided.")
            return
        
        # Extract titles
        chapter_titles = extract_titles_from_url(url)
        
        if not chapter_titles:
            print("❌ Could not extract chapter titles from URL.")
            print("💡 Try a different URL or check the page format.")
            return
        
        # Preview and confirm
        if not preview_titles(chapter_titles):
            print("👋 Operation cancelled.")
            return
        
        # Create backup
        backup_path = backup_xml_file(selected_file)
        
        # Update XML
        print(f"\n🔄 Updating {selected_file}...")
        updated_count = update_xml_chapters(selected_file, chapter_titles)
        
        if updated_count > 0:
            print(f"\n✅ SUCCESS! Updated {updated_count} chapters in {selected_file}")
            print(f"💾 Backup saved as: {backup_path}")
            print(f"\n🎯 Ready for HandBrake import!")
            print(f"   1. Open video in HandBrake")
            print(f"   2. Go to Chapters tab")
            print(f"   3. Click 'Import' and select: {selected_file}")
            print(f"   4. Enjoy perfect chapters! 🎬")
        else:
            print("❌ No chapters were updated.")
        
    except KeyboardInterrupt:
        print("\n👋 Cancelled.")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main() 