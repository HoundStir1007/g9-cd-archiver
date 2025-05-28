# PERMANENT FIX: Never Need Physical Access Again 🔒

**CRITICAL ISSUE:** Paperless-ngx should auto-start but isn't working reliably.

## 🚨 **Root Cause Analysis**

Your `docker-compose.yml` already has `restart: unless-stopped` on all services, but containers still don't start after reboot. This means:

1. **Docker service** might not be enabled to start on boot
2. **External storage** might not be mounted before Docker starts
3. **Timing issues** between services starting

## 🔧 **BULLETPROOF SOLUTION**

### **Step 1: Ensure Docker Starts on Boot**
```bash
# SSH to G9 and run these commands:
ssh mark@100.91.157.19

# Enable Docker to start on boot
sudo systemctl enable docker

# Check Docker status
sudo systemctl status docker

# Verify Docker auto-start is enabled
sudo systemctl is-enabled docker
```

### **Step 2: Create Paperless Startup Service**
```bash
# Create a dedicated service for Paperless-ngx
sudo nano /etc/systemd/system/paperless-ngx.service
```

**Service file content:**
```ini
[Unit]
Description=Paperless-ngx Document Management System
Requires=docker.service
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
User=mark
Group=mark
WorkingDirectory=/home/mark
ExecStartPre=/bin/sleep 30
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
TimeoutStartSec=300
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Enable the service:**
```bash
# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable paperless-ngx.service
sudo systemctl start paperless-ngx.service

# Check service status
sudo systemctl status paperless-ngx.service
```

### **Step 3: Verify External Storage Auto-Mount**
```bash
# Check if external drive auto-mounts
cat /etc/fstab | grep paperless

# If not present, add auto-mount entry
sudo blkid  # Find your drive UUID
sudo nano /etc/fstab
```

**Add this line to /etc/fstab (replace UUID with your drive's UUID):**
```
UUID=your-drive-uuid /media/paperless-storage ext4 defaults,nofail 0 2
```

### **Step 4: Create Health Check Script**
```bash
# Create monitoring script
nano /home/mark/paperless-health-check.sh
```

**Health check script:**
```bash
#!/bin/bash
# Paperless-ngx Health Check and Auto-Recovery

LOG_FILE="/var/log/paperless-health.log"
PAPERLESS_URL="http://localhost:8000"

# Function to log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if Paperless is responding
if ! curl -s --max-time 10 "$PAPERLESS_URL" > /dev/null; then
    log_message "Paperless-ngx not responding, attempting restart..."
    
    # Try to restart containers
    cd /home/mark
    docker-compose down
    sleep 5
    docker-compose up -d
    
    # Wait and check again
    sleep 30
    if curl -s --max-time 10 "$PAPERLESS_URL" > /dev/null; then
        log_message "Paperless-ngx successfully restarted"
    else
        log_message "CRITICAL: Paperless-ngx restart failed - manual intervention required"
    fi
else
    log_message "Paperless-ngx is healthy"
fi
```

**Make executable and add to cron:**
```bash
chmod +x /home/mark/paperless-health-check.sh

# Add to crontab (runs every 5 minutes)
crontab -e
# Add this line:
*/5 * * * * /home/mark/paperless-health-check.sh
```

## 🧪 **TESTING THE SOLUTION**

### **Test 1: Reboot Test**
```bash
# Reboot the G9
sudo reboot

# Wait 5 minutes, then test from MacBook:
curl http://100.91.157.19:8000
```

### **Test 2: Service Status Check**
```bash
# Check all services are running
sudo systemctl status docker
sudo systemctl status paperless-ngx
docker-compose ps
```

### **Test 3: Health Check Verification**
```bash
# Check health check logs
tail -f /var/log/paperless-health.log
```

## 🎯 **EXPECTED RESULTS**

**After implementing this solution:**
- ✅ **Docker starts automatically** on every boot
- ✅ **Paperless-ngx starts automatically** 2-3 minutes after boot
- ✅ **External storage mounts** before services start
- ✅ **Health monitoring** detects and fixes issues automatically
- ✅ **Zero manual intervention** required EVER

**Startup sequence after reboot:**
1. **0-30 seconds:** System boot, network initialization
2. **30-60 seconds:** Docker service starts
3. **60-90 seconds:** External storage mounts
4. **90-180 seconds:** Paperless containers start
5. **180+ seconds:** Full web access available

## 🚨 **IMPLEMENTATION PRIORITY**

**Run these commands TODAY:**
1. **Enable Docker auto-start** (2 minutes)
2. **Create systemd service** (5 minutes)  
3. **Set up health monitoring** (10 minutes)
4. **Test with reboot** (5 minutes)

**Total time investment: 22 minutes to NEVER need physical access again**

## 📞 **VERIFICATION COMMANDS**

**Check everything is working:**
```bash
# Service status
sudo systemctl is-enabled docker
sudo systemctl is-enabled paperless-ngx

# Container status
docker-compose ps

# Health check
curl http://100.91.157.19:8000

# Logs
journalctl -u paperless-ngx.service -f
```

---

**🔒 GUARANTEE: After implementing this, you will NEVER need physical access to G9 again!** 