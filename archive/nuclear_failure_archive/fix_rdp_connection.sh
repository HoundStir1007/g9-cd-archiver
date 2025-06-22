#!/bin/bash

# Fix X Server Startup Issues after Hardware Changes (4TB M.2 SSD Installation)
# Addresses hardware detection and graphics driver initialization problems

echo "🔧 Fixing X Server startup issues after hardware upgrade..."

# 1. Reinitialize hardware detection
echo "🔄 Reinitializing hardware detection..."
sudo depmod -a
sudo update-initramfs -u

# 2. Fix Intel graphics driver issues after hardware changes
echo "🎮 Checking and fixing Intel graphics drivers..."
sudo modprobe -r i915
sudo modprobe i915
echo "intel" | sudo tee /etc/modules-load.d/intel.conf

# 3. Ensure X server has proper device access
echo "🔐 Fixing device permissions for X server..."
sudo chmod 666 /dev/tty*
sudo chmod 666 /dev/dri/card* 2>/dev/null || true
sudo chmod 666 /dev/dri/renderD* 2>/dev/null || true

# 4. Add user to all graphics-related groups
echo "👤 Adding user to graphics groups..."
sudo usermod -a -G video,render,input,tty,dialout,plugdev gmk

# 5. Force X server to use correct graphics hardware
echo "🖥️ Configuring X server for hardware changes..."
sudo tee /etc/X11/xorg.conf.d/20-intel.conf > /dev/null << 'EOF'
Section "Device"
    Identifier "Intel Graphics"
    Driver "intel"
    Option "AccelMethod" "sna"
    Option "TearFree" "true"
EndSection
EOF

# 6. Update xRDP session configuration for hardware compatibility
echo "⚙️ Updating xRDP session configuration..."
sudo tee /etc/xrdp/startwm.sh > /dev/null << 'EOF'
#!/bin/sh

# Fix for hardware changes - ensure proper environment
export DISPLAY=:10.0
export XDG_RUNTIME_DIR=/tmp/runtime-gmk
export XDG_SESSION_CLASS=user
export XDG_SESSION_TYPE=x11

# Create runtime directory if it doesn't exist
mkdir -p $XDG_RUNTIME_DIR
chown gmk:gmk $XDG_RUNTIME_DIR

# Start session with proper hardware initialization
if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi

# Ensure X server can access hardware
xhost +local:

# Start XFCE4 session
exec startxfce4
EOF

sudo chmod +x /etc/xrdp/startwm.sh

# 7. Create proper .xsession file for the user
echo "📄 Creating .xsession file..."
cat > /home/gmk/.xsession << 'EOF'
#!/bin/bash
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
exec startxfce4
EOF
chmod +x /home/gmk/.xsession

# 8. Install TigerVNC as backup option
echo "🐅 Installing TigerVNC as backup..."
sudo apt update
sudo apt install -y tigervnc-standalone-server tigervnc-common

# 9. Configure xRDP to use VNC backend (more stable after hardware changes)
echo "🔄 Configuring xRDP to use VNC backend..."
sudo tee /etc/xrdp/xrdp.ini > /dev/null << 'EOF'
[Globals]
ini_version=1
fork=true
port=3389
security_layer=negotiate
crypt_level=high
certificate=
key_file=
ssl_protocols=TLSv1.2, TLSv1.3
max_bpp=32
xserverbpp=24
tcp_nodelay=true
tcp_keepalive=true
use_fastpath=both

[Xvnc]
name=Xvnc
lib=libvnc.so
username=ask
password=ask
ip=127.0.0.1
port=-1
chansrvport=-1
code=20
xserverbpp=24
EOF

# 10. Restart all related services in proper order
echo "🔄 Restarting services in proper order..."
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman
sudo systemctl stop lightdm

# Wait a moment for complete shutdown
sleep 3

sudo systemctl start lightdm
sudo systemctl start xrdp-sesman
sudo systemctl start xrdp

# 11. Verify service status
echo "✅ Verifying service status..."
echo "LightDM Status:"
sudo systemctl status lightdm --no-pager -l

echo -e "\nxRDP-SESMAN Status:"
sudo systemctl status xrdp-sesman --no-pager -l

echo -e "\nxRDP Status:"
sudo systemctl status xrdp --no-pager -l

# 12. Show hardware detection status
echo -e "\n🔍 Hardware Detection Status:"
echo "Graphics Cards:"
lspci | grep -i vga
echo -e "\nDRM Devices:"
ls -la /dev/dri/ 2>/dev/null || echo "No DRM devices found"
echo -e "\nLoaded Graphics Modules:"
lsmod | grep -E "(i915|drm)"

echo ""
echo "🎯 X Server hardware fix complete!"
echo ""
echo "💡 NEXT STEPS:"
echo "1. 🔄 REBOOT the server to fully reinitialize hardware detection"
echo "2. 🖱️ Try RDP connection after reboot"
echo "3. 🐅 If still issues, try VNC connection as backup:"
echo "   vncserver :1 -geometry 1920x1080 -depth 24"
echo ""
echo "🚀 Connection Details:"
echo "   Server: 100.91.157.19"
echo "   Port: 3389"
echo "   Username: gmk"
echo ""
echo "📊 If issues persist, check logs:"
echo "   sudo tail -f /var/log/xrdp-sesman.log"
echo "   sudo tail -f /var/log/xrdp.log" 