# 🌟 G9 Network File Sharing Guide 📁

## 🎯 **READY TO ACCESS! Your G9 files are now available on the network!** ✨

### **📍 Connection Details**
- **🔗 Server Address**: `100.100.71.107` (via Tailscale VPN)
- **👤 Username**: `mark`
- **🔐 Password**: `admin123` (same as your other services)
- **🌐 Protocol**: SMB/CIFS (native macOS support)

---

## 🍎 **MacBook Connection Instructions**

### **Method 1: Finder (Recommended) 🎯**
1. **Open Finder** on your MacBook
2. **Press** `Cmd + K` (or Go → Connect to Server)
3. **Enter**: `smb://100.100.71.107`
4. **Click "Connect"**
5. **Choose "Registered User"**
6. **Enter credentials**:
   - Name: `mark`
   - Password: `admin123`
7. **Select shares to mount** (see options below)

### **Method 2: Direct Share URLs 🚀**
**✅ RECOMMENDED: Use these space-free versions (confirmed working on macOS):**
- **📊 Data Drive**: `smb://100.100.71.107/DataDrive`
- **💾 Storage Drive**: `smb://100.100.71.107/StorageDrive`  
- **🔧 Home Research**: `smb://100.100.71.107/HomeResearch`

**Alternative URLs (with spaces - may cause compatibility issues):**
- **📊 Data Drive**: `smb://100.100.71.107/Data%20Drive`
- **💾 Storage Drive**: `smb://100.100.71.107/Storage%20Drive`  
- **🔧 Home Research**: `smb://100.100.71.107/Home%20Research`

---

## 📁 **Available Network Shares**

### **🗂️ Data Drive (1.8TB - 96% full)**
- **Path**: `/mnt/data`
- **Contents**: Paperless-ngx documents, archives, important data
- **Size**: 1.7TB used, 84GB available
- **Use**: Document storage, Paperless data, archives

### **💾 Storage Drive (3.7TB - Lots of space!)**
- **Path**: `/mnt/storage`  
- **Contents**: Media files, backups, CD rips, general storage
- **Size**: 23GB used, 3.5TB available (97% free!)
- **Use**: Media library, backups, CD ripping output, bulk storage

### **🏠 Home Research Project**
- **Path**: `/home/mark/Desktop/home_server_research`
- **Contents**: All your G9 configuration scripts and documentation
- **Use**: Direct editing of server configs from MacBook

---

## 🔧 **What You Can Do Now**

### **📝 Direct File Management**
- **Browse & Edit**: All your server files directly from MacBook
- **Drag & Drop**: Move files between MacBook and G9 drives
- **Real-time Access**: Changes sync immediately
- **Native Integration**: Works with all macOS apps

### **💡 Practical Uses**
1. **📄 Access Paperless Documents**: Browse scanned documents directly
2. **🎬 Media Management**: Organize Jellyfin media files
3. **💾 Backup Storage**: Use Storage Drive for MacBook backups
4. **🎵 CD Rip Management**: Access your ripped CDs
5. **⚙️ Server Configuration**: Edit G9 configs from MacBook

### **🎵 CD Ripping Integration**
- **Output Location**: `/mnt/storage/digital_consolidation/cd_rips/`
- **Access**: Browse ripped CDs directly from your MacBook
- **Organization**: Automatic Artist/Album folder structure

---

## 🔐 **Security Features**

✅ **Tailscale VPN Protection**: All traffic encrypted  
✅ **User Authentication**: Password-protected access  
✅ **No Guest Access**: Secure, user-only shares  
✅ **Permission Control**: Proper file ownership maintained  

---

## 🚀 **Performance Tips**

### **For Best Performance**:
- **Use Tailscale IP**: `100.100.71.107` (faster than local discovery)
- **Mount Specific Shares**: Don't mount all at once if not needed
- **Large File Transfers**: Use Storage Drive (3.5TB free space)

### **Automount on MacBook** (Optional):
Add to **System Settings → General → Login Items** for automatic connection

---

## 🎉 **Success! Your G9 is now a proper network storage server!**

### **What's Working**:
✅ **SMB Server**: Running and accessible  
✅ **Firewall**: Configured for SMB access  
✅ **User Authentication**: Secure password access  
✅ **Three Network Shares**: All drives accessible  
✅ **Tailscale Integration**: Secure remote access  

### **Next Steps**:
1. **Connect from MacBook** using instructions above
2. **Test file transfers** between drives
3. **Organize your data** across the available storage
4. **Enjoy network file access** from anywhere via Tailscale! 🌟

---

*Network sharing operational! Access your G9 files from your MacBook like a pro! 📁✨* 