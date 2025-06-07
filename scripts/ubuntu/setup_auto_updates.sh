#!/bin/bash

# Script to configure automatic security updates
# Must be run as root or with sudo

# Install unattended-upgrades
echo "Installing unattended-upgrades..."
apt update
apt install -y unattended-upgrades apt-listchanges

# Configure automatic updates
echo "Configuring automatic updates..."
cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOL'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}";
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};

// Automatically remove unused packages
Unattended-Upgrade::Remove-Unused-Dependencies "true";

// Automatically reboot if needed
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";

// Send email notifications
Unattended-Upgrade::Mail "gmk@example.com";
Unattended-Upgrade::MailReport "on-change";

// Only install security updates
Unattended-Upgrade::Package-Blacklist {
};

// Enable automatic updates
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Verbose "1";
EOL

# Enable the service
echo "Enabling automatic updates..."
systemctl enable unattended-upgrades
systemctl start unattended-upgrades

# Test the configuration
echo "Testing automatic updates configuration..."
unattended-upgrades --dry-run --debug

echo ""
echo "Automatic updates have been configured with the following settings:"
echo "- Security updates will be installed automatically"
echo "- System will reboot at 2 AM if needed"
echo "- Unused packages will be removed automatically"
echo "- Email notifications will be sent to gmk@example.com"
echo ""
echo "To check the status of automatic updates:"
echo "sudo unattended-upgrades --dry-run --debug"
echo ""
echo "To view the update log:"
echo "cat /var/log/unattended-upgrades/unattended-upgrades.log"
echo ""
echo "Note: Please update the email address in /etc/apt/apt.conf.d/50unattended-upgrades"
echo "to your preferred email address for notifications." 