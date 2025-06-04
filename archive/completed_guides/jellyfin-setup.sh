#!/bin/bash

# ARCHIVED - 2025-06-02
# Status: ✅ COMPLETED - Jellyfin deployment successful
# Purpose: Historical reference for Jellyfin setup process

echo "🎬 Jellyfin Setup Script for G9 Ubuntu Server"
echo "=============================================="

# Step 1: Create directory structure on Samsung SSD
echo "📁 Creating Jellyfin directory structure on Samsung SSD..."
sudo mkdir -p /mnt/paperless-ssd/jellyfin
cd /mnt/paperless-ssd/jellyfin

echo "📂 Creating subdirectories..."
sudo mkdir -p {config,cache,media,media/movies,media/tv,media/home-videos,media/music}

echo "🔑 Setting proper ownership to gmk user..."
sudo chown -R gmk:gmk /mnt/paperless-ssd/jellyfin

echo "📋 Directory structure created:"
ls -la /mnt/paperless-ssd/jellyfin/

# Step 2: Copy docker-compose.yml file
echo "🐳 Copying docker-compose.yml..."
# You'll need to copy the docker-compose.yml file to this directory

# Step 3: Check Intel Quick Sync support
echo "🎥 Checking Intel Quick Sync hardware acceleration support..."
ls -la /dev/dri/

# Step 4: Create backup media directory (optional)
echo "💾 Creating backup media directory on USB drive..."
sudo mkdir -p /media/paperless-storage/jellyfin
sudo chown -R gmk:gmk /media/paperless-storage/jellyfin

echo "✅ Setup complete! Next steps:"
echo "1. Copy docker-compose.yml to /mnt/paperless-ssd/jellyfin/"
echo "2. Run: cd /mnt/paperless-ssd/jellyfin && docker compose up -d"
echo "3. Access Jellyfin at: http://100.91.157.19:8096"

# ARCHIVAL NOTE:
# This script was successfully used for Jellyfin deployment on 2025-06-02
# Jellyfin is now operational at http://100.91.157.19:8096 with SMB sharing
# System includes Intel Quick Sync acceleration and Samsung SSD storage 