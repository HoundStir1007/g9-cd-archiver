# CD-R Batch Ripper - G9 Server Web Interface 📀🌐

## ✅ **G9 SERVER-BASED SOLUTION** - Web-Managed CD-R Processing

**Platform**: G9 Ubuntu Server with USB Optical Drive  
**Interface**: Web UI accessible from any device (iPhone, iPad, laptop)  
**Storage**: Direct to 4TB M.2 internal storage (`/mnt/paperless-ssd/digital_consolidation/cd_rips/`)  
**Access**: Via Tailscale VPN for anywhere management

---

## 🛠️ **Hardware Setup**

### **G9 Server Configuration:**
- **USB Optical Drive** → Connected to G9 Ubuntu server
- **Web Service** → Running on port 8080 (http://g9-server:8080)
- **Storage Target** → 4TB M.2 internal drive
- **Remote Access** → Tailscale VPN for mobile/remote management

### **Setup Requirements:**
1. **Connect USB Optical Drive** to G9 server USB port
2. **Install web interface** via setup script
3. **Configure permissions** for optical drive access
4. **Test mobile access** via web browser

---

## 🌐 **Web Interface Features**

### **📀 Automatic Workflow:**
1. **Insert CD-R** → Web UI shows "Disc Detected: [Name]"
2. **Duplicate Check** → "Checking if disc already ripped..."
3. **Auto-Start** → Begins ripping automatically if new disc
4. **Progress Display** → Real-time progress bar and file count
5. **Completion Alert** → Web notification + optional audio alert
6. **Auto-Eject** → Disc ejects automatically when complete

### **📱 Mobile-Optimized Interface:**
```
📀 G9 CD-R Ripper
━━━━━━━━━━━━━━━━━━━━━━━━
Status: Waiting for disc...

[  Insert CD-R into drive  ]

Current Session: 0 discs
Total Archived: 247 discs
Available Space: 3.2TB
━━━━━━━━━━━━━━━━━━━━━━━━
```

### **🎯 Smart Features:**
- **Duplicate Detection** → Hash-based comparison of existing rips
- **Custom Naming** → Override auto-detected disc names
- **Content Preview** → Show files before ripping starts
- **Batch Tracking** → Session statistics and progress
- **Error Recovery** → Retry failed reads, skip corrupted files
- **Audio Alerts** → Optional sound notifications for completion

---

## 🚀 **Installation & Setup**

### **1. Deploy Web Interface**
```bash
# Run on G9 server after G9-Reborn installation
sudo apt update && sudo apt install python3-flask python3-psutil
cd /opt
sudo git clone [cd-ripper-web-repo]
sudo ./setup-cd-ripper.sh
```

### **2. Configure USB Drive Access**
```bash
# Add user to cdrom group for optical drive access
sudo usermod -a -G cdrom $USER
# Configure udev rules for automatic detection
sudo cp 99-cd-ripper.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
```

### **3. Start Web Service**
```bash
# Enable systemd service for auto-start
sudo systemctl enable cd-ripper-web
sudo systemctl start cd-ripper-web
# Access via http://g9-server:8080 or Tailscale IP
```

---

## 📱 **Mobile Web Interface Workflow**

### **Typical Session:**
1. **📱 Open browser** → Navigate to `http://g9-server:8080`
2. **👀 Status check** → See current disc status and available space
3. **📀 Insert disc** → Web UI auto-detects and shows disc info
4. **✅ Auto-start** → Ripping begins automatically (or manual override)
5. **📊 Monitor progress** → Real-time updates on mobile device
6. **🔔 Completion alert** → Web notification when disc complete
7. **⏏️ Auto-eject** → Disc ejects, ready for next

### **Manual Override Options:**
- **⏸️ Pause/Resume** → Control ripping process
- **📝 Rename** → Custom disc/folder naming
- **🔍 Preview** → See disc contents before starting
- **⚠️ Force Retry** → Re-rip discs that had errors

---

## 🎯 **Integration with Digital Archive**

### **Storage Structure:**
```
/mnt/paperless-ssd/digital_consolidation/cd_rips/
├── session_logs/
│   └── ripping_session_20250122.json
├── duplicates_detected/
│   └── [discs that were already ripped]
├── Family_Photos_2003_20250122_143022/
│   ├── _DISC_INFO.json
│   └── [original files]
└── Music_Collection_20250122_143156/
    ├── _DISC_INFO.json
    └── [audio files]
```

### **Metadata Tracking:**
- **Disc fingerprint** → SHA256 hash for duplicate detection
- **Rip timestamp** → When disc was processed
- **File integrity** → Checksums for all copied files
- **Session tracking** → Batch processing statistics
- **Error logs** → Issues encountered during ripping

---

## 🔧 **Advanced Features**

### **🤖 Smart Detection:**
- **Disc type recognition** → Audio CD vs. Data CD vs. Mixed
- **Content analysis** → Photo disc vs. backup disc vs. software
- **Automatic organization** → Smart folder categorization
- **Metadata extraction** → Audio CD track info via MusicBrainz

### **📊 Analytics Dashboard:**
- **Session progress** → Discs processed per session
- **Storage usage** → Space used vs. available
- **Duplicate statistics** → How many duplicates found
- **Error rates** → Success vs. failure percentages

### **🔔 Notification Options:**
- **Web alerts** → Browser notifications
- **Audio alerts** → Configurable sound effects
- **Tailscale integration** → Push notifications via network
- **Completion summary** → End-of-session reports

---

**🎉 Result**: Professional CD-R archiving system with anywhere-access web management!**  
**📱 Mobile-first**: Perfect for iPhone/iPad remote management  
**🚀 Automated**: Insert disc → automatic processing → audio alert → eject  
**🏆 Integration**: Seamless addition to 1.315TB digital archaeology collection

---

*Ready for G9-Reborn deployment with USB optical drive web management!* 🌟✨ 