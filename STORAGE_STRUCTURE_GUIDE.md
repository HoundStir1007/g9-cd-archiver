# 💾 Storage Structure Guide - Post Migration

## 📊 **Current Storage Layout**

### **Paperless-SSD (1.8TB) - Documents & System Files**
**Usage**: 83% (302GB available)
**Purpose**: Documents, scans, system files, and project files

**Contents:**
- 📄 **Paperless-ngx scans** - Document management
- 📁 **Digital consolidation** - Organized files
- 💾 **System backups** - Automated backups
- 🗂️ **Project files** - Development and documentation
- 📚 **Jellyfin config** - Configuration files only
- 🎬 **Movies** (298GB) - *Migrating to large drive*
- 🎬 **AtmosFX** (110GB) - *Migrating to large drive*

### **Large Drive (3.7TB) - All Media Libraries**
**Usage**: ~50% (2TB+ available)
**Purpose**: All Jellyfin media and entertainment content

**Contents:**
- 🎵 **Music** (40GB) - ✅ Migrated
- 🎵 **Music Archive** (116GB) - ✅ Migrated
- 📺 **TV Shows** (46GB) - ✅ Migrated
- 🏠 **Home Videos** (62GB) - ✅ Migrated
- 🎭 **Stand-Up** (3.5GB) - ✅ Migrated
- 🎵 **Riffing** (12GB) - ✅ Migrated
- 🎬 **Music Videos** (17GB) - ✅ Migrated
- 📚 **Books** (576MB) - ✅ Migrated
- 🎬 **Movies** (298GB) - 🔄 Migrating
- 🎬 **AtmosFX** (110GB) - 🔄 Migrating

## 🎯 **Jellyfin Library Paths**

### **Completed Migrations** ✅
- 🎵 **Music**: `/storage-drive/jellyfin/media/music`
- 📺 **TV Shows**: `/storage-drive/jellyfin/media/tv`
- 🏠 **Home Videos**: `/storage-drive/jellyfin/media/home-videos`
- 📚 **Books**: `/storage-drive/jellyfin/media/books`
- 🎭 **Stand-Up**: `/storage-drive/jellyfin/media/Stand-Up`
- 🎵 **Riffing**: `/storage-drive/jellyfin/media/Riffing`
- 🎬 **Music Videos**: `/storage-drive/jellyfin/media/Music Videos and Concerts`

### **In Progress** 🔄
- 🎬 **Movies**: `/storage-drive/jellyfin/media/movies`
- 🎬 **AtmosFX**: `/storage-drive/jellyfin/media/AtmosFX`

### **Legacy Paths** (No longer used)
- ~~`/paperless-ssd/jellyfin/media/music`~~
- ~~`/paperless-ssd/jellyfin/media/tv`~~
- ~~`/paperless-ssd/jellyfin/media/home-videos`~~

## 🚀 **Migration Benefits**

### **Immediate Benefits:**
- 🎯 **500GB freed** on paperless drive
- 📄 **Room for paperless-ngx** to grow
- 🎬 **Space for more DVD rips** on large drive
- 🚀 **Better performance** (SSD for docs, HDD for media)

### **Long-term Benefits:**
- 📊 **Organized storage** - docs vs media separation
- 🎯 **Scalable system** - room for growth
- 🛡️ **Better backups** - separate backup strategies
- 📱 **Future-proof** - room for more content

## 📈 **Space Projections**

### **After Complete Migration:**
- **Paperless-SSD**: ~60% usage (700GB+ available)
- **Large Drive**: ~60% usage (1.5TB+ available)
- **Total media capacity**: Room for 1000+ more movies

### **Growth Potential:**
- **Paperless-ngx**: Can scan 10,000+ documents
- **Jellyfin**: Can add 1000+ more movies
- **System**: Plenty of room for projects and backups

## 🔧 **Maintenance Tasks**

### **Post-Migration Tasks:**
1. **Update Jellyfin libraries** with new paths
2. **Test media playback** in Jellyfin
3. **Verify all media** is accessible
4. **Clean up old backups** (thunderbolt_transfer, canvio_transfer)

### **Regular Maintenance:**
1. **Monitor space usage** on both drives
2. **Archive old projects** to large drive
3. **Clean up temporary files** regularly
4. **Verify backup integrity** monthly

## 🛡️ **Backup Strategy**

### **Paperless-SSD Backups:**
- **Documents**: Enhanced backup system (daily)
- **Configs**: System backup (weekly)
- **Projects**: Archive to large drive (monthly)

### **Large Drive Backups:**
- **Media**: Redundant storage (monthly)
- **Jellyfin config**: System backup (weekly)
- **Metadata**: Archive to paperless-ssd (monthly)

## 📋 **File Organization Rules**

### **Paperless-SSD (Documents & System):**
- ✅ Documents and scans
- ✅ System configurations
- ✅ Project files and documentation
- ✅ Temporary files (clean regularly)
- ❌ Large media files
- ❌ Entertainment content

### **Large Drive (Media & Archives):**
- ✅ All Jellyfin media libraries
- ✅ Movie and TV show files
- ✅ Music and audio files
- ✅ Archive and backup files
- ✅ Large project files
- ❌ System configurations
- ❌ Active development files

---

**Last Updated**: January 28, 2025  
**Migration Status**: In Progress (Movies & AtmosFX)  
**Next Focus**: Complete migration and update Jellyfin paths 