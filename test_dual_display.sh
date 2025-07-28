#!/bin/bash
# Test Dual Display Setup - Check what displays are available

echo "🔍 **G9 Display Port Analysis**"
echo "================================"

echo ""
echo "📊 **Available Ports:**"
for port in HDMI-A-1 HDMI-A-2 DP-1; do
    if [[ -f "/sys/class/drm/card1-$port/status" ]]; then
        status=$(cat /sys/class/drm/card1-$port/status)
        if [[ "$status" == "connected" ]]; then
            echo "  ✅ $port: CONNECTED"
        else
            echo "  🔌 $port: Available (disconnected)"
        fi
    fi
done

echo ""
echo "🖥️ **Current XRandR Status:**"
xrandr --query | grep -E "(Screen|connected|disconnected)" | head -10

echo ""
echo "💡 **Recommended Setup:**"
echo "  📺 HDMI-A-2 → Vizio TV (Jellyfin viewing)"
echo "  🖥️ HDMI-A-1 → Local monitor (server maintenance)" 
echo "  🔌 DP-1 → Alternative for local monitor"

echo ""
echo "🎯 **Next Steps:**"
echo "  1. Connect a monitor to HDMI-A-1 (second HDMI port)"
echo "  2. Run: ./dual_display_jellyfin.sh"
echo "  3. Enjoy dual display setup!" 