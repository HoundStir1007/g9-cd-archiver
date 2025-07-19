#!/bin/bash
# Fix Primary Display After G9 Restart
# Set monitor as primary display for login screen

echo "🖥️ Fixing Primary Display Configuration..."
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

# Fix primary display configuration
fix_primary_display() {
    echo "🔧 Fixing primary display configuration..."
    
    if [[ -n "$LOCAL_DISPLAY" ]]; then
        echo "  🖥️ Setting $LOCAL_DISPLAY as primary display..."
        
        # Set the local monitor as primary
        xrandr --output $LOCAL_DISPLAY --primary
        
        # If TV is also connected, configure dual display properly
        if [[ -n "$TV_DISPLAY" ]]; then
            echo "  📺 Configuring dual display setup..."
            
            # Configure positions: Monitor on left (primary), TV on right
            if [[ "$LOCAL_DISPLAY" == "HDMI-1" ]]; then
                # Monitor at 0,0 (primary), TV at 1920,0
                xrandr --output $LOCAL_DISPLAY --mode 1920x1080 --pos 0x0 --primary
                xrandr --output $TV_DISPLAY --mode 1920x1080 --pos 1920x0
                echo "  ✅ Monitor (HDMI-1) at 0,0 (primary)"
                echo "  ✅ TV (HDMI-2) at 1920,0"
            elif [[ "$LOCAL_DISPLAY" == "DP-1" ]]; then
                # DisplayPort monitor at 0,0 (primary), TV at 3840,0 (assuming 4K monitor)
                xrandr --output $LOCAL_DISPLAY --mode 3840x2160 --pos 0x0 --primary
                xrandr --output $TV_DISPLAY --mode 1920x1080 --pos 3840x0
                echo "  ✅ 4K Monitor (DP-1) at 0,0 (primary)"
                echo "  ✅ TV (HDMI-2) at 3840,0"
            fi
        else
            # Single monitor setup
            xrandr --output $LOCAL_DISPLAY --mode 1920x1080 --primary
            echo "  ✅ Single monitor setup configured"
        fi
        
    elif [[ -n "$TV_DISPLAY" ]]; then
        echo "  📺 Only TV detected - setting as primary..."
        xrandr --output $TV_DISPLAY --mode 1920x1080 --primary
        echo "  ⚠️ No local monitor detected - login will be on TV"
        
    else
        echo "❌ No displays detected! Check connections."
        exit 1
    fi
}

# Main execution
detect_displays
fix_primary_display

echo ""
echo "✅ Primary display configuration fixed!"
echo ""
if [[ -n "$LOCAL_DISPLAY" ]]; then
    echo "🖥️ **Login screen should now appear on the monitor**"
    echo "📺 TV will be secondary display (if connected)"
else
    echo "📺 Login screen will appear on TV (no monitor detected)"
fi
echo ""
echo "🔄 **Next time G9 restarts, run this script again if needed**" 