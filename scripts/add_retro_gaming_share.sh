#!/bin/bash

# Add RetroArch SMB share to Samba configuration
echo "🎮 Adding retro-gaming SMB share..."

# Add the retro-gaming share configuration
cat << 'EOF' | sudo tee -a /etc/samba/smb.conf

   [retro-gaming]
   path = /mnt/paperless-ssd/retro-gaming
   browseable = yes
   writable = yes
   guest ok = no
   valid users = gmk
   create mask = 0755
   directory mask = 0755
EOF

echo "✅ SMB configuration updated!"
echo "🔄 Restarting SMB services..."

# Restart SMB services
sudo systemctl restart smbd
sudo systemctl restart nmbd

echo "🎉 RetroArch SMB share is ready!"
echo "📁 Access via: smb://100.91.157.19/retro-gaming"
echo "🌐 Or local: smb://192.168.0.178/retro-gaming" 