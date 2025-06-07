#!/bin/bash

# Script to install and configure fail2ban
# Must be run as root or with sudo

# Install fail2ban
echo "Installing fail2ban..."
apt update
apt install -y fail2ban

# Create a local configuration file
echo "Creating fail2ban configuration..."
cat > /etc/fail2ban/jail.local << 'EOL'
[DEFAULT]
# Ban hosts for 1 hour
bantime = 3600
# Retry window of 10 minutes
findtime = 600
# Allow 5 retries
maxretry = 5
# Ban on all interfaces
banaction = ufw
# Enable logging
logtarget = /var/log/fail2ban.log

# SSH protection
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
findtime = 600
bantime = 3600

# xRDP protection
[xrdp]
enabled = true
port = 3389
filter = xrdp
logpath = /var/log/xrdp.log
maxretry = 5
findtime = 600
bantime = 3600

# xRDP-sesman protection
[xrdp-sesman]
enabled = true
port = 3350
filter = xrdp-sesman
logpath = /var/log/xrdp-sesman.log
maxretry = 5
findtime = 600
bantime = 3600
EOL

# Create xrdp filter
echo "Creating xrdp filter..."
cat > /etc/fail2ban/filter.d/xrdp.conf << 'EOL'
[Definition]
failregex = ^.*xrdp.*Connection refused: .* from <HOST>.*$
            ^.*xrdp.*Connection closed: .* from <HOST>.*$
            ^.*xrdp.*Failed to authenticate: .* from <HOST>.*$
ignoreregex =
EOL

# Create xrdp-sesman filter
echo "Creating xrdp-sesman filter..."
cat > /etc/fail2ban/filter.d/xrdp-sesman.conf << 'EOL'
[Definition]
failregex = ^.*xrdp-sesman.*Connection refused: .* from <HOST>.*$
            ^.*xrdp-sesman.*Connection closed: .* from <HOST>.*$
            ^.*xrdp-sesman.*Failed to authenticate: .* from <HOST>.*$
ignoreregex =
EOL

# Restart fail2ban
echo "Restarting fail2ban service..."
systemctl restart fail2ban

# Enable fail2ban to start on boot
echo "Enabling fail2ban to start on boot..."
systemctl enable fail2ban

# Show status
echo "Fail2ban configuration complete. Current status:"
fail2ban-client status

echo ""
echo "Fail2ban has been configured with the following settings:"
echo "- 5 failed attempts within 10 minutes will result in a 1-hour ban"
echo "- Protection enabled for: SSH, xRDP, and xRDP-sesman"
echo "- Logs are stored in /var/log/fail2ban.log"
echo ""
echo "You can check the status of fail2ban at any time with:"
echo "sudo fail2ban-client status"
echo ""
echo "To unban an IP address if needed:"
echo "sudo fail2ban-client set JAIL unbanip IP_ADDRESS" 