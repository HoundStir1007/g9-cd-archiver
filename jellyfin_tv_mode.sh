#!/bin/bash
# Jellyfin TV Mode - Fullscreen Kiosk for Vizio TV via HDMI
# Run this script to start Jellyfin in TV-friendly fullscreen mode

echo "🎬 Starting Jellyfin TV Mode..."

# Wait for display to be ready
sleep 2

# Kill any existing Firefox instances
pkill firefox 2>/dev/null

# Wait a moment
sleep 1

# Launch Firefox in fullscreen kiosk mode pointing to local Jellyfin
DISPLAY=:0 firefox \
  --kiosk \
  --no-first-run \
  --disable-session-crashed-bubble \
  --disable-infobars \
  --disable-notifications \
  --disable-translate \
  --disable-features=VizDisplayCompositor \
  "http://localhost:8096/web/#/home.html" &

echo "✅ Jellyfin TV Mode started!"
echo "📱 Use your phone to control: http://192.168.0.182:8096"
echo "🛑 To exit: Press Alt+F4 or Ctrl+Alt+T to open terminal"

# Optional: Hide cursor after 5 seconds of inactivity
sleep 5
DISPLAY=:0 unclutter -idle 5 -root &>/dev/null &

echo "🎯 Ready! Switch your Vizio TV to the HDMI input connected to G9" 