#!/bin/bash
# Test script to verify Firefox opens on TV display

echo "🧪 Testing Firefox positioning on TV display..."

# Kill any existing Firefox
pkill firefox 2>/dev/null
sleep 2

# Display current setup
echo "📺 Current display configuration:"
xrandr --query | grep " connected"

echo ""
echo "🎯 Launching Firefox on TV (position 0,0 - left display)..."

# Launch Firefox with explicit positioning
DISPLAY=:0.0 firefox \
  --new-window \
  --window-position=0,0 \
  --window-size=1920,1080 \
  "http://localhost:8096/web/#/home.html" &

# Wait for Firefox to start
sleep 4

# Check if xdotool is available and use it for positioning
if command -v xdotool >/dev/null 2>&1; then
    echo "✅ Using xdotool for precise positioning..."
    xdotool search --name "Jellyfin" windowmove 0 0 2>/dev/null || true
    xdotool search --name "Jellyfin" windowsize 1920 1080 2>/dev/null || true
    echo "🎯 Firefox should now be on your TV (left display)"
else
    echo "⚠️ xdotool not available - using basic positioning"
fi

echo ""
echo "🔍 Check your TV display - Firefox should be there!"
echo "🛑 To close: Alt+F4 or run: pkill firefox" 