# 🚨 Server Monitoring System Plan

## 📋 Problem Statement
The current monitoring system failed to notify about server downtime due to:
- Migration from Windows to Ubuntu without proper monitoring setup
- Archived/deprecated monitoring scripts
- Email notification system configuration issues
- Lack of redundant notification methods
- No specific handling for power outage scenarios

## 🎯 Goals
- Create a robust, multi-layered monitoring system on Ubuntu
- Implement redundant notification methods
- Ensure proper detection of various failure scenarios
- Provide detailed logging for troubleshooting
- Make the system self-healing where possible

## 📝 Implementation Checklist

### 1. 🔍 Assessment & Preparation
- [ ] Review current server architecture and services
  - [ ] Document all critical services requiring monitoring
  - [ ] Identify their health check endpoints
  - [ ] Determine acceptable downtime thresholds
- [ ] Inventory existing monitoring components
  - [ ] Check Uptime Kuma configuration
  - [ ] Review existing scripts in `/Users/marksakamoto/Desktop/home server research/scripts/`
  - [ ] Document current logging locations
- [ ] Determine notification preferences
  - [ ] Email (primary or secondary?)
  - [ ] SMS/text messaging options
  - [ ] Push notifications to mobile devices
  - [ ] Integration with messaging platforms (Discord, Slack, etc.)

### 2. 🛠️ Core Monitoring Setup
- [ ] Install & configure monitoring tools on Ubuntu
  - [ ] Update Uptime Kuma to latest version
  - [ ] Configure proper persistence for Uptime Kuma database
  - [ ] Set up Prometheus for metrics collection (optional)
  - [ ] Install Node Exporter for system metrics (optional)
- [ ] Create base monitoring script framework
  - [ ] Implement proper Ubuntu paths (`/var/log/monitoring/`)
  - [ ] Set up log rotation with logrotate
  - [ ] Create error handling framework
  - [ ] Implement retry logic with exponential backoff

### 3. 📡 Service-Specific Monitoring
- [ ] Configure Jellyfin monitoring
  - [ ] Health check endpoint: `http://192.168.0.182:8096/health`
  - [ ] Tailscale endpoint: `http://100.91.157.19:8096/health`
  - [ ] Set appropriate timeout and retry parameters
  - [ ] Implement content validation for responses
- [ ] Configure Paperless-ngx monitoring
  - [ ] Health check endpoint: `http://100.91.157.19:8000/api/health/`
  - [ ] Set appropriate timeout and retry parameters
  - [ ] Implement content validation for responses
- [ ] Configure Plex monitoring
  - [ ] Health check endpoint: `http://100.91.157.19:32400/identity`
  - [ ] Set appropriate timeout and retry parameters
- [ ] Configure system-level monitoring
  - [ ] CPU usage thresholds
  - [ ] Memory usage thresholds
  - [ ] Disk space thresholds
  - [ ] Network connectivity tests

### 4. ⚡ Power Outage & Network Failure Detection
- [ ] Implement external connectivity checks
  - [ ] Regular ping tests to reliable external services
  - [ ] Traceroute logging for network path issues
  - [ ] DNS resolution verification
- [ ] Create power outage detection logic
  - [ ] Monitor UPS status if available
  - [ ] Implement "last gasp" notification before shutdown
  - [ ] Create recovery detection and notification
- [ ] Set up cross-device verification
  - [ ] Configure secondary device to monitor primary server
  - [ ] Implement mutual monitoring between devices

### 5. 📱 Multi-Channel Notification System
- [ ] Configure email notifications
  - [ ] Set up proper SMTP authentication for Gmail
  - [ ] Store credentials securely using environment variables
  - [ ] Implement email delivery verification
- [ ] Set up push notifications
  - [ ] Configure Pushover or similar service
  - [ ] Set up different urgency levels for different alerts
  - [ ] Implement delivery confirmation
- [ ] Configure SMS notifications for critical alerts
  - [ ] Research SMS gateway options
  - [ ] Implement rate limiting to prevent spam
- [ ] Set up messaging platform integration
  - [ ] Discord webhook for notifications
  - [ ] Slack webhook (optional)

### 6. 🔄 Automation & Scheduling
- [ ] Create systemd service for monitoring
  ```bash
  # /etc/systemd/system/server-monitoring.service
  [Unit]
  Description=Server Monitoring Service
  After=network.target

  [Service]
  Type=simple
  User=gmk
  ExecStart=/usr/bin/python3 /opt/monitoring/monitor.py
  Restart=always
  RestartSec=5

  [Install]
  WantedBy=multi-user.target
  ```
- [ ] Create systemd timer for regular checks
  ```bash
  # /etc/systemd/system/server-monitoring.timer
  [Unit]
  Description=Run Server Monitoring Every Minute

  [Timer]
  OnBootSec=1min
  OnUnitActiveSec=1min
  AccuracySec=1s

  [Install]
  WantedBy=timers.target
  ```
- [ ] Set up log rotation
  ```bash
  # /etc/logrotate.d/server-monitoring
  /var/log/monitoring/*.log {
      daily
      rotate 7
      compress
      delaycompress
      missingok
      notifempty
      create 0640 gmk gmk
  }
  ```
- [ ] Configure automatic recovery actions
  - [ ] Service restart attempts
  - [ ] System reboot for critical failures
  - [ ] Documentation of automatic actions in logs

### 7. 📊 Logging & Reporting
- [ ] Implement structured logging
  - [ ] JSON format for machine parsing
  - [ ] Consistent log levels (INFO, WARN, ERROR, CRITICAL)
  - [ ] Contextual information in each log entry
- [ ] Create status dashboard
  - [ ] Current status of all services
  - [ ] Historical uptime statistics
  - [ ] Recent incidents with resolution status
- [ ] Set up regular status reports
  - [ ] Daily summary email
  - [ ] Weekly uptime report
  - [ ] Monthly trend analysis

### 8. 🧪 Testing & Validation
- [ ] Create test scenarios
  - [ ] Service shutdown test
  - [ ] Network disconnection test
  - [ ] Power failure simulation
  - [ ] External service dependency failure
- [ ] Validate notification delivery
  - [ ] Confirm emails are received
  - [ ] Verify push notifications arrive
  - [ ] Test SMS delivery if configured
- [ ] Perform recovery testing
  - [ ] Verify monitoring resumes after service restart
  - [ ] Confirm system reboot recovery
  - [ ] Test automatic recovery actions

### 9. 📝 Documentation
- [ ] Create system architecture diagram
  - [ ] Monitoring components
  - [ ] Notification flow
  - [ ] Recovery processes
- [ ] Document configuration details
  - [ ] File locations
  - [ ] Credentials storage
  - [ ] Service dependencies
- [ ] Create troubleshooting guide
  - [ ] Common failure scenarios
  - [ ] Log interpretation guide
  - [ ] Manual recovery steps

### 10. 🚀 Deployment & Maintenance
- [ ] Deploy monitoring system
  - [ ] Install all components
  - [ ] Configure services and timers
  - [ ] Verify initial operation
- [ ] Establish maintenance schedule
  - [ ] Weekly log review
  - [ ] Monthly configuration verification
  - [ ] Quarterly full system test
- [ ] Create update procedure
  - [ ] Testing updates in isolation
  - [ ] Backup before updates
  - [ ] Rollback plan for failed updates

## 🔧 Implementation Priority
1. Core monitoring setup (highest priority)
2. Multi-channel notifications
3. Service-specific monitoring
4. Power outage detection
5. Automation and scheduling
6. Logging and reporting
7. Testing and validation
8. Documentation
9. Deployment
10. Maintenance procedures

## 📚 Resources & References
- Uptime Kuma Documentation: https://github.com/louislam/uptime-kuma/wiki
- SystemD Service Documentation: https://www.freedesktop.org/software/systemd/man/systemd.service.html
- Pushover API Documentation: https://pushover.net/api
- Gmail SMTP Settings: https://support.google.com/mail/answer/7126229

## 🛠️ Tools & Technologies
- **Monitoring Framework**: Uptime Kuma, Prometheus (optional)
- **Scripting**: Python, Bash
- **Notification**: Email (Gmail SMTP), Pushover, Discord Webhooks
- **Scheduling**: SystemD Timers, Cron
- **Logging**: Rotating File Logs, JSON structured logging 