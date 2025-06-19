# CD-R Batch Ripper Instructions 📀

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

### Output Location
- All ripped files go to: `/Volumes/Canvio/CD_Rips/`
- Each disc gets its own timestamped folder
- Log file created: `/Volumes/Canvio/CD_Rips/ripping_log.txt`
- **Requires Canvio drive to be connected and mounted**

### Folder Structure Example
```
/Volumes/Canvio/CD_Rips/
├── Family_Photos_2003_20250619_143022/
│   ├── _DISC_INFO.txt
│   ├── IMG_001.jpg
│   └── IMG_002.jpg
├── Music_Mix_20250619_143156/
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

## Tips 💡

1. **Empty disc names**: If a disc has no name, it will use the mount path
2. **Special characters**: Automatically sanitized for safe folder names
3. **Large discs**: Progress is shown, be patient for full CDs
4. **Read errors**: Script continues copying what it can
5. **Quit anytime**: Type `quit`, `exit`, or `q` to stop

## Troubleshooting 🔧

### Script won't run:
```bash
chmod +x cd_ripper_mac.sh
```

### Canvio drive not detected:
- Ensure Canvio drive is connected via USB
- Check if it appears in Finder under "Devices"
- May need to manually mount: Go to Disk Utility

### No disc detected:
- Wait a moment after inserting disc
- Try ejecting and reinserting
- Check if disc mounts in Finder

### Permission errors:
- Some discs may have read-only files - this is normal
- Script will copy what it can and continue

## After Ripping 📦

Once you've ripped all your CD-Rs:
1. **Copy results** to thumb drive
2. **Transfer to G9 server** via your existing workflow
3. **Add to digital consolidation project** 
4. Files will be ready for **LLM-assisted organization**!

## Integration with Digital Archaeology Project 🏛️

This perfectly fits your current consolidation effort:
- Output format matches your existing `cd_rips/` staging area
- Timestamps and metadata support organization phase
- Ready for bulk transfer to G9 server
- Prepared for LLM duplicate detection and sorting

Happy ripping! 🎵 