#!/bin/bash

# ===========================================
# RetroArch Directory Setup Script
# -------------------------------------------
# Purpose: Sets up RetroArch directory structure on Ubuntu server
# Target: HP G9 MicroServer running Ubuntu
# Usage: sudo ./setup_retroarch_directories.sh [mount_path]
# Default mount: /mnt/paperless-ssd
# ===========================================

# Get mount path from argument or use default
MOUNT_PATH="${1:-/mnt/paperless-ssd}"
echo "🎮 Starting RetroArch directory setup on $MOUNT_PATH..."

# Check if running as root/sudo
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

# Check if mount point exists
if ! mountpoint -q "$MOUNT_PATH"; then
    echo "❌ Error: $MOUNT_PATH is not mounted"
    exit 1
fi

# Check available space
AVAILABLE_SPACE=$(df -h "$MOUNT_PATH" | awk 'NR==2 {print $4}')
echo "💾 Available space on $MOUNT_PATH: $AVAILABLE_SPACE"

# Create main RetroArch directory
echo "📁 Creating main RetroArch directory..."
mkdir -p "$MOUNT_PATH/retro-gaming"

# Create subdirectories
echo "📂 Creating subdirectories..."
mkdir -p "$MOUNT_PATH/retro-gaming"/{roms,saves,states,configs,cores,bios,screenshots,playlists,system,cheats,shaders}

# Create ROM system directories
echo "🎲 Creating ROM system directories..."
mkdir -p "$MOUNT_PATH/retro-gaming/roms"/{nes,snes,gba,gbc,n64,psx,genesis,arcade,atari2600,mastersystem,gameboy,nds,psp,dreamcast,saturn,segacd,neogeo,mame}

# Set ownership to gmk user
echo "👤 Setting ownership..."
if id "gmk" &>/dev/null; then
    chown -R gmk:gmk "$MOUNT_PATH/retro-gaming"
else
    echo "⚠️  Warning: User 'gmk' not found. Please set ownership manually."
fi

# Set proper permissions
echo "🔒 Setting permissions..."
chmod -R 755 "$MOUNT_PATH/retro-gaming"

# Create symbolic link in home directory for easy access (if gmk user exists)
if id "gmk" &>/dev/null; then
    GMK_HOME=$(eval echo ~gmk)
    ln -sf "$MOUNT_PATH/retro-gaming" "$GMK_HOME/RetroGaming"
    chown -h gmk:gmk "$GMK_HOME/RetroGaming"
    echo "🔗 Created symbolic link: ~/RetroGaming"
fi

echo "✅ Directory structure created!"
echo ""
echo "📁 Main structure:"
ls -la "$MOUNT_PATH/retro-gaming"
echo ""
echo "🎮 ROM systems:"
ls -la "$MOUNT_PATH/retro-gaming/roms"
echo ""
echo "🎉 RetroArch directory setup complete!"
echo "📝 Next steps:"
echo "  1. Place your BIOS files in: $MOUNT_PATH/retro-gaming/bios"
echo "  2. Place your ROMs in the corresponding system folders"
echo "  3. Configure RetroArch to use these directories" 