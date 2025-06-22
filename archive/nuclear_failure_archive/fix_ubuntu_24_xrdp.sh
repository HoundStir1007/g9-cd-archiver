#!/bin/bash

# FIX UBUNTU 24.10 XRDP COMPATIBILITY ISSUE
# Switch from Xorg to Xvnc backend due to ABI incompatibility

echo "🔧 FIXING UBUNTU 24.10 XRDP COMPATIBILITY"
echo "Switching from Xorg to Xvnc backend..."
echo ""
echo "⚠️  Ubuntu 24.10 has Xorg ABI compatibility issues with xorgxrdp"
echo "   Using Xvnc as recommended workaround"
echo ""

# Stop services
echo "🛑 Stopping xRDP services..."
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman

# Install tigervnc-standalone-server (Xvnc)
echo "📦 Installing TigerVNC server..."
sudo apt update
sudo apt install -y tigervnc-standalone-server tigervnc-common

# Create new sesman.ini with Xvnc backend
echo "⚙️ Configuring xRDP for Xvnc backend..."
sudo tee /etc/xrdp/sesman.ini > /dev/null << 'EOF'
[Globals]
ListenPort=3350
EnableUserWindowManager=true
UserWindowManager=startxfce4
DefaultWindowManager=startxfce4

[Security]
AllowRootLogin=false
MaxLoginRetry=4
TerminalServerUsers=tsusers
TerminalServerAdmins=tsadmins

[Sessions]
MaxSessions=50
KillDisconnected=false
DisconnectedTimeLimit=0

[Logging]
LogFile=xrdp-sesman.log
LogLevel=INFO
EnableSyslog=1
SyslogLevel=INFO

[Xvnc]
param=/usr/bin/Xvnc
param=-ac
param=-nolisten
param=tcp
param=-localhost
param=-dpi
param=96
param=-depth
param=24
param=-geometry
param=1920x1080
param=-rfbauth
param=/home/%s/.vnc/sesman_passwd
EOF

# Create xrdp.ini with Xvnc session
echo "🖥️ Configuring xRDP main config..."
sudo tee /etc/xrdp/xrdp.ini > /dev/null << 'EOF'
[Globals]
ini_version=1
fork=true
port=3389
security_layer=negotiate
crypt_level=high
max_bpp=32
xserverbpp=24

[Xvnc]
name=Xvnc
lib=libvnc.so
username=ask
password=ask
ip=127.0.0.1
port=-1
code=20
EOF

# Create proper startwm.sh for Xvnc
echo "🚀 Configuring session startup..."
sudo tee /etc/xrdp/startwm.sh > /dev/null << 'EOF'
#!/bin/sh
# xrdp X session start script

if test -r /etc/profile; then
    . /etc/profile
fi

# Set up environment for XFCE4
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11

# Create VNC directory if it doesn't exist
test -d ~/.vnc || mkdir ~/.vnc

# Start XFCE4 session
exec /usr/bin/startxfce4
EOF

sudo chmod +x /etc/xrdp/startwm.sh

# Create user .xsession file
echo "👤 Creating user session configuration..."
cat > /home/gmk/.xsession << 'EOF'
#!/bin/bash
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11
exec startxfce4
EOF
chmod +x /home/gmk/.xsession
chown gmk:gmk /home/gmk/.xsession

# Start services
echo "🚀 Starting xRDP services..."
sudo systemctl start xrdp-sesman
sleep 2
sudo systemctl start xrdp

# Verify services
echo "✅ Verifying services..."
echo ""
echo "xRDP-sesman Status:"
sudo systemctl status xrdp-sesman --no-pager -l | head -5
echo ""
echo "xRDP Status:"
sudo systemctl status xrdp --no-pager -l | head -5

echo ""
echo "🎉 UBUNTU 24.10 XRDP FIX COMPLETE!"
echo ""
echo "📋 What was changed:"
echo "   ✅ Switched from Xorg to Xvnc backend"
echo "   ✅ Installed TigerVNC server"
echo "   ✅ Configured proper VNC parameters"
echo "   ✅ Fixed ABI compatibility issues"
echo ""
echo "🎯 Test RDP connection now:"
echo "   Server: 100.91.157.19:3389"
echo "   Username: gmk"
echo ""
echo "🔄 Expected result: XFCE4 desktop via VNC backend" 