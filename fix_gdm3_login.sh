#!/bin/bash
# Fix GDM3 Login Screen Display Configuration
# This will make the monitor primary for the login screen

echo "🔐 FIXING GDM3 LOGIN SCREEN DISPLAY..."
echo "======================================="

# Function to detect connected displays
detect_displays() {
    echo "🔍 Detecting connected displays..."
    
    TV_DISPLAY=""
    LOCAL_DISPLAY=""
    
    # Check what's actually connected
    if cat /sys/class/drm/card1-HDMI-A-2/status 2>/dev/null | grep -q "connected"; then
        TV_DISPLAY="HDMI-2"  # Vizio TV
        echo "  ✅ TV found on HDMI-2 (Vizio)"
    fi
    
    if cat /sys/class/drm/card1-HDMI-A-1/status 2>/dev/null | grep -q "connected"; then
        LOCAL_DISPLAY="HDMI-1"
        echo "  ✅ Local monitor found on HDMI-1"
    elif cat /sys/class/drm/card1-DP-1/status 2>/dev/null | grep -q "connected"; then
        LOCAL_DISPLAY="DP-1"  
        echo "  ✅ Local monitor found on DisplayPort"
    fi
}

# Create GDM3 configuration
create_gdm3_config() {
    echo "🔧 Creating GDM3 display configuration..."
    
    # Create GDM3 configuration directory
    GDM3_CONFIG="/etc/gdm3/custom.conf"
    
    # Backup existing config
    if [[ -f "$GDM3_CONFIG" ]]; then
        sudo cp "$GDM3_CONFIG" "$GDM3_CONFIG.backup"
        echo "  ✅ Backed up existing GDM3 config"
    fi
    
    # Create custom GDM3 configuration
    sudo tee "$GDM3_CONFIG" > /dev/null << 'EOF'
# GDM3 configuration for monitor as primary display
[daemon]
# Uncomment the line below to force the login screen to use the monitor
# WaylandEnable=false

[security]

[xdmcp]

[chooser]

[debug]
# Uncomment to enable debug logging
# Enable=true
EOF
    
    echo "  ✅ Created GDM3 configuration: $GDM3_CONFIG"
}

# Create X11 configuration for GDM3
create_x11_config() {
    echo "🔧 Creating X11 configuration for GDM3..."
    
    # Create X11 configuration that GDM3 will use
    X11_CONFIG="/etc/X11/xorg.conf.d/10-monitor.conf"
    sudo mkdir -p "$(dirname "$X11_CONFIG")"
    
    sudo tee "$X11_CONFIG" > /dev/null << 'EOF'
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
    
    echo "  ✅ Created X11 configuration: $X11_CONFIG"
}

# Create systemd service for GDM3 display fix
create_gdm3_service() {
    echo "🔧 Creating systemd service for GDM3 display fix..."
    
    # Create the service file
    SERVICE_FILE="/etc/systemd/system/gdm3-display-fix.service"
    
    sudo tee "$SERVICE_FILE" > /dev/null << 'EOF'
[Unit]
Description=Fix GDM3 Display Configuration
After=gdm.service
Wants=gdm.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'sleep 5 && xrandr --output HDMI-1 --primary 2>/dev/null || true'
RemainAfterExit=yes

[Install]
WantedBy=gdm.service
EOF
    
    # Enable the service
    sudo systemctl daemon-reload
    sudo systemctl enable gdm3-display-fix.service
    echo "  ✅ Created and enabled GDM3 display fix service"
}

# Main execution
detect_displays
create_gdm3_config
create_x11_config
create_gdm3_service

echo ""
echo "✅ GDM3 LOGIN SCREEN FIX COMPLETE!"
echo ""
echo "🔐 **Login screen should now appear on monitor**"
echo "🖥️ **Desktop session will remain on monitor**"
echo ""
echo "🔄 **Restart to test**: sudo reboot"
echo "🗑️ **To remove**: sudo systemctl disable gdm3-display-fix.service"
echo ""
echo "🧪 **Test**: Restart G9 - login should appear on monitor!" 