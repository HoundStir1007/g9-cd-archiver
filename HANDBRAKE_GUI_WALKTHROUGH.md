# 🎬 HandBrake GUI DVD Ripping Walkthrough

## 🎯 **Complete Step-by-Step Guide for Visual DVD Ripping** ✨

### **📱 Step 1: Connect to Your G9**
1. **Open Microsoft Remote Desktop** on your MacBook
2. **Connect to**: `100.100.71.107:3389`
3. **Login**: Username `mark`, Password `admin123`
4. **You should see the XFCE desktop**

---

## 🚀 **Step 2: Launch HandBrake GUI**

### **Method 1: Terminal Launch (Recommended)**
```bash
# Open terminal in the desktop
ghb
```

### **Method 2: Applications Menu**
- Click **Applications** → **Multimedia** → **HandBrake**

---

## 📀 **Step 3: Load Your DVD**

### **Insert DVD First**
1. **Insert DVD** into your USB optical drive
2. **Wait** for it to be detected
3. **In HandBrake**: Click **Source** button (top-left)

### **Select DVD Source**
1. **Choose**: `/dev/sr0` (your DVD drive)
2. **HandBrake will scan** the DVD (this takes 30-60 seconds)
3. **You'll see**: Title list appear on the left

---

## 🔍 **Step 4: Analyze DVD Content**

### **Understanding the Title List**
- **Main Feature**: Usually the longest title (the movie)
- **Chapters**: Individual scenes or episodes
- **Duration**: Shows length of each title
- **Size**: Indicates video quality/bitrate

### **For Movies**:
- **Select** the longest title (usually Title 1)
- **Check duration** matches expected movie length

### **For TV Shows**:
- **Multiple titles** of similar length = episodes
- **Note** which titles are actual episodes vs. menus

---

## ⚙️ **Step 5: Choose Output Settings**

### **Destination Tab**
1. **Click Browse** next to "Destination"
2. **Navigate to**: `/mnt/storage/digital_consolidation/dvd_rips/`
3. **Create folders**: 
   - `movies/` for films
   - `tv_shows/Show_Name/Season_X/` for series
4. **Name your file**: `Movie_Name.mp4` or `Show_S01E01.mp4`

### **Presets Panel (Right Side)**
**For Movies (High Quality)**:
- **Select**: `HQ 1080p30 Surround`
- **Good for**: Feature films, high quality

**For TV Shows (Faster)**:
- **Select**: `Fast 1080p30`
- **Good for**: Series, quicker processing

**For Compatibility**:
- **Select**: `Roku 1080p30 Surround`
- **Good for**: Streaming devices

---

## 🎛️ **Step 6: Advanced Settings (Optional)**

### **Video Tab**
- **Quality**: RF 18-22 (lower = higher quality)
- **Encoder**: H.264 (x264) - most compatible
- **Framerate**: "Same as source"

### **Audio Tab**
- **Track 1**: Usually English audio
- **Codec**: AAC for compatibility
- **Check**: "All Audio" to keep multiple languages

### **Subtitles Tab**
- **Check**: "Scan Foreign Audio"
- **This finds**: Forced subtitles automatically
- **Add more**: If you want all subtitle tracks

### **Chapters Tab**
- **Keep enabled** for navigation in media players
- **Rename chapters** if desired

---

## 🎬 **Step 7: Start Ripping Process**

### **Final Check**
1. **Source**: Shows your DVD title
2. **Destination**: Correct output file path
3. **Preset**: Appropriate quality setting
4. **Duration**: Matches expected length

### **Start Encoding**
1. **Click**: Big green **"Start Encode"** button
2. **Progress bar** appears at bottom
3. **Encoding info** shows:
   - Current FPS (frames per second)
   - ETA (estimated time remaining)
   - File size progress

### **Monitor Progress**
- **Normal speed**: 20-60 FPS depending on quality
- **Time estimate**: Usually 1-3x the movie length
- **Don't close**: HandBrake while encoding

---

## 📊 **Step 8: Understanding the Interface**

### **Activity Window**
- **View** → **Activity Window** shows detailed log
- **Useful for**: Troubleshooting errors
- **Shows**: Detailed encoding progress

### **Preview Feature**
- **Preview** button lets you see a sample
- **Good for**: Testing settings before full rip
- **Choose**: Different time positions

### **Queue System**
- **Add multiple titles** to queue
- **Perfect for**: TV show episodes
- **Process**: Multiple files automatically

---

## 🎯 **Step 9: TV Show Batch Processing**

### **For Multiple Episodes**
1. **Select first episode** title
2. **Set destination**: `Show_S01E01.mp4`
3. **Click**: "Add to Queue" (don't start yet)
4. **Select next episode** title
5. **Change filename**: `Show_S01E02.mp4`
6. **Repeat** for all episodes
7. **Start Queue** processes all automatically

---

## ✅ **Step 10: Completion & Verification**

### **When Finished**
1. **Green checkmark** appears
2. **Audio notification** (optional)
3. **Check file** in destination folder

### **Quick Verification**
1. **Right-click** output file → Properties
2. **Check file size**: Should be 1-8GB depending on quality
3. **Test playback**: Open with media player

### **Automatic Eject**
- **HandBrake** can auto-eject when done
- **Preferences** → **General** → "Eject disc after encode"

---

## 🔧 **Pro Tips for Best Results**

### **Quality Settings**
- **RF 18**: Highest quality (larger files)
- **RF 20**: Excellent quality (recommended)
- **RF 22**: Good quality (smaller files)
- **RF 24**: Acceptable quality (very small files)

### **Speed vs Quality**
- **x264 Preset**: 
  - "Faster" = quicker encode, larger files
  - "Slow" = longer encode, smaller files
  - "Medium" = good balance

### **Audio Considerations**
- **Keep original**: For best quality
- **Downmix**: To stereo if needed
- **Multiple tracks**: For different languages

---

## 🚨 **Troubleshooting Common Issues**

### **DVD Not Detected**
```bash
# Check if DVD is mounted
lsblk | grep sr0

# If not detected, try ejecting and reinserting
eject /dev/sr0
# Wait, then reinsert DVD
```

### **Encoding Errors**
- **Try different title** if one fails
- **Check disc** for scratches/damage
- **Lower quality** settings if struggling

### **Slow Performance**
- **Use "Fast" presets** for quicker processing
- **Close other applications** while encoding
- **Check available disk space**

---

## 📁 **Output Organization**

### **Recommended Structure**
```
/mnt/storage/digital_consolidation/dvd_rips/
├── movies/
│   ├── The_Matrix_1999.mp4
│   ├── Inception_2010.mp4
│   └── ...
├── tv_shows/
│   ├── Breaking_Bad/
│   │   ├── Season_1/
│   │   │   ├── Breaking_Bad_S01E01.mp4
│   │   │   ├── Breaking_Bad_S01E02.mp4
│   │   │   └── ...
│   │   └── Season_2/
│   └── The_Office/
└── documentaries/
```

---

## 🌐 **Network Access**

### **From Your MacBook**
1. **Connect**: `smb://100.100.71.107/StorageDrive`
2. **Navigate**: `digital_consolidation/dvd_rips/`
3. **Stream directly** or copy to MacBook

---

## 🎉 **You're Ready to Rip!**

**The GUI gives you complete control over:**
- ✅ **Visual disc analysis** - see all titles and chapters
- ✅ **Quality previews** - test settings before full rip  
- ✅ **Batch processing** - queue multiple episodes
- ✅ **Advanced options** - fine-tune every setting
- ✅ **Real-time monitoring** - watch progress and stats

**Start with a test disc and explore the interface!** 🚀🎬✨

---

*Professional DVD ripping with visual control - your G9 media station at its finest!* 