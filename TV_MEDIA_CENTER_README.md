# 🎬🎮 TV Media Center - Ultimate Entertainment System

**Transform your G9 into a complete living room entertainment system!**

---

## 🎯 **What This System Does**

Your G9 server now functions as a **complete TV media center** that combines:
- **🎬 Jellyfin Media Streaming** - Movies, TV shows, music with gamepad control
- **🎮 RetroArch Gaming** - Classic console emulation with same gamepad setup
- **📺 Dual Display Setup** - TV for entertainment, monitor for desktop work
- **🔊 TV Audio Routing** - Perfect audio through TV speakers via HDMI
- **⚡ Unified Control** - Same gamepad works for both media and gaming

---

## 🚀 **Quick Start**

### **Option 1: Full Menu System**
```bash
./tv_media_center.sh
```
Choose from interactive menu:
1. 🎬 Jellyfin Media Center
2. 🎮 RetroArch Gaming  
3. ⚙️ Configure RetroArch
4. 🛑 Exit

### **Option 2: Direct Launch**
```bash
./launch_jellyfin_tv.sh    # Direct to Jellyfin TV mode
./launch_retroarch_tv.sh   # Direct to RetroArch gaming
```

---

## 📺 **Display Setup**

**Perfect Dual Display Configuration:**
- **📺 Vizio TV (HDMI-2)**: 1920x1080 at position 0,0 (Entertainment display)
- **🖥️ 4K Monitor (HDMI-1)**: 3840x2160 at position 1920,0 (Desktop work)

**Total Resolution**: 5760x2160 pixels - TV + Monitor working together!

---

## 🎬 **Jellyfin TV Mode**

### **Features:**
- ✅ **TV Fullscreen**: Firefox optimized for TV viewing
- ✅ **Gamepad Control**: D-pad navigation with smooth sensitivity  
- ✅ **TV Audio**: Sound routed to TV speakers (HDMI 1)
- ✅ **TV Mode Interface**: Large tiles perfect for couch viewing
- ✅ **Zero Transcoding**: Direct local playback for perfect quality
- ✅ **Phone Backup**: Remote control via http://192.168.0.182:8096

### **Usage:**
1. Run `./launch_jellyfin_tv.sh`
2. Drag Firefox window to TV and make fullscreen
3. Go to Settings > Display > Enable TV Mode
4. Use gamepad for navigation
5. Press `Alt+F4` or `pkill firefox` to exit

---

## 🎮 **RetroArch Gaming Mode**

### **Features:**
- ✅ **TV Fullscreen**: Games display perfectly on TV
- ✅ **Gamepad Control**: Same controller works for navigation and gaming
- ✅ **TV Audio**: Game audio through TV speakers
- ✅ **Save States**: Save/load game progress anywhere
- ✅ **Multiple Consoles**: NES, SNES, GBA, N64, PlayStation, Genesis, etc.
- ✅ **High Performance**: Samsung SSD storage for fast loading

### **Usage:**
1. Run `./launch_retroarch_tv.sh`
2. RetroArch opens fullscreen on TV
3. Use gamepad to navigate menu
4. Load Content > Browse for ROM files
5. Download cores for different consoles
6. Press `F1` to toggle menu, `Escape` to exit

### **Key Controls:**
- **Navigation**: Gamepad D-pad or arrow keys
- **Select**: A button or Enter
- **Back**: B button or Escape
- **Menu Toggle**: F1 or Select+Start
- **Save State**: F2
- **Load State**: F4
- **Exit**: Escape

---

## 📁 **File Organization**

### **ROM Storage:**
```
/mnt/paperless-ssd/retro-gaming/
├── roms/
│   ├── nes/        ← Nintendo Entertainment System
│   ├── snes/       ← Super Nintendo
│   ├── gba/        ← Game Boy Advance
│   ├── gbc/        ← Game Boy Color  
│   ├── n64/        ← Nintendo 64
│   ├── psx/        ← PlayStation 1
│   ├── genesis/    ← Sega Genesis
│   ├── arcade/     ← Arcade/MAME
│   ├── atari2600/  ← Atari 2600
│   ├── gameboy/    ← Game Boy
│   ├── dreamcast/  ← Dreamcast
│   └── neogeo/     ← Neo Geo
├── saves/          ← Save files
├── states/         ← Save states
├── bios/           ← System BIOS files
├── screenshots/    ← Game screenshots
└── playlists/      ← Game collections
```

### **Adding ROMs:**
1. Copy ROM files to appropriate system folder
2. Some systems need BIOS files in `/mnt/paperless-ssd/retro-gaming/bios/`
3. RetroArch will automatically detect new ROMs

---

## 🎯 **System Settings**

### **Audio Configuration:**
- **HDMI Audio**: Automatically routes to TV speakers via HDMI 1
- **Volume**: Set to 70% for optimal TV listening
- **Device**: `alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1`

### **Gamepad Settings:**
- **Repeat Rate**: 150ms for smooth navigation
- **Delay**: 500ms to prevent accidental inputs
- **Auto-detect**: Gamepads automatically recognized

### **Display Settings:**
- **TV Target**: HDMI-2 (1920x1080) for all entertainment
- **Monitor Available**: HDMI-1 (3840x2160) for desktop work
- **Fullscreen**: All media applications launch fullscreen on TV

---

## 🛠️ **Technical Components**

### **System Requirements:**
- ✅ **Ubuntu Server**: G9 with dual HDMI outputs
- ✅ **Jellyfin**: Media server running on port 8096
- ✅ **RetroArch**: Version 1.18.0 with cores
- ✅ **Firefox**: Web browser for Jellyfin TV interface
- ✅ **Storage**: Samsung SSD mounted at `/mnt/paperless-ssd`

### **Network Access:**
- **Jellyfin**: http://100.100.71.107:8096 (Tailscale) or http://192.168.0.182:8096 (local)
- **Remote Desktop**: 100.100.71.107:3389 for system management
- **File Sharing**: SMB access via `smb://100.100.71.107`

---

## 🎉 **Why This Setup is Superior**

### **vs. Commercial Streaming Devices:**
- ✅ **No Monthly Fees**: Own your media library
- ✅ **Perfect Quality**: No compression or transcoding
- ✅ **Complete Control**: Full customization of interface
- ✅ **Gaming Integration**: Retro gaming + media in one system
- ✅ **Desktop Available**: Monitor for system management

### **vs. Separate Gaming Systems:**
- ✅ **Unified Interface**: One system for all entertainment
- ✅ **Shared Storage**: All media and games on fast SSD
- ✅ **Single Gamepad**: Same controller for media and gaming
- ✅ **Consistent Audio**: TV speakers for everything
- ✅ **No Device Switching**: Seamless between media and games

---

## 🔧 **Troubleshooting**

### **Audio Issues:**
```bash
# Check audio devices
pactl list short sinks

# Reset audio to TV
pactl set-default-sink alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1
```

### **Display Issues:**
```bash
# Check display configuration
xrandr --listmonitors

# Verify TV is detected
xrandr | grep HDMI
```

### **Gamepad Issues:**
```bash
# Check gamepad detection
ls /dev/input/js*

# Test gamepad input
jstest /dev/input/js0
```

### **RetroArch Issues:**
```bash
# Reset RetroArch configuration
rm -rf ~/.config/retroarch/retroarch.cfg
./tv_media_center.sh  # Select option 3 to reconfigure
```

---

## 🎯 **Usage Scenarios**

### **Movie Night:**
1. Run `./launch_jellyfin_tv.sh`
2. Navigate to Movies with gamepad
3. Select and play - perfect quality on TV
4. Use phone as backup remote if needed

### **Gaming Session:**
1. Run `./launch_retroarch_tv.sh`
2. Load Content > Browse ROM folders
3. Select game and play on TV
4. Save states to continue later

### **Party Mode:**
1. Use main menu `./tv_media_center.sh`
2. Switch between movies and games easily
3. Everyone can use same gamepad
4. TV speakers for group entertainment

---

## 📈 **Next Steps**

### **Content Organization:**
- Add ROM files to system-specific folders
- Create game playlists for favorites
- Organize Jellyfin library with metadata

### **System Enhancement:**
- Add more gaming systems (PSP, Nintendo DS, etc.)
- Create game artwork and descriptions
- Set up network multiplayer gaming

### **Advanced Features:**
- Configure RetroArch shaders for enhanced graphics
- Set up achievement systems
- Create custom game collections

---

🎉 **Your G9 is now a complete entertainment powerhouse!** 🎉

*Enjoy your unified TV media center with both streaming and gaming capabilities!* 