#!/bin/bash
# Force Fix Primary Display - Clear Cache and Reset Configuration
# This script aggressively resets display configuration to force monitor as primary

echo "🛠️ Force Fixing Primary Display Configuration..."
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

# Clear display configuration cache
clear_display_cache() {
    echo "🧹 Clearing display configuration cache..."
    
    # Kill any display manager processes that might be caching config
    pkill -f "gnome-settings-daemon" 2>/dev/null || true
    pkill -f "gdm" 2>/dev/null || true
    
    # Clear X11 configuration cache
    rm -f ~/.config/monitors.xml 2>/dev/null || true
    rm -f ~/.config/gnome-settings-daemon/xrandr/ 2>/dev/null || true
    
    # Clear system-wide display config
    sudo rm -f /var/lib/gdm3/.config/monitors.xml 2>/dev/null || true
    
    echo "  ✅ Display cache cleared"
}

# Force reset all displays
reset_displays() {
    echo "🔄 Force resetting all displays..."
    
    # Turn off all displays first
    xrandr --output HDMI-1 --off 2>/dev/null || true
    xrandr --output HDMI-2 --off 2>/dev/null || true
    xrandr --output DP-1 --off 2>/dev/null || true
    
    sleep 2
    
    # Turn on local monitor first (this makes it primary)
    if [[ -n "$LOCAL_DISPLAY" ]]; then
        echo "  🖥️ Turning on $LOCAL_DISPLAY as primary..."
        xrandr --output $LOCAL_DISPLAY --auto --primary
        sleep 1
        
        # If TV is connected, add it as secondary
        if [[ -n "$TV_DISPLAY" ]]; then
            echo "  📺 Adding $TV_DISPLAY as secondary..."
            xrandr --output $TV_DISPLAY --auto --right-of $LOCAL_DISPLAY
        fi
    else
        echo "  📺 Only TV detected - setting as primary..."
        xrandr --output $TV_DISPLAY --auto --primary
    fi
}

# Alternative method: Use xrandr to force specific configuration
force_xrandr_config() {
    echo "⚡ Force configuring with xrandr..."
    
    if [[ -n "$LOCAL_DISPLAY" && -n "$TV_DISPLAY" ]]; then
        # Force dual display with monitor as primary
        echo "  🖥️ Forcing dual display: Monitor primary, TV secondary"
        
        # Get current resolutions
        LOCAL_RES=$(xrandr | grep $LOCAL_DISPLAY | grep -o '[0-9]*x[0-9]*' | head -1)
        TV_RES=$(xrandr | grep $TV_DISPLAY | grep -o '[0-9]*x[0-9]*' | head -1)
        
        if [[ -z "$LOCAL_RES" ]]; then LOCAL_RES="1920x1080"; fi
        if [[ -z "$TV_RES" ]]; then TV_RES="1920x1080"; fi
        
        echo "  📐 Monitor resolution: $LOCAL_RES"
        echo "  📐 TV resolution: $TV_RES"
        
        # Force the configuration
        xrandr --output $LOCAL_DISPLAY --mode $LOCAL_RES --pos 0x0 --primary \
               --output $TV_DISPLAY --mode $TV_RES --pos ${LOCAL_RES%x*}x0
        
    elif [[ -n "$LOCAL_DISPLAY" ]]; then
        echo "  🖥️ Single monitor setup"
        xrandr --output $LOCAL_DISPLAY --auto --primary
    else
        echo "  📺 TV-only setup"
        xrandr --output $TV_DISPLAY --auto --primary
    fi
}

# Main execution
detect_displays
clear_display_cache
reset_displays
force_xrandr_config

echo ""
echo "✅ Force display configuration complete!"
echo ""
if [[ -n "$LOCAL_DISPLAY" ]]; then
    echo "🖥️ **Monitor should now be primary for login screen**"
    echo "📺 TV will be secondary display"
else
    echo "📺 TV will be primary (no monitor detected)"
fi
echo ""
echo "🔄 **If this doesn't work, try: sudo reboot**" 