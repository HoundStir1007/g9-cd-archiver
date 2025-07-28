# 🎬 Jellyfin Storage Migration Guide

## 📊 **Current Situation**
- **Paperless-SSD**: 1.8TB - **83% used** (302GB available) ✅
- **Large Drive**: 3.7TB - **~50% used** ✅
- **Status**: Migration in progress - ~500GB freed so far!

## 🎯 **Migration Strategy**

### **Paperless-SSD (1.8TB) - Keep For:**
- 📄 **Paperless-ngx scans** (documents, photos, images)
- 📁 **Digital consolidation** (organized files)
- 💾 **System backups** and archives
- 🗂️ **Project files** and documentation

### **Large Drive (3.7TB) - Move All Jellyfin Media To:**
- 🎬 **Movies** (304GB) - Your DVD rips!
- 🎵 **Music** (156GB total) - All music libraries
- 📺 **TV Shows** (46GB) - TV content
- 🏠 **Home Videos** (62GB) - Personal videos
- 🎭 **Stand-Up & Riffing** (15GB) - Comedy content
- 🎬 **Music Videos** (17GB) - Concert videos
- 🎬 **AtmosFX** (110GB) - Ambient videos

## 🚀 **Migration Steps**

### **Step 1: Migration Scripts Executed** ✅
```bash
chmod +x migrate_jellyfin_to_large_drive.sh
./migrate_jellyfin_to_large_drive.sh
```

**Status**: Migration in progress!
- ✅ **Completed**: Music, TV Shows, Home Videos, Stand-Up, Riffing, Music Videos
- 🔄 **In Progress**: Movies (298GB), AtmosFX (110GB)
- ⏳ **Pending**: None

### **Step 2: Update Jellyfin Configuration**
```bash
# Stop current Jellyfin
docker-compose -f jellyfin-docker-compose.yml down

# Update to new configuration
cp jellyfin-docker-compose-migrated.yml jellyfin-docker-compose.yml

# Start with new paths
docker-compose -f jellyfin-docker-compose.yml up -d
```

### **Step 3: Update Jellyfin Library Paths**
In Jellyfin web interface (`http://100.100.71.107:8096`):

**Updated Library Paths (After Migration):**
- 🎵 **Music**: `/storage-drive/jellyfin/media/music` ✅
- 🎬 **Movies**: `/storage-drive/jellyfin/media/movies` 🔄 (in progress)
- 📺 **TV Shows**: `/storage-drive/jellyfin/media/tv` ✅
- 🏠 **Home Videos**: `/storage-drive/jellyfin/media/home-videos` ✅
- 📚 **Books**: `/storage-drive/jellyfin/media/books` ✅
- 🎭 **Stand-Up**: `/storage-drive/jellyfin/media/Stand-Up` ✅
- 🎵 **Riffing**: `/storage-drive/jellyfin/media/Riffing` ✅
- 🎬 **Music Videos**: `/storage-drive/jellyfin/media/Music Videos and Concerts` ✅
- 🎬 **AtmosFX**: `/storage-drive/jellyfin/media/AtmosFX` 🔄 (in progress)

### **Step 4: Movies Migration (After Muppets Rip)**
```bash
chmod +x migrate_movies_later.sh
./migrate_movies_later.sh
```

**Status**: Movies migration is currently running! 🎬

## 📊 **Current Results**

### **Space Freed on Paperless-SSD:**
- **~500GB** freed so far (from 100% to 83% usage)
- **302GB available** for documents and scans
- **Paperless-ngx** has plenty of room now

### **Space Used on Large Drive:**
- **~500GB** media storage moved
- **Still 2TB+ available** for future rips
- **Room for 1000+ more movies** at 2GB each!

## 🔧 **Post-Migration Tasks**

### **1. Verify Media Access**
```bash
# Check if media is accessible
docker exec jellyfin ls -la /storage-drive/jellyfin/media/
```

### **2. Update Jellyfin Libraries**
- Go to Jellyfin web interface
- Navigate to Libraries
- Update each library path to use `/storage-drive/` instead of `/paperless-ssd/`

### **3. Test Media Playback**
- Try playing a few movies
- Check music playback
- Verify TV show access

### **4. Clean Up Old Backups**
```bash
# Remove old transfer directories (after verifying they're backed up)
rm -rf /media/mark/paperless-ssd1/digital_consolidation/thunderbolt_transfer
rm -rf /media/mark/paperless-ssd1/digital_consolidation/canvio_transfer
```

## 🛡️ **Safety Measures**

### **Before Migration:**
- ✅ **Backup verification** - All data is backed up
- ✅ **Space check** - Large drive has 2.5TB free
- ✅ **Migration script** - Uses rsync for safe transfer

### **During Migration:**
- ✅ **Progress tracking** - Script shows transfer progress
- ✅ **Error handling** - Stops on any failure
- ✅ **Source removal** - Only deletes after successful move

### **After Migration:**
- ✅ **Path verification** - Confirm new paths work
- ✅ **Media testing** - Verify playback works
- ✅ **Space verification** - Check freed space

## 📈 **Benefits of This Migration**

### **Immediate Benefits:**
- 🎯 **700GB freed** on paperless drive
- 📄 **Room for paperless-ngx** to grow
- 🎬 **Space for more DVD rips** on large drive
- 🚀 **Better performance** (SSD for docs, HDD for media)

### **Long-term Benefits:**
- 📊 **Organized storage** - docs vs media separation
- 🎯 **Scalable system** - room for growth
- 🛡️ **Better backups** - separate backup strategies
- 📱 **Future-proof** - room for more content

## 🎉 **Success Metrics**

After migration, you should have:
- ✅ **Paperless-SSD**: 30-40% usage (plenty of room)
- ✅ **Large Drive**: 50-60% usage (room for 1000+ more movies)
- ✅ **Jellyfin**: All media accessible and working
- ✅ **Paperless-ngx**: Plenty of room for scans
- ✅ **System**: Better organized and scalable

---

**Migration Status**: Ready to execute  
**Estimated Time**: 2-3 hours for full migration  
**Risk Level**: Low (safe rsync migration with verification) 