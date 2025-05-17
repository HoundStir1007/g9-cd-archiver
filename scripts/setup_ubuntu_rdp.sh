#!/bin/bash

# Script to set up xRDP on Ubuntu
# Must be run as root or with sudo

# Update package lists
echo "Updating package lists..."
apt update

# Install xRDP and required packages
echo "Installing xRDP and required packages..."
apt install -y xrdp xorgxrdp

# Enable and start xRDP service
echo "Enabling and starting xRDP service..."
systemctl enable xrdp
systemctl start xrdp

# Configure firewall to allow RDP
echo "Configuring firewall..."
ufw allow 3389/tcp

# Create .xsession file for proper desktop environment
echo "Configuring desktop environment..."
echo "xfce4-session" > /home/$SUDO_USER/.xsession
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.xsession

# Add user to ssl-cert group for xRDP
echo "Adding user to ssl-cert group..."
usermod -a -G ssl-cert $SUDO_USER

# Restart xRDP service
echo "Restarting xRDP service..."
systemctl restart xrdp

echo "xRDP setup complete!"
echo "You can now connect using Microsoft Remote Desktop to: $(hostname -I | awk '{print $1}')"
echo "or using Tailscale IP: $(tailscale ip -4)"
echo ""
echo "Note: You may need to log out and log back in for all changes to take effect." 