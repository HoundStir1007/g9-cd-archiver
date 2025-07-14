#!/bin/bash
# 🌐 Browser Preference Setup
# Choose between Chrome and Firefox for web-based shortcuts

echo "🌐 Browser Preference Setup"
echo "=========================="
echo ""

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_DIR="$HOME/Desktop"

# Check available browsers
CHROME_AVAILABLE=$(which google-chrome 2>/dev/null)
FIREFOX_AVAILABLE=$(which firefox 2>/dev/null)

echo "🔍 Available browsers:"
if [ -n "$CHROME_AVAILABLE" ]; then
    echo "✅ Chrome: $CHROME_AVAILABLE"
fi
if [ -n "$FIREFOX_AVAILABLE" ]; then
    echo "✅ Firefox: $FIREFOX_AVAILABLE"
fi
echo ""

# Function to update shortcuts
update_shortcuts() {
    local browser="$1"
    local browser_cmd="$2"
    
    echo "🔄 Updating shortcuts to use $browser..."
    
    # Update desktop shortcuts
    local shortcuts=("Jellyfin Web" "Pi-hole Admin" "Uptime Kuma")
    local urls=("http://localhost:8096" "http://localhost:8080" "http://localhost:3001")
    
    for i in "${!shortcuts[@]}"; do
        local shortcut_name="${shortcuts[$i]}"
        local url="${urls[$i]}"
        local desktop_file="$DESKTOP_DIR/$shortcut_name.desktop"
        
        if [ -f "$desktop_file" ]; then
            sed -i "s|^Exec=.*|Exec=$browser_cmd $url|" "$desktop_file"
            echo "✅ Updated: $shortcut_name"
        fi
    done
    
    # Update dual display script
    if [ -f "$SCRIPT_DIR/dual_display_jellyfin.sh" ]; then
        if [ "$browser" = "Chrome" ]; then
            sed -i 's/firefox/google-chrome/g' "$SCRIPT_DIR/dual_display_jellyfin.sh"
            sed -i 's/Firefox/Chrome/g' "$SCRIPT_DIR/dual_display_jellyfin.sh"
        else
            sed -i 's/google-chrome/firefox/g' "$SCRIPT_DIR/dual_display_jellyfin.sh"
            sed -i 's/Chrome/Firefox/g' "$SCRIPT_DIR/dual_display_jellyfin.sh"
        fi
        echo "✅ Updated: dual_display_jellyfin.sh"
    fi
    
    # Update quick launcher
    if [ -f "$SCRIPT_DIR/quick_launcher.sh" ]; then
        if [ "$browser" = "Chrome" ]; then
            sed -i 's/firefox/google-chrome/g' "$SCRIPT_DIR/quick_launcher.sh"
        else
            sed -i 's/google-chrome/firefox/g' "$SCRIPT_DIR/quick_launcher.sh"
        fi
        echo "✅ Updated: quick_launcher.sh"
    fi
    
    echo ""
    echo "🎯 Browser preference set to: $browser"
    echo "All web-based shortcuts now use $browser"
}

# Show menu
echo "🎯 Choose your preferred browser:"
echo ""
if [ -n "$CHROME_AVAILABLE" ]; then
    echo "1) Chrome (Recommended - Better performance)"
fi
if [ -n "$FIREFOX_AVAILABLE" ]; then
    echo "2) Firefox (Alternative option)"
fi
echo "3) Show current browser usage"
echo "4) Exit"
echo ""

read -p "Enter your choice: " choice

case $choice in
    1)
        if [ -n "$CHROME_AVAILABLE" ]; then
            update_shortcuts "Chrome" "google-chrome"
        else
            echo "❌ Chrome not available"
        fi
        ;;
    2)
        if [ -n "$FIREFOX_AVAILABLE" ]; then
            update_shortcuts "Firefox" "firefox"
        else
            echo "❌ Firefox not available"
        fi
        ;;
    3)
        echo "📊 Current browser usage:"
        echo ""
        echo "Desktop shortcuts:"
        for shortcut in "Jellyfin Web" "Pi-hole Admin" "Uptime Kuma"; do
            if [ -f "$DESKTOP_DIR/$shortcut.desktop" ]; then
                browser=$(grep "^Exec=" "$DESKTOP_DIR/$shortcut.desktop" | cut -d' ' -f1 | sed 's/Exec=//')
                echo "  • $shortcut: $browser"
            fi
        done
        echo ""
        echo "Scripts:"
        if [ -f "$SCRIPT_DIR/dual_display_jellyfin.sh" ]; then
            if grep -q "google-chrome" "$SCRIPT_DIR/dual_display_jellyfin.sh"; then
                echo "  • dual_display_jellyfin.sh: Chrome"
            else
                echo "  • dual_display_jellyfin.sh: Firefox"
            fi
        fi
        if [ -f "$SCRIPT_DIR/quick_launcher.sh" ]; then
            if grep -q "google-chrome" "$SCRIPT_DIR/quick_launcher.sh"; then
                echo "  • quick_launcher.sh: Chrome"
            else
                echo "  • quick_launcher.sh: Firefox"
            fi
        fi
        ;;
    4)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "🎉 Browser preference updated successfully!" 