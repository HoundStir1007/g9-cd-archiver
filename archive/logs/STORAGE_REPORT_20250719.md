# 🖥️ **COMPREHENSIVE STORAGE REPORT** - July 19, 2025

## 📊 **OVERALL STORAGE STATUS**

### **🔴 CRITICAL ALERT - Root Drive**
- **Drive**: `/dev/mmcblk0p2` (eMMC)
- **Size**: 56GB total
- **Used**: 49GB (91% full)
- **Available**: 5.0GB
- **Status**: ⚠️ **CRITICAL - Only 5GB free space**

### **🟡 WARNING - Paperless-SSD**
- **Drive**: `/dev/nvme1n1p1` (NVMe SSD)
- **Size**: 1.8TB total
- **Used**: 1.7TB (98% full)
- **Available**: 39GB
- **Status**: ⚠️ **WARNING - Only 39GB free space**

### **🟢 GOOD - Storage Drive**
- **Drive**: `/dev/nvme0n1p2` (NVMe SSD)
- **Size**: 3.7TB total
- **Used**: 1.1TB (30% full)
- **Available**: 2.5TB
- **Status**: ✅ **EXCELLENT - 2.5TB available**

### **💿 OPTICAL - Weird Al DVD**
- **Drive**: `/dev/sr1` (DVD-ROM)
- **Size**: 5.0GB total
- **Used**: 5.0GB (100% full)
- **Status**: 📀 **DVD mounted for access**

## 📁 **FILE DISTRIBUTION ANALYSIS**

### **📂 PAPERLESS-SSD (1.7TB used)**
```
1.1TB  digital_consolidation/
├── 701GB  thunderbolt_transfer/     (migrated from paperless-SSD)
├── 312GB  canvio_transfer/          (migrated from paperless-SSD)
└── 18GB   cd_rips/                  (migrated from root drive)

672GB  jellyfin/
├── 671GB  media/                    (Jellyfin media library)
├── 675MB  config/                   (Jellyfin configuration)
└── 81MB   cache/                    (Jellyfin cache)

661MB  paperless/                     (Paperless-ngx data)
76MB   retro-gaming/                 (Retro gaming files)
```

### **📂 STORAGE DRIVE (1.1TB used)**
```
1.0TB  archives/
├── 701GB  thunderbolt_transfer/     (duplicate of paperless-SSD)
├── 312GB  canvio_transfer/          (duplicate of paperless-SSD)
└── 4KB    digital_consolidation/    (archive structure)

18GB   media/                         (misc media files)
13GB   vm-images/                     (virtual machine images)
5.5GB  Windows11.iso                 (Windows installation media)
3.8GB  digital_consolidation/        (additional files)
3.4GB  dvd_salvage_20250713_162809/ (DVD salvage work)
2.6GB  usr/                          (system files)
1.6GB  var/                          (system files)
400MB  logs/                          (system logs)
146MB  cache/                         (system cache)
```

### **📂 ROOT DRIVE (49GB used)**
- **System files**: Ubuntu OS and applications
- **Home directory**: User files and workspace
- **Temporary files**: System caches and logs
- **Status**: ⚠️ **CRITICAL - Only 5GB free**

## 🎯 **STORAGE OPTIMIZATION OPPORTUNITIES**

### **🔄 DUPLICATE DATA IDENTIFIED**
- **Thunderbolt Transfer**: 701GB duplicated on both drives
- **Canvio Transfer**: 312GB duplicated on both drives
- **Total Duplicates**: 1,013GB (1TB+) of duplicate data
- **Potential Savings**: 1TB+ if duplicates are removed

### **📦 ARCHIVE OPTIMIZATION**
- **Storage Drive Archives**: 1.0TB of archive data
- **Paperless-SSD Archives**: 1.1TB of archive data
- **Overlap**: Significant duplication between drives
- **Recommendation**: Consolidate archives to single location

### **🗂️ FILE TYPE DISTRIBUTION**

#### **Media Files (Largest Category)**
- **Jellyfin Media**: 671GB (movies, TV shows, music)
- **Thunderbolt Movies**: 701GB (migrated movie collection)
- **Canvio Videos**: 312GB (migrated video collection)
- **CD Rips**: 18GB (audio files)
- **Total Media**: ~1.7TB

#### **System Files**
- **VM Images**: 13GB (virtual machines)
- **Windows ISO**: 5.5GB (installation media)
- **System Logs**: 400MB (operational logs)
- **Cache Files**: 146MB (system cache)

#### **Archive Files**
- **Digital Consolidation**: 1.1TB (migrated data)
- **DVD Salvage**: 3.4GB (recovery work)
- **Project Files**: Various sizes (development work)

## 🚨 **CRITICAL ISSUES & RECOMMENDATIONS**

### **🔴 IMMEDIATE ACTIONS NEEDED**

#### **1. Root Drive Emergency (91% full)**
- **Issue**: Only 5GB free space remaining
- **Risk**: System instability, failed updates
- **Actions**:
  - Clean apt cache: `sudo apt clean`
  - Remove old kernels: `sudo apt autoremove`
  - Clear system logs: `sudo journalctl --vacuum-time=7d`
  - Move large files to storage drive

#### **2. Paperless-SSD Warning (98% full)**
- **Issue**: Only 39GB free space remaining
- **Risk**: Service failures, data corruption
- **Actions**:
  - Remove duplicate data (1TB+ available)
  - Archive old data to storage drive
  - Optimize Jellyfin cache settings

### **🟡 OPTIMIZATION OPPORTUNITIES**

#### **3. Duplicate Data Cleanup**
- **Opportunity**: 1TB+ of duplicate data
- **Action**: Remove duplicates from paperless-SSD
- **Benefit**: Free up 1TB+ of space

#### **4. Archive Consolidation**
- **Opportunity**: Consolidate archives to storage drive
- **Action**: Move paperless-SSD archives to storage drive
- **Benefit**: Better organization and space efficiency

## 📈 **STORAGE EFFICIENCY METRICS**

### **Current Utilization**
- **Root Drive**: 91% (CRITICAL)
- **Paperless-SSD**: 98% (WARNING)
- **Storage Drive**: 30% (EXCELLENT)

### **Available Space**
- **Root Drive**: 5GB (CRITICAL)
- **Paperless-SSD**: 39GB (WARNING)
- **Storage Drive**: 2.5TB (EXCELLENT)

### **Duplicate Data**
- **Identified**: 1,013GB (1TB+)
- **Potential Savings**: 1TB+ if cleaned up
- **Impact**: Could solve both critical issues

## 🎯 **RECOMMENDED ACTION PLAN**

### **Phase 1: Emergency Relief (Immediate)**
1. **Clean Root Drive**: Remove system caches and old files
2. **Move Large Files**: Transfer large files to storage drive
3. **Optimize Services**: Adjust Jellyfin and Paperless settings

### **Phase 2: Duplicate Cleanup (This Week)**
1. **Remove Duplicates**: Clean up 1TB+ of duplicate data
2. **Consolidate Archives**: Move archives to storage drive
3. **Verify Integrity**: Ensure no data loss during cleanup

### **Phase 3: Long-term Optimization (Ongoing)**
1. **Monitor Usage**: Set up storage monitoring
2. **Regular Cleanup**: Schedule periodic maintenance
3. **Archive Strategy**: Implement systematic archiving

---

**📊 REPORT SUMMARY**: Root drive at 91% (CRITICAL), Paperless-SSD at 98% (WARNING), but storage drive has 2.5TB available. 1TB+ of duplicate data identified - cleanup could solve both critical issues. Immediate action needed on root drive, followed by duplicate cleanup and archive consolidation. 🚨💾 