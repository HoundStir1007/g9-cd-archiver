#!/bin/bash
# 🚀 Quick Launcher for G9 Media Center
# Can be run from anywhere to access important functions

echo "🚀 G9 Media Center Quick Launcher"
echo "================================"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to show menu
show_menu() {
    echo "🎯 Choose an option:"
    echo ""
    echo "🎬 MEDIA CENTER:"
    echo "  1) Jellyfin TV Mode"
    echo "  2) RetroArch Gaming"
    echo "  3) TV Media Center (Unified)"
    echo ""
    echo "🔧 SYSTEM MANAGEMENT:"
    echo "  4) Fix Display"
    echo "  5) Test Display"
    echo "  6) Server Status"
    echo ""
    echo "📋 QUICK ACCESS:"
    echo "  7) Jellyfin Web"
    echo "  8) Pi-hole Admin"
    echo "  9) Uptime Kuma"
    echo ""
    echo "🛠️ MEDIA TOOLS:"
    echo "  10) Handbrake GUI"
    echo "  11) DVD Ripper"
    echo "  12) CD Ripper"
    echo ""
    echo "❌ Exit"
    echo ""
}

# Function to execute choice
execute_choice() {
    case $1 in
        1)
            echo "🎬 Launching Jellyfin TV Mode..."
            cd "$SCRIPT_DIR" && ./dual_display_jellyfin.sh
            ;;
        2)
            echo "🎮 Launching RetroArch Gaming..."
            cd "$SCRIPT_DIR" && ./launch_retroarch_tv.sh
            ;;
        3)
            echo "🎬 Launching TV Media Center..."
            cd "$SCRIPT_DIR" && ./tv_media_center.sh
            ;;
        4)
            echo "🖥️ Running Display Fix..."
            cd "$SCRIPT_DIR" && ./wayland_display_fix.sh
            ;;
        5)
            echo "🖥️ Testing Display Configuration..."
            cd "$SCRIPT_DIR" && ./test_dual_display.sh
            ;;
        6)
            echo "📊 Server Status:"
            echo "  Jellyfin: http://100.100.71.107:8096"
            echo "  Pi-hole: http://100.100.71.107:8080"
            echo "  Uptime Kuma: http://100.100.71.107:3001"
            echo "  Remote Desktop: 100.100.71.107:3389"
            read -p "Press Enter to continue..."
            ;;
        7)
            echo "🌐 Opening Jellyfin Web..."
            google-chrome http://localhost:8096 &
            ;;
        8)
            echo "🌐 Opening Pi-hole Admin..."
            google-chrome http://localhost:8080 &
            ;;
        9)
            echo "📊 Opening Uptime Kuma..."
            google-chrome http://localhost:3001 &
            ;;
        10)
            echo "🎬 Launching Handbrake GUI..."
            cd "$SCRIPT_DIR" && ./launch_handbrake_gui.sh
            ;;
        11)
            echo "📀 Launching DVD Ripper..."
            cd "$SCRIPT_DIR" && ./g9_dvd_ripper.sh
            ;;
        12)
            echo "💿 Launching CD Ripper..."
            cd "$SCRIPT_DIR" && ./g9_cd_ripper.sh
            ;;
        *)
            echo "❌ Invalid option. Please try again."
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice (1-12, or 'q' to quit): " choice
    
    if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
        echo "👋 Goodbye!"
        exit 0
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le 12 ]; then
        execute_choice "$choice"
        echo ""
        read -p "Press Enter to continue..."
    else
        echo "❌ Invalid choice. Please enter a number 1-12 or 'q' to quit."
        echo ""
    fi
done 