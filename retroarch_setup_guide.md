# 🎮 RetroArch Centralized Gaming Setup Guide

**Server:** G9 Ubuntu (100.91.157.19)  
**Setup Time:** ~30 minutes  
**Result:** Centralized retro gaming library with cross-device save states

---

## 🏗️ **Infrastructure Complete**

✅ **RetroArch Installed:** Version 1.20.0 on Ubuntu server  
✅ **Directory Structure:** Professional ROM organization on Samsung SSD  
✅ **SMB Share:** `retro-gaming` accessible via Finder  
✅ **Storage:** High-performance Samsung SSD for fast loading

### 📁 **Directory Structure Created**
```
/mnt/paperless-ssd/retro-gaming/
├── roms/           ← ROM files organized by system
│   ├── nes/        ← Nintendo Entertainment System
│   ├── snes/       ← Super Nintendo
│   ├── gba/        ← Game Boy Advance
│   ├── gbc/        ← Game Boy Color
│   ├── n64/        ← Nintendo 64
│   ├── psx/        ← PlayStation 1
│   ├── genesis/    ← Sega Genesis
│   ├── arcade/     ← Arcade/MAME
│   └── [others]/   ← Additional systems
├── saves/          ← Save files (.sav)
├── states/         ← Save states (.state)
├── configs/        ← System-specific configurations
├── cores/          ← RetroArch core files
├── bios/           ← System BIOS files
├── screenshots/    ← In-game screenshots
└── playlists/      ← Game playlists and metadata
```

---

## 🌐 **Access Methods**

### **SMB Share Access (Recommended)**
- **Tailscale:** `smb://100.91.157.19/retro-gaming`
- **Local Network:** `smb://192.168.0.178/retro-gaming`
- **macOS Finder:** Drag and drop ROM management
- **Credentials:** Username: `gmk`, Password: [server password]

### **SSH Access (Advanced)**
```bash
ssh gmk@100.91.157.19
cd /mnt/paperless-ssd/retro-gaming
```

---

## 🎮 **RetroArch Configuration**

### **Step 1: Configure Directories (On Server)**
```bash
ssh gmk@100.91.157.19
retroarch --menu
```

**In RetroArch Menu:**
1. Settings → Directory
2. Set paths to shared directories:
   - **ROM Directory:** `/mnt/paperless-ssd/retro-gaming/roms`
   - **Save Files:** `/mnt/paperless-ssd/retro-gaming/saves`
   - **Save States:** `/mnt/paperless-ssd/retro-gaming/states`
   - **System/BIOS:** `/mnt/paperless-ssd/retro-gaming/bios`
   - **Screenshots:** `/mnt/paperless-ssd/retro-gaming/screenshots`
   - **Playlists:** `/mnt/paperless-ssd/retro-gaming/playlists`

### **Step 2: Download Cores**
**In RetroArch Menu:**
1. Online Updater → Core Downloader
2. Download cores for your systems:
   - **NES:** `nestopia_libretro.so` or `fceu_libretro.so`
   - **SNES:** `snes9x_libretro.so`
   - **Game Boy/GBC:** `gambatte_libretro.so`
   - **GBA:** `mgba_libretro.so`
   - **N64:** `mupen64plus_next_libretro.so`
   - **PlayStation:** `pcsx_rearmed_libretro.so`
   - **Genesis:** `genesis_plus_gx_libretro.so`

### **Step 3: BIOS Setup (If Needed)**
Some systems require BIOS files:
- **PlayStation:** `scph1001.bin`, `scph5501.bin`, `scph7001.bin`
- **Game Boy Advance:** `gba_bios.bin`
- Place in `/mnt/paperless-ssd/retro-gaming/bios/`

---

## 📱 **Multi-Device Setup**

### **Option 1: Additional RetroArch Installations**
Install RetroArch on other devices and point to same SMB share:
- **macOS:** `brew install --cask retroarch`
- **Windows:** Download from retroarch.com
- **Configuration:** Point all directories to mounted SMB share

### **Option 2: ROM Management Only**
- Use SMB share just for ROM management via Finder
- Copy ROMs to local RetroArch installations as needed
- Manually sync save files when switching devices

---

## 🎯 **Usage Workflow**

### **Adding New ROMs**
1. **Open Finder:** Connect to `smb://100.91.157.19/retro-gaming`
2. **Navigate:** Go to appropriate ROM system folder
3. **Add ROMs:** Drag and drop ROM files from Downloads
4. **Refresh:** RetroArch will detect new ROMs automatically

### **Cross-Device Gaming**
1. **Start Game:** On any device with access to shared storage
2. **Save State:** Use RetroArch's save state feature
3. **Switch Devices:** Load same save state on different device
4. **Continue Playing:** Seamless gameplay across devices

### **Backup Strategy**
- **Primary Storage:** Samsung SSD (high performance)
- **Backup:** Include in existing server backup strategy
- **ROM Organization:** Keep original ROM downloads organized

---

## 🔧 **Troubleshooting**

### **SMB Connection Issues**
```bash
# Test SMB service status
sudo systemctl status smbd

# Restart SMB services
sudo systemctl restart smbd nmbd

# Check share permissions
ls -la /mnt/paperless-ssd/retro-gaming
```

### **RetroArch Directory Issues**
```bash
# Verify directory permissions
sudo chown -R gmk:gmk /mnt/paperless-ssd/retro-gaming
sudo chmod -R 755 /mnt/paperless-ssd/retro-gaming
```

### **Performance Issues**
- **Wired Connection:** Use Ethernet for best ROM loading speeds
- **Local Storage:** Consider copying frequently played games to local storage
- **Core Selection:** Some cores perform better than others

---

## 🎉 **Ready to Game!**

Your centralized RetroArch system provides:
- **🗂️ Organized Library:** Professional ROM organization by system
- **💾 Shared Saves:** Start on server, continue on MacBook
- **🌐 Remote Access:** Play your games from anywhere via Tailscale
- **📱 Easy Management:** Finder drag-and-drop ROM management
- **⚡ Fast Loading:** Samsung SSD performance for instant game loading

### **Next Steps:**
1. **🎮 Add ROMs:** Start building your game library
2. **🎯 Test Gaming:** Verify save states work across devices
3. **📋 Organize:** Create playlists for favorite games
4. **🎨 Customize:** Configure RetroArch themes and settings

**🏆 Professional retro gaming setup complete!**

---

*Running on G9 Ubuntu + Samsung SSD - Centralized gaming library operational* 