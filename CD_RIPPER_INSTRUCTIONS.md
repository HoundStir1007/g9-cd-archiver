# CD-R Batch Ripper Instructions 📀

## ✅ **UPDATED POST-DIGITAL ARCHAEOLOGY** - 4TB Internal Storage Ready!

**Status**: Canvio drive **liberated** after successful 320GB transfer to G9 server  
**New Target**: Direct network transfer to **4TB M.2 internal storage** (post-Saturday installation)  
**Platform**: Mac mini A1347 (now freed from transfer duties for CD-R automation)

---

## Setup on Mac Mini (OS X 10.8)

### 1. Transfer Files
Copy these files to your Mac Mini via thumb drive:
- `cd_ripper_mac.sh` - The main script
- `CD_RIPPER_INSTRUCTIONS.md` - This file

### 2. Prepare the Script
1. Open Terminal on your Mac Mini
2. Navigate to where you copied the script:
   ```bash
   cd /Volumes/YourThumbDrive/  # or wherever you copied it
   ```
3. Make the script executable:
   ```bash
   chmod +x cd_ripper_mac.sh
   ```
4. Copy to Desktop for easy access:
   ```bash
   cp cd_ripper_mac.sh ~/Desktop/
   cd ~/Desktop
   ```

### 3. Run the Script
```bash
./cd_ripper_mac.sh
```

## How It Works 🚀

### Automated Process
1. **Insert CD-R** into the drive
2. **Press ENTER** when prompted
3. Script will:
   - Detect the disc automatically
   - Create a folder named: `DiscName_YYYYMMDD_HHMMSS`
   - Copy ALL files with original dates preserved
   - Create a `_DISC_INFO.txt` file with metadata
   - Eject the disc automatically
   - Play beep sounds when done
4. **Repeat** for next disc

### 🔄 **NEW: Network Storage Strategy**
- **Pre-4TB Installation**: Local staging to Mac mini internal drive
- **Post-4TB Installation**: Direct network transfer to G9 server 4TB M.2 storage
- **Target Path**: `/mnt/paperless-ssd/digital_consolidation/cd_rips/` (4TB internal)
- **Integration**: Seamless addition to **1.315TB digital archaeology collection**

### Folder Structure Example
```
# Post-4TB Installation (Network Target):
/mnt/paperless-ssd/digital_consolidation/cd_rips/
├── Family_Photos_2003_20250622_143022/
│   ├── _DISC_INFO.txt
│   ├── IMG_001.jpg
│   └── IMG_002.jpg
├── Music_Mix_20250622_143156/
│   ├── _DISC_INFO.txt
│   ├── track01.mp3
│   └── track02.mp3
└── ripping_log.txt
```

## Features ✨

- **Automatic disc detection** - No need to specify paths
- **Safe file naming** - Handles special characters in disc names
- **Metadata preservation** - Keeps original file dates
- **Comprehensive logging** - Track what was ripped when
- **Audio feedback** - Beeps when each disc is complete
- **Error handling** - Gracefully handles read errors
- **Unique naming** - Timestamp prevents folder conflicts
- **🆕 Network Integration** - Direct transfer to 4TB internal storage

## Tips 💡

1. **Empty disc names**: If a disc has no name, it will use the mount path
2. **Special characters**: Automatically sanitized for safe folder names
3. **Large discs**: Progress is shown, be patient for full CDs
4. **Read errors**: Script continues copying what it can
5. **Quit anytime**: Type `quit`, `exit`, or `q` to stop
6. **🆕 Network Storage**: Wait for 4TB installation for optimal workflow

## Troubleshooting 🔧

### Script won't run:
```bash
chmod +x cd_ripper_mac.sh
```

### ~~Canvio drive not detected~~ ✅ **RESOLVED**: 
- **Canvio Status**: **Successfully transferred** to G9 server (320GB rescued)
- **New Strategy**: Direct network storage to 4TB M.2 internal drive
- **Platform**: Mac mini now dedicated to CD-R batch processing

### No disc detected:
- Wait a moment after inserting disc
- Try ejecting and reinserting
- Check if disc mounts in Finder

### Permission errors:
- Some discs may have read-only files - this is normal
- Script will copy what it can and continue

## 🎯 **Integration with Completed Digital Archaeology Project**

### **Perfect Timing** ⚡
- **Canvio Drive**: ✅ **320GB transferred** to G9 server - drive now available
- **Thunderbolt Drive**: ✅ **995GB transferred** to G9 server - total **1.315TB rescued**
- **Mac mini A1347**: **Freed from transfer duties** - ready for CD-R automation
- **4TB M.2 SSD**: **Saturday installation** - unlimited storage capacity

### **Seamless Integration** 🔗
- CD-R content will join **1.315TB digital archaeology collection**
- All content consolidated on **4TB internal M.2 storage** 
- **LLM-assisted organization** of combined digital archives
- **Pure internal storage architecture** - no external drives needed

### **Deployment Readiness** 🚀
- **Platform Ready**: Mac mini liberated for CD-R duties
- **Storage Ready**: 4TB M.2 installation Saturday
- **Workflow Tested**: Transfer protocols proven with 1.315TB success
- **Organization Ready**: LLM categorization system prepared

---

**🎉 Status**: Ready for deployment post-4TB installation!  
**🎯 Capacity**: Decades of CD-R content with automated organization  
**🏆 Integration**: Perfect addition to 1.315TB digital archaeology success!

Happy ripping! 🎵💾 