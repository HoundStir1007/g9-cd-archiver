# 🔧 Monitoring System Setup Guide for macOS

This guide explains how to set up the monitoring system as a LaunchAgent on macOS.

## 📋 Prerequisites

1. Python 3.6+ installed
2. Required Python packages:
   ```bash
   pip3 install requests psutil
   ```

## 📁 File Setup

1. Create the monitoring directory:
   ```bash
   mkdir -p ~/Library/Application\ Support/Monitoring/secrets
   mkdir -p ~/Library/Logs/Monitoring
   ```

2. Copy the monitoring script:
   ```bash
   cp monitoring_script.py ~/Library/Application\ Support/Monitoring/monitor.py
   chmod +x ~/Library/Application\ Support/Monitoring/monitor.py
   ```

3. Create the password file for email notifications:
   ```bash
   echo "your-email-password" > ~/Library/Application\ Support/Monitoring/secrets/smtp_password.txt
   chmod 600 ~/Library/Application\ Support/Monitoring/secrets/smtp_password.txt
   ```

## ⚙️ LaunchAgent Setup

1. Create the LaunchAgent plist file:
   ```bash
   mkdir -p ~/Library/LaunchAgents
   nano ~/Library/LaunchAgents/com.monitoring.server.plist
   ```

2. Add the following content:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.monitoring.server</string>
       <key>ProgramArguments</key>
       <array>
           <string>/usr/bin/python3</string>
           <string>~/Library/Application Support/Monitoring/monitor.py</string>
       </array>
       <key>StartInterval</key>
       <integer>60</integer>
       <key>RunAtLoad</key>
       <true/>
       <key>StandardErrorPath</key>
       <string>~/Library/Logs/Monitoring/error.log</string>
       <key>StandardOutPath</key>
       <string>~/Library/Logs/Monitoring/output.log</string>
       <key>KeepAlive</key>
       <true/>
   </dict>
   </plist>
   ```

## 🚀 Enable and Start the Service

1. Load the LaunchAgent:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.monitoring.server.plist
   ```

2. Start the service:
   ```bash
   launchctl start com.monitoring.server
   ```

3. Verify the service is running:
   ```bash
   launchctl list | grep monitoring
   ```

4. Check the logs:
   ```bash
   tail -f ~/Library/Logs/Monitoring/output.log
   ```

## 🔍 Troubleshooting

If you encounter issues:

1. Check the service status:
   ```bash
   launchctl list | grep monitoring
   ```

2. View the logs:
   ```bash
   tail -f ~/Library/Logs/Monitoring/error.log
   ```

3. Common issues:
   - **Permission denied**: Check file permissions on script and log directory
   - **Import error**: Ensure all required Python packages are installed
   - **Email errors**: Verify SMTP settings and password file
   - **Uptime Kuma errors**: Confirm Uptime Kuma is running and push URLs are correct

## 📱 Setting Up Push Notifications (Optional)

[Same content as in systemd guide...]

## 🔄 Updating the Configuration

If you need to update the configuration:

1. Edit the monitoring script:
   ```bash
   nano ~/Library/Application\ Support/Monitoring/monitor.py
   ```

2. Restart the service:
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.monitoring.server.plist
   launchctl load ~/Library/LaunchAgents/com.monitoring.server.plist
   ```

3. Check the logs to confirm changes:
   ```bash
   tail -f ~/Library/Logs/Monitoring/output.log
   ``` 