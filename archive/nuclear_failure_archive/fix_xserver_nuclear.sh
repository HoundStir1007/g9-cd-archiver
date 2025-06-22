#!/bin/bash

# NUCLEAR X SERVER FIX - Complete Desktop Environment Reinstall
# For filesystem corruption issues after hardware installation

echo "🚀 NUCLEAR X SERVER FIX - Level 1: Complete Desktop Reinstall"
echo "This will completely remove and reinstall all GUI components"
echo ""
echo "⚠️  WARNING: This will:"
echo "   - Remove ALL desktop environments"
echo "   - Purge X server configuration"
echo "   - Reset display manager settings"
echo "   - Require reconfiguration of desktop preferences"
echo ""
read -p "🎯 Proceed with nuclear desktop reinstall? (yes/NO): " confirm

if [[ $confirm != "yes" ]]; then
    echo "❌ Aborted. Try a different approach."
    exit 1
fi

echo "💥 Starting nuclear desktop environment reinstall..."

# 1. Stop all GUI services
echo "🛑 Stopping all GUI services..."
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman  
sudo systemctl stop lightdm
sudo systemctl stop gdm3 2>/dev/null || true

# 2. Kill any remaining X processes
echo "💀 Killing remaining X processes..."
sudo pkill -f "X.*"
sudo pkill -f "xrdp"
sudo pkill -f "lightdm"

# 3. NUCLEAR PURGE - Remove everything GUI-related
echo "💥 NUCLEAR PURGE: Removing all desktop environments..."
sudo apt purge -y \
    xfce4* \
    lightdm* \
    gdm3* \
    ubuntu-desktop* \
    xorg* \
    xserver-xorg* \
    xrdp* \
    tigervnc* \
    gnome-shell* \
    unity* \
    plasma* \
    lxde* \
    mate-desktop* \
    2>/dev/null || true

# 4. Remove configuration directories
echo "🗑️ Removing corrupted configuration directories..."
sudo rm -rf /etc/X11
sudo rm -rf /etc/xrdp
sudo rm -rf /etc/lightdm
sudo rm -rf /etc/gdm3
sudo rm -rf /var/lib/lightdm
sudo rm -rf /var/lib/gdm3
sudo rm -rf /home/gmk/.config/xfce4
sudo rm -rf /home/gmk/.xsession*
sudo rm -rf /home/gmk/.Xauth*

# 5. Clean package system
echo "🧹 Cleaning package system..."
sudo apt autoremove -y
sudo apt autoclean
sudo apt update

# 6. Fresh install - XFCE4 (lightweight and reliable)
echo "✨ Fresh install: XFCE4 desktop environment..."
sudo apt install -y \
    xfce4 \
    xfce4-goodies \
    xorg \
    xserver-xorg \
    xserver-xorg-core \
    xserver-xorg-video-intel \
    lightdm \
    lightdm-gtk-greeter

# 7. Fresh install - xRDP with all dependencies
echo "🔄 Fresh install: xRDP with full dependencies..."
sudo apt install -y \
    xrdp \
    xorgxrdp \
    pulseaudio \
    pulseaudio-module-xrdp

# 8. Create fresh user session configuration
echo "👤 Creating fresh user session configuration..."
cat > /home/gmk/.xsession << 'EOF'
#!/bin/bash
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11
exec startxfce4
EOF
chmod +x /home/gmk/.xsession
chown gmk:gmk /home/gmk/.xsession

# 9. Create fresh xRDP configuration
echo "⚙️ Creating fresh xRDP configuration..."
sudo tee /etc/xrdp/xrdp.ini > /dev/null << 'EOF'
[Globals]
ini_version=1
fork=true
port=3389
security_layer=negotiate
crypt_level=high
max_bpp=32
xserverbpp=24

[Xorg]
name=Xorg
lib=libxup.so
username=ask
password=ask
ip=127.0.0.1
port=-1
code=20
EOF

# 10. Configure proper permissions
echo "🔐 Setting proper permissions..."
sudo usermod -a -G ssl-cert,video,render,input,tty gmk

# 11. Enable and start services in proper order
echo "🚀 Starting services in proper order..."
sudo systemctl enable lightdm
sudo systemctl enable xrdp
sudo systemctl enable xrdp-sesman

sudo systemctl start lightdm
sleep 3
sudo systemctl start xrdp-sesman
sleep 2
sudo systemctl start xrdp

# 12. Verify installation
echo "✅ Verifying installation..."
echo ""
echo "Service Status:"
sudo systemctl status lightdm --no-pager -l
echo ""
sudo systemctl status xrdp-sesman --no-pager -l
echo ""
sudo systemctl status xrdp --no-pager -l

echo ""
echo "🎉 NUCLEAR REINSTALL COMPLETE!"
echo ""
echo "🔄 REBOOT REQUIRED for complete hardware reinitialization"
echo ""
echo "After reboot, test RDP connection:"
echo "   Server: 100.91.157.19"
echo "   Port: 3389"
echo "   Username: gmk"
echo ""
echo "🚀 If this doesn't work, proceed to Level 2 (New User Test)"

# Optional: Install audio support for RDP
sudo apt install -y pulseaudio-module-xrdp

# Optional: Install additional tools
sudo apt install -y dbus-x11  # Prevents some session issues 