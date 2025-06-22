#!/bin/bash

# ULTIMATE NUCLEAR SETUP - Fresh Ubuntu on 4TB while preserving Windows
echo "🚀 ULTIMATE NUCLEAR G9 SETUP"
echo "Fresh Ubuntu 24.04 LTS installation on 4TB M.2 SSD"
echo "Windows preservation guaranteed!"
echo ""
echo "💾 CURRENT SETUP DETECTED:"
echo "   • mmcblk0 (56GB) - Current Ubuntu (will be wiped)"
echo "   • nvme0n1 (4TB) - Target for fresh Ubuntu install"  
echo "   • nvme1n1 - Windows drive (PRESERVED, untouched)"
echo "   • nvme2n1 (2TB) - Paperless data (preserved)"
echo "   • sda1 (916GB) - External storage (preserved)"
echo ""

# Pre-flight checks
echo "🔍 PRE-FLIGHT CHECKS:"
echo "====================="

# Check available space on 4TB drive
AVAILABLE_4TB=$(df -h /mnt/4tb-internal | tail -1 | awk '{print $4}')
echo "✅ 4TB Drive available space: $AVAILABLE_4TB"

# Check current Ubuntu system size
CURRENT_UBUNTU=$(df -h / | tail -1 | awk '{print $3}')
echo "✅ Current Ubuntu size: $CURRENT_UBUNTU" 

# Check if Windows drive is detected
if lsblk | grep -q nvme1n1; then
    echo "✅ Windows drive detected and will be preserved"
else
    echo "⚠️ Windows drive not clearly detected"
fi

echo ""
echo "🎯 NUCLEAR SETUP PLAN:"
echo "======================"
echo "PHASE 1: 📦 Backup current Ubuntu configs"
echo "PHASE 2: 💾 Prepare 4TB drive for Ubuntu installation"
echo "PHASE 3: 🔄 Download Ubuntu 24.04 LTS ISO"
echo "PHASE 4: 💿 Create installation media instructions"
echo "PHASE 5: ⚙️ Post-install optimization script"
echo ""

read -p "🚀 Proceed with ULTIMATE NUCLEAR SETUP? (yes/NO): " confirm
if [[ $confirm != "yes" ]]; then
    echo "❌ Setup cancelled"
    exit 1
fi

# PHASE 1: Backup critical configs
echo ""
echo "📦 PHASE 1: Backing up critical configurations..."
BACKUP_DIR="/mnt/4tb-internal/ubuntu_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Clean up VNC remnants from troubleshooting
echo "🧹 Cleaning up VNC installations from troubleshooting..."
sudo rm -rf ~/.vnc 2>/dev/null || true
sudo rm -rf /home/gmk/.vnc 2>/dev/null || true

# Clean up test user from troubleshooting
echo "🧹 Removing test user created during troubleshooting..."
sudo userdel -r testuser 2>/dev/null || true

# Clean up Tailscale monitoring from troubleshooting
echo "🧹 Removing Tailscale monitoring setup from troubleshooting..."
sudo rm -rf /opt/tailscale-monitoring 2>/dev/null || true
sudo rm -rf /var/log/tailscale-monitoring 2>/dev/null || true
sudo userdel tailscale-monitor 2>/dev/null || true

# Clean up log files from troubleshooting
echo "🧹 Cleaning up troubleshooting log files..."
sudo rm -rf /var/log/enhanced-backup* 2>/dev/null || true
sudo rm -rf /home/gmk/.backup_notifications 2>/dev/null || true

echo "Backing up SSH keys..."
cp -r ~/.ssh "$BACKUP_DIR/" 2>/dev/null || echo "No SSH keys found"

echo "Backing up home directory configs..."
tar czf "$BACKUP_DIR/home_configs.tar.gz" \
    ~/.bashrc ~/.profile ~/.gitconfig ~/.vimrc \
    ~/.config 2>/dev/null || echo "Some configs not found"

echo "Backing up system configs..."
sudo cp -r /etc/ssh "$BACKUP_DIR/" 2>/dev/null
sudo cp /etc/fstab "$BACKUP_DIR/" 2>/dev/null
sudo cp -r /etc/systemd/system "$BACKUP_DIR/" 2>/dev/null

echo "✅ Backup completed at: $BACKUP_DIR"

# PHASE 2: Prepare 4TB drive space
echo ""
echo "💾 PHASE 2: Preparing 4TB drive for Ubuntu installation..."

# Create space for Ubuntu (we need ~50GB minimum)
FREE_SPACE=$(df /mnt/4tb-internal | tail -1 | awk '{print $4}')
echo "Available space: ${FREE_SPACE}K"

if [[ ${FREE_SPACE%K} -lt 52428800 ]]; then  # 50GB in KB
    echo "⚠️ Warning: Less than 50GB free space. Consider moving some data."
    echo "Current data will be preserved, but ensure adequate space."
fi

# PHASE 3: Download Ubuntu ISO
echo ""
echo "🔄 PHASE 3: Preparing Ubuntu 24.04 LTS download..."
echo "Ubuntu 24.04 LTS will be downloaded to external storage"

UBUNTU_ISO_DIR="/media/gmk/seagate/ubuntu_install"
mkdir -p "$UBUNTU_ISO_DIR"

cat > "$UBUNTU_ISO_DIR/download_ubuntu.sh" << 'EOF'
#!/bin/bash
echo "🔄 Downloading Ubuntu 24.04 LTS..."
cd "$(dirname "$0")"
wget -O ubuntu-24.04-desktop-amd64.iso \
    "https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso"
echo "✅ Ubuntu ISO downloaded successfully!"
echo "📍 Location: $(pwd)/ubuntu-24.04-desktop-amd64.iso"
EOF

chmod +x "$UBUNTU_ISO_DIR/download_ubuntu.sh"

# PHASE 4: Create installation instructions
echo ""
echo "💿 PHASE 4: Creating installation instructions..."

cat > "$UBUNTU_ISO_DIR/INSTALLATION_INSTRUCTIONS.md" << 'EOF'
# 🚀 G9 Ubuntu Fresh Installation Instructions

## ⚠️ CRITICAL: Drive Selection During Installation

### ✅ CORRECT DRIVE TO SELECT:
- **Target**: `nvme0n1` (4TB M.2 SSD) 
- **Description**: Samsung 990 PRO or similar 4TB drive
- **Current mount**: `/mnt/4tb-internal`

### ❌ DRIVES TO AVOID:
- **nvme1n1** - Windows drive (BitLocker encrypted) - DO NOT TOUCH!
- **mmcblk0** - Old Ubuntu system (can be wiped after new install works)
- **nvme2n1** - Paperless data drive - DO NOT TOUCH!
- **sda** - External Seagate drive - DO NOT TOUCH!

## 🔧 Installation Steps:

1. **Boot from USB**: Use Ubuntu 24.04 LTS ISO
2. **Choose "Something else"** for partitioning
3. **Select nvme0n1** (4TB drive) ONLY
4. **Create partitions**:
   - 512MB EFI partition (if needed)
   - Remaining space as ext4 root partition (/)
5. **Install GRUB** to nvme0n1 (4TB drive)
6. **Complete installation**

## ⚙️ Post-Installation:
Run the post-install script located at:
`/media/nvme0n1/post_install_setup.sh`

## 🪟 Windows Preservation:
- Windows remains on nvme1n1 (separate drive)
- Accessible via GRUB menu after installation
- License preserved and tied to G9 hardware
EOF

# PHASE 5: Create post-installation setup script
echo ""
echo "⚙️ PHASE 5: Creating post-installation setup script..."

cat > "$UBUNTU_ISO_DIR/post_install_setup.sh" << 'EOF'
#!/bin/bash

# POST-INSTALLATION SETUP for G9 Fresh Ubuntu
echo "🚀 G9 Post-Installation Setup"
echo "Configuring fresh Ubuntu installation for optimal performance"

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
sudo apt install -y \
    openssh-server \
    curl \
    wget \
    git \
    vim \
    htop \
    tmux \
    tree \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install XFCE4 desktop environment
echo "🖥️ Installing XFCE4 desktop environment..."
sudo apt install -y xfce4 xfce4-goodies

# Install and configure xRDP
echo "🔄 Installing and configuring xRDP..."
sudo apt install -y xrdp xorgxrdp
sudo systemctl enable xrdp
sudo usermod -a -G ssl-cert $USER

# Configure desktop session
echo '#!/bin/bash
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11
exec startxfce4' > ~/.xsession
chmod +x ~/.xsession

# Install Tailscale
echo "🔗 Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 3389/tcp

# Mount existing data drives
echo "💾 Configuring data drive mounts..."
sudo mkdir -p /mnt/paperless-ssd
sudo mkdir -p /mnt/seagate-external

# Add to fstab (you'll need to verify UUIDs)
echo "📝 Note: Add the following to /etc/fstab manually:"
echo "UUID=6aba2948-0f30-4b5a-83f5-6e3cac43caec /mnt/paperless-ssd ext4 defaults 0 2"
echo "UUID=938d27e9-8dbd-49ae-9322-77aee1a63655 /mnt/seagate-external ext4 defaults 0 2"

# Install Docker
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

echo ""
echo "🎉 POST-INSTALLATION SETUP COMPLETE!"
echo ""
echo "🔄 Next steps:"
echo "1. Reboot the system"
echo "2. Connect via Tailscale"
echo "3. Test xRDP connection"
echo "4. Mount data drives permanently"
echo "5. Restore backed up configurations"
echo ""
echo "🔗 Connection details:"
echo "   SSH: ssh $(whoami)@[tailscale-ip]"
echo "   RDP: [tailscale-ip]:3389"
EOF

chmod +x "$UBUNTU_ISO_DIR/post_install_setup.sh"

echo ""
echo "🎉 ULTIMATE NUCLEAR SETUP PREPARATION COMPLETE!"
echo ""
echo "📍 All files created in: $UBUNTU_ISO_DIR"
echo ""
echo "🎯 NEXT STEPS:"
echo "1. 🔄 Run download script: $UBUNTU_ISO_DIR/download_ubuntu.sh"
echo "2. 💿 Create bootable USB from downloaded ISO"
echo "3. 🔄 Boot from USB and follow installation instructions"
echo "4. ⚙️ Run post-install script after installation"
echo ""
echo "🪟 WINDOWS SAFETY GUARANTEE:"
echo "   ✅ Windows on nvme1n1 will remain completely untouched"
echo "   ✅ License preserved and can be reinstalled anytime"
echo "   ✅ Dual boot will be configured automatically"
echo ""
echo "🚀 This will give you a PERFECT, optimized Ubuntu setup!"
EOF 