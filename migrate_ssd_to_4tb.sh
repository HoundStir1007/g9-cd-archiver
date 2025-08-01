#!/bin/bash

# 📦 SSD to 4.1TB Migration Script
# Moves digital consolidation content from paperless-ssd2 to main storage

echo "📦 SSD to 4.1TB Volume Migration Plan"
echo "===================================="

SSD_PATH="/media/mark/paperless-ssd2/digital_consolidation"
TARGET_4TB="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2"

echo "📊 Current usage analysis:"
echo "  SSD Source: $SSD_PATH"
echo "  4.1TB Target: $TARGET_4TB"
echo ""

# Check available space
echo "💾 Space Analysis:"
df -h "$SSD_PATH" | tail -1 | awk '{print "  SSD Free: " $4}'
df -h "$TARGET_4TB" | tail -1 | awk '{print "  4.1TB Free: " $4}'
echo ""

echo "📁 Migration Categories:"
echo ""

echo "1. 🎬 BULK MEDIA (701GB thunderbolt_transfer)"
echo "   → Target: $TARGET_4TB/archives/thunderbolt_transfer/"
echo "   → Content: Old Mac photos, videos, documents"
echo ""

echo "2. 💾 CANVIO TRANSFER (312GB canvio_transfer)" 
echo "   → Target: $TARGET_4TB/archives/canvio_transfer/"
echo "   → Content: External drive consolidation"
echo ""

echo "3. 💿 CD RIPS (18GB cd_rips)"
echo "   → Target: $TARGET_4TB/digital_consolidation/cd_rips/"
echo "   → Content: Extracted CD data, photos, videos"
echo ""

echo "⚠️  KEEPING ON SSD:"
echo "   • jellyfin/ (3GB cache - needs SSD speed)"
echo "   • paperless/ (661MB docs - fast access needed)"
echo "   • retro-gaming/ (76MB - fine on SSD)"
echo ""

echo "🎯 BENEFITS:"
echo "   • Free up ~1.1TB on SSD"
echo "   • Reduce SSD wear from large file storage"
echo "   • Better organization in archives"
echo "   • Keep fast files (docs, cache) on SSD"
echo ""

read -p "🚀 Proceed with migration? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Migration cancelled"
    exit 0
fi

echo ""
echo "🚀 Starting migration..."

# Create archive structure on 4.1TB
mkdir -p "$TARGET_4TB/archives"
mkdir -p "$TARGET_4TB/digital_consolidation"

# 1. Move thunderbolt_transfer (largest)
if [[ -d "$SSD_PATH/thunderbolt_transfer" ]]; then
    echo "📦 Moving thunderbolt_transfer (701GB)..."
    mv "$SSD_PATH/thunderbolt_transfer" "$TARGET_4TB/archives/"
    echo "   ✅ Moved to: $TARGET_4TB/archives/thunderbolt_transfer/"
fi

# 2. Move canvio_transfer  
if [[ -d "$SSD_PATH/canvio_transfer" ]]; then
    echo "📦 Moving canvio_transfer (312GB)..."
    mv "$SSD_PATH/canvio_transfer" "$TARGET_4TB/archives/"
    echo "   ✅ Moved to: $TARGET_4TB/archives/canvio_transfer/"
fi

# 3. Move cd_rips
if [[ -d "$SSD_PATH/cd_rips" ]]; then
    echo "📦 Moving cd_rips (18GB)..."
    mv "$SSD_PATH/cd_rips" "$TARGET_4TB/digital_consolidation/"
    echo "   ✅ Moved to: $TARGET_4TB/digital_consolidation/cd_rips/"
fi

echo ""
echo "✅ Migration complete!"
echo "📊 Final space check:"
df -h "$SSD_PATH" | tail -1 | awk '{print "  SSD Free: " $4}'
df -h "$TARGET_4TB" | tail -1 | awk '{print "  4.1TB Used: " $3 " / " $2}'

echo ""
echo "🎉 ~1.1TB freed on SSD!"
echo "📁 Archives now organized on 4.1TB volume" 