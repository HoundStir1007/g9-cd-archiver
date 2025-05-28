# Configure GRUB for Ubuntu Default Boot

## 🎯 **Goal**: Make Ubuntu boot automatically without user intervention

## 📋 **Steps to Configure**

### 1. **Check Current GRUB Configuration**
```bash
# SSH into your G9 Ubuntu system
ssh gmk@100.91.157.19

# Check current settings
grep -E '^GRUB_DEFAULT|^GRUB_TIMEOUT' /etc/default/grub
```

### 2. **Edit GRUB Configuration**
```bash
# Edit the GRUB configuration file
sudo nano /etc/default/grub

# Change these lines:
GRUB_DEFAULT=0                    # Boot first option (Ubuntu)
GRUB_TIMEOUT=3                    # Wait only 3 seconds
GRUB_TIMEOUT_STYLE=menu          # Show menu briefly
```

### 3. **Apply Changes**
```bash
# Update GRUB with new configuration
sudo update-grub

# Verify the changes
grep -E '^GRUB_DEFAULT|^GRUB_TIMEOUT' /etc/default/grub
```

### 4. **Test the Configuration**
```bash
# Reboot to test (will boot Ubuntu automatically)
sudo reboot
```

## ✅ **Expected Result**
- System boots directly to Ubuntu after 3 seconds
- No manual selection needed
- Perfect for power outage recovery
- Home server stays "hands-off"

## 🎯 **Why This Matters**
- **Power outages**: System recovers automatically
- **Remote management**: No physical access needed
- **Service availability**: Paperless-ngx starts automatically
- **True home server**: Set it and forget it! 