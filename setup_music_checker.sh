#!/bin/bash

# Music YouTube Checker - Setup Script
# =====================================

echo "🎵 Setting up Music YouTube Availability Checker..."
echo "=================================================="

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed. Please install Python 3 first."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not installed. Please install pip first."
    exit 1
fi

echo "✅ pip3 found"

# Create virtual environment if it doesn't exist
if [ ! -d "music_checker_env" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv music_checker_env
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source music_checker_env/bin/activate

# Install required packages
echo "📥 Installing required packages..."
pip install --upgrade pip

# Install packages one by one for better error handling
packages=(
    "mutagen"
    "youtube-search-python"
    "fuzzywuzzy"
    "python-levenshtein"
    "colorama"
)

for package in "${packages[@]}"; do
    echo "   Installing $package..."
    pip install "$package"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install $package"
        exit 1
    fi
done

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎯 USAGE INSTRUCTIONS:"
echo "======================"
echo ""
echo "1. Activate the virtual environment:"
echo "   source music_checker_env/bin/activate"
echo ""
echo "2. Run the music checker:"
echo "   python music_youtube_checker.py /path/to/your/music/folder"
echo ""
echo "3. Examples:"
echo "   # Scan your Music folder"
echo "   python music_youtube_checker.py ~/Music"
echo ""
echo "   # Scan with custom output directory"
echo "   python music_youtube_checker.py ~/Music --output my_analysis"
echo ""
echo "   # Scan without generating detailed reports (faster)"
echo "   python music_youtube_checker.py ~/Music --no-reports"
echo ""
echo "🔍 WHAT IT DOES:"
echo "================"
echo "• Scans all audio files (.mp3, .flac, .m4a, .aac, .ogg, .wav, .wma)"
echo "• Extracts artist and title from file metadata"
echo "• Searches YouTube for each track"
echo "• Uses fuzzy matching to determine if results are good matches"
echo "• Identifies tracks that might be rare or hard to find online"
echo "• Generates detailed CSV and summary reports"
echo ""
echo "📊 OUTPUT FILES:"
echo "================"
echo "• music_analysis_detailed_*.csv - Complete analysis for all tracks"
echo "• potentially_rare_tracks_*.csv - Just the rare/hard-to-find tracks"
echo "• music_analysis_full_*.json - Full technical details"
echo "• analysis_summary_*.txt - Human-readable summary"
echo ""
echo "💡 TIPS:"
echo "========"
echo "• The script can handle large collections (1000+ tracks)"
echo "• You can interrupt with Ctrl+C and it will save partial results"
echo "• Focus on the 'potentially_rare_tracks_*.csv' file for treasures!"
echo "• Use the detailed CSV to see match scores for all tracks"
echo ""
echo "🚀 Ready to discover your rare music gems!" 