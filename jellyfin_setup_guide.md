# Jellyfin Setup Guide - G9 Ubuntu Server 🎬

**Target System:** GMKtec G9 Ubuntu 24.10  
**Access Method:** SSH via Tailscale (`ssh gmk@100.91.157.19`)  
**Estimated Setup Time:** 45-60 minutes  
**Prerequisites:** Docker and Docker Compose already installed  
**Storage Status:** Samsung 990 EVO 2TB NVMe (primary) + USB drive (live backup)

---

## 📋 Pre-Installation Checklist

### System Verification
- [x] SSH access to G9 Ubuntu: `ssh gmk@100.91.157.19` ✅
- [x] Docker running: `docker --version && docker compose version` ✅
- [x] Available storage space: `df -h` (Samsung SSD: 1.7T available) ✅
- [x] Network connectivity: `ping google.com` ✅
- [x] Tailscale status: Working via IP 100.91.157.19 ✅

### Current Storage Configuration
- [x] **Primary Storage:** Samsung 990 EVO 2TB NVMe (`/mnt/paperless-ssd/` - running Paperless-ngx) ✅
- [x] **Backup Storage:** USB drive (`/media/paperless-storage/` - live backup system) ✅
- [x] **Available for Jellyfin:** Jellyfin directory created on Samsung SSD ✅
- [x] Plan for different media types (Movies, TV Shows, Home Videos, Music) ✅

---

## 🚀 Installation Steps

### Step 1: Create Jellyfin Directory Structure on Samsung SSD
- [x] **COMPLETED** ✅ Directory structure created at `/mnt/paperless-ssd/jellyfin/`
- [x] **COMPLETED** ✅ Subdirectories: config, cache, media/{movies,tv,home-videos,music}
- [x] **COMPLETED** ✅ Proper ownership set to gmk:gmk

### Step 2: Create Docker Compose File
- [x] **COMPLETED** ✅ `docker-compose.yml` created with Jellyfin configuration
- [x] **COMPLETED** ✅ Volume mounts configured for Samsung SSD storage
- [x] **COMPLETED** ✅ Network configuration for Tailscale access
- [x] **COMPLETED** ✅ Hardware acceleration configured (Intel Quick Sync)

### Step 3: Docker Compose Configuration
- [x] **COMPLETED** ✅ Configuration deployed to `/mnt/paperless-ssd/jellyfin/docker-compose.yml`

### Step 4: Deploy Jellyfin
- [x] **COMPLETED** ✅ Container started: `docker compose up -d`
- [x] **COMPLETED** ✅ Container status: Healthy and running
- [x] **COMPLETED** ✅ Logs verified: No errors, startup in 6.28 seconds
- [x] **COMPLETED** ✅ Intel Quick Sync detected: h264_qsv, hevc_qsv, av1_qsv available

---

## 🔧 Initial Configuration

### Step 5: Web Interface Setup
- [x] **READY** ✅ Access via Tailscale: `http://100.91.157.19:8096`
- [x] **READY** ✅ Access via local network: `http://192.168.0.182:8096` *(Updated IP)*
- [ ] Complete initial setup wizard:
  - [ ] Set admin username and password
  - [ ] Configure media libraries
  - [ ] Set up remote access settings

### Step 6: Media Library Configuration
- [ ] **Movies Library:**
  - [ ] Path: `/media/movies`
  - [ ] Content type: Movies
  - [ ] Metadata downloaders: TheMovieDB
  - [ ] Image fetchers: TheMovieDB
  
- [ ] **TV Shows Library:**
  - [ ] Path: `/media/tv`
  - [ ] Content type: TV Shows  
  - [ ] Metadata downloaders: TheTVDB
  - [ ] Image fetchers: TheTVDB

- [ ] **Home Videos Library:**
  - [ ] Path: `/media/home-videos`
  - [ ] Content type: Home Videos & Photos
  - [ ] Disable metadata fetchers (for privacy)
  - [ ] Enable subtitle extraction

- [ ] **Music Library (Optional):**
  - [ ] Path: `/media/music`
  - [ ] Content type: Music
  - [ ] Metadata downloaders: MusicBrainz

- [ ] **Backup Media Library (Optional):**
  - [ ] Path: `/backup-media` (USB drive content)
  - [ ] Use for archived or less-frequently accessed content

### Step 7: Playback & Transcoding Settings
- [ ] Navigate to Dashboard → Playback
- [ ] **Hardware Acceleration:**
  - [ ] Check Intel Quick Sync: `ls /dev/dri` (should show renderD128)
  - [ ] Enable Intel Quick Sync Video acceleration
  - [ ] Set transcoding path: `/cache/transcoding` (on fast SSD)
  
- [ ] **Quality Settings:**
  - [ ] Max streaming bitrate: Auto (Samsung SSD can handle high bitrates)
  - [ ] Enable hardware-accelerated encoding
  - [ ] Configure subtitle settings

---

## 📱 Client Setup & Testing

### Step 8: Test Web Access
- [ ] **Local Network Test:** http://192.168.0.178:8096
- [ ] **Tailscale Test:** http://100.91.157.19:8096  
- [ ] **Mobile Safari Test:** Same URLs from iPhone
- [ ] **macOS Safari Test:** From MacBook via Tailscale

### Step 9: Mobile App Setup
- [ ] **iOS:** Download Jellyfin app from App Store
- [ ] **Android:** Download from Google Play or F-Droid
- [ ] **Connect to server:** Use `http://100.91.157.19:8096`
- [ ] **Test video playback:** Upload a test video first

### Step 10: Upload Test Content
- [ ] **Test Movie:** Copy a video file to `/mnt/paperless-ssd/jellyfin/media/movies/`
- [ ] **Test Home Video:** Copy a personal video to `/mnt/paperless-ssd/jellyfin/media/home-videos/`
- [ ] **Trigger Library Scan:** Dashboard → Libraries → Scan All Libraries
- [ ] **Verify Detection:** Check that media appears in web interface
- [ ] **Test Playback:** Play test content on web and mobile

---

## 🔒 Security & Access Configuration

### Step 11: User & Security Setup
- [ ] **Create Family Users:**
  - [ ] Navigate to Dashboard → Users
  - [ ] Add family member accounts with appropriate permissions
  - [ ] Set parental controls if needed
  
- [ ] **Configure Remote Access:**
  - [ ] Dashboard → Networking
  - [ ] Set external address: `http://100.91.157.19:8096`
  - [ ] Enable automatic port mapping: NO (using Tailscale)
  - [ ] Configure local network subnets: `192.168.0.0/24`

### Step 12: Backup Configuration
- [ ] **Config Backup to USB Drive:**
  ```bash
  # Create backup script that uses USB backup drive
  tar -czf "/media/paperless-storage/jellyfin-config-$(date +%Y%m%d).tar.gz" ./config
  ```
- [ ] **Database Backup:** Config folder contains SQLite databases
- [ ] **Media Backup Strategy:** Important media can be copied to USB backup drive

---

## 🎯 DVD ISO Support Configuration

### Step 13: DVD ISO Preparation (Optional)
- [ ] **Install Additional Tools:**
  ```bash
  sudo apt update
  sudo apt install libdvdcss2 # Enable DVD decryption
  ```
  
- [ ] **ISO Handling:**
  - [ ] Create `/mnt/paperless-ssd/jellyfin/media/dvd-isos/` directory
  - [ ] Note: Jellyfin has limited ISO support
  - [ ] Consider using MakeMKV to convert ISOs to MKV files
  - [ ] Alternative: Use VLC to stream ISOs directly

### Step 14: Long Video Optimization
- [ ] **Storage Optimization:**
  - [ ] Enable hardware transcoding for large files (Samsung SSD + Intel Quick Sync)
  - [ ] Set appropriate quality presets
  - [ ] Configure chapter detection for long videos
  
- [ ] **Network Optimization:**
  - [ ] Test streaming large files over Tailscale
  - [ ] Adjust bitrate settings for remote viewing
  - [ ] Configure local vs remote quality profiles

---

## ✅ Verification & Testing Checklist

### Final Testing
- [ ] **Web Interface:**
  - [ ] Login successful at both network addresses
  - [ ] All media libraries visible and populated
  - [ ] Test video plays without issues
  - [ ] Subtitle support working (if applicable)
  
- [ ] **Mobile Access:**
  - [ ] iOS/Android app connects successfully
  - [ ] Video playback smooth on mobile
  - [ ] Download for offline works (if needed)
  
- [ ] **Performance:**
  - [ ] Transcoding working (check Dashboard → Activity)
  - [ ] Intel Quick Sync hardware acceleration active
  - [ ] Fast seeking and chapter navigation (SSD performance)
  
- [ ] **Network Access:**
  - [ ] Local network streaming (high quality)
  - [ ] Tailscale remote streaming (appropriate quality)
  - [ ] Multiple concurrent streams (if family usage)

---

## 🚨 Troubleshooting Quick Reference

### Common Issues & Solutions

**Can't access web interface:**
```bash
# Check container status
docker ps
docker-compose logs jellyfin

# Check port availability
sudo netstat -tlnp | grep 8096
```

**Hardware acceleration not working:**
```bash
# Check Intel Quick Sync support
ls -la /dev/dri/
# Should show renderD128

# Check container permissions
docker exec jellyfin ls -la /dev/dri/
```

**Media not detected:**
```bash
# Check permissions on Samsung SSD
ls -la /mnt/paperless-ssd/jellyfin/media/
# Should show gmk:gmk ownership

# Check container mount
docker exec jellyfin ls -la /media/
```

**Tailscale access issues:**
```bash
# Verify Tailscale status
sudo tailscale status
# Check published server URL in Jellyfin settings
```

---

## 📚 Post-Setup Documentation

### Important URLs & Access
- **Web Interface (Local):** http://192.168.0.178:8096
- **Web Interface (Tailscale):** http://100.91.157.19:8096  
- **Admin Dashboard:** Add `/web/index.html#!/dashboard` to base URL
- **SSH Access:** `ssh gmk@100.91.157.19`

### File Locations
- **Configuration:** `/mnt/paperless-ssd/jellyfin/config/`
- **Cache/Transcoding:** `/mnt/paperless-ssd/jellyfin/cache/` (fast SSD storage)
- **Media Storage:** `/mnt/paperless-ssd/jellyfin/media/`
- **Docker Compose:** `/mnt/paperless-ssd/jellyfin/docker-compose.yml`
- **Backup Storage:** `/media/paperless-storage/` (USB drive for backups)

### Storage Architecture
- **Primary Storage:** Samsung 990 EVO 2TB NVMe
  - Paperless-ngx: `/mnt/paperless-ssd/paperless/`
  - Jellyfin: `/mnt/paperless-ssd/jellyfin/`
  - High-speed transcoding and database operations
- **Backup Storage:** USB Drive
  - Live backup of Paperless-ngx data
  - Optional media archive storage
  - Configuration backups

### Maintenance Commands
```bash
# View logs
docker-compose logs jellyfin

# Restart service
docker-compose restart jellyfin

# Update Jellyfin
docker-compose pull
docker-compose up -d

# Backup configuration to USB drive
tar -czf "/media/paperless-storage/jellyfin-backup-$(date +%Y%m%d).tar.gz" config/
```

---

## 🎉 Success Criteria

**Jellyfin is successfully installed when:**
- [ ] Web interface accessible from local network and Tailscale
- [ ] At least one media library configured and working
- [ ] Test video plays successfully on web and mobile
- [ ] Family members can access with their own accounts
- [ ] Intel Quick Sync hardware acceleration active
- [ ] Ready for long home video and media library management

**🎬 Ready to provide blazing-fast media server capabilities with Samsung SSD performance and USB backup protection!**

---

*Setup guide for G9 Ubuntu system with Samsung 990 EVO primary storage and USB backup system* 