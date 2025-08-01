#!/bin/bash
# Simple display fix - just set monitor as primary

echo "🖥️ Quick display fix..."

# Set HDMI-1 as primary
xrandr --output HDMI-1 --primary 2>/dev/null || true

# Position TV as secondary if connected
xrandr --output HDMI-2 --pos 1920x0 2>/dev/null || true

echo "✅ Monitor should now be primary"
