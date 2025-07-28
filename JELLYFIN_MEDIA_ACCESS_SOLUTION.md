# Jellyfin Media Access Solution - Complete Documentation 🎬

## 🎯 **PROBLEM SUMMARY**
**Issue**: Jellyfin Docker container appeared unable to access media files on external drives  
**Symptoms**: Empty libraries, `/media` directory showing as empty inside container  
**User Frustration**: Multiple failed attempts using symbolic links, permission fixes, and mount troubleshooting  

## ✅ **ACTUAL ROOT CAUSE**
**The Real Problem**: Jellyfin container was running with an **old configuration** that lacked proper volume mounts  
**Key Insight**: The `jellyfin-docker-compose.yml` file was **correct all along** - it just wasn't being used!

## 🔧 **THE SOLUTION**

### **Step 1: Stop the Old Container**
```bash
cd /home/mark/Desktop/home_server_research
docker-compose -f jellyfin-docker-compose.yml down
```

### **Step 2: Start with Correct Configuration**
```bash
docker-compose -f jellyfin-docker-compose.yml up -d
```

### **Step 3: Verify Success**
```bash
# Check container is running
docker ps

# Verify media access
docker exec jellyfin ls -la /paperless-ssd/jellyfin/media/
docker exec jellyfin ls /paperless-ssd/jellyfin/media/music/ | wc -l
```

**Expected Results**:
- Container shows as running and healthy
- Media directories are visible and populated
- Music directory should show 1,836 files

## 📋 **WORKING DOCKER CONFIGURATION**

**File**: `/home/mark/Desktop/home_server_research/jellyfin-docker-compose.yml`

```yaml
version: '3.8'

services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    user: 1000:1000  # mark user ID
    environment:
      - JELLYFIN_PublishedServerUrl=http://100.100.71.107:8096
    volumes:
      - /mnt/data/jellyfin/config:/config
      - /mnt/data/jellyfin/cache:/cache
      - /media/mark/paperless-ssd:/paperless-ssd:ro
      - /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb:/storage-drive:ro
    ports:
      - "8096:8096"
      - "8920:8920"  # HTTPS port (optional)
      - "7359:7359/udp"  # Auto-discovery (optional)
      - "1900:1900/udp"  # DLNA (optional)
    devices:
      - /dev/dri:/dev/dri  # Hardware acceleration (Intel Quick Sync)
```

## 🗂️ **STORAGE LAYOUT**

### **Host System Drives**
- **Root Drive** (`/`): 56GB total, 51GB used (96% full)
- **Paperless-SSD** (`/media/mark/paperless-ssd`): 1.8TB, 1.7TB used - **MAIN MEDIA DRIVE**
- **Storage Drive** (`/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb`): 3.7TB, 29GB used

### **Media File Locations (Host)**
- **Movies**: `/media/mark/paperless-ssd/jellyfin/media/movies/`
- **TV Shows**: `/media/mark/paperless-ssd/jellyfin/media/tv/`
- **Music**: `/media/mark/paperless-ssd/jellyfin/media/music/` (1,836 files)
- **Home Videos**: `/media/mark/paperless-ssd/jellyfin/media/home-videos/`
- **Books**: `/media/mark/paperless-ssd/jellyfin/media/books/`

### **Container Mount Points**
- **Movies**: `/paperless-ssd/jellyfin/media/movies/`
- **TV Shows**: `/paperless-ssd/jellyfin/media/tv/`
- **Music**: `/paperless-ssd/jellyfin/media/music/`
- **Home Videos**: `/paperless-ssd/jellyfin/media/home-videos/`
- **Books**: `/paperless-ssd/jellyfin/media/books/`
- **Storage**: `/storage-drive/` (3.7TB available)

## 📚 **JELLYFIN LIBRARY CONFIGURATION**

### **Access Jellyfin Web Interface**
URL: `http://100.100.71.107:8096`

### **Add Media Libraries**
1. Go to **Dashboard** → **Libraries**
2. Click **Add Media Library**
3. Select content type (Movies, Music, TV Shows, etc.)
4. Add folder using the **container paths** below:

### **Library Paths (Use These Exact Paths)**
- **🎵 Music Library**: `/paperless-ssd/jellyfin/media/music`
- **🎬 Movie Library**: `/paperless-ssd/jellyfin/media/movies`
- **📺 TV Shows Library**: `/paperless-ssd/jellyfin/media/tv`
- **🏠 Home Videos Library**: `/paperless-ssd/jellyfin/media/home-videos`
- **📚 Books Library**: `/paperless-ssd/jellyfin/media/books`

## ⚠️ **CRITICAL NOTES**

### **Normal Behavior (Not Errors)**
- **`/media/` directory inside container is EMPTY** - This is normal and expected
- Media is accessed through `/paperless-ssd/` and `/storage-drive/` mount points
- Do NOT try to use `/media/` paths in Jellyfin library setup

### **Path Confusion Prevention**
- **Host paths**: `/media/mark/paperless-ssd/...` (where files actually exist)
- **Container paths**: `/paperless-ssd/...` (what Jellyfin sees and uses)
- **Always use container paths** when configuring Jellyfin libraries

## 🔍 **TROUBLESHOOTING GUIDE**

### **If Jellyfin Shows Empty Libraries**
1. **Check container status**: `docker ps` (should show "healthy")
2. **Verify mounts**: `docker exec jellyfin ls -la /paperless-ssd/jellyfin/media/`
3. **Check file count**: `docker exec jellyfin ls /paperless-ssd/jellyfin/media/music/ | wc -l`
4. **If mounts missing**: Restart with correct config (see Solution steps above)

### **If Container Won't Start**
1. **Check logs**: `docker logs jellyfin`
2. **Verify host paths exist**: `ls -la /media/mark/paperless-ssd/`
3. **Check permissions**: Files should be owned by `mark:mark` (user ID 1000)

### **🚨 CRITICAL: Mount Path Issues** ⭐ **COMMON PROBLEM**
**Symptom**: `Library folder /storage-drive/jellyfin/media/movies is inaccessible or empty, skipping`

**Root Cause**: Docker compose mount path typos or incorrect drive names

**Diagnosis**:
```bash
# Check what container can actually see:
docker exec jellyfin ls /storage-drive/jellyfin/media/movies/

# If "No such file or directory" → mount path is wrong
```

**Fix**:
1. **Verify correct host path**: `ls /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies/`
2. **Check docker-compose.yml mount path**:
   ```yaml
   # ❌ WRONG (common typo):
   - /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1:/storage-drive:ro
   
   # ✅ CORRECT:
   - /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2:/storage-drive:ro
   ```
3. **Restart container**: `docker-compose down && docker-compose up -d`
4. **Verify fix**: `docker exec jellyfin ls /storage-drive/jellyfin/media/movies/`

### **If Media Files Not Visible**
1. **Verify on host**: `ls -la /media/mark/paperless-ssd/jellyfin/media/music/`
2. **Check inside container**: `docker exec jellyfin ls -la /paperless-ssd/jellyfin/media/music/`
3. **If mismatch**: Container using wrong configuration (restart with correct compose file)

## 🎯 **SUCCESS INDICATORS**

### **Container Health Check**
```bash
docker exec jellyfin ls -la /paperless-ssd/jellyfin/media/
```
**Expected**: Should show directories: AtmosFX, books, home-videos, movies, music, tv

### **Music File Count**
```bash
docker exec jellyfin ls /paperless-ssd/jellyfin/media/music/ | wc -l
```
**Expected**: Should return `1836`

### **Jellyfin Library Scan**
- Libraries should discover and import media files automatically
- Music library should show 1,836+ tracks
- Movies and other content should appear based on what's in the directories

## 📝 **LESSONS LEARNED**

1. **Configuration Mismatch**: Always verify which docker-compose file is actually being used
2. **Mount Naming**: Using named mounts (`/paperless-ssd`) instead of `/media` is cleaner and works better
3. **Empty `/media`**: An empty `/media` directory inside the container is normal when using named mounts
4. **Troubleshooting Order**: Check container configuration before assuming Docker or permission issues

## 🚀 **CURRENT STATUS**
✅ **RESOLVED** - All 1.7TB of media files accessible to Jellyfin  
✅ **CONFIRMED** - 1,836 music files accessible  
✅ **READY** - Jellyfin can now be configured with media libraries  
✅ **STABLE** - Solution is robust and will persist across reboots  

**Last Updated**: July 2025 - Solution verified and documented completely 