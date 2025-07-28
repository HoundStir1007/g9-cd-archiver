#!/bin/bash
# 🎯 Update Shortcuts to Use Chrome
# Updates existing desktop shortcuts to use Chrome instead of Firefox

echo "🎯 Updating shortcuts to use Chrome..."

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_DIR="$HOME/Desktop"

# Function to update desktop shortcut
update_shortcut() {
    local shortcut_name="$1"
    local new_command="$2"
    local desktop_file="$DESKTOP_DIR/$shortcut_name.desktop"
    
    if [ -f "$desktop_file" ]; then
        # Update the Exec line
        sed -i "s|^Exec=.*|Exec=$new_command|" "$desktop_file"
        echo "✅ Updated: $shortcut_name"
    else
        echo "⚠️  Not found: $shortcut_name"
    fi
}

echo "🌐 Updating web-based shortcuts to use Chrome..."

# Update web-based shortcuts to use Chrome
update_shortcut "Jellyfin Web" "google-chrome http://localhost:8096"
update_shortcut "Pi-hole Admin" "google-chrome http://localhost:8080"
update_shortcut "Uptime Kuma" "google-chrome http://localhost:3001"

echo ""
echo "🎬 Updating media center shortcuts..."

# Update the dual display Jellyfin script to use Chrome
if [ -f "$SCRIPT_DIR/dual_display_jellyfin.sh" ]; then
    # Create a backup
    cp "$SCRIPT_DIR/dual_display_jellyfin.sh" "$SCRIPT_DIR/dual_display_jellyfin.sh.backup"
    
    # Update Firefox references to Chrome
    sed -i 's/firefox/google-chrome/g' "$SCRIPT_DIR/dual_display_jellyfin.sh"
    sed -i 's/Firefox/Chrome/g' "$SCRIPT_DIR/dual_display_jellyfin.sh"
    
    echo "✅ Updated dual_display_jellyfin.sh to use Chrome"
fi

echo ""
echo "⌨️ Updating keyboard shortcuts..."

# Update keyboard shortcuts to use Chrome
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jellyfin-web/command" "'google-chrome http://localhost:8096'" 2>/dev/null || true
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pi-hole-admin/command" "'google-chrome http://localhost:8080'" 2>/dev/null || true
dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/uptime-kuma/command" "'google-chrome http://localhost:3001'" 2>/dev/null || true

echo ""
echo "🎯 Creating Chrome-specific shortcuts..."

# Create new Chrome-specific shortcuts
cat > "$DESKTOP_DIR/Jellyfin Chrome.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Jellyfin Chrome
Comment=Open Jellyfin in Chrome browser
Exec=google-chrome http://localhost:8096
Icon=video
Terminal=false
Categories=AudioVideo;Player;Media;
EOF

cat > "$DESKTOP_DIR/Pi-hole Chrome.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Pi-hole Chrome
Comment=Open Pi-hole admin in Chrome browser
Exec=google-chrome http://localhost:8080
Icon=network-server
Terminal=false
Categories=Network;
EOF

cat > "$DESKTOP_DIR/Uptime Kuma Chrome.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Uptime Kuma Chrome
Comment=Open Uptime Kuma in Chrome browser
Exec=google-chrome http://localhost:3001
Icon=utilities-system-monitor
Terminal=false
Categories=System;Utility;
EOF

chmod +x "$DESKTOP_DIR/Jellyfin Chrome.desktop"
chmod +x "$DESKTOP_DIR/Pi-hole Chrome.desktop"
chmod +x "$DESKTOP_DIR/Uptime Kuma Chrome.desktop"

echo "✅ Created Chrome-specific shortcuts"

echo ""
echo "🎯 Shortcuts updated successfully!"
echo ""
echo "🌐 Web shortcuts now use Chrome:"
echo "   • Jellyfin Web → Chrome"
echo "   • Pi-hole Admin → Chrome"
echo "   • Uptime Kuma → Chrome"
echo ""
echo "🎬 Media center scripts updated:"
echo "   • dual_display_jellyfin.sh → Chrome"
echo ""
echo "📋 New Chrome-specific shortcuts:"
echo "   • Jellyfin Chrome - Direct Chrome access"
echo "   • Pi-hole Chrome - Direct Chrome access"
echo "   • Uptime Kuma Chrome - Direct Chrome access"
echo ""
echo "💡 Benefits of using Chrome:"
echo "   • Better performance for web apps"
echo "   • Improved compatibility with modern web features"
echo "   • Better hardware acceleration"
echo "   • More consistent rendering" 