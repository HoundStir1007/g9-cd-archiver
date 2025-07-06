# 🔧 G9-REBORN UUID Repair Guide
*Phase 2: Boot from USB and Fix UUID Issues*

## 🎯 **MISSION: Fix UUID Boot Errors**

**Status**: Ubuntu installation complete ✅, but UUIDs preventing normal boot ❌  
**Goal**: Get G9-REBORN booting normally to Ubuntu desktop! 🖥️

---

## 📋 **LIVE USB RESCUE CHECKLIST**

### **1️⃣ BOOT FROM USB**
- Connect USB to G9 server
- Boot from USB (F12 or BIOS boot menu)
- Select "Try Ubuntu without installing"
- Wait for live desktop to load

### **2️⃣ OPEN TERMINAL & IDENTIFY DRIVES**
```bash
# Check all drives and partitions
sudo fdisk -l

# Check partition UUIDs (this is the key!)
sudo blkid

# Look for your 4TB drive partitions:
# - EFI partition (1.13GB)
# - Root partition (100GB) 
# - Home partition (3.99TB)
# - Swap partition (8GB)
```

### **3️⃣ MOUNT THE INSTALLED SYSTEM**
```bash
# Create mount point
sudo mkdir /mnt/ubuntu

# Mount root partition (replace UUID with actual from blkid)
sudo mount /dev/nvme0n1p4 /mnt/ubuntu

# Mount other critical partitions
sudo mount /dev/nvme0n1p2 /mnt/ubuntu/boot/efi  # EFI partition
sudo mount /dev/nvme0n1p5 /mnt/ubuntu/home      # Home partition

# Verify mounts worked
ls /mnt/ubuntu  # Should show Ubuntu filesystem
```

### **4️⃣ CHECK AND FIX FSTAB**
```bash
# View current fstab (the problem child!)
sudo cat /mnt/ubuntu/etc/fstab

# Compare with actual UUIDs
sudo blkid | grep nvme0n1

# Edit fstab to match reality
sudo nano /mnt/ubuntu/etc/fstab

# Fix each UUID to match what blkid shows:
# UUID=actual-root-uuid / ext4 defaults 0 1
# UUID=actual-efi-uuid /boot/efi vfat defaults 0 2
# UUID=actual-home-uuid /home ext4 defaults 0 2
# UUID=actual-swap-uuid none swap sw 0 0
```

### **5️⃣ UPDATE BOOT SYSTEM**
```bash
# Prepare chroot environment
sudo mount --bind /dev /mnt/ubuntu/dev
sudo mount --bind /proc /mnt/ubuntu/proc
sudo mount --bind /sys /mnt/ubuntu/sys

# Enter the installed system
sudo chroot /mnt/ubuntu

# Update initramfs (clears UUID cache)
update-initramfs -u

# Update GRUB bootloader
update-grub

# Exit chroot
exit
```

### **6️⃣ CLEAN UNMOUNT & REBOOT**
```bash
# Unmount everything cleanly
sudo umount /mnt/ubuntu/dev
sudo umount /mnt/ubuntu/proc
sudo umount /mnt/ubuntu/sys
sudo umount /mnt/ubuntu/boot/efi
sudo umount /mnt/ubuntu/home
sudo umount /mnt/ubuntu

# Remove USB and reboot to internal drive
sudo reboot
```

---

## 🎯 **EXPECTED SUCCESS SEQUENCE**

After reboot (USB removed):
1. **GRUB loads** → No UUID timeout errors ✅
2. **Ubuntu splash** → Intel graphics working ✅  
3. **Login screen** → Shows `mark@g9-reborn` ✅
4. **Desktop loads** → G9-REBORN SUCCESS! 🎉

---

## 🚨 **TROUBLESHOOTING BACKUP PLANS**

**If fstab fix doesn't work:**
```bash
# Boot-Repair tool (nuclear option)
sudo add-apt-repository ppa:yannubuntu/boot-repair
sudo apt update
sudo apt install -y boot-repair
sudo boot-repair
```

**If you need to identify partitions:**
```bash
# Show partition labels and sizes
lsblk -f

# Show detailed partition info
sudo parted -l
```

---

## 📝 **WHAT TO DOCUMENT**

When you're in the live environment, capture:
- Output of `sudo blkid` (actual UUIDs)
- Contents of `/mnt/ubuntu/etc/fstab` (before fix)
- Any error messages during mount/chroot

This will help if we need to iterate! 🔧

---

**🚀 Success Probability: VERY HIGH - You've got this!** ✨ 