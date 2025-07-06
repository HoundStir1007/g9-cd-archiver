# G9-REBORN Boot Troubleshooting Guide 🚀🔧

## Current Issue
- ❌ Boot ends at black screen with blinking cursor after UUID repair attempt
- ✅ Ubuntu 24.04 installation completed on nvme1n1 (4TB iDSONiX)
- ✅ Created fstab file and updated boot configuration

## Complete Boot Option Check Procedure

### 1️⃣ Access UEFI/BIOS Boot Menu
- Power on the G9 machine
- Repeatedly press **F2** or **Delete** key during startup (before black screen appears)
- If that doesn't work, try **F12**, **F10**, or **Esc**

### 2️⃣ Check Boot Order Priority
- In UEFI/BIOS, locate "Boot" or "Boot Priority" section
- Ensure **nvme1n1** (4TB iDSONiX) is the first boot device
- Save changes and exit (usually F10)

### 3️⃣ One-Time Boot Menu Option
- Power on and press **F12** (or alternative key based on G9 model)
- Select **Ubuntu** or the nvme1n1 device from the list
- This bypasses the default boot order

### 4️⃣ Check for Multiple EFI Boot Entries
If you can boot to USB again:
```bash
# Mount the EFI partition
sudo mkdir -p /mnt/efi
sudo mount /dev/nvme1n1p1 /mnt/efi

# List all EFI boot entries
ls -la /mnt/efi/EFI/

# Check Ubuntu boot entry
ls -la /mnt/efi/EFI/ubuntu/
```

### 5️⃣ GRUB Repair from Live USB
If you can boot from the Ubuntu USB again:
```bash
# Mount your installed system
sudo mkdir -p /mnt/ubuntu
sudo mount /dev/nvme1n1p2 /mnt/ubuntu
sudo mount /dev/nvme1n1p1 /mnt/ubuntu/boot/efi

# Chroot into the system
sudo mount --bind /dev /mnt/ubuntu/dev
sudo mount --bind /proc /mnt/ubuntu/proc
sudo mount --bind /sys /mnt/ubuntu/sys
sudo chroot /mnt/ubuntu

# Update grub
update-grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu --recheck

# Exit chroot and reboot
exit
sudo reboot
```

### 6️⃣ Check for Legacy Windows Boot Manager Interference
If dual boot was previously configured:
```bash
# Check for Windows Boot Manager entries
sudo efibootmgr -v
```

### 7️⃣ Force UEFI Mode (Not CSM/Legacy)
- In BIOS/UEFI settings, find "Boot Mode" or "UEFI/Legacy Boot"
- Set to **UEFI Only** (not Legacy or CSM)
- Save and exit

### 8️⃣ Check for Secure Boot Interference
- Find "Secure Boot" option in UEFI settings
- Try **Disabling** Secure Boot temporarily
- Save and exit

### 9️⃣ Emergency Kernel Parameters
From GRUB menu (if accessible):
1. Press 'e' to edit boot entry
2. Find line starting with "linux"
3. Add these parameters at end:
   `nomodeset` (for graphics issues)
   or
   `nouveau.modeset=0` (NVIDIA graphics)
4. Press F10 to boot with changes

### 🔟 Check Boot Partition Size
If you can boot from USB:
```bash
# Check partition sizes
sudo fdisk -l /dev/nvme1n1

# Verify EFI partition (should be around 512MB)
# If too small, might need to resize
```

## Next Steps if Still Not Booting

### Advanced Recovery
1. Boot from USB
2. Mount your system:
   ```bash
   sudo mount /dev/nvme1n1p2 /mnt
   sudo mount /dev/nvme1n1p1 /mnt/boot/efi
   ```
3. Check logs for boot failures:
   ```bash
   less /mnt/var/log/kern.log
   less /mnt/var/log/syslog
   ```

### Consider Windows Boot Manager Conflicts
Given the system originally had Windows, check:
```bash
# Show all EFI boot entries
sudo efibootmgr -v

# If Windows entries are interfering, can modify order:
sudo efibootmgr -o XXXX,YYYY # (replace with your Ubuntu entry number)
```

Report back with the results and we'll adjust the plan accordingly! 🚀 