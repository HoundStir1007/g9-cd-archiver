#!/bin/bash

# COMPREHENSIVE FIX: Package System + x11vnc Setup
# Based on web search findings for Ubuntu 24.10 issues

echo "🔧 COMPREHENSIVE UBUNTU 24.10 REMOTE DESKTOP FIX"
echo "Part 1: Fixing broken packages"
echo "Part 2: Setting up x11vnc as xRDP alternative"
echo ""

# Part 1: Fix broken package system
echo "🩹 FIXING BROKEN PACKAGE SYSTEM..."

# Install missing dependencies first
echo "📦 Installing missing base packages..."
sudo apt update
sudo apt install -y gawk desktop-base desktop-base-dbg || true

# Force fix broken packages
echo "🔨 Force fixing broken packages..."
sudo dpkg --configure -a --force-confdef || true

# Remove problematic packages and reinstall cleanly
echo "🧹 Cleaning up problematic packages..."
sudo apt remove --purge -y tigervnc-standalone-server tigervnc-common tigervnc-tools || true
sudo apt autoremove -y || true

# Part 2: Install and configure x11vnc (the reliable solution)
echo ""
echo "📡 SETTING UP X11VNC (Recommended Solution)..."

# Install x11vnc (much more reliable than TigerVNC)
sudo apt install -y x11vnc xvfb

# Create x11vnc service for headless operation
echo "⚙️ Creating x11vnc service..."
sudo tee /etc/systemd/system/x11vnc.service > /dev/null << 'EOF'
[Unit]
Description=x11vnc remote desktop server
After=graphical-session.target

[Service]
Type=simple
User=gmk
Group=gmk
ExecStartPre=/bin/bash -c 'if [ ! -f /home/gmk/.vnc/passwd ]; then mkdir -p /home/gmk/.vnc && echo "ubuntu" | x11vnc -storepasswd /home/gmk/.vnc/passwd; fi'
ExecStart=/usr/bin/x11vnc -display :0 -forever -shared -bg -rfbauth /home/gmk/.vnc/passwd -rfbport 5900 -nopw
Restart=always
RestartSec=3

[Install]
WantedBy=graphical.target
EOF

# Create standalone x11vnc service (fallback)
echo "🖥️ Creating standalone x11vnc service..."
sudo tee /etc/systemd/system/x11vnc-standalone.service > /dev/null << 'EOF'
[Unit]
Description=x11vnc standalone with virtual display
After=multi-user.target

[Service]
Type=forking
User=gmk
Group=gmk
ExecStartPre=/bin/bash -c 'mkdir -p /home/gmk/.vnc'
ExecStartPre=/bin/bash -c 'if [ ! -f /home/gmk/.vnc/passwd ]; then echo "ubuntu" | x11vnc -storepasswd /home/gmk/.vnc/passwd; fi'
ExecStart=/usr/bin/x11vnc -create -forever -shared -rfbauth /home/gmk/.vnc/passwd -rfbport 5901 -geometry 1920x1080 -depth 24
Restart=always
RestartSec=5
Environment=DISPLAY=:1

[Install]
WantedBy=multi-user.target
EOF

# Set permissions
sudo chown gmk:gmk /home/gmk/.vnc 2>/dev/null || true

# Configure firewall for VNC
echo "🔥 Configuring firewall..."
sudo ufw allow 5900/tcp comment "x11vnc primary"
sudo ufw allow 5901/tcp comment "x11vnc standalone"

# Enable services
echo "🚀 Enabling x11vnc services..."
sudo systemctl daemon-reload
sudo systemctl enable x11vnc-standalone
sudo systemctl start x11vnc-standalone

# Also keep xRDP running as backup
echo "🔄 Keeping xRDP as backup option..."
sudo systemctl enable xrdp || true
sudo systemctl start xrdp || true

# Display connection information
echo ""
echo "🎉 SETUP COMPLETE!"
echo ""
echo "📋 CONNECTION OPTIONS:"
echo ""
echo "🥇 OPTION 1 - VNC (Recommended):"
echo "   • VNC Viewer: 100.91.157.19:5901"
echo "   • Password: ubuntu"
echo "   • Built-in Screen Sharing: vnc://100.91.157.19:5901"
echo ""
echo "🥈 OPTION 2 - RDP (Backup):"
echo "   • Microsoft Remote Desktop: 100.91.157.19:3389"
echo "   • Username: gmk"
echo ""
echo "✅ ADVANTAGES OF VNC:"
echo "   • No X server compatibility issues"
echo "   • Works with Ubuntu 24.10"
echo "   • Reliable connection"
echo "   • Lower resource usage"
echo ""
echo "🔧 TROUBLESHOOTING:"
echo "   • Service status: sudo systemctl status x11vnc-standalone"
echo "   • Restart service: sudo systemctl restart x11vnc-standalone"
echo "   • Change password: echo 'newpass' | x11vnc -storepasswd ~/.vnc/passwd"

# Check service status
echo ""
echo "📊 SERVICE STATUS:"
sudo systemctl status x11vnc-standalone --no-pager -l | head -10 