#!/bin/bash
# 🎯 Desktop Shortcuts Setup for G9 Media Center
# Creates desktop icons for Jellyfin, RetroArch, and important scripts

echo "🎯 Setting up Desktop Shortcuts for G9 Media Center..."

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_DIR="$HOME/Desktop"

# Create desktop directory if it doesn't exist
mkdir -p "$DESKTOP_DIR"

# Function to create desktop shortcut
create_shortcut() {
    local name="$1"
    local exec_cmd="$2"
    local icon="$3"
    local comment="$4"
    
    local desktop_file="$DESKTOP_DIR/$name.desktop"
    
    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Comment=$comment
Exec=$exec_cmd
Icon=$icon
Terminal=false
Categories=AudioVideo;Player;Media;
EOF
    
    chmod +x "$desktop_file"
    echo "✅ Created: $name.desktop"
}

# Function to create script shortcut
create_script_shortcut() {
    local name="$1"
    local script_path="$2"
    local icon="$3"
    local comment="$4"
    
    # Make script executable
    chmod +x "$script_path"
    
    local desktop_file="$DESKTOP_DIR/$name.desktop"
    
    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Comment=$comment
Exec=$script_path
Icon=$icon
Terminal=true
Categories=System;Utility;
EOF
    
    chmod +x "$desktop_file"
    echo "✅ Created: $name.desktop"
}

echo "🎬 Creating Media Center shortcuts..."

# Jellyfin Media Center
create_shortcut "Jellyfin TV Mode" \
    "bash -c 'cd \"$SCRIPT_DIR\" && ./dual_display_jellyfin.sh'" \
    "video" \
    "Launch Jellyfin on TV display with dual monitor setup"

# RetroArch Gaming
create_shortcut "RetroArch Gaming" \
    "bash -c 'cd \"$SCRIPT_DIR\" && ./launch_retroarch_tv.sh'" \
    "games-app" \
    "Launch RetroArch gaming on TV with gamepad support"

# TV Media Center (Unified)
create_shortcut "TV Media Center" \
    "bash -c 'cd \"$SCRIPT_DIR\" && ./tv_media_center.sh'" \
    "applications-multimedia" \
    "Unified media center with Jellyfin and RetroArch options"

echo ""
echo "🔧 Creating System Management shortcuts..."

# Display Fix Scripts
create_script_shortcut "Fix Display" \
    "$SCRIPT_DIR/wayland_display_fix.sh" \
    "video-display" \
    "Quick display configuration fix for Ubuntu 24.10"

create_script_shortcut "Simple Display Fix" \
    "$SCRIPT_DIR/simple_display_fix.sh" \
    "video-display" \
    "Simple display configuration fix"

create_script_shortcut "Test Display" \
    "$SCRIPT_DIR/test_dual_display.sh" \
    "video-display" \
    "Test dual display configuration"

# System Monitoring
create_script_shortcut "Server Status" \
    "bash -c 'echo \"🎯 G9 Server Status:\"; echo \"Jellyfin: http://100.100.71.107:8096\"; echo \"Pi-hole: http://100.100.71.107:8080\"; echo \"Uptime Kuma: http://100.100.71.107:3001\"; echo \"Remote Desktop: 100.100.71.107:3389\"; read -p \"Press Enter to continue...\"'" \
    "utilities-system-monitor" \
    "Show server service status and URLs"

# Handbrake Tools
create_script_shortcut "Handbrake GUI" \
    "$SCRIPT_DIR/launch_handbrake_gui.sh" \
    "applications-multimedia" \
    "Launch Handbrake GUI for video encoding"

# DVD/CD Tools
create_script_shortcut "DVD Ripper" \
    "$SCRIPT_DIR/g9_dvd_ripper.sh" \
    "applications-multimedia" \
    "Rip DVDs to digital format"

create_script_shortcut "CD Ripper" \
    "$SCRIPT_DIR/g9_cd_ripper.sh" \
    "applications-multimedia" \
    "Rip CDs to digital format"

echo ""
echo "📋 Creating Quick Access shortcuts..."

# Quick Access to Important URLs
create_shortcut "Jellyfin Web" \
    "google-chrome http://100.100.71.107:8096" \
    "video" \
    "Open Jellyfin web interface"

create_shortcut "Pi-hole Admin" \
    "google-chrome http://100.100.71.107:8080" \
    "network-server" \
    "Open Pi-hole admin interface"

create_shortcut "Uptime Kuma" \
    "google-chrome http://100.100.71.107:3001" \
    "utilities-system-monitor" \
    "Open Uptime Kuma monitoring"

# Quick Scripts
create_script_shortcut "Mount Drives" \
    "$SCRIPT_DIR/mount_drive.sh" \
    "drive-harddisk" \
    "Mount external drives"

create_script_shortcut "Baton Status" \
    "$SCRIPT_DIR/run_baton.sh" \
    "text-editor" \
    "Show current project status"

echo ""
echo "🎯 Desktop shortcuts created successfully!"
echo ""
echo "📁 Shortcuts created in: $DESKTOP_DIR"
echo ""
echo "🎬 Media Center Shortcuts:"
echo "   • Jellyfin TV Mode - Launch Jellyfin on TV"
echo "   • RetroArch Gaming - Launch RetroArch on TV"
echo "   • TV Media Center - Unified entertainment system"
echo ""
echo "🔧 System Management:"
echo "   • Fix Display - Quick display fix"
echo "   • Simple Display Fix - Basic display fix"
echo "   • Test Display - Check display configuration"
echo "   • Server Status - Show service URLs"
echo ""
echo "📋 Quick Access:"
echo "   • Jellyfin Web - Open web interface"
echo "   • Pi-hole Admin - Open admin interface"
echo "   • Uptime Kuma - Open monitoring"
echo "   • Mount Drives - Mount external drives"
echo "   • Baton Status - Show project status"
echo ""
echo "🎯 All shortcuts are now available on your desktop!"
echo "   Double-click any icon to launch the application or script." 