# Plex Directory Scanning Issue Fix 🔧

**Date:** 2025-01-10  
**Issue:** Plex not finding files during library scan  
**Status:** ⚠️ FIXING

---

## 🎯 **Root Cause:**
1. **Missing subdirectories** - `/data/movies`, `/data/tv`, `/data/music` don't exist in container
2. **Permission issues** - Host directories owned by root instead of gmk
3. **Volume mapping** - Files might be in wrong location

---

## 🔧 **Quick Fix Steps:**

**Step 1: Create directories inside Plex container**
```bash
# SSH into Ubuntu
ssh gmk@192.168.0.182

# Create directories inside the container
docker exec plex-server mkdir -p /data/{movies,tv,music}

# Verify they exist
docker exec plex-server ls -la /data/
```

**Step 2: Upload test content**
```bash
# From host Ubuntu system
mkdir -p /home/gmk/plex/media/{movies,tv,music}

# Add a test movie file
echo "test movie content" > /home/gmk/plex/media/movies/test_movie.mp4

# Verify Plex can see it
docker exec plex-server ls -la /data/movies/
```

**Step 3: Fix library path in Plex**
- **Plex Web UI:** http://192.168.0.182:32400/web
- **Library Path:** `/data/movies` (NOT `/home/gmk/plex/media/movies`)
- **Scan Library Manually:** Settings > Libraries > [Library] > Scan Library Files

---

## 📁 **Correct File Structure:**

**Host Ubuntu System:**
```
/home/gmk/plex/media/
├── movies/           ← Put movie files here
├── tv/              ← Put TV show files here
└── music/           ← Put music files here
```

**Inside Plex Container:**
```
/data/
├── movies/          ← Plex sees files here
├── tv/              ← Plex sees files here
└── music/           ← Plex sees files here
```

---

## 🎬 **Testing Movie Formats:**

**Supported Formats:**
- ✅ MP4, MKV, AVI, MOV
- ✅ H.264, H.265 codecs
- ✅ Most common formats

**File Naming:**
- ✅ `Movie Title (Year).mp4`
- ✅ `The Matrix (1999).mkv`
- ❌ Avoid special characters in filenames

---

## 🚀 **Next Steps:**

1. **Run the fix commands above**
2. **Add your actual movie files** to `/home/gmk/plex/media/movies/`
3. **Refresh Plex library** (should find files automatically)
4. **Repeat for TV shows and music**

**Status:** Ready to apply fix! 🎯 