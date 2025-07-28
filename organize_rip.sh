#!/bin/bash
# 🎬 Simple Rip Organization Helper
# Assists with manual organization of HandBrake exports
# NOT automation - just helps with the tedious parts!

STAGING_DIR="$HOME/handbrake-exports"
JELLYFIN_MOVIES="/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies"

echo "🎬 Rip Organization Helper"
echo "========================="

# Check for files in staging
echo "📁 Files in staging area:"
ls -la "$STAGING_DIR"/*.{mp4,mkv,avi} 2>/dev/null || echo "  (No video files found)"

echo ""
echo "💡 MANUAL WORKFLOW:"
echo "1. Use HandBrake GUI to export to: $STAGING_DIR"
echo "2. Ask Cursor AI: 'Help me organize [movie name] with proper year and directory'"
echo "3. Use our XML chapter workflow for chapter files"
echo "4. Manually move organized files to Jellyfin when ready"

echo ""
echo "🎯 Example commands you can ask Cursor AI to generate:"
echo "  mkdir '$JELLYFIN_MOVIES/Movie Name (YYYY)'"
echo "  mv '$STAGING_DIR/your_file.mkv' '$JELLYFIN_MOVIES/Movie Name (YYYY)/Movie Name (YYYY).mkv'"

echo ""
echo "📄 Chapter file workflow:"
echo "  1. Create XML: touch movie_name.xml"
echo "  2. Ask AI: '@movie_name.xml update with chapters from @URL'"
echo "  3. Use in HandBrake: Import chapter file" 