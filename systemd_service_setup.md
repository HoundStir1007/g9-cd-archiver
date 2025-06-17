# 🔧 Monitoring System Setup Guide

This guide explains how to set up the monitoring system as a systemd service on Ubuntu.

## 📋 Prerequisites

1. Python 3.6+ installed
2. Required Python packages:
   ```bash
   sudo apt update
   sudo apt install python3-pip
   pip3 install requests psutil
   ```

## 📁 File Setup

1. Create the monitoring directory:
   ```bash
   sudo mkdir -p /opt/monitoring/secrets
   ```

2. Copy the monitoring script:
   ```bash
   sudo cp ubuntu_monitoring_script.py /opt/monitoring/monitor.py
   sudo chmod +x /opt/monitoring/monitor.py
   ```

3. Create the password file for email notifications:
   ```bash
   echo "your-email-password" | sudo tee /opt/monitoring/secrets/smtp_password.txt
   sudo chmod 600 /opt/monitoring/secrets/smtp_password.txt
   ```

4. Create log directory:
   ```bash
   sudo mkdir -p /var/log/monitoring
   ```

## ⚙️ SystemD Service Setup

1. Create the systemd service file:
   ```bash
   sudo nano /etc/systemd/system/server-monitoring.service
   ```

2. Add the following content:
   ```ini
   [Unit]
   Description=Server Monitoring Service
   After=network.target

   [Service]
   Type=simple
   User=root
   ExecStart=/usr/bin/python3 /opt/monitoring/monitor.py
   Restart=always
   RestartSec=5

   [Install]
   WantedBy=multi-user.target
   ```

3. Create the systemd timer file:
   ```bash
   sudo nano /etc/systemd/system/server-monitoring.timer
   ```

4. Add the following content:
   ```ini
   [Unit]
   Description=Run Server Monitoring Every Minute

   [Timer]
   OnBootSec=1min
   OnUnitActiveSec=1min
   AccuracySec=1s

   [Install]
   WantedBy=timers.target
   ```

5. Set up log rotation:
   ```bash
   sudo nano /etc/logrotate.d/server-monitoring
   ```

6. Add the following content:
   ```
   /var/log/monitoring/*.log {
       daily
       rotate 7
       compress
       delaycompress
       missingok
       notifempty
       create 0640 root root
   }
   ```

## 🚀 Enable and Start the Service

1. Reload systemd to recognize the new service:
   ```bash
   sudo systemctl daemon-reload
   ```

2. Enable the timer to start at boot:
   ```bash
   sudo systemctl enable server-monitoring.timer
   ```

3. Start the timer:
   ```bash
   sudo systemctl start server-monitoring.timer
   ```

4. Verify the timer is running:
   ```bash
   sudo systemctl status server-monitoring.timer
   ```

5. Run the service once manually to test:
   ```bash
   sudo systemctl start server-monitoring.service
   ```

6. Check the logs:
   ```bash
   sudo tail -f /var/log/monitoring/server_monitor.log
   ```

## 🔍 Troubleshooting

If you encounter issues:

1. Check the service status:
   ```bash
   sudo systemctl status server-monitoring.service
   ```

2. View the logs:
   ```bash
   sudo journalctl -u server-monitoring.service
   ```

3. Common issues:
   - **Permission denied**: Check file permissions on script and log directory
   - **Import error**: Ensure all required Python packages are installed
   - **Email errors**: Verify SMTP settings and password file
   - **Uptime Kuma errors**: Confirm Uptime Kuma is running and push URLs are correct

## 📱 Setting Up Push Notifications (Optional)

### Pushover Setup

1. Create a Pushover account at https://pushover.net/
2. Create an application to get an API token
3. Update the configuration in the monitoring script:
   ```python
   "pushover": {
       "enabled": True,
       "api_token": "YOUR_API_TOKEN",
       "user_key": "YOUR_USER_KEY",
       "priority": 1
   }
   ```

### Discord Setup

1. Create a webhook in your Discord server
2. Update the configuration in the monitoring script:
   ```python
   "discord": {
       "enabled": True,
       "webhook_url": "YOUR_WEBHOOK_URL"
   }
   ```

## 🔄 Updating the Configuration

If you need to update the configuration:

1. Edit the monitoring script:
   ```bash
   sudo nano /opt/monitoring/monitor.py
   ```

2. Restart the service:
   ```bash
   sudo systemctl restart server-monitoring.service
   ```

3. Check the logs to confirm changes:
   ```bash
   sudo tail -f /var/log/monitoring/server_monitor.log
   ``` 