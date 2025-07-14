#!/usr/bin/env python3
"""
HandBrake Chapter XML Generator
Converts chapter titles from template to HandBrake XML format
"""

import re
import xml.etree.ElementTree as ET
from xml.dom import minidom

def read_chapter_titles(filename):
    """Read chapter titles from the template file"""
    chapters = {}
    
    with open(filename, 'r') as f:
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

def create_handbrake_xml(chapters, output_file):
    """Create HandBrake-compatible XML file"""
    
    # Create root element
    root = ET.Element("Chapters")
    
    # Add each chapter
    for chapter_num in sorted(chapters.keys()):
        chapter_elem = ET.SubElement(root, "Chapter")
        
        # Add chapter number
        num_elem = ET.SubElement(chapter_elem, "ChapterNumber")
        num_elem.text = str(chapter_num)
        
        # Add chapter title
        title_elem = ET.SubElement(chapter_elem, "ChapterTitle")
        title_elem.text = chapters[chapter_num]
        
        # Add default start time (HandBrake will calculate actual times)
        start_elem = ET.SubElement(chapter_elem, "ChapterStartTime")
        start_elem.text = "00:00:00.000"
    
    # Pretty print the XML
    xml_str = ET.tostring(root, encoding='unicode')
    pretty_xml = minidom.parseString(xml_str).toprettyxml(indent="  ")
    
    # Remove extra blank lines
    lines = [line for line in pretty_xml.split('\n') if line.strip()]
    final_xml = '\n'.join(lines)
    
    # Write to file
    with open(output_file, 'w') as f:
        f.write(final_xml)
    
    return len(chapters)

def main():
    template_file = "chapter_titles_template.txt"
    output_file = "handbrake_chapters.xml"
    
    try:
        print("🎬 Reading chapter titles from template...")
        chapters = read_chapter_titles(template_file)
        
        if not chapters:
            print("❌ No chapter titles found in template file!")
            print("Please fill in the chapter titles in chapter_titles_template.txt")
            return
        
        print(f"📝 Found {len(chapters)} chapter titles")
        
        # Show preview
        print("\n🎯 Chapter Preview:")
        for i, (num, title) in enumerate(sorted(chapters.items())):
            print(f"  {num:2d}. {title}")
            if i >= 9:  # Show first 10
                print(f"  ... and {len(chapters) - 10} more")
                break
        
        print(f"\n🎬 Creating HandBrake XML file...")
        chapter_count = create_handbrake_xml(chapters, output_file)
        
        print(f"✅ HandBrake XML created: {output_file}")
        print(f"📊 Total chapters: {chapter_count}")
        print(f"\n🎯 To use in HandBrake:")
        print(f"   1. Open your video in HandBrake")
        print(f"   2. Go to Chapters tab")
        print(f"   3. Click 'Import' and select: {output_file}")
        print(f"   4. HandBrake will apply the chapter titles!")
        
    except FileNotFoundError:
        print(f"❌ Template file not found: {template_file}")
        print("Please make sure chapter_titles_template.txt exists and is filled in.")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main() 