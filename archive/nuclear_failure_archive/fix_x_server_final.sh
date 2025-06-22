#!/bin/bash

# FINAL X SERVER FIX - Targeted LightDM and X Server Repair
# Addresses specific startup failures after nuclear fix

echo "🔧 FINAL X SERVER FIX - Targeted Repair"
echo "Fixing LightDM startup and X server configuration issues..."
echo ""

# 1. Stop all display services completely
echo "🛑 Stopping all display services..."
sudo systemctl stop lightdm
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman

# 2. Kill any remaining X processes
echo "💀 Cleaning up remaining processes..."
sudo pkill -f "lightdm"
sudo pkill -f "Xorg"
sudo pkill -f "xrdp"

# 3. Clean up X server locks and sockets
echo "🧹 Cleaning X server locks and sockets..."
sudo rm -f /tmp/.X*-lock
sudo rm -f /tmp/.X11-unix/*
sudo rm -f /var/lib/lightdm/.Xauthority*
sudo rm -f /home/gmk/.Xauthority*

# 4. Reconfigure X server from scratch
echo "⚙️ Reconfiguring X server..."
sudo dpkg-reconfigure xserver-xorg-core

# 5. Recreate LightDM configuration
echo "🖥️ Recreating LightDM configuration..."
sudo tee /etc/lightdm/lightdm.conf > /dev/null << 'EOF'
[Seat:*]
autologin-guest=false
autologin-user=
autologin-user-timeout=0
autologin-session=
user-session=xfce
greeter-session=lightdm-gtk-greeter
greeter-hide-users=false
greeter-allow-guest=false
greeter-show-manual-login=true
xserver-command=X -core
session-wrapper=/etc/X11/Xsession
display-setup-script=
display-stopped-script=
greeter-setup-script=
session-setup-script=
session-cleanup-script=
EOF

# 6. Configure xRDP for Xorg sessions specifically
echo "🔄 Configuring xRDP for Xorg..."
sudo tee /etc/xrdp/startwm.sh > /dev/null << 'EOF'
#!/bin/sh
# xrdp X session start script (c) 2015, 2017, 2021 mirabilos
# published under The MirOS Licence

# Rely on /etc/pam.d/xrdp-sesman using pam_env to load both
# /etc/environment and /etc/default/locale to initialise the
# locale and the user environment properly.

if test -r /etc/profile; then
	. /etc/profile
fi

# Set up the desktop environment
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11

# Start XFCE4 session
exec /usr/bin/startxfce4
EOF

sudo chmod +x /etc/xrdp/startwm.sh

# 7. Create proper user session file
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

# 8. Fix permissions on critical directories
echo "🔐 Fixing permissions..."
sudo chown lightdm:lightdm /var/lib/lightdm
sudo chmod 750 /var/lib/lightdm
sudo chown gmk:gmk /home/gmk

# 9. Regenerate X server configuration
echo "🔧 Regenerating X configuration..."
sudo X -configure :1 2>/dev/null || true

# 10. Start services in correct order
echo "🚀 Starting services in correct order..."
sudo systemctl enable lightdm
sudo systemctl start lightdm
sleep 3

sudo systemctl enable xrdp-sesman
sudo systemctl start xrdp-sesman
sleep 2

sudo systemctl enable xrdp
sudo systemctl start xrdp

# 11. Verify services
echo "✅ Verifying services..."
echo ""
echo "LightDM Status:"
sudo systemctl status lightdm --no-pager -l | head -10
echo ""
echo "xRDP-sesman Status:"
sudo systemctl status xrdp-sesman --no-pager -l | head -10
echo ""
echo "xRDP Status:"
sudo systemctl status xrdp --no-pager -l | head -10

echo ""
echo "🎉 FINAL X SERVER FIX COMPLETE!"
echo ""
echo "🔄 No reboot required - services restarted"
echo ""
echo "🎯 Test RDP connection now:"
echo "   Server: 100.91.157.19:3389"
echo "   Username: gmk"
echo ""
echo "📊 If still issues, check logs:"
echo "   sudo tail -f /var/log/lightdm/lightdm.log"
echo "   sudo tail -f /var/log/xrdp-sesman.log" 