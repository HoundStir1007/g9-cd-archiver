#!/bin/bash
# Install Jellyfin Media Bar
# This script adds the Media Bar to Jellyfin's web interface

echo "🎬 Installing Jellyfin Media Bar..."

# Check if Jellyfin is running
if ! docker ps | grep -q jellyfin; then
    echo "❌ Jellyfin is not running. Please start Jellyfin first."
    exit 1
fi

# Find Jellyfin web files location (Docker container)
JELLYFIN_WEB_PATH="/jellyfin/jellyfin-web"
echo "🎯 Found Jellyfin web files at: $JELLYFIN_WEB_PATH"

echo "📁 Found Jellyfin web path: $JELLYFIN_WEB_PATH"

# Check if index.html exists in Docker container
if ! docker exec jellyfin test -f "$JELLYFIN_WEB_PATH/index.html"; then
    echo "❌ index.html not found at $JELLYFIN_WEB_PATH in Docker container"
    exit 1
fi

# Create backup
echo "💾 Creating backup of index.html..."
docker exec jellyfin cp "$JELLYFIN_WEB_PATH/index.html" "$JELLYFIN_WEB_PATH/index.html.backup.$(date +%Y%m%d_%H%M%S)"

# Check if Media Bar is already installed
if docker exec jellyfin grep -q "Jellyfin-Media-Bar" "$JELLYFIN_WEB_PATH/index.html"; then
    echo "⚠️  Media Bar appears to already be installed."
    echo "Do you want to reinstall it? (y/n)"
    read -p "Reinstall? " REINSTALL
    if [ "$REINSTALL" != "y" ]; then
        echo "Installation cancelled."
        exit 0
    fi
fi

# Add Media Bar CSS and JS to index.html
echo "🔧 Adding Media Bar to index.html..."

# Create temporary file on host
TEMP_FILE=$(mktemp)

# Copy index.html from container to host
docker exec jellyfin cat "$JELLYFIN_WEB_PATH/index.html" > "$TEMP_FILE"

# Add the Media Bar CSS and JS before </head>
sed '/<\/head>/i\
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/MakD/Jellyfin-Media-Bar@latest/slideshowpure.css" />\
    <script async src="https://cdn.jsdelivr.net/gh/MakD/Jellyfin-Media-Bar@latest/slideshowpure.js"></script>\
' "$TEMP_FILE" > "${TEMP_FILE}.new"

# Copy modified file back to container
docker exec jellyfin bash -c "cat > $JELLYFIN_WEB_PATH/index.html" < "${TEMP_FILE}.new"

# Clean up temporary files
rm "$TEMP_FILE" "${TEMP_FILE}.new"

echo "✅ Media Bar installed successfully!"
echo ""
echo "🎯 Next Steps:"
echo "   1. Open Jellyfin in your browser: http://localhost:8096"
echo "   2. Hard refresh the page (Ctrl+Shift+R) twice"
echo "   3. You should see a beautiful media bar at the top!"
echo ""
echo "📝 Optional: Create a custom playlist by adding a list.txt file to your avatars folder"
echo "   Format: First line = playlist name, following lines = item IDs"
echo ""
echo "🔄 To uninstall: Restore from backup or remove the added lines from index.html" 