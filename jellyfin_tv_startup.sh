#!/bin/bash
# Jellyfin TV Mode Startup Script
# Restores all TV mode settings on boot

echo "🎬 Restoring Jellyfin TV Mode Settings..."

# Wait for audio system to be ready
sleep 5

# Set HDMI audio routing to TV (HDMI 1)
echo "🔊 Setting HDMI audio to TV..."
pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo-extra1
sleep 2

# Set default audio sink to TV
pactl set-default-sink alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1
sleep 1

# Set TV audio volume to 70%
pactl set-sink-volume alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1 70%

# Gamepad sensitivity settings (these should persist but let's be sure)
echo "🎮 Setting gamepad sensitivity..."
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 150
gsettings set org.gnome.desktop.peripherals.keyboard delay 500

echo "✅ Jellyfin TV Mode settings restored!"
echo "🎯 Audio: TV speakers via HDMI 1"
echo "🎮 Gamepad: Optimized sensitivity"
echo "📺 Ready for: ./jellyfin_tv_mode_final.sh" 