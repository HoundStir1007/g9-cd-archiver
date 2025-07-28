#!/bin/bash
# GDM3 Display Fix - Reset Display Manager Configuration
# This will reset GDM3's display memory and force monitor as primary

echo "🖥️ GDM3 DISPLAY FIX - RESET DISPLAY MANAGER..."
echo "================================================"

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

# Reset GDM3 display configuration
reset_gdm3_config() {
    echo "🔧 Resetting GDM3 display configuration..."
    
    # Stop GDM3
    echo "  🛑 Stopping GDM3..."
    sudo systemctl stop gdm3
    sleep 3
    
    # Clear GDM3 display cache
    echo "  🗑️ Clearing GDM3 display cache..."
    sudo rm -rf /var/lib/gdm3/.config/monitors.xml 2>/dev/null || true
    sudo rm -rf /var/lib/gdm3/.config/xrandr 2>/dev/null || true
    sudo rm -rf /var/lib/gdm3/.cache 2>/dev/null || true
    
    # Clear user display cache
    echo "  🗑️ Clearing user display cache..."
    rm -rf ~/.config/monitors.xml 2>/dev/null || true
    rm -rf ~/.config/xrandr 2>/dev/null || true
    rm -rf ~/.cache 2>/dev/null || true
    
    # Create new monitor configuration
    echo "  🔧 Creating new monitor configuration..."
    MONITOR_CONFIG="$HOME/.config/monitors.xml"
    mkdir -p "$(dirname "$MONITOR_CONFIG")"
    
    cat > "$MONITOR_CONFIG" << 'EOF'
<monitors version="2">
  <configuration>
    <logicalmonitor>
      <x>0</x>
      <y>0</y>
      <scale>1</scale>
      <primary>yes</primary>
      <monitor>
        <monitorspec>
          <connector>HDMI-1</connector>
          <vendor>Unknown</vendor>
          <product>Unknown</product>
          <serial>Unknown</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>60</rate>
        </mode>
      </monitor>
    </logicalmonitor>
    <logicalmonitor>
      <x>1920</x>
      <y>0</y>
      <scale>1</scale>
      <primary>no</primary>
      <monitor>
        <monitorspec>
          <connector>HDMI-2</connector>
          <vendor>Unknown</vendor>
          <product>Unknown</product>
          <serial>Unknown</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>60</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  </configuration>
</monitors>
EOF
    
    # Copy to GDM3 config
    sudo cp "$MONITOR_CONFIG" /var/lib/gdm3/.config/
    sudo chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
    
    echo "  ✅ GDM3 configuration reset"
}

# Create systemd service for display fix
create_display_service() {
    echo "🔧 Creating systemd service for display fix..."
    
    # Create the service file
    SERVICE_FILE="/etc/systemd/system/gdm-display-fix.service"
    
    sudo tee "$SERVICE_FILE" > /dev/null << 'EOF'
[Unit]
Description=GDM Display Fix - Force Monitor as Primary
After=gdm.service
Wants=gdm.service

[Service]
Type=oneshot
User=root
Environment=DISPLAY=:0
ExecStart=/bin/bash -c 'sleep 15 && DISPLAY=:0 xrandr --output HDMI-1 --mode 1920x1080 --primary --pos 0x0 && DISPLAY=:0 xrandr --output HDMI-2 --mode 1920x1080 --pos 1920x0'
RemainAfterExit=yes

[Install]
WantedBy=gdm.service
EOF
    
    # Enable the service
    sudo systemctl daemon-reload
    sudo systemctl enable gdm-display-fix.service
    echo "  ✅ Created and enabled GDM display fix service"
}

# Restart GDM3
restart_gdm3() {
    echo "🔄 Restarting GDM3..."
    sudo systemctl start gdm3
    echo "  ✅ GDM3 restarted with new configuration"
}

# Main execution
detect_displays
reset_gdm3_config
create_display_service
restart_gdm3

echo ""
echo "✅ GDM3 DISPLAY FIX COMPLETE!"
echo ""
echo "🖥️ **Monitor should now be the primary display for login**"
echo "📺 **TV will be secondary display**"
echo ""
echo "🔄 **This configuration will persist across reboots**"
echo "🗑️ **To remove**: sudo systemctl disable gdm-display-fix.service"
echo ""
echo "🧪 **Test**: The login screen should now appear on the monitor!" 