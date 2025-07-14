#!/bin/bash
# Final Jellyfin TV Mode Script - Fixes X11 Authorization Issue

echo "🎬 Final Jellyfin TV Mode Starting..."

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

# Set up environment for correct display - Fix X11 authorization
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

echo "🎯 Launching Firefox with proper X11 authorization..."

# Launch Firefox with correct display settings
firefox \
    --new-window \
    --class="JellyfinTV" \
    "http://localhost:8096/web/#/home.html" &

FIREFOX_PID=$!
echo "🔄 Firefox PID: $FIREFOX_PID"

# Wait for Firefox to fully start
sleep 5

# Try multiple methods to position the window
echo "🎯 Attempting window positioning..."

# Method 1: Try wmctrl with various window names
WINDOW_MOVED=false

for window_name in "Firefox" "Jellyfin" "JellyfinTV" "Mozilla Firefox"; do
    if wmctrl -l | grep -i "$window_name"; then
        echo "✅ Found window: $window_name"
        wmctrl -r "$window_name" -e 0,0,0,1920,1080
        wmctrl -r "$window_name" -b add,fullscreen
        echo "✅ Window positioned using wmctrl"
        WINDOW_MOVED=true
        break
    fi
done

# Method 2: Try xdotool if wmctrl didn't work
if [ "$WINDOW_MOVED" = false ]; then
    echo "🔄 Trying xdotool method..."
    
    # Try to find window by PID
    WINDOW_ID=$(xdotool search --pid $FIREFOX_PID 2>/dev/null | head -1)
    if [ -n "$WINDOW_ID" ]; then
        echo "✅ Found Firefox window with xdotool (ID: $WINDOW_ID)"
        xdotool windowmove $WINDOW_ID 0 0
        xdotool windowsize $WINDOW_ID 1920 1080
        xdotool key --window $WINDOW_ID F11  # Toggle fullscreen
        echo "✅ Window positioned using xdotool"
        WINDOW_MOVED=true
    else
        # Try to find any Firefox window
        WINDOW_ID=$(xdotool search --name "Firefox" 2>/dev/null | head -1)
        if [ -n "$WINDOW_ID" ]; then
            echo "✅ Found Firefox window by name (ID: $WINDOW_ID)"
            xdotool windowmove $WINDOW_ID 0 0
            xdotool windowsize $WINDOW_ID 1920 1080
            xdotool key --window $WINDOW_ID F11  # Toggle fullscreen
            echo "✅ Window positioned using xdotool"
            WINDOW_MOVED=true
        fi
    fi
fi

# Method 3: Manual fullscreen trigger
if [ "$WINDOW_MOVED" = false ]; then
    echo "🔄 Trying manual fullscreen trigger..."
    sleep 2
    # Focus on Firefox and press F11 for fullscreen
    xdotool search --name "Firefox" key F11 2>/dev/null
    echo "✅ Sent F11 to Firefox"
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
echo "   2. Firefox should be running Jellyfin"
echo "   3. If not fullscreen, press F11 to toggle"
echo "   4. Use your 4K monitor for desktop work"
echo ""
echo "🛑 **To exit:** Alt+F4 or run: pkill firefox"
echo ""
echo "📱 **Remote control:** http://192.168.0.182:8096"
echo ""
echo "🎯 **If Firefox is on wrong display:**"
echo "   - Try: wmctrl -r 'Firefox' -e 0,0,0,1920,1080"
echo "   - Or drag window to TV manually" 