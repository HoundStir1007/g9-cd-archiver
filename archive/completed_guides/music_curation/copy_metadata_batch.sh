#!/bin/bash

# Batch metadata copy script for compressed videos
# Copies metadata from Jellyfin originals to compressed versions

echo "🎯 Starting batch metadata copy..."

# Copy metadata for each compressed video
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/1BF5BCBF-1762-41D7-A8C5-42AA2EFB5418.mov" -All:All "1BF5BCBF-1762-41D7-A8C5-42AA2EFB5418-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/4311FF55-5419-4CC9-B7CE-7BEA1F9BA448.mov" -All:All "4311FF55-5419-4CC9-B7CE-7BEA1F9BA448-compressed.mp4" 
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/48972E14-A00E-412A-B491-F36A7518C081.mov" -All:All "48972E14-A00E-412A-B491-F36A7518C081-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_0000 (11).mov" -All:All "IMG_0000 (11)-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_1058.MOV" -All:All "IMG_1058-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_4064.mov" -All:All "IMG_4064-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_5714.mov" -All:All "IMG_5714-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_6130.mov" -All:All "IMG_6130-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_6272.mov" -All:All "IMG_6272-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_6922.mov" -All:All "IMG_6922-compressed.mp4"
exiftool -TagsFromFile "/Volumes/jellyfin-media/home-videos/IMG_8145.MOV" -All:All "IMG_8145-compressed.mp4"

echo "✅ Batch metadata copy complete!"
echo "🎉 All compressed videos now have original metadata!" 