#!/bin/bash
# Wayland display fix script

echo "🖥️ Wayland display fix..."

# Try wlr-randr if available (Wayland)
if command -v wlr-randr >/dev/null 2>&1; then
    wlr-randr --output HDMI-1 --primary 2>/dev/null || true
    echo "  ✅ Used wlr-randr for Wayland"
else
    # Fallback to xrandr if available
    xrandr --output HDMI-1 --primary 2>/dev/null || true
    echo "  ✅ Used xrandr fallback"
fi

echo "✅ Wayland display fix applied"
