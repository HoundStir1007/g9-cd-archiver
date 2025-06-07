#!/bin/bash

# Script to configure UFW firewall for Ubuntu server
# Must be run as root or with sudo

# Reset UFW to default settings
echo "Resetting UFW to default settings..."
ufw --force reset

# Set default policies
echo "Setting default policies..."
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (required for remote access)
echo "Configuring SSH access..."
ufw allow ssh

# Allow Tailscale
echo "Configuring Tailscale access..."
ufw allow in on tailscale0
ufw allow out on tailscale0

# Allow xRDP (if installed)
if systemctl is-active --quiet xrdp; then
    echo "Configuring xRDP access..."
    ufw allow 3389/tcp
fi

# Allow local network access
echo "Configuring local network access..."
ufw allow from 192.168.0.0/24
ufw allow from 192.168.137.0/24

# Enable logging
echo "Enabling UFW logging..."
ufw logging on

# Enable the firewall
echo "Enabling UFW..."
ufw --force enable

# Show final status
echo "Firewall configuration complete. Current status:"
ufw status verbose

echo ""
echo "Important: Make sure you can still access the system via SSH before closing this session!"
echo "If you lose access, you may need to connect directly to the machine to fix the firewall rules." 