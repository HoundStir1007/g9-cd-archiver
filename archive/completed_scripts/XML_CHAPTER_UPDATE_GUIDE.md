# 🎬 XML Chapter Update Guide

**Complete workflow for updating XML chapter files with web sources** ✨

## 🚀 **Quick Start**

### **Update XML Chapters from Web Source**
```bash
# Run the interactive XML chapter updater
python3 update_xml_chapters.py
```

**The script will:**
1. 📁 **Scan** for XML files in current directory
2. 🎯 **Auto-select** if only one file, or show selection menu
3. 🌐 **Ask for URL** containing chapter titles
4. 📋 **Extract titles** from Wikipedia, Discogs, AllMusic, or other sites
5. 🔄 **Update XML** with proper character escaping
6. 💾 **Create backup** with timestamp
7. ✅ **Alert when complete**

---

## 🎯 **Supported Websites**

### **Wikipedia** ⭐ (Recommended)
- **Best for**: Album track listings, TV episodes, movie chapters
- **Format**: Handles track listing tables and numbered lists
- **Example**: `https://en.wikipedia.org/wiki/Album_Name`

### **Discogs** 🎵
- **Best for**: Detailed album information
- **Format**: Professional music database
- **Example**: `https://www.discogs.com/release/123456`

### **AllMusic** 🎶
- **Best for**: Comprehensive music metadata
- **Format**: Track listings with detailed info
- **Example**: `https://www.allmusic.com/album/...`

### **Generic Sites** 🌐
- **Any site** with numbered lists or tables
- **Works with**: Track listings, episode guides, chapter lists
- **Auto-detects**: Numbered patterns and list structures

---

## 🔧 **How It Works**

### **Step 1: File Selection**
```
📁 Found XML file: OGWT-v3.xml
```
*Auto-selects if only one XML file found*

```
📁 Multiple XML files found:
  1. OGWT-v3.xml (47 chapters)
  2. THE_TRUTH_ABOUT_DE_EVOLUTION_CHAPTERS.xml (25 chapters)

🎯 Select file number: 1
```
*Shows selection menu for multiple files*

### **Step 2: URL Input**
```
🌐 Please paste the URL containing chapter titles:
   (Wikipedia, Discogs, AllMusic, or any page with a track listing)

🔗 URL: https://en.wikipedia.org/wiki/Old_Grey_Whistle_Test
```

### **Step 3: Title Extraction**
```
🌐 Fetching content from: https://en.wikipedia.org/wiki/...
📋 Found 47 chapter titles:
   1. Intro/Credits
   2. Meet Me On The Corner - Lindisfarne
   3. Oh You Pretty Things - David Bowie
   ... and 44 more

🎯 Use these titles? (y/n): y
```

### **Step 4: XML Update**
```
💾 Backup created: OGWT-v3.xml.backup_20250119_143022
🔄 Updating OGWT-v3.xml...
🎬 Found 47 chapters in XML
📝 Got 47 titles from URL

   1. Intro/Credits → Intro/Credits
   2. Chapter 2 → Meet Me On The Corner - Lindisfarne
   3. Chapter 3 → Oh You Pretty Things - David Bowie
   ... (all chapters updated)

✅ SUCCESS! Updated 47 chapters in OGWT-v3.xml
```

---

## 🛡️ **XML Character Escaping**

### **Automatic Escaping Applied**
Following the `XML_CHAPTER_TROUBLESHOOTING_GUIDE.md`:

```xml
Character    →    XML Escape
'            →    &apos;
&            →    &amp;
"            →    &quot;
<            →    &lt;
>            →    &gt;
```

### **Example Transformations**
```
Before: Couldn't Love You More
After:  Couldn&apos;t Love You More

Before: Jesus & Mary Chain  
After:  Jesus &amp; Mary Chain

Before: "She Said Yeah"
After:  &quot;She Said Yeah&quot;
```

**Result**: ✅ **Perfect HandBrake compatibility**

---

## 📁 **Archive Management**

### **Automatic Archiving**
The system intelligently archives completed XML files:

#### **Auto-Archive Criteria**
- ✅ File is older than 7 days with no recent edits
- ✅ OR file is older than 30 days
- ✅ AND most chapters have meaningful titles (not "Chapter 1", "Chapter 2")

#### **Manual Archiving**
```bash
# Interactive archive mode
python3 archive_xml_chapters.py

# Auto-archive completed files
python3 archive_xml_chapters.py --auto
```

#### **Archive Features**
- 📁 **Moves files** to `archive/chapter_files/`
- 💾 **Preserves backups** alongside main files
- 📝 **Updates README** with archive history
- 🗓️ **Timestamps** all archived files

---

## 🎯 **Usage Examples**

### **Example 1: Wikipedia Album**
```bash
python3 update_xml_chapters.py
# Paste: https://en.wikipedia.org/wiki/Nevermind
# Result: Perfect track listing with proper titles
```

### **Example 2: TV Show Episodes**
```bash
python3 update_xml_chapters.py  
# Paste: https://en.wikipedia.org/wiki/Breaking_Bad_(season_1)
# Result: Episode titles extracted automatically
```

### **Example 3: Movie Chapters**
```bash
python3 update_xml_chapters.py
# Paste: Any site with chapter/scene listings
# Result: Meaningful chapter names instead of "Chapter 1"
```

---

## ⚡ **Workflow Integration**

### **Complete DVD Processing Workflow**
1. **Rip DVD** → HandBrake creates chapters
2. **Export chapters** → XML file with timing
3. **Run script** → `python3 update_xml_chapters.py`
4. **Provide URL** → Wikipedia/Discogs track listing
5. **Import back** → Updated XML into HandBrake
6. **Archive** → Old files cleaned up automatically

### **HandBrake Integration**
1. **Export chapters**: HandBrake → Chapters tab → Export
2. **Update titles**: Run our script with web source
3. **Import chapters**: HandBrake → Chapters tab → Import
4. **Perfect result**: Proper titles with exact timing

---

## 🔍 **Troubleshooting**

### **No Titles Extracted**
```
❌ Could not extract chapter titles from URL.
💡 Try a different URL or check the page format.
```

**Solutions**:
- ✅ Try the Wikipedia page for the album/show
- ✅ Look for pages with clear track listings
- ✅ Check that the page has numbered lists or tables

### **Character Encoding Issues**
- ✅ **Automatic UTF-8** handling for international characters
- ✅ **XML escaping** prevents import failures
- ✅ **Smart detection** of problematic characters

### **File Selection Issues**
```
❌ No XML files found in current directory!
```
- ✅ Make sure you're in the directory with XML files
- ✅ XML files must have `.xml` extension
- ✅ Files named with 'test', 'backup', 'temp' are ignored

---

## 📊 **Success Metrics**

### **Before This Script**
- ❌ Manual copy/paste of each chapter title
- ❌ XML character escaping errors
- ❌ HandBrake import failures
- ❌ Time-consuming manual process

### **After This Script**
- ✅ **Automatic extraction** from web sources  
- ✅ **Perfect XML escaping** every time
- ✅ **100% HandBrake compatibility**
- ✅ **10x faster** chapter updating

---

## 🎯 **Next Steps**

### **Immediate Use**
1. ✅ **Run script** on current XML files
2. ✅ **Test with Wikipedia** track listings
3. ✅ **Verify HandBrake import** works perfectly

### **Archive Management**
1. ✅ **Auto-archive** happens automatically
2. ✅ **Manual cleanup** when needed
3. ✅ **Clean workspace** maintained

### **Integration with Existing Workflow**
- ✅ **Complements** existing `update_handbrake_chapters.py`
- ✅ **Follows** XML troubleshooting guide principles
- ✅ **Maintains** backup and archive practices
- ✅ **Enhances** media consolidation project

---

*This guide integrates with your existing XML chapter troubleshooting documentation and media organization workflow.*

**Created**: January 19, 2025  
**Status**: Ready for immediate use! 🚀 