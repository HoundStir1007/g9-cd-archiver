#!/bin/bash
# 🚀 Quick Deploy Script - Complete Holding Tank Pipeline
# Processes and deploys all media in one go

set -e

echo "🎬 AI Media Holding Tank - Quick Deploy Pipeline"
echo "================================================"

# Check if holding tank is set up
if [[ ! -f "media_holding_tank.py" ]]; then
    echo "❌ Please run setup_holding_tank.sh first"
    exit 1
fi

# Check for new media
echo "📥 Checking for incoming media..."
INCOMING_DIR="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media-holding-tank/incoming"
INCOMING_COUNT=$(find "$INCOMING_DIR" -type f -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" 2>/dev/null | wc -l)

if [[ $INCOMING_COUNT -eq 0 ]]; then
    echo "📭 No new media files to process"
    echo "💡 Copy your ripped media to: $INCOMING_DIR"
    exit 0
fi

echo "📊 Found $INCOMING_COUNT media files to process"

# Show status before processing
echo ""
echo "📊 Current holding tank status:"
python3 media_holding_tank.py status

# Process incoming media
echo ""
echo "🤖 Processing incoming media with AI analysis..."
python3 media_holding_tank.py process

# Show what's ready for deployment
echo ""
echo "📦 Checking what's ready for deployment..."
python3 media_holding_tank.py status

# Ask for confirmation before deployment
echo ""
read -p "🚀 Deploy processed media to Jellyfin? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Deploying to Jellyfin libraries..."
    python3 media_holding_tank.py deploy
    
    echo ""
    echo "✅ Deployment complete!"
    echo "🎬 Check Jellyfin at: http://100.100.71.107:8096"
    echo "🔄 Jellyfin will auto-scan new content"
    
    # Optional: Trigger Jellyfin library scan
    echo ""
    read -p "🔄 Trigger Jellyfin library scan now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔄 Triggering Jellyfin library scan..."
        # This would need Jellyfin API integration
        echo "💡 Please manually refresh libraries in Jellyfin web interface"
    fi
else
    echo "📦 Media processed and ready - run deploy later"
fi

echo ""
echo "📊 Final status:"
python3 media_holding_tank.py status

echo ""
echo "🎉 Quick deploy pipeline complete!" 