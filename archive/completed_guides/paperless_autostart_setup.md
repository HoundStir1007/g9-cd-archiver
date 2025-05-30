# Paperless-ngx Auto-Start Setup 🚀

*Make Paperless-ngx automatically start after G9 reboots*

## 🎯 **Quick Fix for Current Issue**

**Run these commands on G9 to restart Paperless-ngx:**
```bash
ssh mark@100.91.157.19
cd /home/mark
docker-compose up -d
```

## 🔧 **Permanent Solution: Auto-Start on Boot**

### **Method 1: Docker Compose Restart Policy (Recommended)**

Edit your `docker-compose.yml` to add restart policies:

```yaml
services:
  paperless-redis:
    restart: unless-stopped
    # ... rest of config

  paperless-db:
    restart: unless-stopped
    # ... rest of config

  paperless-webserver:
    restart: unless-stopped
    # ... rest of config

  paperless-gotenberg:
    restart: unless-stopped
    # ... rest of config

  paperless-tika:
    restart: unless-stopped
    # ... rest of config
```

### **Method 2: Systemd Service (Alternative)**

Create a systemd service for automatic startup:

```bash
# Create service file
sudo nano /etc/systemd/system/paperless-ngx.service
```

**Service file content:**
```ini
[Unit]
Description=Paperless-ngx Document Management
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/mark
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
TimeoutStartSec=0
User=mark
Group=mark

[Install]
WantedBy=multi-user.target
```

**Enable the service:**
```bash
sudo systemctl enable paperless-ngx.service
sudo systemctl start paperless-ngx.service
```

## 🔍 **Verification Commands**

**Check if containers are running:**
```bash
docker ps
docker-compose ps
```

**Check container logs:**
```bash
docker-compose logs paperless-webserver
```

**Test web access:**
```bash
curl http://localhost:8000
curl http://100.91.157.19:8000
```

## 📋 **Implementation Steps**

### **Step 1: Fix Current Issue (5 minutes)**
1. SSH to G9: `ssh mark@100.91.157.19`
2. Navigate: `cd /home/mark`
3. Start services: `docker-compose up -d`
4. Verify: `docker-compose ps`

### **Step 2: Add Restart Policies (10 minutes)**
1. Edit `docker-compose.yml`
2. Add `restart: unless-stopped` to all services
3. Restart with new config: `docker-compose down && docker-compose up -d`

### **Step 3: Test Auto-Start (Optional)**
1. Reboot G9: `sudo reboot`
2. Wait 2-3 minutes
3. Test access: http://100.91.157.19:8000

## 🎯 **Expected Results**

**After implementing restart policies:**
- ✅ Paperless-ngx starts automatically after reboot
- ✅ Services restart if they crash
- ✅ No manual intervention needed
- ✅ Reliable access via Tailscale

**Startup time after reboot:**
- Docker service: ~30 seconds
- Paperless containers: ~60-90 seconds
- Full web access: ~2-3 minutes total

## 🚨 **Troubleshooting**

**If containers won't start:**
```bash
# Check Docker service
sudo systemctl status docker

# Check disk space
df -h

# Check container logs
docker-compose logs
```

**If web interface won't load:**
```bash
# Check if port is listening
sudo netstat -tlnp | grep 8000

# Check firewall
sudo ufw status
```

---

*Run the quick fix now, then implement auto-start for future reboots!* 🔧✅ 