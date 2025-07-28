#!/bin/bash

# 🎧 Move Audiobooks and Comedy from Music Directory
# Moves Harry Potter to audiobooks and comedy to Comedy folder

echo "🎧 Moving Audiobooks and Comedy from Music Directory"
echo "==================================================="

# Define paths
MUSIC_DIR="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/music"
AUDIOBOOKS_DIR="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/audiobooks"
COMEDY_DIR="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/comedy"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Create directories
mkdir -p "$AUDIOBOOKS_DIR"
mkdir -p "$COMEDY_DIR"

echo -e "${BLUE}📁 Creating directories:${NC}"
echo -e "${CYAN}   Audiobooks: $AUDIOBOOKS_DIR${NC}"
echo -e "${CYAN}   Comedy: $COMEDY_DIR${NC}"
echo ""

# List of audiobooks to move
AUDIOBOOKS_TO_MOVE=(
    "J.K. Rowling/Harry Potter And The Deathly Hallows"
)

# List of comedy/stand-up to move
COMEDY_TO_MOVE=(
    "Patton Oswalt"
    "Eugene Mirman"
    "Mark & Brian"
    "Compilations/Comedy Death Ray"
)

echo -e "${YELLOW}📚 Moving Audiobooks:${NC}"
echo ""

moved_audiobooks=0
moved_comedy=0
skipped_count=0

# Move audiobooks
for item in "${AUDIOBOOKS_TO_MOVE[@]}"; do
    source_path="$MUSIC_DIR/$item"
    dest_path="$AUDIOBOOKS_DIR/$(basename "$item")"
    
    if [ -d "$source_path" ]; then
        file_count=$(find "$source_path" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
        
        if [ "$file_count" -gt 0 ]; then
            echo -e "${GREEN}📖 Moving: $item (${file_count} files)${NC}"
            echo -e "${CYAN}   From: $source_path${NC}"
            echo -e "${CYAN}   To:   $dest_path${NC}"
            
            # Check if destination already exists
            if [ -d "$dest_path" ]; then
                echo -e "${YELLOW}   ⚠️  Destination exists, skipping...${NC}"
                skipped_count=$((skipped_count + 1))
            else
                # Move the directory
                mv "$source_path" "$dest_path"
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}   ✅ Successfully moved${NC}"
                    moved_audiobooks=$((moved_audiobooks + 1))
                else
                    echo -e "${RED}   ❌ Failed to move${NC}"
                fi
            fi
        else
            echo -e "${YELLOW}⚠️  Skipping: $item (no audio files)${NC}"
            skipped_count=$((skipped_count + 1))
        fi
    else
        echo -e "${RED}❌ Source not found: $source_path${NC}"
        skipped_count=$((skipped_count + 1))
    fi
    echo ""
done

echo -e "${YELLOW}🎭 Moving Comedy/Stand-up:${NC}"
echo ""

# Move comedy
for item in "${COMEDY_TO_MOVE[@]}"; do
    source_path="$MUSIC_DIR/$item"
    dest_path="$COMEDY_DIR/$(basename "$item")"
    
    if [ -d "$source_path" ]; then
        file_count=$(find "$source_path" -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.flac" \) | wc -l)
        
        if [ "$file_count" -gt 0 ]; then
            echo -e "${GREEN}🎤 Moving: $item (${file_count} files)${NC}"
            echo -e "${CYAN}   From: $source_path${NC}"
            echo -e "${CYAN}   To:   $dest_path${NC}"
            
            # Check if destination already exists
            if [ -d "$dest_path" ]; then
                echo -e "${YELLOW}   ⚠️  Destination exists, skipping...${NC}"
                skipped_count=$((skipped_count + 1))
            else
                # Move the directory
                mv "$source_path" "$dest_path"
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}   ✅ Successfully moved${NC}"
                    moved_comedy=$((moved_comedy + 1))
                else
                    echo -e "${RED}   ❌ Failed to move${NC}"
                fi
            fi
        else
            echo -e "${YELLOW}⚠️  Skipping: $item (no audio files)${NC}"
            skipped_count=$((skipped_count + 1))
        fi
    else
        echo -e "${RED}❌ Source not found: $source_path${NC}"
        skipped_count=$((skipped_count + 1))
    fi
    echo ""
done

# Summary
echo "=================================================="
echo -e "${BLUE}📊 MOVE SUMMARY:${NC}"
echo -e "${GREEN}   📖 Audiobooks moved: $moved_audiobooks${NC}"
echo -e "${GREEN}   🎭 Comedy moved: $moved_comedy${NC}"
echo -e "${YELLOW}   ⚠️  Skipped: $skipped_count${NC}"
echo ""
echo -e "${BLUE}📁 New directories:${NC}"
echo -e "${CYAN}   Audiobooks: $AUDIOBOOKS_DIR${NC}"
echo -e "${CYAN}   Comedy: $COMEDY_DIR${NC}"
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "   1. Update Jellyfin library paths"
echo "   2. Add audiobooks and comedy libraries to Jellyfin"
echo "   3. Test playback in both libraries"
echo ""

# Show what was moved
echo -e "${BLUE}📚 Contents of audiobooks directory:${NC}"
ls -la "$AUDIOBOOKS_DIR" 2>/dev/null || echo "Directory is empty or doesn't exist"
echo ""
echo -e "${BLUE}🎭 Contents of comedy directory:${NC}"
ls -la "$COMEDY_DIR" 2>/dev/null || echo "Directory is empty or doesn't exist" 