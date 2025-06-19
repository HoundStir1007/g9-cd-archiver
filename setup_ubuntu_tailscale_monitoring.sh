#!/bin/bash
# Ubuntu Tailscale Monitoring Setup Script
# Replaces the Windows PowerShell monitoring system

set -e

echo "🐧 Setting up Ubuntu Tailscale Monitoring System..."
echo "This replaces the Windows PowerShell version for Ubuntu systems"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root" 
   echo "Run as regular user, sudo will be used when needed"
   exit 1
fi

# Verify tailscale is installed
if ! command -v tailscale &> /dev/null; then
    echo "❌ Tailscale is not installed or not in PATH"
    echo "Please install Tailscale first: https://tailscale.com/download/linux"
    exit 1
fi

# Create directory structure
echo "📁 Creating directory structure..."
sudo mkdir -p /opt/tailscale-monitoring
sudo mkdir -p /var/log/tailscale-monitoring/metrics

# Create tailscale-monitor user for security
echo "👤 Creating tailscale-monitor user..."
if ! id "tailscale-monitor" &>/dev/null; then
    sudo useradd --system --no-create-home --shell /bin/false tailscale-monitor
fi

# Copy files to deployment location
echo "📋 Copying monitoring script..."
sudo cp ubuntu_tailscale_monitoring.py /opt/tailscale-monitoring/
sudo chmod +x /opt/tailscale-monitoring/ubuntu_tailscale_monitoring.py

echo "📋 Installing systemd service files..."
sudo cp tailscale-monitoring.service /etc/systemd/system/
sudo cp tailscale-monitoring.timer /etc/systemd/system/

# Set up environment file template
echo "🔐 Setting up environment configuration..."
sudo tee /opt/tailscale-monitoring/.env.template > /dev/null << 'EOF'
# Tailscale Monitoring Environment Variables
# Copy this to .env and fill in actual values

# SMTP Configuration for Email Alerts
SMTP_PASSWORD=your_gmail_app_password_here
SMTP_USERNAME=msakamoto+homelab@gmail.com
SMTP_FROM=msakamoto+homelab@gmail.com
SMTP_TO=msakamoto+alerts@gmail.com
EOF

# Check if .env already exists
if [ ! -f /opt/tailscale-monitoring/.env ]; then
    echo "📝 Creating environment file from template..."
    sudo cp /opt/tailscale-monitoring/.env.template /opt/tailscale-monitoring/.env
    echo ""
    echo "⚠️  IMPORTANT: You need to edit /opt/tailscale-monitoring/.env"
    echo "   and set your Gmail app password for email alerts to work!"
    echo ""
fi

# Set proper ownership and permissions
echo "🔒 Setting ownership and permissions..."
sudo chown -R tailscale-monitor:tailscale-monitor /opt/tailscale-monitoring
sudo chown -R tailscale-monitor:tailscale-monitor /var/log/tailscale-monitoring
sudo chmod 600 /opt/tailscale-monitoring/.env*

# Allow tailscale-monitor user to run tailscale command
echo "🔧 Configuring tailscale permissions..."
sudo usermod -a -G tailscale tailscale-monitor

# Reload systemd and enable services
echo "⚙️  Enabling systemd services..."
sudo systemctl daemon-reload
sudo systemctl enable tailscale-monitoring.timer
sudo systemctl start tailscale-monitoring.timer

# Test the monitoring script
echo "🧪 Testing monitoring script..."
sudo -u tailscale-monitor /usr/bin/python3 /opt/tailscale-monitoring/ubuntu_tailscale_monitoring.py

# Check service status
echo ""
echo "📊 Service status:"
sudo systemctl status tailscale-monitoring.timer --no-pager -l

echo ""
echo "✅ Ubuntu Tailscale monitoring setup completed!"
echo ""
echo "📋 What's been configured:"
echo "   • Monitoring script: /opt/tailscale-monitoring/ubuntu_tailscale_monitoring.py"
echo "   • Systemd timer: runs every 5 minutes"
echo "   • Logs: /var/log/tailscale-monitoring/"
echo "   • Service user: tailscale-monitor (for security)"
echo ""
echo "🔧 Next steps:"
echo "   1. Edit /opt/tailscale-monitoring/.env with your Gmail app password"
echo "   2. Test email alerts: sudo systemctl start tailscale-monitoring.service"
echo "   3. Check logs: sudo journalctl -u tailscale-monitoring.service -f"
echo ""
echo "📈 Monitoring commands:"
echo "   • View timer status: sudo systemctl status tailscale-monitoring.timer"
echo "   • View recent logs: sudo journalctl -u tailscale-monitoring.service -n 20"
echo "   • Manual test: sudo -u tailscale-monitor python3 /opt/tailscale-monitoring/ubuntu_tailscale_monitoring.py"
echo ""
echo "🎉 You now have Ubuntu-based Tailscale monitoring with email alerts!" 