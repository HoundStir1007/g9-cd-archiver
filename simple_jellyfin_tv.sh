#!/bin/bash
# Simple Jellyfin TV Mode for existing dual display setup
# Works with your current configuration: TV(left) + 4K Monitor(right)

echo "🎬 Launching Jellyfin TV Mode..."

# Kill any existing Firefox
pkill firefox 2>/dev/null
sleep 2

# Launch Firefox in kiosk mode on the TV display
DISPLAY=:0 firefox \
  --new-window \
  --kiosk \
  --no-first-run \
  --disable-session-crashed-bubble \
  --disable-infobars \
  --disable-notifications \
  --disable-translate \
  --disable-features=VizDisplayCompositor \
  "http://localhost:8096/web/#/home.html" &

echo ""
echo "✅ Jellyfin TV Mode launched!"
echo ""
echo "📺 **Vizio TV**: Should show Jellyfin fullscreen"
echo "🖥️  **4K Monitor**: Available for server maintenance"
echo "📱 **Phone Control**: http://192.168.0.182:8096"
echo ""
echo "🎯 **Usage:**"
echo "   - Switch Vizio TV to correct HDMI input"
echo "   - Use 4K monitor for any server work"
echo "   - Control playback from your phone/tablet"
echo ""
echo "🛑 **To exit**: Press Alt+F4 or run: pkill firefox" 