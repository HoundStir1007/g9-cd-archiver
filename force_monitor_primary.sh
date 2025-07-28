#!/bin/bash
# Force Monitor as Primary Display - Nuclear Option
# This script will aggressively set the monitor as primary and disable TV if needed

echo "🖥️ FORCING MONITOR AS PRIMARY DISPLAY..."
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

# Nuclear option: Force monitor as primary and disable TV
force_monitor_primary() {
    echo "💥 Using nuclear option to force monitor as primary..."
    
    if [[ -n "$LOCAL_DISPLAY" ]]; then
        echo "  🖥️ Setting $LOCAL_DISPLAY as primary and disabling TV..."
        
        # First, disable the TV completely
        if [[ -n "$TV_DISPLAY" ]]; then
            echo "  📺 Disabling TV display..."
            xrandr --output $TV_DISPLAY --off
            sleep 2
        fi
        
        # Set monitor as primary with specific mode
        echo "  🖥️ Configuring monitor as primary..."
        xrandr --output $LOCAL_DISPLAY --mode 1920x1080 --primary --pos 0x0
        
        # Wait a moment, then re-enable TV if needed
        if [[ -n "$TV_DISPLAY" ]]; then
            echo "  📺 Re-enabling TV as secondary..."
            sleep 3
            xrandr --output $TV_DISPLAY --mode 1920x1080 --pos 1920x0
        fi
        
        echo "  ✅ Monitor forced as primary display"
        
    else
        echo "❌ No local monitor detected! Check connections."
        exit 1
    fi
}

# Create persistent configuration
create_persistent_config() {
    echo "🔧 Creating persistent display configuration..."
    
    # Create a startup script that will run on login
    SCRIPT_PATH="$HOME/.config/autostart/fix_display.sh"
    mkdir -p "$(dirname "$SCRIPT_PATH")"
    
    cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash
# Auto-fix display configuration on login
sleep 5  # Wait for X to fully initialize

# Force monitor as primary
if cat /sys/class/drm/card1-HDMI-A-1/status 2>/dev/null | grep -q "connected"; then
    xrandr --output HDMI-1 --mode 1920x1080 --primary --pos 0x0
    if cat /sys/class/drm/card1-HDMI-A-2/status 2>/dev/null | grep -q "connected"; then
        xrandr --output HDMI-2 --mode 1920x1080 --pos 1920x0
    fi
elif cat /sys/class/drm/card1-DP-1/status 2>/dev/null | grep -q "connected"; then
    xrandr --output DP-1 --mode 1920x1080 --primary --pos 0x0
    if cat /sys/class/drm/card1-HDMI-A-2/status 2>/dev/null | grep -q "connected"; then
        xrandr --output HDMI-2 --mode 1920x1080 --pos 1920x0
    fi
fi
EOF
    
    chmod +x "$SCRIPT_PATH"
    echo "  ✅ Created persistent startup script: $SCRIPT_PATH"
}

# Main execution
detect_displays
force_monitor_primary
create_persistent_config

echo ""
echo "✅ MONITOR FORCED AS PRIMARY DISPLAY!"
echo ""
echo "🖥️ **Login screen should now appear on the monitor**"
echo "📺 TV will be secondary display (if connected)"
echo ""
echo "🔄 **This configuration will persist across reboots**"
echo "🗑️ **To remove auto-fix**: rm ~/.config/autostart/fix_display.sh" 