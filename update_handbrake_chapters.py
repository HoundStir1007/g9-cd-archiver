#!/usr/bin/env python3
"""
HandBrake Chapter Title Updater
Updates exported HandBrake XML with proper chapter titles while preserving timing
"""

import re
import xml.etree.ElementTree as ET
from xml.dom import minidom

def read_chapter_titles(template_file):
    """Read chapter titles from the template file"""
    chapters = {}
    
    with open(template_file, 'r') as f:
        lines = f.readlines()
    
    # Process each line to find chapter definitions
    for line in lines:
        line = line.strip()
        if line.startswith('CHAPTER_') and '=' in line:
            # Split on first = sign
            key, value = line.split('=', 1)
            
            # Extract chapter number
            chapter_match = re.match(r'CHAPTER_(\d+)', key)
            if chapter_match:
                chapter_num = int(chapter_match.group(1))
                
                # Extract title (remove quotes and unescape)
                if value.startswith('"') and value.endswith('"'):
                    title = value[1:-1]  # Remove surrounding quotes
                    # Unescape quotes and other characters
                    title = title.replace('\\"', '"').replace('\\\\', '\\')
                    
                    if title.strip():  # Only add non-empty titles
                        chapters[chapter_num] = title
    
    return chapters

def update_handbrake_xml(export_file, template_file, output_file):
    """Update HandBrake XML with proper chapter titles"""
    
    # Read chapter titles from template
    chapter_titles = read_chapter_titles(template_file)
    print(f"📝 Loaded {len(chapter_titles)} chapter titles from template")
    
    # Parse the exported XML
    tree = ET.parse(export_file)
    root = tree.getroot()
    
    # Find all ChapterAtom elements
    chapter_atoms = root.findall('.//ChapterAtom')
    print(f"🎬 Found {len(chapter_atoms)} chapters in exported XML")
    
    updated_count = 0
    
    # Update each chapter
    for i, chapter_atom in enumerate(chapter_atoms):
        chapter_num = i + 1  # Chapters are 1-indexed
        
        # Find the ChapterString element
        chapter_display = chapter_atom.find('ChapterDisplay')
        if chapter_display is not None:
            chapter_string = chapter_display.find('ChapterString')
            
            if chapter_string is not None:
                # Get the title from our template
                if chapter_num in chapter_titles:
                    old_title = chapter_string.text
                    new_title = chapter_titles[chapter_num]
                    chapter_string.text = new_title
                    print(f"  {chapter_num:2d}. {old_title} → {new_title}")
                    updated_count += 1
                else:
                    print(f"  {chapter_num:2d}. {chapter_string.text} (no title in template)")
    
    # Write the updated XML
    xml_str = ET.tostring(root, encoding='unicode')
    
    # Add the DOCTYPE declaration back (ElementTree doesn't preserve it)
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
    with open(output_file, 'w') as f:
        f.write(final_xml)
    
    return updated_count

def main():
    export_file = "handbrake_chapters_export.xml"
    template_file = "chapter_titles_template.txt"
    output_file = "handbrake_chapters_final.xml"
    
    try:
        print("🎬 Updating HandBrake XML with proper chapter titles...")
        print(f"📥 Reading exported XML: {export_file}")
        print(f"📋 Reading chapter titles: {template_file}")
        
        updated_count = update_handbrake_xml(export_file, template_file, output_file)
        
        print(f"\n✅ HandBrake XML updated: {output_file}")
        print(f"📊 Updated {updated_count} chapter titles")
        print(f"⏱️  All timing information preserved")
        
        print(f"\n🎯 To use in HandBrake:")
        print(f"   1. Open your Spinal Tap video in HandBrake")
        print(f"   2. Go to Chapters tab")
        print(f"   3. Click 'Import' and select: {output_file}")
        print(f"   4. Perfect chapters with proper titles and timing!")
        
    except FileNotFoundError as e:
        print(f"❌ File not found: {e}")
        print("Make sure both files exist in the current directory.")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main() 