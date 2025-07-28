#!/bin/bash
# Simple Jellyfin Media Bar Installation
# Uses browser-based injection instead of modifying container files

echo "🎬 Installing Jellyfin Media Bar (Browser Method)..."

# Check if Jellyfin is running
if ! docker ps | grep -q jellyfin; then
    echo "❌ Jellyfin is not running. Please start Jellyfin first."
    exit 1
fi

echo "✅ Jellyfin is running!"
echo ""
echo "🎯 Manual Installation Instructions:"
echo "=================================="
echo ""
echo "1. Open Jellyfin in your browser:"
echo "   http://localhost:8096"
echo ""
echo "2. Open Developer Tools (F12 or Ctrl+Shift+I)"
echo ""
echo "3. Go to the Console tab and paste this code:"
echo ""
echo "// Install Media Bar"
echo "const link = document.createElement('link');"
echo "link.rel = 'stylesheet';"
echo "link.href = 'https://cdn.jsdelivr.net/gh/MakD/Jellyfin-Media-Bar@latest/slideshowpure.css';"
echo "document.head.appendChild(link);"
echo ""
echo "const script = document.createElement('script');"
echo "script.src = 'https://cdn.jsdelivr.net/gh/MakD/Jellyfin-Media-Bar@latest/slideshowpure.js';"
echo "document.head.appendChild(script);"
echo ""
echo "4. Press Enter to execute the code"
echo ""
echo "5. Refresh the page (F5) to see the Media Bar!"
echo ""
echo "🎉 The Media Bar will now appear at the top of Jellyfin!"
echo ""
echo "💡 Pro Tip: You can bookmark this page and run the code each time"
echo "   you want to use the Media Bar, or set up a browser extension."
echo ""
echo "📝 For permanent installation, consider using a reverse proxy"
echo "   with custom CSS injection or a browser extension." 