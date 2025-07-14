#!/bin/bash
# Fixed Jellyfin TV Mode Script
# Properly handles dual display positioning

echo "🎬 Fixed Jellyfin TV Mode Starting..."

# Kill any existing Firefox
pkill firefox 2>/dev/null
sleep 3

# Check display configuration
echo "📺 Display Configuration:"
xrandr --listmonitors
echo ""

# Ensure Jellyfin is running
echo "🔍 Checking Jellyfin service..."
if ! curl -s http://localhost:8096 > /dev/null; then
    echo "❌ Jellyfin not accessible at localhost:8096"
    echo "   Starting Jellyfin container..."
    cd /home/mark/Desktop/home_server_research
    docker-compose up -d jellyfin
    sleep 5
fi

# Set up environment for correct display
export DISPLAY=:0.0
export XAUTHORITY=/home/mark/.Xauthority

echo "🎯 Launching Firefox with proper display handling..."

# Launch Firefox with specific display targeting
# We'll use a more direct approach to ensure it opens on TV
timeout 30 firefox \
    --new-window \
    --display=:0.0 \
    --geometry=1920x1080+0+0 \
    "http://localhost:8096/web/#/home.html" &

FIREFOX_PID=$!
echo "🔄 Firefox PID: $FIREFOX_PID"

# Wait for Firefox to fully start
sleep 5

# Try multiple methods to position the window
echo "🎯 Attempting window positioning..."

# Method 1: Try wmctrl
if wmctrl -l | grep -i firefox; then
    echo "✅ Found Firefox window with wmctrl"
    wmctrl -r "Firefox" -e 0,0,0,1920,1080
    wmctrl -r "Firefox" -b add,fullscreen
    echo "✅ Window positioned using wmctrl"
elif wmctrl -l | grep -i jellyfin; then
    echo "✅ Found Jellyfin window with wmctrl"
    wmctrl -r "Jellyfin" -e 0,0,0,1920,1080
    wmctrl -r "Jellyfin" -b add,fullscreen
    echo "✅ Window positioned using wmctrl"
else
    echo "⚠️ No Firefox/Jellyfin window found with wmctrl"
    
    # Method 2: Try xdotool
    WINDOW_ID=$(xdotool search --pid $FIREFOX_PID 2>/dev/null | head -1)
    if [ -n "$WINDOW_ID" ]; then
        echo "✅ Found Firefox window with xdotool (ID: $WINDOW_ID)"
        xdotool windowmove $WINDOW_ID 0 0
        xdotool windowsize $WINDOW_ID 1920 1080
        xdotool key --window $WINDOW_ID F11  # Toggle fullscreen
        echo "✅ Window positioned using xdotool"
    else
        echo "⚠️ No Firefox window found with xdotool"
    fi
fi

# Final check
echo ""
echo "🔍 Final window check:"
wmctrl -l
echo ""

echo "✅ Jellyfin TV Mode Setup Complete!"
echo ""
echo "📺 **Instructions:**"
echo "   1. Switch your Vizio TV to the HDMI input"
echo "   2. Firefox should be running Jellyfin in fullscreen"
echo "   3. If not visible, press F11 to toggle fullscreen"
echo "   4. Use your 4K monitor for desktop work"
echo ""
echo "🛑 **To exit:** Alt+F4 or run: pkill firefox"
echo ""
echo "📱 **Remote control:** http://192.168.0.182:8096" 