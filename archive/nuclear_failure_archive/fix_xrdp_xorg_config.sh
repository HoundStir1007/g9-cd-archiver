#!/bin/bash

# FIX XRDP XORG CONFIGURATION
# Fixes the missing executable path in sesman.ini

echo "🔧 FIXING XRDP XORG CONFIGURATION"
echo "Adding missing Xorg executable path..."
echo ""

# Stop xRDP services
echo "🛑 Stopping xRDP services..."
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman

# Create correct sesman.ini configuration
echo "⚙️ Creating correct sesman.ini configuration..."
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

[Xorg]
param=/usr/bin/Xorg
param=-ac
param=-nolisten
param=tcp
param=-noreset
param=-auth
param=.Xauthority
EOF

# Create proper xrdp.ini as well
echo "🖥️ Creating correct xrdp.ini configuration..."
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

# Start services
echo "🚀 Starting xRDP services..."
sudo systemctl start xrdp-sesman
sleep 2
sudo systemctl start xrdp

# Verify configuration
echo "✅ Verifying services..."
echo ""
echo "xRDP-sesman Status:"
sudo systemctl status xrdp-sesman --no-pager -l | head -5
echo ""
echo "xRDP Status:"
sudo systemctl status xrdp --no-pager -l | head -5

echo ""
echo "🎉 XRDP XORG CONFIGURATION FIXED!"
echo ""
echo "🎯 Test RDP connection now:"
echo "   Server: 100.91.157.19:3389"
echo "   Username: gmk"
echo ""
echo "The X server should now start correctly!" 