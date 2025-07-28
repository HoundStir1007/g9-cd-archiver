# 🎬 HandBrake DVD Ripping Guide for G9

## 🎯 **HandBrake is Ready!** Your G9 now handles both audio CDs AND video DVDs! ✨

### **📍 Installation Complete**
- **✅ HandBrake CLI**: `HandBrakeCLI` (command-line power)
- **✅ HandBrake GUI**: `ghb` (visual interface)
- **✅ DVD Ripper Script**: `./g9_dvd_ripper.sh` (automated workflow)
- **✅ Storage Ready**: `/mnt/storage/digital_consolidation/dvd_rips/`

---

## 🚀 **Three Ways to Use HandBrake**

### **Method 1: Automated Script (Recommended) 🎯**
```bash
# Run the automated DVD ripper
./g9_dvd_ripper.sh
```
**Features:**
- 🎥 **Movie Mode**: Single main title ripping
- 📺 **TV Show Mode**: Multi-episode processing  
- 🔍 **Custom Mode**: Advanced options
- 📋 **Scan Mode**: Just analyze the DVD
- ⏏️ **Auto-eject**: Automatic disc ejection
- 📝 **Logging**: Complete session logs

### **Method 2: HandBrake GUI (Visual) 🖥️**
```bash
# Launch HandBrake GUI (via remote desktop)
ghb
```
**Perfect for:**
- Visual disc analysis
- Custom encoding settings
- Preview before ripping
- Fine-tuned quality control

### **Method 3: Command Line (Advanced) 💻**
```bash
# Basic DVD rip example
HandBrakeCLI -i /dev/sr0 -o "Movie_Name.mp4" --preset "Fast 1080p30" --main-feature

# TV show episode example  
HandBrakeCLI -i /dev/sr0 -o "Show_S01E01.mp4" --preset "Fast 1080p30" -t 1
```

---

## 📁 **Storage Organization**

Your DVDs will be organized as:
```
/mnt/storage/digital_consolidation/dvd_rips/
├── movies/           # Feature films
├── tv_shows/         # Series organized by show/season
│   └── Show_Name/
│       └── Season_1/
└── other/           # Custom/misc content
```

**🌐 Network Access**: All ripped content accessible via SMB:
- `smb://100.100.71.107/StorageDrive` → Browse to `digital_consolidation/dvd_rips/`

---

## 🎛️ **Quality Presets (Most Useful)**

### **Fast Presets (Quick Processing)**
- `Fast 1080p30` - Good quality, fast encoding
- `Fast 720p30` - Smaller files, very fast

### **High Quality Presets (Best Results)**  
- `HQ 1080p30 Surround` - Excellent quality with surround sound
- `HQ 720p30 Surround` - Great quality, smaller files

### **TV/Streaming Optimized**
- `Roku 1080p30 Surround` - Perfect for streaming devices
- `Apple 1080p60 Surround` - Apple TV/iPhone optimized

---

## 🔧 **Integration with Your Existing Workflow**

### **Enhanced CD/DVD Station**
Your G9 now handles:
- **🎵 Audio CDs** → `./g9_cd_ripper.sh` → FLAC + MP3
- **🎬 Video DVDs** → `./g9_dvd_ripper.sh` → MP4
- **📀 Data Discs** → Enhanced copy in CD ripper

### **Automatic Detection** 
Your existing `g9_cd_ripper.sh` has been enhanced to:
- Detect video DVDs automatically
- Suggest using HandBrake for video content
- Maintain seamless audio CD processing

---

## 🎯 **Quick Start Examples**

### **Rip a Movie**
```bash
./g9_dvd_ripper.sh
# Select option 1 (Movie)
# Enter movie name
# Wait for completion
```

### **Rip TV Show Season**
```bash
./g9_dvd_ripper.sh  
# Select option 2 (TV Show)
# Enter show name and season
# Select number of episodes
# Batch processing begins
```

### **Quick Command Line**
```bash
# Rip main feature in high quality
HandBrakeCLI -i /dev/sr0 -o "output.mp4" --preset "HQ 1080p30 Surround" --main-feature
```

---

## 🚀 **Advanced Features**

### **Subtitle Support**
- **Automatic scanning** for forced subtitles
- **Multiple language tracks** preserved
- **Closed captions** when available

### **Audio Tracks**
- **All audio tracks** preserved by default
- **Surround sound** maintained in HQ presets
- **Multiple languages** supported

### **Batch Processing**
- **TV series** support with episode numbering
- **Automatic file naming** with sanitization
- **Progress logging** for long sessions

---

## 🔍 **Troubleshooting**

### **DVD Not Detected**
```bash
# Check if DVD is mounted
lsblk | grep sr0

# Test HandBrake detection
HandBrakeCLI -i /dev/sr0 -t 0
```

### **Permission Issues**
```bash
# Fix permissions if needed
sudo chown -R mark:mark /mnt/storage/digital_consolidation
```

### **Check Available Space**
```bash
# Verify storage space (DVDs need 1-8GB each)
df -h /mnt/storage
```

---

## 🌟 **G9 Media Station Complete!**

### **What You Now Have**
✅ **Audio CD Ripping**: Professional FLAC + MP3 output  
✅ **Video DVD Ripping**: High-quality MP4 with HandBrake  
✅ **Data Disc Copying**: Speed-optimized with fallback  
✅ **Network Storage**: All content accessible from MacBook  
✅ **Automated Workflows**: Insert disc, press Enter, done!  

### **Storage Capacity**
- **📊 Data Drive**: 1.8TB (documents, archives)
- **💾 Storage Drive**: 3.5TB free (media, backups, rips)
- **🌐 Network Access**: SMB shares via Tailscale VPN

### **Performance**
- **🚀 Hardware Acceleration**: Where available
- **⚡ Multiple Presets**: Fast to ultra-high quality
- **📱 Device Optimization**: Apple TV, Roku, etc.

---

## 🎉 **Ready to Digitize Your DVD Collection!**

**Your G9 is now the ultimate disc processing station:**
1. **Insert any disc** (CD, DVD, data)
2. **Auto-detection** determines the best tool
3. **Professional processing** with optimal settings
4. **Network storage** accessible from your MacBook
5. **Organized output** in logical folder structures

**Start ripping!** 🚀📀➡️💾✨

---

*From physical discs to digital perfection - your G9 handles it all!* 