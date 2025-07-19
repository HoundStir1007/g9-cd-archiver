# Media Consolidation & Archive Retrieval Guide 🎬

*For Homelab Media Server Management*

## 📋 **Overview**

This guide documents strategies for consolidating media collections, particularly when dealing with:
- **Incomplete commercial releases** (missing content due to licensing)
- **YouTube download restrictions** (HTTP 403, bot detection)
- **Archive sources** for missing media
- **Homelab integration** best practices

## 🎯 **Use Case: Devo "R U Experienced" Recovery**

### **Problem Identified**
- **Rhino Records DVD** (2003) missing "R U Experienced" due to Hendrix estate objections
- **YouTube blocking** direct downloads with yt-dlp (HTTP 403 Forbidden)
- **Need complete collection** for Jellyfin media server

### **Solution Applied**
Successfully retrieved missing content via **Ghostarchive.org** workaround.

## 🔧 **Archive Retrieval Methods**

### **Method 1: Ghostarchive.org (Primary Solution)**

**When to Use**: YouTube blocks yt-dlp downloads

**Steps**:
```bash
# 1. Find archived video on Ghostarchive
# Visit: https://ghostarchive.org/varchive/[YOUTUBE_VIDEO_ID]

# 2. Scrape the direct CDN link
wget "https://ghostarchive.org/varchive/[VIDEO_ID]" -O temp_page.html
grep -o 'https://[^"]*\.mp4[^"]*' temp_page.html

# 3. Download directly from CDN
wget "https://ghostvideo.b-cdn.net/chimurai/[VIDEO_ID].mp4" -O "output_filename.mp4"

# 4. Clean up
rm temp_page.html
```

**Example**:
```bash
# Devo R U Experienced retrieval
wget "https://ghostarchive.org/varchive/JP8Eo24rNm8" -O temp.html
grep -o 'https://[^"]*\.mp4[^"]*' temp.html
# Returns: https://ghostvideo.b-cdn.net/chimurai/JP8Eo24rNm8.mp4

wget "https://ghostvideo.b-cdn.net/chimurai/JP8Eo24rNm8.mp4" -O "Devo_R_U_Experienced.mp4"
```

### **Method 2: Internet Archive (archive.org)**

**When to Use**: Ghostarchive doesn't have the content

**Search Strategy**:
- Visit `archive.org`
- Search: "[Artist] [Song/Video Title]"
- Look for TV recordings, compilations, or user uploads
- Download via their direct links (usually works)

### **Method 3: yt-dlp Workarounds**

**When YouTube allows but restricts**:

```bash
# Try different player clients
yt-dlp --extractor-args "youtube:player_client=android" [URL]

# Use browser cookies
yt-dlp --cookies-from-browser firefox [URL]

# Custom user agent
yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0" [URL]
```

### **Method 4: Alternative Sources**

**Priority Order**:
1. **Archive.org** - Usually most permissive
2. **Ghostarchive.org** - Good for YouTube archives
3. **Vimeo/Dailymotion** - Often less restrictive
4. **Fan sites/forums** - Sometimes have direct links
5. **BitTorrent** - Last resort for rare content

## 🏠 **Homelab Integration Workflow**

### **1. Content Gap Analysis**
```bash
# Identify missing content in your collection
# Compare against official track listings (Wikipedia, etc.)
# Document gaps in collection
```

### **2. Archive Retrieval**
```bash
# Use methods above to retrieve missing content
# Verify quality and authenticity
# Check runtime against expected duration
```

### **3. Media Processing**
```bash
# Add to appropriate directory structure
mv "retrieved_video.mp4" "/media/mark/paperless-ssd/jellyfin/media/movies/"

# Update metadata if needed (see separate guide)
# Add chapters, subtitles post-encoding
```

### **4. Library Integration**
```bash
# Trigger Jellyfin library scan
# Verify correct metadata detection
# Test playback on multiple devices
```

## 📊 **Quality Verification**

### **Check Downloaded Content**:
```bash
# Verify file integrity
ls -lh downloaded_file.mp4

# Check video info
ffprobe -v quiet -print_format json -show_format -show_streams downloaded_file.mp4

# Quick playback test
vlc downloaded_file.mp4
```

### **Expected Quality Indicators**:
- **File size**: Should be reasonable for content length
- **Resolution**: Check if matches expected quality
- **Audio sync**: Verify audio/video alignment
- **No corruption**: Full playback without errors

## 🚨 **Common Issues & Solutions**

### **YouTube Download Failures**

**Error**: `HTTP Error 403: Forbidden`
**Solution**: Use Ghostarchive method

**Error**: `Sign in to confirm you're not a bot`
**Solution**: Try different video IDs or archive sources

**Error**: `nsig extraction failed`
**Solution**: Update yt-dlp or use alternative method

### **Archive Source Issues**

**Ghostarchive returns 404**:
- Try Internet Archive
- Search for alternative uploads with different IDs

**Poor quality archives**:
- Compare multiple sources
- Choose highest bitrate/resolution available

## 🎯 **Best Practices**

### **For Homelab Media Servers**:

1. **Document Everything**: Keep track of sources and methods used
2. **Verify Quality**: Always check content before integration
3. **Backup Sources**: Note where content was retrieved from
4. **Legal Considerations**: Ensure compliance with local copyright laws
5. **Metadata Management**: Properly tag and organize retrieved content

### **Collection Management**:

1. **Gap Analysis**: Regularly audit for missing content
2. **Version Control**: Track different versions/qualities
3. **Archive Monitoring**: Check archive sites for new additions
4. **Update Workflows**: Keep retrieval methods current

## 📚 **Related Documentation**

- **[Handbrake Setup Guide](HANDBRAKE_SETUP_GUIDE.md)** - Video encoding
- **[Chapter Files Guide](archive/chapter_files/README.md)** - Chapter management
- **[Jellyfin Setup Guide](archive/completed_guides/jellyfin_setup_guide.md)** - Media server setup

## 🔗 **Useful Resources**

**Archive Sites**:
- [Ghostarchive.org](https://ghostarchive.org) - YouTube archives
- [Archive.org](https://archive.org) - Internet Archive
- [Wayback Machine](https://web.archive.org) - Website archives

**Tools**:
- `yt-dlp` - YouTube downloader
- `wget` - Direct file downloads
- `ffprobe` - Media file analysis
- `grep` - Text parsing for links

## 📝 **Example Success Cases**

### **Case 1: Devo "R U Experienced"**
- **Problem**: Missing from Rhino DVD, YouTube blocked
- **Solution**: Ghostarchive CDN retrieval
- **Result**: 3.8MB MP4, complete collection
- **Integration**: Added to Jellyfin "Truth About De-Evolution" collection

### **Case 2: [Template for Future Cases]**
- **Problem**: [Describe issue]
- **Solution**: [Method used]
- **Result**: [File specs]
- **Integration**: [How added to homelab]

---

*Last Updated: July 19, 2025*  
*Created for: G9 Homelab Media Server Project* 