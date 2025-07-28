#!/bin/bash
# Dual Display Jellyfin Setup
# HDMI-A-2 (Vizio TV) = Jellyfin fullscreen
# HDMI-A-1 or DP-1 (Local Monitor) = Desktop/maintenance

echo "🎬 Setting up Dual Display Jellyfin TV Mode..."

# Function to detect connected displays
detect_displays() {
    echo "🔍 Detecting connected displays..."
    
    # Check what's actually connected
    TV_DISPLAY=""
    LOCAL_DISPLAY=""
    
    # Map kernel names to xrandr names
    if cat /sys/class/drm/card1-HDMI-A-2/status 2>/dev/null | grep -q "connected"; then
        TV_DISPLAY="HDMI-2"  # This is your Vizio TV
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

# Configure displays
setup_displays() {
    if [[ -n "$TV_DISPLAY" && -n "$LOCAL_DISPLAY" ]]; then
        echo "🖥️ Setting up DUAL display mode..."
        
        # Configure dual display: Keep existing setup (4K monitor on right, TV on left)
        # User already has: TV(1920x1080) at 0,0 + 4K Monitor(3840x2160) at 1920,0
        echo "  ✅ Using existing dual display configuration"
        echo "  📺 TV: 1920x1080 at position 0,0"
        echo "  🖥️ 4K Monitor: 3840x2160 at position 1920,0"
               
        JELLYFIN_DISPLAY=$TV_DISPLAY
        echo "  ✅ Dual display configured: Local monitor (primary) + TV"
        echo "  📺 TV will show Jellyfin, local monitor shows desktop"
        
    elif [[ -n "$TV_DISPLAY" ]]; then
        echo "📺 TV-only mode (no local monitor detected)"
        xrandr --output $TV_DISPLAY --mode 1920x1080 --primary
        JELLYFIN_DISPLAY=$TV_DISPLAY
        
    else
        echo "❌ No displays detected! Check connections."
        exit 1
    fi
}

# Launch Jellyfin on TV display
launch_jellyfin_tv() {
    echo "🎬 Launching Jellyfin on TV display..."
    
    # Kill existing Chrome
    pkill google-chrome 2>/dev/null
    sleep 2
    
    # Launch Chrome fullscreen on the TV display
    if [[ "$JELLYFIN_DISPLAY" == "HDMI-2" ]]; then
        echo "📺 Opening Chrome on TV (HDMI-2)..."
        
        # Set display environment and launch Chrome with specific geometry
        # TV is at position 0,0 with 1920x1080 resolution
        DISPLAY=:0.0 google-chrome \
          --new-window \
          --kiosk \
          --no-first-run \
          --disable-session-crashed-bubble \
          --disable-infobars \
          --disable-notifications \
          --disable-translate \
          --window-position=0,0 \
          --window-size=1920,1080 \
          "http://localhost:8096/web/#/home.html" &
          
        # Wait for Chrome to start, then ensure it's on the TV
        sleep 4
        
        # Force window to TV display using xdotool (more reliable than wmctrl)
        if command -v xdotool >/dev/null 2>&1; then
            # Move Chrome window to TV coordinates (0,0)
            xdotool search --name "Jellyfin" windowmove 0 0 2>/dev/null || true
            xdotool search --name "Jellyfin" windowsize 1920 1080 2>/dev/null || true
            echo "  ✅ Chrome positioned on TV using xdotool"
        elif command -v wmctrl >/dev/null 2>&1; then
            # Fallback to wmctrl if xdotool not available
            wmctrl -r "Jellyfin" -e 0,0,0,1920,1080 2>/dev/null || true
            echo "  ✅ Chrome positioned on TV using wmctrl"
        else
            echo "  ⚠️ Window positioning tools not available - Chrome may open on wrong display"
        fi
    fi
}

# Main execution
detect_displays
setup_displays
launch_jellyfin_tv

echo ""
echo "✅ Setup complete!"
echo ""
echo "📺 **TV (Vizio - Left)**: Jellyfin fullscreen interface"
echo "🖥️  **4K Monitor (Right)**: Desktop for server maintenance"
echo "📱 **Phone Control**: http://192.168.0.182:8096"
echo ""
echo "🎯 **Usage:**"
echo "   - Switch Vizio TV to HDMI input to view Jellyfin"
echo "   - Use local monitor for any server maintenance"
echo "   - Control Jellyfin from your phone/iPad"
echo ""
echo "🛑 **To exit**: Alt+F4 on TV or run: pkill google-chrome" 