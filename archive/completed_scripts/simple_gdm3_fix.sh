#!/bin/bash
# Simple GDM3 Login Screen Fix
# This uses environment variables to force monitor as primary

echo "🔐 SIMPLE GDM3 LOGIN SCREEN FIX..."
echo "===================================="

# Create GDM3 environment configuration
create_gdm3_env() {
    echo "🔧 Creating GDM3 environment configuration..."
    
    # Create GDM3 environment file
    GDM3_ENV="/etc/gdm3/Init/Default"
    
    # Backup existing file
    if [[ -f "$GDM3_ENV" ]]; then
        sudo cp "$GDM3_ENV" "$GDM3_ENV.backup"
        echo "  ✅ Backed up existing GDM3 Init file"
    fi
    
    # Create GDM3 Init script with display configuration
    sudo tee "$GDM3_ENV" > /dev/null << 'EOF'
#!/bin/sh
# GDM3 Init script to force monitor as primary display

# Force HDMI-1 as primary display
xrandr --output HDMI-1 --primary 2>/dev/null || true

# Position TV as secondary if connected
xrandr --output HDMI-2 --pos 1920x0 2>/dev/null || true

# Exit with success
exit 0
EOF
    
    # Make it executable
    sudo chmod +x "$GDM3_ENV"
    echo "  ✅ Created GDM3 Init script: $GDM3_ENV"
}

# Create systemd override for GDM3
create_gdm3_override() {
    echo "🔧 Creating systemd override for GDM3..."
    
    # Create systemd override directory
    OVERRIDE_DIR="/etc/systemd/system/gdm.service.d"
    sudo mkdir -p "$OVERRIDE_DIR"
    
    # Create override file
    sudo tee "$OVERRIDE_DIR/display-fix.conf" > /dev/null << 'EOF'
[Service]
Environment=DISPLAY=:0
ExecStartPre=/bin/bash -c 'sleep 3 && xrandr --output HDMI-1 --primary 2>/dev/null || true'
EOF
    
    # Reload systemd
    sudo systemctl daemon-reload
    echo "  ✅ Created systemd override for GDM3"
}

# Main execution
create_gdm3_env
create_gdm3_override

echo ""
echo "✅ SIMPLE GDM3 FIX COMPLETE!"
echo ""
echo "🔐 **Login screen should now appear on monitor**"
echo "🖥️ **Desktop session will remain on monitor**"
echo ""
echo "🔄 **Restart to test**: sudo reboot"
echo "🗑️ **To remove**: sudo rm /etc/systemd/system/gdm.service.d/display-fix.conf"
echo ""
echo "🧪 **Test**: Restart G9 - login should appear on monitor!" 