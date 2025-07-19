#!/bin/bash
# Nuclear Display Fix - Complete Display Reset
# This will completely reset the display configuration and force monitor as login

echo "💥 NUCLEAR DISPLAY FIX - COMPLETE RESET..."
echo "=========================================="

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

# Nuclear option: Complete display reset
nuclear_reset() {
    echo "💥 Performing nuclear display reset..."
    
    # Step 1: Disable ALL displays
    echo "  🔌 Disabling all displays..."
    xrandr --output HDMI-1 --off 2>/dev/null || true
    xrandr --output HDMI-2 --off 2>/dev/null || true
    xrandr --output DP-1 --off 2>/dev/null || true
    sleep 3
    
    # Step 2: Enable monitor first (this makes it primary)
    if [[ -n "$LOCAL_DISPLAY" ]]; then
        echo "  🖥️ Enabling monitor as primary..."
        xrandr --output $LOCAL_DISPLAY --mode 1920x1080 --primary --pos 0x0
        sleep 2
        
        # Step 3: Enable TV as secondary (if connected)
        if [[ -n "$TV_DISPLAY" ]]; then
            echo "  📺 Enabling TV as secondary..."
            xrandr --output $TV_DISPLAY --mode 1920x1080 --pos 1920x0
            sleep 2
        fi
        
        echo "  ✅ Nuclear reset complete - monitor should be primary"
        
    else
        echo "❌ No local monitor detected! Check connections."
        exit 1
    fi
}

# Create persistent X11 configuration
create_x11_config() {
    echo "🔧 Creating persistent X11 configuration..."
    
    # Create X11 configuration that forces monitor as primary
    X11_CONFIG="$HOME/.config/x11-display.conf"
    mkdir -p "$(dirname "$X11_CONFIG")"
    
    cat > "$X11_CONFIG" << 'EOF'
# Force monitor as primary display
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

# Create systemd service for display fix
create_display_service() {
    echo "🔧 Creating systemd service for display fix..."
    
    # Create the service file
    SERVICE_FILE="/etc/systemd/system/force-monitor-primary.service"
    
    sudo tee "$SERVICE_FILE" > /dev/null << 'EOF'
[Unit]
Description=Force Monitor as Primary Display
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=oneshot
User=mark
Environment=DISPLAY=:0
ExecStart=/bin/bash -c 'sleep 10 && xrandr --output HDMI-1 --mode 1920x1080 --primary --pos 0x0 && xrandr --output HDMI-2 --mode 1920x1080 --pos 1920x0'
RemainAfterExit=yes

[Install]
WantedBy=graphical-session.target
EOF
    
    # Enable the service
    sudo systemctl daemon-reload
    sudo systemctl enable force-monitor-primary.service
    echo "  ✅ Created and enabled systemd service"
}

# Main execution
detect_displays
nuclear_reset
create_x11_config
create_display_service

echo ""
echo "✅ NUCLEAR DISPLAY RESET COMPLETE!"
echo ""
echo "🖥️ **Monitor should now be the primary display for login**"
echo "📺 **TV will be secondary display**"
echo ""
echo "🔄 **This configuration will persist across reboots**"
echo "🗑️ **To remove**: sudo systemctl disable force-monitor-primary.service"
echo ""
echo "🧪 **Test**: Restart the G9 now - login should appear on monitor!" 