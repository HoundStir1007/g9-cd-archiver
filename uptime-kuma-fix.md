# Uptime Kuma Monitor Fix Guide 🔧

## Current Issues
- Plex showing as down (false negative)
- G9 server showing as down (false negative)
- Push monitors not working correctly

## Correct Monitor Configurations

### 1. Plex Media Server ✅
**Monitor Type:** TCP Port
- **Host:** 100.91.157.19 (or localhost)
- **Port:** 32400
- **Name:** Plex Media Server
- **Check Interval:** 60 seconds
- **Retries:** 3
- **Reason:** Plex requires authentication for HTTP endpoints, TCP port monitoring is more reliable

### 2. G9 System Monitor ✅
**Monitor Type:** Ping
- **Host:** 100.91.157.19
- **Name:** G9 System
- **Check Interval:** 60 seconds
- **Retries:** 3
- **Reason:** Simple ping test to verify system is alive

### 3. Jellyfin Media Server ✅
**Monitor Type:** HTTP(s)
- **URL:** http://100.91.157.19:8096/health
- **Name:** Jellyfin
- **Check Interval:** 60 seconds
- **Expected Status:** 200
- **Expected Content:** "Healthy"
- **Reason:** Jellyfin has a proper health endpoint

### 4. Paperless-ngx ✅
**Monitor Type:** HTTP(s)
- **URL:** http://100.91.157.19:8000/api/health/
- **Name:** Paperless-ngx
- **Check Interval:** 60 seconds
- **Expected Status:** 200
- **Reason:** Paperless has a health API endpoint

## Setup Instructions

### Step 1: Access Uptime Kuma Dashboard
```bash
# Start Uptime Kuma if not running
cd ~/uptime-kuma
docker-compose up -d

# Access at: http://100.91.157.19:3001
```

### Step 2: Delete Current Broken Monitors
1. Go to Dashboard
2. Click on each broken monitor (Plex, G9)
3. Click "Edit"
4. Click "Delete" at the bottom

### Step 3: Create New Monitors

#### Plex Monitor (TCP Port)
1. Click "Add New Monitor"
2. Monitor Type: "TCP Port"
3. Friendly Name: "Plex Media Server"
4. Hostname: "100.91.157.19"
5. Port: "32400"
6. Heartbeat Interval: "60"
7. Retries: "3"
8. Click "Save"

#### G9 System Monitor (Ping)
1. Click "Add New Monitor"
2. Monitor Type: "Ping"
3. Friendly Name: "G9 System"
4. Hostname: "100.91.157.19"
5. Heartbeat Interval: "60"
6. Retries: "3"
7. Click "Save"

### Step 4: Verify Existing Monitors

#### Check Jellyfin Monitor
- Should be HTTP type checking: http://100.91.157.19:8096/health
- Should expect "Healthy" response

#### Check Paperless Monitor
- Should be HTTP type checking: http://100.91.157.19:8000/api/health/
- Should expect 200 status code

## Quick Test Commands

Test the endpoints manually to verify they work:

```bash
# Test Plex (should connect to port)
telnet 100.91.157.19 32400

# Test G9 system (should respond)
ping -c 3 100.91.157.19

# Test Jellyfin health
curl http://100.91.157.19:8096/health

# Test Paperless health  
curl http://100.91.157.19:8000/api/health/
```

## Expected Results After Fix

All monitors should show green/up status:
- ✅ Plex Media Server (TCP:32400)
- ✅ G9 System (Ping)
- ✅ Jellyfin (HTTP Health Check)
- ✅ Paperless-ngx (HTTP Health Check)

## Troubleshooting

### If Plex Still Shows Down
- Check if container is running: `docker ps | grep plex`
- Verify port is open: `netstat -tlnp | grep 32400`
- Try local test: `telnet localhost 32400`

### If G9 System Still Shows Down
- This would be very unusual since we're on the system
- Check Tailscale connectivity: `tailscale status`
- Try local ping: `ping localhost`

### If Services Don't Start
```bash
# Check if Uptime Kuma is running
docker ps | grep uptime

# Restart if needed
cd ~/uptime-kuma
docker-compose restart

# Check logs
docker-compose logs
``` 