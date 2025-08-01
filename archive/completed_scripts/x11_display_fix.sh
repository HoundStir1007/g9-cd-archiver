#!/bin/bash
# X11 Display Configuration Fix
# This creates X11 configuration that Ubuntu reads during boot

echo "🖥️ X11 DISPLAY CONFIGURATION FIX..."
echo "===================================="

# Create X11 configuration that Ubuntu reads during boot
create_x11_config() {
    echo "🔧 Creating X11 configuration for boot..."
    
    # Create X11 configuration directory
    X11_DIR="/etc/X11/xorg.conf.d"
    sudo mkdir -p "$X11_DIR"
    
    # Create monitor configuration
    sudo tee "$X11_DIR/10-monitor.conf" > /dev/null << 'EOF'
Section "Monitor"
    Identifier "HDMI-1"
    Option "Primary" "true"
    Option "PreferredMode" "1920x1080"
    Option "Position" "0 0"
EndSection

Section "Monitor"
    Identifier "HDMI-2"
    Option "Primary" "false"
    Option "PreferredMode" "1920x1080"
    Option "Position" "1920 0"
EndSection

Section "Monitor"
    Identifier "DP-1"
    Option "Primary" "true"
    Option "PreferredMode" "1920x1080"
    Option "Position" "0 0"
EndSection

Section "Screen"
    Identifier "Screen0"
    Monitor "HDMI-1"
    DefaultDepth 24
    SubSection "Display"
        Depth 24
        Modes "1920x1080"
    EndSubSection
EndSection

Section "ServerLayout"
    Identifier "Layout0"
    Screen "Screen0"
    Option "Xinerama" "0"
EndSection
EOF
    
    echo "  ✅ Created X11 configuration: $X11_DIR/10-monitor.conf"
}

# Create additional X11 configuration for GDM3
create_gdm3_x11_config() {
    echo "🔧 Creating GDM3-specific X11 configuration..."
    
    # Create GDM3 X11 configuration
    sudo tee "$X11_DIR/20-gdm3-monitor.conf" > /dev/null << 'EOF'
Section "Monitor"
    Identifier "HDMI-1"
    Option "Primary" "true"
    Option "PreferredMode" "1920x1080"
EndSection

Section "Monitor"
    Identifier "DP-1"
    Option "Primary" "true"
    Option "PreferredMode" "1920x1080"
EndSection

Section "Screen"
    Identifier "Screen0"
    Monitor "HDMI-1"
    DefaultDepth 24
    SubSection "Display"
        Depth 24
        Modes "1920x1080"
    EndSubSection
EndSection
EOF
    
    echo "  ✅ Created GDM3 X11 configuration: $X11_DIR/20-gdm3-monitor.conf"
}

# Create systemd service that runs very early
create_early_display_service() {
    echo "🔧 Creating early display service..."
    
    # Create the service file
    SERVICE_FILE="/etc/systemd/system/early-display-fix.service"
    
    sudo tee "$SERVICE_FILE" > /dev/null << 'EOF'
[Unit]
Description=Early Display Configuration Fix
After=systemd-user-sessions.service
Before=gdm.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'sleep 2 && DISPLAY=:0 xrandr --output HDMI-1 --primary 2>/dev/null || true'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
    
    # Enable the service
    sudo systemctl daemon-reload
    sudo systemctl enable early-display-fix.service
    echo "  ✅ Created and enabled early display service"
}

# Create environment variable for GDM3
create_gdm3_env() {
    echo "🔧 Creating GDM3 environment configuration..."
    
    # Create GDM3 environment file
    GDM3_ENV="/etc/gdm3/Init/Default"
    
    # Backup existing file
    if [[ -f "$GDM3_ENV" ]]; then
        sudo cp "$GDM3_ENV" "$GDM3_ENV.backup"
        echo "  ✅ Backed up existing GDM3 Init file"
    fi
    
    # Create GDM3 Init script with display configuration
    sudo tee "$GDM3_ENV" > /dev/null << 'EOF'
#!/bin/sh
# GDM3 Init script to force monitor as primary display

# Wait for X server to be ready
sleep 3

# Force HDMI-1 as primary display
DISPLAY=:0 xrandr --output HDMI-1 --primary 2>/dev/null || true

# Position TV as secondary if connected
DISPLAY=:0 xrandr --output HDMI-2 --pos 1920x0 2>/dev/null || true

# Exit with success
exit 0
EOF
    
    # Make it executable
    sudo chmod +x "$GDM3_ENV"
    echo "  ✅ Updated GDM3 Init script: $GDM3_ENV"
}

# Main execution
create_x11_config
create_gdm3_x11_config
create_early_display_service
create_gdm3_env

echo ""
echo "✅ X11 DISPLAY CONFIGURATION FIX COMPLETE!"
echo ""
echo "🖥️ **Login screen should now appear on monitor**"
echo "🔄 **Restart to test**: sudo reboot"
echo "🗑️ **To remove**: sudo rm /etc/X11/xorg.conf.d/10-monitor.conf"
echo ""
echo "🧪 **Test**: Restart G9 - login should appear on monitor!" 