# Plex Media Server - Apple TV Connection Guide 🍎📺

**Status:** ✅ **PLEX SERVER ALREADY OPERATIONAL**  
**Target:** Connect Apple TV to existing Plex server  
**Duration:** 10-15 minutes (Apple TV setup only)  
**Server:** GMKtec G9 Ubuntu with media libraries already configured  

## Current Status ✅

**🎉 Plex Media Server is fully operational!**

Your Plex server is already running and configured with access to all your media:

**📂 Available Content:**
- **🎬 Movies:** Halloween content, DRYWALL ZOMBIES, Santa's Bakery, and more
- **🎵 Music:** 1,800+ track collection with various artists
- **📱 Home Videos:** Personal content including timestamps, family videos
- **📺 TV Shows:** Directory ready for TV series content
- **📚 Books:** Additional media content available

**🔗 Server Access:**
- **Tailscale Remote:** `http://100.91.157.19:32400/web` ✅ Working
- **Docker Container:** Healthy and running ✅
- **Media Libraries:** Sharing Jellyfin media directories ✅

---

## Apple TV Plex App Setup 📱

### Install Plex App on Apple TV
1. **Open App Store** on Apple TV
2. **Search "Plex"** 
3. **Download and Install** Plex app (free)

### Connect Apple TV to Plex Server
1. **Open Plex App** on Apple TV
2. **Sign In** with your Plex account
3. **Automatic Discovery:** Server should appear as your G9 server
4. **Manual Entry** (if needed): `100.91.157.19:32400`

### Test Your Content 🎬
- **Movies:** Try "DRYWALL ZOMBIES" or Halloween content
- **Music:** Browse your 1,800+ track collection
- **Home Videos:** Access personal content and family videos
- **Verify smooth playback** and remote control functionality

---

## Optional: Additional Settings ⚙️

### Server Settings Optimization
In Plex Settings → Server → Transcoder:

- **Transcoder Quality:** Automatic
- **Transcoder Default:** 720p 4Mbps (Apple TV handles up to 4K)
- **Use Hardware Acceleration:** Enable (Intel Quick Sync on G9)
- **Background Transcoding:** 1 hour after creation

### Apple TV App Settings
In Plex app Settings:
- **Quality:** Maximum (Apple TV can handle full quality)
- **Allow Direct Play:** ON
- **Allow Direct Stream:** ON  
- **Allow Cellular Data:** Configure per preference

### Library Scanning
- **Automatic Scan:** Enable for all libraries
- **Scan Interval:** Every 15 minutes
- **Empty Trash:** After every scan

---

## Access Points Summary 🔗

### Web Interface Access
- **Primary Access:** http://100.91.157.19:32400/web (Tailscale - works anywhere) ✅
- **SSH Tunnel:** `ssh -L 32400:localhost:32400 gmk@100.91.157.19` (backup method)

### Apple TV Access
- **Native Plex App:** Automatic server discovery ✅
- **Manual Server:** `100.91.157.19:32400` 

### Mobile & Device Access
- **Plex Mobile Apps:** iOS/Android apps connect automatically via Tailscale
- **Any Web Browser:** Access from any device with internet connection

---

## Troubleshooting 🔧

### Server Not Found on Apple TV
```bash
# Check Plex service status
sudo systemctl status plexmediaserver

# Restart Plex service
sudo systemctl restart plexmediaserver

# Check firewall status
sudo ufw status
```

### Media Not Scanning
```bash
# Check media directory permissions
ls -la /mnt/paperless-ssd/jellyfin/media/

# Fix permissions if needed
sudo chown -R plex:plex /mnt/paperless-ssd/jellyfin/media/
sudo chmod -R 755 /mnt/paperless-ssd/jellyfin/media/
```

### Remote Access Issues
1. **Verify Tailscale:** `sudo tailscale status`
2. **Check port forwarding:** Ensure 32400 is accessible
3. **Manual remote access:** Use SSH tunnel as backup

---

## Dual Media Server Benefits 🎯

### Plex Advantages (Apple TV)
- **Native tvOS app** with Apple TV remote integration
- **Superior TV interface** optimized for big screen
- **Hardware acceleration** for smooth 4K playback
- **Family sharing** with individual user profiles
- **Offline sync** to iOS devices for travel

### Jellyfin Advantages (Personal Use)
- **Privacy-focused** with no external dependencies
- **Mobile browser access** without app requirements
- **Personal content** optimization (home videos, books)
- **No subscription fees** or premium features locked
- **Complete control** over metadata and organization

### Shared Infrastructure
- **Same Media Files:** No duplicate storage required
- **Samsung SSD Performance:** Both servers benefit from NVMe speed
- **Unified Management:** Add content once, available in both
- **Backup Strategy:** Single backup covers both media servers

---

## Maintenance Notes 📝

### Regular Maintenance
```bash
# Update Plex server
sudo apt update && sudo apt upgrade plexmediaserver

# Check storage usage
df -h /mnt/paperless-ssd/

# Monitor service health
sudo systemctl status plexmediaserver
```

### Media Organization
- **Add content** to `/mnt/paperless-ssd/jellyfin/media/` directories
- **Both Plex and Jellyfin** will detect new content automatically
- **Organize** by type: movies/, tv/, home-videos/, music/

---

## 🎉 Ready to Connect Your Apple TV!

**✅ Plex Server Status: FULLY OPERATIONAL**

Your Plex server is already configured and ready for Apple TV connection:

- ✅ **Server Running:** Docker container healthy and accessible
- ✅ **Media Libraries:** Movies, Music, Home Videos, TV Shows all available
- ✅ **Remote Access:** Working via Tailscale (100.91.157.19:32400)
- ✅ **Content Ready:** 1,800+ music tracks, movies, personal videos

**🍎 Apple TV Connection: 10-15 minutes**
1. Install Plex app from Apple TV App Store
2. Sign in with your Plex account  
3. Connect to your G9 server (auto-discovery or manual)
4. Start enjoying your media library on the big screen!

**🏆 Dual Media Server Benefits:**
- **📺 Plex + Apple TV:** Perfect for living room entertainment
- **📱 Jellyfin:** Continues to handle personal content and mobile access
- **🎬 Shared Content:** Same media files accessible from both servers
- **🌐 Anywhere Access:** Stream your content from anywhere via Tailscale

---

*Apple TV connection time: 10-15 minutes*  
*Your media server ecosystem is ready for big-screen entertainment!* 🍎✨ 