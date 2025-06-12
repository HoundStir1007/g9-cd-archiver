#!/bin/bash
# Create Music Archive Structure
# Generated: 2025-06-08 15:21:43.444980

# Navigate to G9 Jellyfin directory
cd /mnt/paperless-ssd/jellyfin/

# Create archive directories
mkdir -p music_archive_common/found_on_youtube
mkdir -p music_archive_common/reports
mkdir -p music_rare_collection/very_rare
mkdir -p music_rare_collection/potentially_rare
mkdir -p music_rare_collection/reports

echo 'Archive structure created successfully!'
ls -la music_*
