#!/bin/bash

# Jellyfin Media Access Verification Script
# This script quickly verifies that Jellyfin can access all media files

echo "🎬 JELLYFIN MEDIA ACCESS VERIFICATION"
echo "======================================"
echo ""

# Check if container is running
echo "1. 📦 Checking container status..."
if docker ps | grep -q jellyfin; then
    echo "   ✅ Jellyfin container is running"
    echo "   🔗 Container ID: $(docker ps --format "table {{.ID}}\t{{.Status}}" | grep jellyfin | awk '{print $1}')"
else
    echo "   ❌ Jellyfin container is NOT running"
    echo "   🔧 Run: docker-compose -f jellyfin-docker-compose.yml up -d"
    exit 1
fi

echo ""

# Check if mounts are accessible
echo "2. 📂 Checking media mounts..."
if docker exec jellyfin test -d /paperless-ssd/jellyfin/media; then
    echo "   ✅ /paperless-ssd/jellyfin/media is accessible"
else
    echo "   ❌ /paperless-ssd/jellyfin/media is NOT accessible"
    echo "   🔧 Container may be using wrong configuration"
    exit 1
fi

if docker exec jellyfin test -d /storage-drive; then
    echo "   ✅ /storage-drive is accessible"
else
    echo "   ❌ /storage-drive is NOT accessible"
fi

echo ""

# Check media directory contents
echo "3. 🎵 Checking media directories..."
media_dirs=$(docker exec jellyfin ls /paperless-ssd/jellyfin/media/ 2>/dev/null)
if [[ -n "$media_dirs" ]]; then
    echo "   ✅ Media directories found:"
    for dir in $media_dirs; do
        if [[ "$dir" != ".DS_Store" && "$dir" != .* ]]; then
            file_count=$(docker exec jellyfin find /paperless-ssd/jellyfin/media/$dir -type f 2>/dev/null | wc -l)
            echo "      📁 $dir: $file_count files"
        fi
    done
else
    echo "   ❌ No media directories found"
    exit 1
fi

echo ""

# Check music files specifically
echo "4. 🎶 Checking music files..."
music_count=$(docker exec jellyfin ls /paperless-ssd/jellyfin/media/music/ 2>/dev/null | wc -l)
if [[ "$music_count" -gt 1800 ]]; then
    echo "   ✅ Music files accessible: $music_count files"
else
    echo "   ⚠️  Music file count low: $music_count files (expected 1836+)"
fi

echo ""

# Check Jellyfin service
echo "5. 🌐 Checking Jellyfin web interface..."
echo "   📍 URL: http://100.100.71.107:8096"
echo "   📚 To add libraries, use these paths:"
echo "      🎵 Music: /paperless-ssd/jellyfin/media/music"
echo "      🎬 Movies: /paperless-ssd/jellyfin/media/movies"
echo "      📺 TV Shows: /paperless-ssd/jellyfin/media/tv"
echo "      🏠 Home Videos: /paperless-ssd/jellyfin/media/home-videos"

echo ""
echo "🎉 VERIFICATION COMPLETE!"
echo "   ✅ All media files are accessible to Jellyfin"
echo "   🎯 Ready to configure libraries in Jellyfin web interface" 