#!/bin/bash
# 🎬🎮 TV Media Center - Unified Entertainment System
# Combines Jellyfin media streaming with RetroArch gaming
# Optimized for TV display with gamepad control

echo "🎬🎮 TV Media Center - Ultimate Entertainment System"
echo "================================================="

# Kill any existing media applications
echo "🔄 Cleaning up existing processes..."
pkill firefox 2>/dev/null
pkill retroarch 2>/dev/null
sleep 2

# Apply universal TV settings (audio routing, gamepad, display)
apply_tv_settings() {
    echo "🔧 Applying TV settings..."
    
    # Set HDMI audio routing to TV (HDMI 1)
    echo "🔊 Setting HDMI audio to TV..."
    pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo-extra1 2>/dev/null
    sleep 1
    
    # Set default audio sink to TV
    pactl set-default-sink alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1 2>/dev/null
    sleep 1
    
    # Set TV audio volume to 70%
    pactl set-sink-volume alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1 70% 2>/dev/null
    
    # Gamepad sensitivity settings
    echo "🎮 Setting gamepad sensitivity..."
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 150 2>/dev/null
    gsettings set org.gnome.desktop.peripherals.keyboard delay 500 2>/dev/null
    
    # Display configuration
    echo "📺 Display Configuration:"
    xrandr --listmonitors
}

# Launch Jellyfin TV Mode
launch_jellyfin() {
    echo "🎬 Launching Jellyfin TV Mode..."
    
    # Check if Jellyfin is running
    if ! curl -s http://localhost:8096 > /dev/null; then
        echo "❌ Jellyfin not accessible at localhost:8096"
        echo "   Starting Jellyfin container..."
        docker-compose up -d jellyfin 2>/dev/null
        sleep 5
    fi
    
    # Launch Firefox with Jellyfin
    firefox \
        --new-window \
        --class="JellyfinTV" \
        "http://localhost:8096/web/#/home.html" &
    
    FIREFOX_PID=$!
    echo "🔄 Firefox PID: $FIREFOX_PID"
    sleep 3
    
    echo ""
    echo "✅ Jellyfin TV Mode Launched!"
    echo "📺 Next Steps:"
    echo "   1. Drag Firefox to your Vizio TV and make fullscreen"
    echo "   2. Go to Settings > Display > Enable TV Mode"
    echo "   3. Use gamepad for navigation"
    echo "   4. Audio should come from TV speakers"
    echo ""
    echo "📱 Backup Control: http://192.168.0.182:8096"
}

# Launch RetroArch Gaming Mode
launch_retroarch() {
    echo "🎮 Launching RetroArch Gaming Mode..."
    
    # Check if retro-gaming directory exists
    if [ ! -d "/mnt/paperless-ssd/retro-gaming" ]; then
        echo "⚠️  RetroArch directory not found. Creating structure..."
        sudo mkdir -p /mnt/paperless-ssd/retro-gaming/{roms,saves,states,bios,configs,screenshots,playlists}
        sudo mkdir -p /mnt/paperless-ssd/retro-gaming/roms/{nes,snes,gba,gbc,n64,psx,genesis,arcade}
        sudo chown -R $USER:$USER /mnt/paperless-ssd/retro-gaming
        echo "✅ RetroArch directories created"
    fi
    
    # Launch RetroArch with TV-optimized settings
    retroarch \
        --fullscreen \
        --verbose \
        --config /home/$USER/.config/retroarch/retroarch.cfg &
    
    RETROARCH_PID=$!
    echo "🔄 RetroArch PID: $RETROARCH_PID"
    sleep 3
    
    echo ""
    echo "✅ RetroArch Gaming Mode Launched!"
    echo "🎮 Controls:"
    echo "   - Navigate with gamepad or arrow keys"
    echo "   - Load Content to browse ROM files"
    echo "   - Download cores for different consoles"
    echo "   - F1 to toggle menu"
    echo "   - Escape to exit"
    echo ""
    echo "📁 ROM Directory: /mnt/paperless-ssd/retro-gaming/roms"
    echo "💾 Save Directory: /mnt/paperless-ssd/retro-gaming/saves"
}

# Configure RetroArch for TV display
configure_retroarch() {
    echo "🔧 Configuring RetroArch for TV display..."
    
    # Create RetroArch config directory
    mkdir -p /home/$USER/.config/retroarch
    
    # Create TV-optimized RetroArch configuration
    cat > /home/$USER/.config/retroarch/retroarch.cfg << 'EOF'
# TV Media Center RetroArch Configuration
# Optimized for TV display with gamepad control

# Video Settings
video_fullscreen = "true"
video_windowed_fullscreen = "false"
video_driver = "gl"
video_vsync = "true"
video_threaded = "true"
video_smooth = "true"
video_aspect_ratio_auto = "true"
video_scale_integer = "false"
video_crop_overscan = "true"

# Audio Settings
audio_driver = "pulse"
audio_device = "alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1"
audio_enable = "true"
audio_sync = "true"
audio_rate_control = "true"
audio_volume = "0.0"
audio_mute = "false"

# Input Settings
input_driver = "udev"
input_autodetect_enable = "true"
input_joypad_driver = "udev"
input_menu_toggle_gamepad_combo = "2"
input_exit_emulator = "escape"
input_pause_toggle = "p"
input_reset = "r"
input_save_state = "f2"
input_load_state = "f4"
input_state_slot_increase = "f7"
input_state_slot_decrease = "f6"

# Menu Settings
menu_driver = "ozone"
menu_linear_filter = "true"
menu_horizontal_animation = "true"
menu_show_core_updater = "true"
menu_show_load_core = "true"
menu_show_load_content = "true"
menu_show_information = "true"
menu_show_configurations = "true"
menu_show_help = "true"
menu_show_quit_retroarch = "true"
menu_show_restart_retroarch = "true"

# Directory Settings
system_directory = "/mnt/paperless-ssd/retro-gaming/bios"
savefile_directory = "/mnt/paperless-ssd/retro-gaming/saves"
savestate_directory = "/mnt/paperless-ssd/retro-gaming/states"
screenshot_directory = "/mnt/paperless-ssd/retro-gaming/screenshots"
playlist_directory = "/mnt/paperless-ssd/retro-gaming/playlists"
rgui_browser_directory = "/mnt/paperless-ssd/retro-gaming/roms"
content_directory = "/mnt/paperless-ssd/retro-gaming/roms"

# Performance Settings
pause_nonactive = "false"
fastforward_ratio = "0.0"
slowmotion_ratio = "3.0"
run_ahead_enabled = "false"
run_ahead_frames = "1"
run_ahead_hide_warnings = "false"

# Network Settings
network_cmd_enable = "false"
stdin_cmd_enable = "false"
EOF
    
    echo "✅ RetroArch configured for TV display"
}

# Main menu
main_menu() {
    echo ""
    echo "🎯 Choose your entertainment:"
    echo "   1) 🎬 Jellyfin Media Center"
    echo "   2) 🎮 RetroArch Gaming"
    echo "   3) ⚙️  Configure RetroArch"
    echo "   4) 🛑 Exit"
    echo ""
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            apply_tv_settings
            launch_jellyfin
            ;;
        2)
            apply_tv_settings
            launch_retroarch
            ;;
        3)
            configure_retroarch
            echo "✅ RetroArch configuration updated!"
            echo "   You can now launch RetroArch gaming mode."
            ;;
        4)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please try again."
            main_menu
            ;;
    esac
}

# Show current display information
echo ""
echo "📺 Current Display Setup:"
xrandr --listmonitors | head -5
echo ""

# Run main menu
main_menu 