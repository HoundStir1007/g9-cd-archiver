#!/bin/bash

# 🎧 Quick Audiobook Finder
# Fast script to identify obvious audiobooks in music directory

echo "🎧 Quick Audiobook Detection"
echo "============================"

MUSIC_DIR="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/music"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}🔍 Scanning for obvious audiobook indicators...${NC}"
echo ""

# 1. Find directories with "chapter" in name
echo -e "${YELLOW}📚 Directories with 'chapter' in name:${NC}"
find "$MUSIC_DIR" -type d -iname "*chapter*" | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  📖 $dir (${file_count} files)${NC}"
done
echo ""

# 2. Find directories with "part" in name
echo -e "${YELLOW}📚 Directories with 'part' in name:${NC}"
find "$MUSIC_DIR" -type d -iname "*part*" | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  📖 $dir (${file_count} files)${NC}"
done
echo ""

# 3. Find directories with "book" in name
echo -e "${YELLOW}📚 Directories with 'book' in name:${NC}"
find "$MUSIC_DIR" -type d -iname "*book*" | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  📖 $dir (${file_count} files)${NC}"
done
echo ""

# 4. Find directories with "audiobook" in name
echo -e "${YELLOW}📚 Directories with 'audiobook' in name:${NC}"
find "$MUSIC_DIR" -type d -iname "*audiobook*" | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  📖 $dir (${file_count} files)${NC}"
done
echo ""

# 5. Find directories with "narrated" or "narrator" in name
echo -e "${YELLOW}📚 Directories with 'narrated' or 'narrator' in name:${NC}"
find "$MUSIC_DIR" -type d \( -iname "*narrated*" -o -iname "*narrator*" \) | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  📖 $dir (${file_count} files)${NC}"
done
echo ""

# 6. Find directories with "disc" or "cd" in name
echo -e "${YELLOW}📚 Directories with 'disc' or 'cd' in name:${NC}"
find "$MUSIC_DIR" -type d \( -iname "*disc*" -o -iname "*cd*" \) | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  📖 $dir (${file_count} files)${NC}"
done
echo ""

# 7. Find directories with many files (potential audiobooks)
echo -e "${YELLOW}📚 Directories with 10+ audio files (potential audiobooks):${NC}"
find "$MUSIC_DIR" -type d | while read dir; do
    file_count=$(find "$dir" -maxdepth 1 -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    if [ "$file_count" -ge 10 ]; then
        dir_name=$(basename "$dir")
        echo -e "${CYAN}  📁 $dir_name (${file_count} files)${NC}"
    fi
done
echo ""

# 8. Find comedy/stand-up albums
echo -e "${YELLOW}🎭 Comedy/Stand-up indicators:${NC}"
find "$MUSIC_DIR" -type d \( -iname "*comedy*" -o -iname "*stand*" -o -iname "*comic*" -o -iname "*comedian*" \) | while read dir; do
    file_count=$(find "$dir" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
    echo -e "${GREEN}  🎤 $dir (${file_count} files)${NC}"
done
echo ""

# 9. Find files with "chapter" in filename
echo -e "${YELLOW}📚 Files with 'chapter' in filename:${NC}"
find "$MUSIC_DIR" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) -iname "*chapter*" | head -20 | while read file; do
    dir=$(dirname "$file")
    echo -e "${GREEN}  📄 $file${NC}"
    echo -e "${CYAN}     Directory: $dir${NC}"
done
echo ""

echo -e "${BLUE}✅ Quick scan complete!${NC}"
echo -e "${YELLOW}💡 Review the above results for potential audiobooks to move.${NC}" 