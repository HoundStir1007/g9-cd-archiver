# 🎬 Jellyfin Troubleshooting Quick Reference

## 🚨 **CRITICAL ISSUES** (Check First)

### **1. Mount Path Issues** ⭐ **MOST COMMON**
**Symptom**: `Library folder /storage-drive/jellyfin/media/movies is inaccessible or empty, skipping`

**Quick Diagnosis**:
```bash
docker exec jellyfin ls /storage-drive/jellyfin/media/movies/
# If "No such file or directory" → mount path wrong
```

**Quick Fix**:
```bash
# 1. Check correct host path exists:
ls /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies/

# 2. Fix docker-compose.yml mount path (common typo fcb1 vs fcb2):
# ❌ WRONG: /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1:/storage-drive:ro
# ✅ RIGHT: /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2:/storage-drive:ro

# 3. Restart container:
docker-compose -f jellyfin-docker-compose.yml down
docker-compose -f jellyfin-docker-compose.yml up -d

# 4. Verify fix:
docker exec jellyfin ls /storage-drive/jellyfin/media/movies/ | head -5
```

### **2. Library Scanning Freezes** ⭐ **DOCUMENTED PATTERN**
**Common Freeze Points**: 81.8%, 99%

**Causes**:
- Single corrupted M4A file (codec ID 98314)
- macOS metadata files (.DS_Store, ._* files)
- Invalid XML characters (0x01, 0x0F, 0x16)

**Quick Fix**:
```bash
# Check logs for specific errors:
docker logs jellyfin --tail 20 | grep -E "(error|xml|codec)"

# Run proven optimization script:
./optimize_jellyfin_scanning.sh

# Scan libraries individually (not all at once):
# 1. Home Videos (smallest)
# 2. Movies 
# 3. TV Shows
# 4. Music (largest - most likely to cause problems)
```

### **3. Movie Naming Issues**
**Symptom**: Movies exist but don't appear in Jellyfin

**Quick Diagnosis**:
```bash
# Check for problematic naming patterns:
ls /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies/ | grep -E "(1080p|x264|YIFY|_|www\.)"
```

**Quick Fix**:
```bash
# Run movie name cleanup script:
./jellyfin_movie_name_cleanup.sh

# Expected format: "Movie Name (Year).ext"
# Examples:
# ✅ "Deadpool (2016).mp4"
# ❌ "Deadpool 2016 1080p BluRay x264 DTS-JYK.mp4"
```

---

## 🔧 **COMMON SOLUTIONS**

### **Container Management**
```bash
# Check status:
docker ps | grep jellyfin

# Restart Jellyfin:
docker-compose -f jellyfin-docker-compose.yml restart

# View logs:
docker logs jellyfin --tail 20

# Monitor logs in real-time:
docker logs jellyfin --follow
```

### **Verification Commands**
```bash
# Check Jellyfin is responding:
curl -s http://100.100.71.107:8096 > /dev/null && echo "✅ Responding" || echo "❌ Down"

# Count movies container can see:
docker exec jellyfin find /storage-drive/jellyfin/media/movies -name "*.mp4" | wc -l

# Check mount points:
docker exec jellyfin df -h | grep storage-drive
```

### **Library Optimization Settings**
When scanning gets stuck, try these settings:

1. **Dashboard → Playback**:
   - Reduce "Transcoding thread count" to 2-4
   - Disable "Enable hardware acceleration" temporarily

2. **Dashboard → Libraries → [Library] → Settings**:
   - Disable "Download images in advance"
   - Set "Metadata downloaders" to minimum  
   - Disable "Download missing subtitles"

---

## 📊 **PROVEN TROUBLESHOOTING WORKFLOW**

### **Step 1: Basic Health Check**
```bash
# Is Jellyfin running?
docker ps | grep jellyfin

# Is it responding?
curl -s http://100.100.71.107:8096

# Any obvious errors?
docker logs jellyfin --tail 10
```

### **Step 2: Mount Path Verification**
```bash
# Can container see movies?
docker exec jellyfin ls /storage-drive/jellyfin/media/movies/ | head -5

# If "No such file or directory" → mount path issue (see Critical Issues #1)
```

### **Step 3: Content Verification**
```bash
# How many movies should be visible?
ls /media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb2/jellyfin/media/movies/ | wc -l

# Are specific movies visible to container?
docker exec jellyfin ls /storage-drive/jellyfin/media/movies/ | grep -i "royal\|pee"
```

### **Step 4: Scanning Strategy**
```bash
# Use proven scanning approach:
./optimize_jellyfin_scanning.sh

# Then access: http://100.100.71.107:8096
# Dashboard → Libraries → Movies → ⋮ → Scan Library
# Monitor progress and logs
```

---

## 🎯 **SUCCESS INDICATORS**

✅ **Container can see movies**: `docker exec jellyfin ls /storage-drive/jellyfin/media/movies/`  
✅ **No mount warnings**: No "inaccessible or empty" in logs  
✅ **Movies appear in web interface**: Pee Wee's Big Adventure and Royal Tenenbaums visible  
✅ **Scanning completes**: No freeze at 81.8% or 99%  

---

## 📚 **RELATED DOCUMENTATION**

- **JELLYFIN_MEDIA_ACCESS_SOLUTION.md** - Complete setup guide
- **baton.md** - Project status and recent fixes
- **optimize_jellyfin_scanning.sh** - Proven scanning optimization
- **jellyfin_movie_name_cleanup.sh** - Movie naming fixes

---

*Last Updated: July 24, 2025 - Mount path fix documented*
*Next Review: After successful library verification* 