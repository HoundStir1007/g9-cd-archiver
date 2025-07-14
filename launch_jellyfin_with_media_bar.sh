#!/bin/bash
# Launch Jellyfin with Media Bar Installation Guide

echo "🎬 Launching Jellyfin with Media Bar Guide..."
echo ""

# Check if Jellyfin is running
if ! docker ps | grep -q jellyfin; then
    echo "❌ Jellyfin is not running. Starting Jellyfin..."
    cd pihole && docker-compose up -d jellyfin
    sleep 5
fi

echo "✅ Jellyfin is running!"
echo ""
echo "🌐 Opening Jellyfin in browser..."
echo "   URL: http://localhost:8096"
echo ""
echo "🎯 To install Media Bar:"
echo "   1. Open Developer Tools (F12)"
echo "   2. Go to Console tab"
echo "   3. Paste this code and press Enter:"
echo ""
echo "const link = document.createElement('link');"
echo "link.rel = 'stylesheet';"
echo "link.href = 'https://cdn.jsdelivr.net/gh/MakD/Jellyfin-Media-Bar@latest/slideshowpure.css';"
echo "document.head.appendChild(link);"
echo ""
echo "const script = document.createElement('script');"
echo "script.src = 'https://cdn.jsdelivr.net/gh/MakD/Jellyfin-Media-Bar@latest/slideshowpure.js';"
echo "document.head.appendChild(script);"
echo ""
echo "4. Refresh page (F5) to see Media Bar!"
echo ""
echo "🎮 For TV mode with gamepad: ./launch_jellyfin_tv.sh"
echo "🎬 For full media center: ./tv_media_center.sh"

# Try to open browser
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open http://localhost:8096 &
elif command -v open >/dev/null 2>&1; then
    open http://localhost:8096 &
fi 