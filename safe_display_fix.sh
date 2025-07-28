#!/bin/bash
# Safe Display Fix - No Boot Interference
# This will fix the display after login without affecting boot process

echo "🛡️ SAFE DISPLAY FIX - NO BOOT INTERFERENCE..."
echo "=============================================="

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

# Safe display fix (no boot interference)
safe_fix() {
    echo "🛡️ Applying safe display fix..."
    
    if [[ -n "$LOCAL_DISPLAY" ]]; then
        echo "  🖥️ Setting $LOCAL_DISPLAY as primary..."
        
        # Simple approach: just set monitor as primary
        xrandr --output $LOCAL_DISPLAY --primary
        
        # If TV is connected, position it as secondary
        if [[ -n "$TV_DISPLAY" ]]; then
            echo "  📺 Positioning TV as secondary..."
            xrandr --output $TV_DISPLAY --pos 1920x0
        fi
        
        echo "  ✅ Safe fix applied - monitor should be primary"
        
    else
        echo "❌ No local monitor detected! Check connections."
        exit 1
    fi
}

# Create simple autostart script (no systemd service)
create_autostart() {
    echo "🔧 Creating simple autostart script..."
    
    # Create autostart script that runs after login
    AUTOSTART_SCRIPT="$HOME/.config/autostart/fix-display.desktop"
    mkdir -p "$(dirname "$AUTOSTART_SCRIPT")"
    
    cat > "$AUTOSTART_SCRIPT" << 'EOF'
[Desktop Entry]
Type=Application
Name=Fix Display
Exec=/home/mark/Desktop/home_server_research/safe_display_fix.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
    
    echo "  ✅ Created autostart entry: $AUTOSTART_SCRIPT"
}

# Create simple fix script
create_fix_script() {
    echo "🔧 Creating simple fix script..."
    
    cat > "simple_display_fix.sh" << 'EOF'
#!/bin/bash
# Simple display fix - just set monitor as primary

echo "🖥️ Quick display fix..."

# Set HDMI-1 as primary
xrandr --output HDMI-1 --primary 2>/dev/null || true

# Position TV as secondary if connected
xrandr --output HDMI-2 --pos 1920x0 2>/dev/null || true

echo "✅ Monitor should now be primary"
EOF
    
    chmod +x "simple_display_fix.sh"
    echo "  ✅ Created simple fix script: simple_display_fix.sh"
}

# Main execution
detect_displays
safe_fix
create_autostart
create_fix_script

echo ""
echo "✅ SAFE DISPLAY FIX COMPLETE!"
echo ""
echo "🖥️ **Monitor should now be primary**"
echo "📺 **TV will be secondary**"
echo ""
echo "🔄 **Auto-fix will run on next login**"
echo "🛠️ **Manual fix**: ./simple_display_fix.sh"
echo ""
echo "🧪 **Test**: Log out and back in - monitor should be primary!" 