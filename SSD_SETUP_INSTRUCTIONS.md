# 4TB SSD Setup Instructions - Continue in Cursor on G9 🚀

## ✅ **STATUS: Hardware Installed Successfully**
- **4TB M.2 SSD** installed with heat sink ✅
- **Detected as** `nvme1n1` (3.7TB) ✅
- **System booted** after filesystem repair ✅
- **Ready for formatting** and final setup ✅

---

## 🎯 **NEXT STEPS (Run in G9 Ubuntu Terminal)**

### **Step 1: Format and Mount 4TB SSD**
```bash
# Make script executable
chmod +x setup_4tb_ssd.sh

# Run the setup script
bash setup_4tb_ssd.sh
```

**When prompted, type exactly: `YES`**

### **Step 2: Verify Setup Success**
```bash
# Check if drive is mounted
df -h /mnt/4tb-internal

# Check available space (should show ~3.6TB)
ls -la /mnt/4tb-internal

# Verify you can write to it
touch /mnt/4tb-internal/test_file
rm /mnt/4tb-internal/test_file
```

---

## 📦 **Data Migration Plan**

### **Current Data Location**
- **1.315TB consolidated data** at: `/mnt/paperless-ssd/digital_consolidation/`
- **Target location**: `/mnt/4tb-internal/`

### **Migration Command**
```bash
# Create directory structure
mkdir -p /mnt/4tb-internal/digital_archive

# Copy data (with progress)
rsync -avh --progress /mnt/paperless-ssd/digital_consolidation/ /mnt/4tb-internal/digital_archive/

# Verify transfer
du -sh /mnt/4tb-internal/digital_archive
```

---

## 🚨 **Known Issues to Fix Later**
- **⚠️ Windows app connection** to Ubuntu may need restoration after hardware changes
- **Document in baton** when ready to address

---

## 🎯 **Success Criteria**
- [ ] 4TB SSD formatted and mounted at `/mnt/4tb-internal`
- [ ] 1.315TB data migrated successfully
- [ ] External drives can be disconnected
- [ ] System stable and responsive
- [ ] Baton updated with success status

---

## 📝 **Commands Reference**

### **Check Drive Status**
```bash
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
df -h
```

### **Monitor Transfer Progress**
```bash
watch -n 1 'du -sh /mnt/4tb-internal/digital_archive'
```

### **Emergency Commands**
```bash
# Unmount if needed
sudo umount /mnt/4tb-internal

# Remount manually
sudo mount /dev/nvme1n1p1 /mnt/4tb-internal
```

---

**🚀 Ready to complete your 4TB SSD setup! All scripts are prepared and tested!** 