#!/bin/bash
# 🎬 AI Media Holding Tank Setup Script
# Installs dependencies and initializes the holding tank system

set -e

echo "🎬 Setting up AI Media Holding Tank..."

# Check if we're in the right directory
if [[ ! -f "media_holding_tank.py" ]]; then
    echo "❌ Please run this script from the directory containing media_holding_tank.py"
    exit 1
fi

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y python3-pip ffmpeg python3-magic

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip3 install --user python-magic

# Make scripts executable
echo "🔧 Setting up permissions..."
chmod +x media_holding_tank.py
chmod +x setup_holding_tank.sh

# Initialize holding tank directories
echo "🏗️ Initializing holding tank structure..."
python3 media_holding_tank.py setup

# Create integration with existing rippers
echo "🔗 Setting up ripper integrations..."

# Update DVD ripper to use holding tank
if [[ -f "g9_dvd_ripper.sh" ]]; then
    echo "  ✅ Found DVD ripper, creating integration..."
    cat >> g9_dvd_ripper.sh << 'EOF'

# 🎬 Auto-deploy to holding tank after rip
if [[ -n "$TITLE" && -f "$OUTPUT_FILE" ]]; then
    echo "📥 Moving ripped content to holding tank..."
    HOLDING_TANK="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media-holding-tank/incoming"
    cp "$OUTPUT_FILE" "$HOLDING_TANK/"
    echo "  ✅ Moved to holding tank: $HOLDING_TANK/$(basename "$OUTPUT_FILE")"
    echo "  🤖 Run 'python3 media_holding_tank.py process' to organize"
fi
EOF
fi

# Update CD ripper to use holding tank  
if [[ -f "g9_cd_ripper.sh" ]]; then
    echo "  ✅ Found CD ripper, creating integration..."
    cat >> g9_cd_ripper.sh << 'EOF'

# 🎵 Auto-deploy to holding tank after rip
if [[ -d "$OUTPUT_DIR" ]]; then
    echo "📥 Moving ripped music to holding tank..."
    HOLDING_TANK="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media-holding-tank/incoming"
    cp -r "$OUTPUT_DIR" "$HOLDING_TANK/"
    echo "  ✅ Moved to holding tank: $HOLDING_TANK/$(basename "$OUTPUT_DIR")"
    echo "  🤖 Run 'python3 media_holding_tank.py process' to organize"
fi
EOF
fi

echo "✅ Holding tank setup complete!"
echo ""
echo "🎯 WORKFLOW:"
echo "1. 📀 Rip media using existing tools (g9_dvd_ripper.sh, g9_cd_ripper.sh)"
echo "2. 📥 Content automatically goes to holding tank incoming/"
echo "3. 🤖 Run: python3 media_holding_tank.py process"
echo "4. 📊 Check: python3 media_holding_tank.py status"  
echo "5. 🚀 Deploy: python3 media_holding_tank.py deploy"
echo ""
echo "📍 Holding tank location: /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/media-holding-tank/"
echo "🎬 Ready to process your ripped media! 🚀" 