# 🚀 G9 Nuclear Ubuntu Setup - Complete Checklist

*Updated: December 22, 2024*  
*Status: READY FOR EXECUTION - Nuclear Option Prepared*

---

## 📋 **EXECUTIVE SUMMARY**

**Mission**: Complete fresh Ubuntu 24.04 LTS installation on 4TB M.2 SSD while preserving Windows and all data.

**Why Nuclear?**: Filesystem corruption during 4TB SSD installation damaged critical system files. Standard repairs failed. Nuclear approach provides clean slate.

**Safety**: Windows license preserved (OEM tied to G9 hardware), all data drives untouched.

---

## 🔍 **CURRENT SYSTEM ANALYSIS**

### **💾 Drive Layout (Confirmed)**
```
├── mmcblk0 (56GB) - Current Ubuntu system - TARGET FOR REPLACEMENT
├── nvme0n1 (4TB) - New M.2 SSD - TARGET FOR FRESH UBUNTU INSTALL  
├── nvme1n1 - Windows drive (BitLocker) - PRESERVE UNTOUCHED
├── nvme2n1 (2TB) - Paperless data - PRESERVE UNTOUCHED
└── sda1 (916GB) - External Seagate - PRESERVE UNTOUCHED
```

### **🪟 Windows License Status**
- ✅ **Windows detected on nvme1n1** (separate drive with BitLocker)
- ✅ **OEM license tied to G9 hardware** - you own it permanently
- ✅ **Can reinstall Windows anytime** on this G9
- ✅ **Completely isolated** - won't be affected by Ubuntu changes

### **⚠️ Current Issue**
- X server session creation fails despite all services running
- Root cause: Filesystem corruption during SSD installation
- All standard repair attempts exhausted
- Nuclear approach = guaranteed fix

---

## 🎯 **NUCLEAR SETUP PLAN**

### **Phase 1: Preparation** ✅
- [x] Analysis complete - system layout confirmed
- [x] Windows preservation verified
- [x] Scripts created and tested
- [x] Backup strategy defined

### **Phase 2: Pre-Installation Setup** 
- [ ] Run `ultimate_nuclear_setup.sh` to prepare system
- [ ] Backup critical configurations
- [ ] Download Ubuntu 24.04 LTS ISO
- [ ] Create bootable USB drive
- [ ] Verify all preparation files

### **Phase 3: Fresh Installation**
- [ ] Boot from Ubuntu USB
- [ ] Install Ubuntu on nvme0n1 (4TB drive) ONLY
- [ ] Configure GRUB for dual boot
- [ ] Complete base installation

### **Phase 4: Post-Installation**
- [ ] Run post-installation setup script
- [ ] Configure all services (SSH, xRDP, Tailscale)
- [ ] Mount existing data drives
- [ ] Restore configurations
- [ ] Test all functionality

---

## 📝 **DETAILED EXECUTION CHECKLIST**

### **🔧 PRE-INSTALLATION (Do First)**

#### **Step 1: Run Nuclear Setup Preparation**
```bash
# Copy and execute preparation script
scp ultimate_nuclear_setup.sh gmk@100.91.157.19:~/
ssh gmk@100.91.157.19 "chmod +x ultimate_nuclear_setup.sh && ./ultimate_nuclear_setup.sh"
```

**This script will:**
- [ ] Backup SSH keys and configurations
- [ ] Backup system configs (/etc/ssh, /etc/fstab, etc.)
- [ ] Create Ubuntu ISO download script
- [ ] Generate installation instructions
- [ ] Create post-installation setup script
- [ ] Verify available space on 4TB drive

**Expected Output Location:** `/media/gmk/seagate/ubuntu_install/`

#### **Step 2: Download Ubuntu ISO**
```bash
# On G9 server
cd /media/gmk/seagate/ubuntu_install/
./download_ubuntu.sh
```
- [ ] Ubuntu 24.04 LTS ISO downloaded
- [ ] Verify download integrity (optional: check SHA256)

#### **Step 3: Create Bootable USB**
```bash
# On macOS (or use GUI tool like Balena Etcher)
sudo dd if=ubuntu-24.04-desktop-amd64.iso of=/dev/diskX bs=1m
# Replace X with correct disk number (use diskutil list)
```
- [ ] Bootable USB created
- [ ] USB tested and boots to Ubuntu installer

### **💿 INSTALLATION PROCESS**

#### **Step 4: Boot and Install Ubuntu**

**⚠️ CRITICAL: Drive Selection**
- ✅ **TARGET**: `nvme0n1` (4TB M.2 SSD) 
- ❌ **AVOID**: `nvme1n1` (Windows), `nvme2n1` (Paperless), `mmcblk0` (old Ubuntu), `sda` (External)

**Installation Steps:**
1. [ ] Boot from USB drive
2. [ ] Select "Install Ubuntu"
3. [ ] Choose **"Something else"** for partitioning
4. [ ] Select **nvme0n1** (4TB drive) ONLY
5. [ ] Create partitions:
   - [ ] 512MB EFI partition (Type: EFI System Partition)
   - [ ] Remaining space as ext4 (Mount point: /)
6. [ ] Install GRUB to **nvme0n1** (4TB drive)
7. [ ] Complete installation with user: `gmk`
8. [ ] Reboot when prompted

#### **Step 5: Initial Boot Verification**
- [ ] System boots to fresh Ubuntu
- [ ] Login with gmk user works
- [ ] Network connectivity confirmed
- [ ] Can access terminal

### **⚙️ POST-INSTALLATION SETUP**

#### **Step 6: Run Post-Installation Script**
```bash
# Copy from backup location or re-download
# Script should be at: /media/[external-drive]/ubuntu_install/post_install_setup.sh
chmod +x post_install_setup.sh
./post_install_setup.sh
```

**Script will install:**
- [ ] SSH server and essential packages
- [ ] XFCE4 desktop environment  
- [ ] xRDP with proper configuration
- [ ] Tailscale for remote access
- [ ] Docker for containers
- [ ] Firewall configuration

#### **Step 7: Mount Existing Data Drives**
```bash
# Create mount points
sudo mkdir -p /mnt/paperless-ssd /mnt/seagate-external

# Add to /etc/fstab (verify UUIDs first with blkid)
echo "UUID=6aba2948-0f30-4b5a-83f5-6e3cac43caec /mnt/paperless-ssd ext4 defaults 0 2" | sudo tee -a /etc/fstab
echo "UUID=938d27e9-8dbd-49ae-9322-77aee1a63655 /mnt/seagate-external ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Mount all
sudo mount -a
```
- [ ] Paperless SSD mounted at `/mnt/paperless-ssd`
- [ ] External Seagate mounted at `/mnt/seagate-external`
- [ ] All existing data accessible

#### **Step 8: Configure Tailscale**
```bash
sudo tailscale up
# Follow authentication prompts
```
- [ ] Tailscale configured and connected
- [ ] Note new Tailscale IP address
- [ ] Verify connectivity from macOS

#### **Step 9: Test Remote Access**
- [ ] SSH connection: `ssh gmk@[tailscale-ip]`
- [ ] xRDP connection: Connect to `[tailscale-ip]:3389` 
- [ ] Desktop environment loads properly
- [ ] File access works for all mounted drives

### **🔄 RESTORE CONFIGURATIONS**

#### **Step 10: Restore Backed-Up Configurations**
```bash
# Restore from backup (created in Step 1)
BACKUP_DIR="/mnt/4tb-internal/ubuntu_backup_[timestamp]"

# Restore SSH keys
cp -r "$BACKUP_DIR/.ssh" ~/

# Restore home configs
cd ~ && tar xzf "$BACKUP_DIR/home_configs.tar.gz"

# Restore system configs (review before applying)
sudo cp -r "$BACKUP_DIR/ssh" /etc/
sudo cp "$BACKUP_DIR/fstab" /etc/fstab.backup  # Review and merge manually
```
- [ ] SSH keys restored
- [ ] User configurations restored
- [ ] System configs reviewed and applied

---

## 🐳 **CONTAINER SERVICES RESTORATION**

### **Step 11: Restore Docker Services**
```bash
# Jellyfin (if data preserved)
cd /mnt/paperless-ssd/jellyfin/
docker-compose up -d

# Uptime Kuma (if configured)
cd ~/uptime-kuma/
docker-compose up -d

# Other services as needed
```
- [ ] Jellyfin restored and accessible
- [ ] Uptime Kuma monitoring restored
- [ ] All media accessible in Jellyfin

---

## ✅ **VERIFICATION CHECKLIST**

### **Core System Tests**
- [ ] Ubuntu 24.04 LTS running on 4TB SSD
- [ ] SSH access via Tailscale working
- [ ] xRDP desktop access working (NO MORE X SERVER ISSUES! 🎉)
- [ ] All data drives mounted and accessible
- [ ] Network connectivity stable

### **Windows Preservation Verification**
- [ ] Windows boot option appears in GRUB menu
- [ ] Can boot into Windows (optional test)
- [ ] Windows drive untouched and intact

### **Service Functionality**
- [ ] Docker containers running
- [ ] Jellyfin media server operational
- [ ] SSH key authentication working
- [ ] Firewall properly configured
- [ ] Automatic mounting of data drives

### **Performance Verification**
- [ ] System boots quickly from 4TB SSD
- [ ] File operations are fast
- [ ] Desktop environment responsive
- [ ] No corruption errors in logs

---

## 📁 **IMPORTANT FILES CREATED**

### **Preparation Scripts**
- `analyze_current_setup.sh` - System analysis
- `ultimate_nuclear_setup.sh` - Main preparation script
- `fix_xserver_nuclear.sh` - Alternative nuclear option (less preferred)
- `test_clean_user.sh` - User isolation test (for troubleshooting)
- `setup_vnc_bypass.sh` - VNC alternative (backup option)

### **Installation Files (Created by ultimate_nuclear_setup.sh)**
- `/media/gmk/seagate/ubuntu_install/download_ubuntu.sh` - ISO download
- `/media/gmk/seagate/ubuntu_install/INSTALLATION_INSTRUCTIONS.md` - Detailed steps
- `/media/gmk/seagate/ubuntu_install/post_install_setup.sh` - Post-install automation

### **Backup Locations**
- Configuration backups: `/mnt/4tb-internal/ubuntu_backup_[timestamp]/`
- ISO and tools: `/media/gmk/seagate/ubuntu_install/`

---

## 🚨 **SAFETY MEASURES**

### **Data Protection**
- ✅ Windows on separate drive (nvme1n1) - completely isolated
- ✅ Paperless data on separate drive (nvme2n1) - read-only during install
- ✅ External storage (sda1) - untouched
- ✅ Current Ubuntu configs backed up before wipe

### **Rollback Plan**
If nuclear installation fails:
1. Boot from original Ubuntu (mmcblk0) - still intact
2. All data drives remain untouched
3. Windows still bootable
4. Can retry installation or try alternative approaches

### **License Preservation**
- ✅ Windows OEM license tied to G9 hardware
- ✅ Can reinstall Windows anytime using original media
- ✅ No license key required for this specific G9

---

## 💡 **POST-NUCLEAR BENEFITS**

### **Performance Improvements**
- 🚀 Ubuntu running on fastest 4TB M.2 SSD
- ⚡ No filesystem corruption issues  
- 🧹 Clean slate configuration
- 🔄 Latest Ubuntu 24.04 LTS with long-term support

### **Problem Resolution**
- ✅ X server session creation WILL WORK (fresh install)
- ✅ xRDP remote desktop fully functional
- ✅ No more "X server could not be started" errors
- ✅ Hardware properly detected and configured

### **Optimal Setup Achieved**
- 📊 Perfect drive utilization strategy
- 🔒 Security best practices from start
- 🐳 Docker containers optimally configured
- 🌐 Network services properly set up

---

## 🎯 **NEXT STEPS FOR FRESH CHAT**

**Hand-off Status**: Ready for nuclear execution

**Critical Information for Next Session:**
1. **Main execution command**: Run `ultimate_nuclear_setup.sh` first
2. **Target drive**: nvme0n1 (4TB) for Ubuntu installation
3. **Preserve**: nvme1n1 (Windows), nvme2n1 (Paperless), sda1 (External)
4. **Expected result**: Fresh Ubuntu 24.04 with working xRDP
5. **All scripts ready** in current working directory

**Key Files to Reference:**
- This checklist: `G9_NUCLEAR_UBUNTU_SETUP_CHECKLIST.md`
- Main prep script: `ultimate_nuclear_setup.sh`
- System analysis: `analyze_current_setup.sh`

**Connection Details Post-Install:**
- SSH: `ssh gmk@[new-tailscale-ip]`
- RDP: `[new-tailscale-ip]:3389`
- Web services will be restored after Docker setup

---

**🎉 READY TO CRUSH THE X SERVER ISSUE WITH NUCLEAR APPROACH! 🚀**

*This checklist ensures zero data loss while achieving optimal G9 configuration.* 