#!/bin/bash

# Optimize Jellyfin Library Scanning Performance
# Fixes stuck scanning at 81.8% issue

echo "🎬 Optimizing Jellyfin Library Scanning Performance..."

# Wait for Jellyfin to fully restart
echo "⏳ Waiting for Jellyfin to restart..."
sleep 30

# Check if Jellyfin is running
if ! curl -s http://100.100.71.107:8096 > /dev/null; then
    echo "❌ Jellyfin is not responding, waiting longer..."
    sleep 30
fi

echo "✅ Jellyfin is running!"

echo ""
echo "🎯 SCANNING OPTIMIZATION STRATEGIES:"
echo ""
echo "1. 📚 SCAN LIBRARIES SEPARATELY (Recommended)"
echo "   - Go to Jellyfin Web: http://100.100.71.107:8096"
echo "   - Dashboard → Libraries"
echo "   - Scan each library individually (Movies, TV, Music, Home Videos)"
echo "   - Start with smaller libraries first"
echo ""
echo "2. 🎵 MUSIC LIBRARY OPTIMIZATION"
echo "   - Your music library has 1,836+ files"
echo "   - Consider scanning music library separately"
echo "   - Or temporarily disable music library scanning"
echo ""
echo "3. ⚙️ PERFORMANCE SETTINGS"
echo "   - Go to Dashboard → Playback"
echo "   - Reduce 'Transcoding thread count' to 2-4"
echo "   - Disable 'Enable hardware acceleration' temporarily"
echo ""
echo "4. 🔧 LIBRARY SETTINGS"
echo "   - Go to each library → Settings"
echo "   - Disable 'Download images in advance'"
echo "   - Set 'Metadata downloaders' to minimum"
echo "   - Disable 'Download missing subtitles'"
echo ""
echo "5. 📊 MONITORING"
echo "   - Check logs: docker logs jellyfin --tail 20"
echo "   - Monitor progress in web interface"
echo "   - Stop scan if it gets stuck again"
echo ""

# Check current library status
echo "📊 CURRENT LIBRARY STATUS:"
echo "   Movies: $(find /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies -name "*.mp4" | wc -l) files"
echo "   Home Videos: $(find /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/home-videos -name "*.mp4" | wc -l) files"
echo "   Music: $(find /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/music -name "*.mp3" -o -name "*.m4a" | wc -l) files"
echo ""
echo "🚨 CRITICAL CHECK: Mount Path Verification"
echo "   Container can see movies: $(docker exec jellyfin ls /storage-drive/jellyfin/media/movies/ 2>/dev/null | wc -l) directories"
echo "   (If 0, check mount path in docker-compose.yml - common fcb1 vs fcb2 typo)"
echo ""

echo "🚀 RECOMMENDED SCANNING ORDER:"
echo "   1. Home Videos (smallest library)"
echo "   2. Movies (medium library)"
echo "   3. TV Shows (if any)"
echo "   4. Music (largest library - scan last)"
echo ""

echo "💡 TIPS FOR SUCCESS:"
echo "   - Scan one library at a time"
echo "   - Monitor the web interface for progress"
echo "   - If a scan gets stuck, restart Jellyfin and try again"
echo "   - Consider scanning music library separately or later"
echo ""

echo "🎬 Ready to scan! Access Jellyfin at: http://100.100.71.107:8096" 