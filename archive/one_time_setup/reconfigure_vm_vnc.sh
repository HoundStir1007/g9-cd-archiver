#!/bin/bash

# Reconfigure Windows VM for VNC (better macOS compatibility)
echo "🔄 Reconfiguring Windows VM for VNC..."

# Wait for VM to fully shutdown
echo "⏳ Waiting for VM to shutdown..."
sleep 3

# Export current VM configuration
virsh dumpxml windows11 > /tmp/windows11_config.xml

# Replace SPICE with VNC in the configuration
sed -i 's/graphics type="spice"/graphics type="vnc"/' /tmp/windows11_config.xml

# Remove SPICE-specific elements
sed -i '/<image compression="off"\/>/d' /tmp/windows11_config.xml
sed -i '/<channel spicevmc>/d' /tmp/windows11_config.xml

# Apply the updated configuration
virsh define /tmp/windows11_config.xml

echo "✅ VM reconfigured for VNC protocol"
echo "🔗 Connection: vnc://100.100.71.107:5900"
echo "📱 Compatible with: Any VNC client, Screen Sharing, Remote Desktop"

# Clean up
rm -f /tmp/windows11_config.xml

# Start the VM
echo "🚀 Starting VM with VNC..."
virsh start windows11

echo ""
echo "🎉 Ready! Connect with:"
echo "   • Built-in Screen Sharing: vnc://100.100.71.107:5900"
echo "   • VNC Viewer: 100.100.71.107:5900"
echo "   • Any VNC/Remote Desktop client" 