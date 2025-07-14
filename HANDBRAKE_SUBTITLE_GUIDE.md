# 📝 HandBrake Subtitle Guide - Complete DVD Subtitle Support

## 🎯 **Your Spinal Tap DVD Subtitles**

### **Available Subtitle Tracks:**
- **Track 1**: French (Francais) - Wide Screen [VOBSUB]
- **Track 2**: Spanish (español) - Wide Screen [VOBSUB]
- **Track 3**: English Closed Caption [CC608] ✨ **DISCOVERED!**
- **Formats**: VOBSUB (image-based) + CC608 (text-based closed captioning)

---

## 🚀 **CLI HandBrake - Enhanced g9_dvd_ripper.sh**

### **Smart Analysis Now Includes Subtitle Options:**

When you run `./g9_dvd_ripper.sh` → option 4 (Smart Analysis), you'll see:

```
📝 Subtitle options:
1. Auto-detect forced subtitles only (recommended)
2. Include all subtitles (French + Spanish + English CC)  
3. English closed captioning only
4. No subtitles
5. Let me choose specific subtitle tracks
```

### **Subtitle Option Details:**

**Option 1: Auto-detect forced (Recommended)** 🎯
- Command: `--subtitle scan --subtitle-forced`
- **Best for**: Most users - automatically finds forced subtitles
- **Example**: Foreign language parts, on-screen text
- **Result**: Only shows subtitles when needed

**Option 2: Include all subtitles** 🌍  
- Command: `--all-subtitles`
- **Best for**: Multilingual users or complete archives
- **Result**: French + Spanish + English CC tracks included
- **File size**: Slightly larger (minimal impact)

**Option 3: English closed captioning only** 🇺🇸
- Command: `--subtitle 3`
- **Best for**: English accessibility needs
- **Result**: English CC608 closed captioning
- **Format**: Text-based, embedded in video stream

**Option 4: No subtitles** 🚫
- Command: (none)
- **Best for**: English-only viewers, smaller file sizes
- **Result**: Clean video with no subtitle tracks

**Option 5: Custom selection** ⚙️
- Command: `--subtitle 1,2,3` or `--subtitle 3`
- **Best for**: Specific language needs
- **Example**: Just English CC = `--subtitle 3`
- **Example**: French + English = `--subtitle 1,3`

---

## 🖥️ **GUI HandBrake Subtitle Setup**

### **Step-by-Step in GUI HandBrake:**

1. **Launch GUI HandBrake**:
   ```bash
   # Connect via Remote Desktop: 100.100.71.107:3389
   ghb
   ```

2. **Load Your DVD**:
   - Click **"Source"** button
   - Select **"/dev/sr0"** (your DVD drive)
   - Wait for title analysis

3. **Navigate to Subtitles Tab**:
   - Click **"Subtitles"** tab (next to Audio tab)
   - You'll see available subtitle tracks

4. **Add Subtitle Tracks**:
   ```
   Available tracks you'll see:
   ├── Track 1: Francais (Wide Screen) [VOBSUB]
   ├── Track 2: español (Wide Screen) [VOBSUB]
   └── Track 3: English Closed Caption [CC608]
   ```

5. **Subtitle Configuration Options**:

   **Auto-Detect Forced (Recommended)**:
   - Check ☑️ **"Scan Foreign Audio Search"**
   - This auto-detects forced subtitles only

   **Include Specific Languages**:
   - Click **"+ Add Track"** for each desired language
   - Select **French** or **Spanish** from dropdown
   - Choose format: **VOBSUB** (preserves original DVD format)

   **Include All Subtitles**:
   - Add both French and Spanish tracks
   - Both will be available for viewer selection

---

## 📊 **Subtitle Format Comparison**

### **VOBSUB (DVD Image Subtitles)**
- ✅ **Original DVD format** - pixel-perfect reproduction
- ✅ **Image-based** - preserves fonts, colors, positioning  
- ✅ **Wide compatibility** - works in most players
- ✅ **Selectable** - viewer can turn on/off
- ⚠️ **Slightly larger** file size
- **Used for**: Foreign language subtitles (French, Spanish)

### **CC608 (Closed Captioning)**
- ✅ **Text-based** - smaller file size
- ✅ **Accessibility standard** - designed for hearing impaired
- ✅ **Embedded in video stream** - part of broadcast standard
- ✅ **Includes sound effects** - "[music playing]", "[door slams]"
- ✅ **Selectable** - viewer can turn on/off
- **Used for**: English closed captioning

### **SRT (Text Subtitles)**
- ✅ **Smaller file size** - text-based
- ✅ **Editable** - can modify timing/text
- ⚠️ **Loses formatting** - plain text only
- ⚠️ **Not available for DVDs** - would need conversion

### **Burned-In Subtitles**
- ✅ **Always visible** - permanently on video
- ✅ **Universal compatibility** - part of video
- ❌ **Cannot disable** - always shown
- ❌ **Larger file size** - more video processing

---

## 🎬 **Recommended Settings by Use Case**

### **Personal Archive (Recommended)**
```bash
Audio: All tracks (main + commentary)
Subtitles: Auto-detect forced only
Format: VOBSUB
```
- **Why**: Preserves original experience with foreign language support

### **Complete Preservation**
```bash  
Audio: All tracks (main + commentary)
Subtitles: All subtitles (French + Spanish)
Format: VOBSUB
```
- **Why**: Maximum preservation for collectors

### **Streaming/Sharing**
```bash
Audio: Main track only  
Subtitles: Auto-detect forced only
Format: VOBSUB
```
- **Why**: Optimal balance of features and file size

### **English Only**
```bash
Audio: Main track only
Subtitles: None
```
- **Why**: Smallest file size, fastest encoding

---

## 🔧 **Advanced Subtitle Commands**

### **CLI HandBrake Subtitle Examples:**

**Auto-detect forced subtitles:**
```bash
HandBrakeCLI -i /dev/sr0 -t 1 -o movie.mp4 \
  --preset "HQ 1080p30 Surround" \
  --subtitle scan --subtitle-forced
```

**Include specific subtitle tracks:**
```bash
HandBrakeCLI -i /dev/sr0 -t 1 -o movie.mp4 \
  --preset "HQ 1080p30 Surround" \
  --subtitle 1,2  # French + Spanish
```

**Include all available subtitles:**
```bash
HandBrakeCLI -i /dev/sr0 -t 1 -o movie.mp4 \
  --preset "HQ 1080p30 Surround" \
  --all-subtitles
```

**No subtitles:**
```bash
HandBrakeCLI -i /dev/sr0 -t 1 -o movie.mp4 \
  --preset "HQ 1080p30 Surround"
  # (no subtitle flags)
```

---

## 💡 **Subtitle Pro Tips**

### **For Your Spinal Tap DVD:**
1. **Start with auto-detect forced** - catches foreign language parts
2. **Preview first** - use Smart Analysis to test subtitle detection
3. **Include French/Spanish** if you want complete language options
4. **VOBSUB format** preserves original DVD subtitle styling

### **General DVD Subtitle Tips:**
- **Forced subtitles** = Usually foreign language parts or important text
- **Full subtitles** = Complete dialogue in other languages  
- **Wide Screen** = Positioned for widescreen format
- **VOBSUB** = DVD standard, best compatibility

### **Player Compatibility:**
- **VLC**: Handles all formats perfectly
- **Plex/Jellyfin**: VOBSUB works great
- **AppleTV/iOS**: VOBSUB supported
- **Most players**: VOBSUB is widely supported

---

## 🎯 **Quick Reference**

### **Smart Analysis Workflow:**
1. `./g9_dvd_ripper.sh` → option 4
2. Choose title 1 (main movie)
3. Audio: Include all (main + commentary)  
4. **Subtitles: Auto-detect forced (option 1)** ⭐
5. Preview → Verify → Rip!

### **GUI HandBrake Workflow:**
1. Remote Desktop → `ghb`
2. Source → `/dev/sr0`
3. **Subtitles tab → "Scan Foreign Audio Search"** ⭐
4. Output → Start encode

**Result**: Perfect Spinal Tap rip with main audio, commentary, and smart subtitle handling! 🎭✨

---

*Your DVD ripping setup now handles audio, video, AND subtitles like a professional media archival system!* 🏆 