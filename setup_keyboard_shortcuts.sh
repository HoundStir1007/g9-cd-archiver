#!/bin/bash
# ⌨️ Keyboard Shortcuts Setup for G9 Media Center
# Sets up custom keyboard shortcuts for quick access

echo "⌨️ Setting up Keyboard Shortcuts for G9 Media Center..."

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to add keyboard shortcut
add_shortcut() {
    local name="$1"
    local command="$2"
    local binding="$3"
    
    # Add to dconf
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$name/binding" "'$binding'"
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$name/command" "'$command'"
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$name/name" "'$name'"
    
    echo "✅ Added shortcut: $name ($binding)"
}

# Get current custom keybindings
CURRENT_BINDINGS=$(dconf read "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings" 2>/dev/null || echo "[]")

# Add new shortcuts
echo "🎬 Setting up Media Center shortcuts..."

# Jellyfin TV Mode - Ctrl+Alt+J
add_shortcut "jellyfin-tv" "bash -c 'cd \"$SCRIPT_DIR\" && ./dual_display_jellyfin.sh'" "<Control><Alt>j"

# RetroArch Gaming - Ctrl+Alt+R
add_shortcut "retroarch-gaming" "bash -c 'cd \"$SCRIPT_DIR\" && ./launch_retroarch_tv.sh'" "<Control><Alt>r"

# Fix Display - Ctrl+Alt+D
add_shortcut "fix-display" "bash -c 'cd \"$SCRIPT_DIR\" && ./wayland_display_fix.sh'" "<Control><Alt>d"

# Quick Launcher - Ctrl+Alt+L
add_shortcut "quick-launcher" "bash -c 'cd \"$SCRIPT_DIR\" && ./quick_launcher.sh'" "<Control><Alt>l"

# Server Status - Ctrl+Alt+S
add_shortcut "server-status" "bash -c 'echo \"🎯 G9 Server Status:\"; echo \"Jellyfin: http://100.100.71.107:8096\"; echo \"Pi-hole: http://100.100.71.107:8080\"; echo \"Uptime Kuma: http://100.100.71.107:3001\"; echo \"Remote Desktop: 100.100.71.107:3389\"; read -p \"Press Enter to continue...\"'" "<Control><Alt>s"

echo ""
echo "⌨️ Keyboard shortcuts configured!"
echo ""
echo "🎯 Available shortcuts:"
echo "   Ctrl+Alt+J - Jellyfin TV Mode"
echo "   Ctrl+Alt+R - RetroArch Gaming"
echo "   Ctrl+Alt+D - Fix Display"
echo "   Ctrl+Alt+L - Quick Launcher"
echo "   Ctrl+Alt+S - Server Status"
echo ""
echo "💡 Pro tip: You can also customize these in Settings → Keyboard → Custom Shortcuts"
echo ""
echo "🎉 All shortcuts are now active!" 