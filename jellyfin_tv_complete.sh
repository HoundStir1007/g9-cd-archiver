#!/bin/bash
# Complete Jellyfin TV Mode Script
# Ensures all settings are correct and launches Firefox

echo "🎬 Complete Jellyfin TV Mode - Ensuring Settings & Launching..."

# Kill any existing Firefox
pkill firefox 2>/dev/null
sleep 2

# Ensure all settings are correct (same as startup script)
echo "🔧 Verifying TV mode settings..."

# Set HDMI audio routing to TV (HDMI 1)
echo "🔊 Setting HDMI audio to TV..."
pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo-extra1 2>/dev/null
sleep 1

# Set default audio sink to TV
pactl set-default-sink alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1 2>/dev/null
sleep 1

# Set TV audio volume to 70%
pactl set-sink-volume alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1 70% 2>/dev/null

# Gamepad sensitivity settings
echo "🎮 Setting gamepad sensitivity..."
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 150 2>/dev/null
gsettings set org.gnome.desktop.peripherals.keyboard delay 500 2>/dev/null

# Display configuration
echo "📺 Display Configuration:"
xrandr --listmonitors

# Ensure Jellyfin is running
echo "🔍 Checking Jellyfin service..."
if ! curl -s http://localhost:8096 > /dev/null; then
    echo "❌ Jellyfin not accessible at localhost:8096"
    echo "   Starting Jellyfin container..."
    docker-compose up -d jellyfin 2>/dev/null
    sleep 5
fi

# Launch Firefox
echo "🎯 Launching Firefox with Jellyfin..."
firefox \
    --new-window \
    --class="JellyfinTV" \
    "http://localhost:8096/web/#/home.html" &

FIREFOX_PID=$!
echo "🔄 Firefox PID: $FIREFOX_PID"

# Wait for Firefox to start
sleep 3

echo ""
echo "✅ Complete Jellyfin TV Mode Setup!"
echo ""
echo "📺 **Next Steps:**"
echo "   1. Drag Firefox to your Vizio TV and make fullscreen"
echo "   2. Go to Settings > Display > Enable TV Mode"
echo "   3. Use gamepad for navigation"
echo "   4. Audio should come from TV speakers"
echo ""
echo "🎮 **Gamepad**: D-pad navigation + action button"
echo "🔊 **Audio**: TV speakers via HDMI 1"
echo "📱 **Backup Control**: http://192.168.0.182:8096"
echo ""
echo "🛑 **To exit**: Alt+F4 or run: pkill firefox" 