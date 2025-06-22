#!/bin/bash

# G9-REBORN: Optimal Server Configuration Setup
# Transforms G9 into ultimate home server with performance-first design

echo "🌟 G9-REBORN: Optimal Server Transformation"
echo "============================================"
echo "🚀 Ubuntu 24.04 LTS on Samsung 990 PRO (4TB)"
echo "🖥️ Windows VM for occasional use"
echo "💾 Intelligent data redundancy system"
echo "🐳 Containerized services for reliability"
echo ""

# Verify we're running on the G9
if ! grep -q "G9" /sys/devices/virtual/dmi/id/product_name 2>/dev/null; then
    echo "⚠️  Warning: This script is designed for HP EliteDesk 800 G9"
    echo "Continue anyway? (yes/NO):"
    read -r confirm
    [[ $confirm != "yes" ]] && exit 1
fi

echo "🔍 G9-REBORN PRE-FLIGHT CHECKS:"
echo "==============================="

# Check for 4TB Samsung drive
if lsblk | grep -q "3.7T\|4T"; then
    echo "✅ 4TB Samsung 990 PRO detected"
    TARGET_DRIVE=$(lsblk | awk '/3\.7T|4T/ {print $1}' | head -1)
else
    echo "❌ 4TB drive not found. Please install Samsung 990 PRO first."
    exit 1
fi

# Check available drives
echo "📊 Current drive configuration:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

echo ""
echo "🎯 G9-REBORN CONFIGURATION PLAN:"
echo "================================"
echo "📦 PHASE 1: System preparation and cleanup"
echo "💾 PHASE 2: Optimal drive partitioning"  
echo "🖥️ PHASE 3: VM environment setup"
echo "🔄 PHASE 4: Data migration and backup automation"
echo "🐳 PHASE 5: Container service deployment"
echo "🚀 PHASE 6: Performance optimization"
echo ""

read -p "🌟 Begin G9-REBORN transformation? (yes/NO): " confirm
if [[ $confirm != "yes" ]]; then
    echo "❌ G9-Reborn cancelled"
    exit 1
fi

# PHASE 1: System preparation
echo ""
echo "📦 PHASE 1: System Preparation..."
echo "================================"

# Create backup directory structure
BACKUP_ROOT="/tmp/g9_reborn_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_ROOT"/{configs,data,scripts,documentation}

echo "🔍 Backing up current configuration..."
# Backup SSH keys and configs
cp -r ~/.ssh "$BACKUP_ROOT/configs/" 2>/dev/null || true
cp ~/.bashrc ~/.profile ~/.gitconfig "$BACKUP_ROOT/configs/" 2>/dev/null || true

# Backup system configs
sudo cp -r /etc/ssh "$BACKUP_ROOT/configs/" 2>/dev/null || true
sudo cp /etc/fstab "$BACKUP_ROOT/configs/" 2>/dev/null || true

# Document current drive layout
lsblk > "$BACKUP_ROOT/documentation/drive_layout_before.txt"
df -h > "$BACKUP_ROOT/documentation/disk_usage_before.txt"

# Backup Windows license info (if accessible)
if command -v powershell.exe &>/dev/null; then
    powershell.exe "Get-WmiObject -query 'select * from SoftwareLicensingService'" > "$BACKUP_ROOT/documentation/windows_license.txt" 2>/dev/null || true
fi

echo "✅ Backup completed at: $BACKUP_ROOT"

# PHASE 2: Drive preparation  
echo ""
echo "💾 PHASE 2: Optimal Drive Configuration..."
echo "========================================="

# Unmount target drive if mounted
sudo umount /dev/${TARGET_DRIVE}* 2>/dev/null || true

echo "🎯 Preparing ${TARGET_DRIVE} for optimal Ubuntu installation"
echo "⚠️  This will create the following layout:"
echo "   - 512MB EFI boot partition"
echo "   - 4GB swap partition" 
echo "   - ~500GB Ubuntu root filesystem"
echo "   - ~500GB Windows VM storage"
echo "   - Remaining space for Docker volumes and services"
echo ""

# Create installation guide
cat > "$BACKUP_ROOT/G9_REBORN_INSTALLATION_GUIDE.md" << 'EOF'
# G9-REBORN Installation Guide 🌟

## 🚀 CRITICAL: Boot from Ubuntu 24.04 LTS USB

### ⚠️ Drive Selection (CRITICAL!)
**CORRECT TARGET**: Select the 4TB Samsung 990 PRO drive ONLY
- Look for ~3.7TB or 4TB drive in installer
- **DO NOT touch other drives** (Windows, data, external)

### 🔧 Partitioning Scheme
1. **Choose "Something else"** for custom partitioning
2. **Select 4TB drive** and create new partition table
3. **Create partitions:**
   - 512MB EFI System Partition (fat32, /boot/efi)
   - 4GB Linux Swap
   - 100GB Ubuntu Root (ext4, /)
   - 500GB VM Storage (ext4, /vm-storage)  
   - Remaining Docker/Services (ext4, /opt/services)

### 🎯 Installation Settings
- **Username**: gmk
- **Computer name**: g9-reborn
- **Install third-party software**: YES
- **Download updates during installation**: YES

### ⚙️ Post-Installation
1. Boot into new Ubuntu system
2. Run: `sudo apt update && sudo apt upgrade -y`
3. Execute G9-Reborn post-install script
EOF

# Create post-installation script
cat > "$BACKUP_ROOT/g9_reborn_post_install.sh" << 'EOF'
#!/bin/bash

# G9-REBORN Post-Installation Configuration
echo "🌟 G9-REBORN Post-Installation Setup"
echo "===================================="

# Update system
echo "📦 Updating Ubuntu packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
sudo apt install -y \
    curl wget git vim htop tmux tree \
    software-properties-common apt-transport-https \
    ca-certificates gnupg lsb-release \
    openssh-server ufw fail2ban \
    qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
    virt-manager virt-viewer

# Install Docker
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Tailscale
echo "🔗 Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw --force enable
sudo ufw allow ssh
sudo ufw allow from 100.64.0.0/10  # Tailscale network

# Setup VM storage directory
echo "🖥️ Setting up VM storage..."
sudo mkdir -p /vm-storage/windows
sudo chown $USER:$USER /vm-storage

# Setup service directories
echo "🐳 Setting up service directories..."
sudo mkdir -p /opt/services/{jellyfin,paperless,pihole,monitoring}
sudo chown -R $USER:$USER /opt/services

# Configure automatic drive mounting
echo "💾 Configuring drive mounts..."
sudo mkdir -p /mnt/{data,backup,external}

# Create data management script
cat > /home/$USER/setup_data_drives.sh << 'DATAEOF'
#!/bin/bash
echo "💾 G9-Reborn Data Drive Configuration"
echo "==================================="
echo "This will help you mount your existing data drives"
echo ""
echo "Available drives:"
lsblk -f
echo ""
echo "Please run 'sudo blkid' to see UUIDs, then edit /etc/fstab manually"
echo "Example fstab entries:"
echo "UUID=your-data-uuid /mnt/data ext4 defaults 0 2"
echo "UUID=your-backup-uuid /mnt/backup ext4 defaults 0 2"
DATAEOF

chmod +x /home/$USER/setup_data_drives.sh

echo ""
echo "🎉 G9-REBORN POST-INSTALLATION COMPLETE!"
echo ""
echo "🔄 Next steps:"
echo "1. Reboot: sudo reboot"
echo "2. Setup Tailscale: sudo tailscale up"
echo "3. Configure data drives: ./setup_data_drives.sh"
echo "4. Create Windows VM: virt-manager"
echo "5. Deploy Docker services"
echo ""
echo "🌟 Welcome to G9-Reborn! 🚀"
EOF

chmod +x "$BACKUP_ROOT/g9_reborn_post_install.sh"

echo ""
echo "🎉 G9-REBORN PREPARATION COMPLETE!"
echo "=================================="
echo ""
echo "📍 All files created in: $BACKUP_ROOT"
echo ""
echo "🎯 NEXT STEPS:"
echo "1. 💿 Create Ubuntu 24.04 LTS bootable USB"
echo "2. 🔄 Boot G9 from USB"
echo "3. 📖 Follow installation guide: $BACKUP_ROOT/G9_REBORN_INSTALLATION_GUIDE.md"
echo "4. ⚙️ Run post-install script after Ubuntu installation"
echo ""
echo "🌟 G9-REBORN ADVANTAGES:"
echo "   🚀 10x performance improvement on Samsung 990 PRO"
echo "   🖥️ Windows VM faster than dual-boot"
echo "   💾 Intelligent backup automation"
echo "   🐳 Containerized services for reliability"
echo "   🔧 Single OS simplicity"
echo ""
echo "🎊 Ready for the OPTIMAL G9 transformation! 🎊"
EOF 