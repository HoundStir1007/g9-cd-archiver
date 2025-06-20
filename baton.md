# Baton - Project Tracking & Handoff Document 🚀

*Updated: June 19, 2025 - MAJOR HARDWARE UPGRADE: 4TB M.2 SSD Ordered + Active Transfers at 121GB!* 🚀💾

---

## 🎯 **CURRENT BATON STATUS**

**Previous Mission**: ✅ **COMPLETED** - Home Server Security & Monitoring (100% Operational)  
**New Objective**: **Digital File Consolidation & LLM-Assisted Organization**  
**Status**: 🚀 **HARDWARE UPGRADE INCOMING** - 4TB M.2 SSD arriving Saturday + active transfers  
**Current Focus**: **121GB transferred** - Major progress on Canvio consolidation + storage expansion  
**Next Holder**: Install 4TB drive → migrate to internal storage → retire external drives → LLM organization

---

## 📋 **NEW MISSION: DIGITAL ARCHAEOLOGY PROJECT**

### 🎯 **PROJECT OVERVIEW**
**Goal**: Create a unified, organized digital library on GMK-G9 server  
**Method**: Systematic gathering → bulk consolidation → LLM-assisted sorting/deduplication  
**Timeline**: Multi-phase approach with checkpoints

### 🗂️ **PHASE 1: FILE GATHERING STRATEGY - IN PROGRESS** ⚡

#### **SOURCE INVENTORY** 📦
- 🎵 **CD-Rs**: Legacy burned discs (photos, music, documents) - **AUTOMATED SOLUTION READY** 
- **USB Drives**: Various portable storage devices - *Next priority*
- ✅ **Mac mini A1347**: Identified and ready for file transfer
- 🔥 **Canvio Drive (1.8TB)**: **ACTIVE TRANSFER** - Toshiba External USB 3.0
- **External Drives**: Any additional storage media
- **Cloud Downloads**: Previous backups or archives

#### **COLLECTION WORKFLOW** 🔄
1. ✅ **Staging area created** on G9: `/mnt/paperless-ssd/digital_consolidation/`
2. ✅ **Source-specific folders operational**: 
   - 🎵 `cd_rips/` - **AUTOMATED SCRIPT READY** (Mac Mini → Canvio)
   - `usb_transfers/` - USB drive files (*pending*) 
       - ✅ `canvio_transfer/mac_mini_files/` - **2.3GB transferred** ✅ 
    - 🔥 `canvio_transfer/photos_to_import/` - **15GB transferred** (growing)
    - 🔥 `canvio_transfer/save_for_migration/` - **11GB transferred** (music, videos)
    - 🔥 `canvio_transfer/iphoto_library/` - **8.5GB transferred** (massive photo library)
3. ✅ **Metadata preservation**: Creation dates, source info maintained via rsync
4. ✅ **Safety first**: No deletion from originals until verification - **ACTIVE POLICY**

#### **RECENT PROGRESS** 📈
- ✅ **Mac mini A1347 Assessment**: Connected to WiFi, ready for file extraction
- ✅ **Transfer Method Selected**: USB drive approach chosen for simplicity  
- ✅ **Connection Strategy**: SFTP fallback option documented for network transfers
- ✅ **Canvio Drive Discovery**: 1.8TB Toshiba External USB 3.0 detected & mounted
- ✅ **Mount Strategy**: HFS+ filesystem mounted at `/media/gmk/canvio`
- ✅ **INITIAL TRANSFER**: Mac Mini files (34GB) **100% COMPLETE** ✅
- ✅ **SAVE FOR MIGRATION**: (13GB) **100% COMPLETE** ✅
- 🔥 **ACTIVE TRANSFERS**: **6 rsync processes** - Photos to Import (52GB), iPhoto Library (22GB)
- 📊 **Major Progress**: **121GB transferred** (+54GB growth!) - 27% complete
- 💾 **HARDWARE BREAKTHROUGH**: **4TB M.2 PCIe Gen4 SSD ordered** - $212.15 (incredible deal!)
- 📦 **Delivery**: **Saturday arrival** - Perfect timing for storage expansion
- 🎯 **Storage Strategy**: 6TB total M.2 (2TB existing + 4TB new) = retire external drives
- 🎵 **CD-R AUTOMATION**: **Batch ripper script ready** for Mac Mini deployment
- 🚀 **Next Phase**: Install 4TB → internal consolidation → external drive liberation

### 🎵 **PHASE 1.5: CD-R BATCH RIPPING - READY TO DEPLOY**

#### **AUTOMATED CD-R SOLUTION** 📀
- **Platform**: Mac mini A1347 (OS X 10.8 Mountain Lion)
- **Script**: `cd_ripper_mac.sh` - Fully automated batch processing
- **Target**: Direct output to Canvio drive (`/Volumes/Canvio/CD_Rips/`)
- **Process**: Insert → Press ENTER → Auto-copy → Auto-eject → Beep notification

#### **SCRIPT CAPABILITIES** ⚡
- **Auto-detection**: Finds mounted discs using `diskutil`
- **Smart naming**: `DiscName_YYYYMMDD_HHMMSS` format
- **Metadata preservation**: Original dates and file attributes maintained
- **Error handling**: Graceful handling of read errors and permissions
- **Safety checks**: Verifies Canvio mount before starting
- **Progress tracking**: Shows disc size, file count, available space
- **Comprehensive logging**: Full session log with timestamps

#### **DEPLOYMENT TIMELINE** ⏰
- **Current Status**: Script ready, waiting for mass transfer completion
- **Prerequisites**: Canvio drive connection to Mac Mini via thumb drive transfer
- **Estimated Start**: After current 67GB transfer operation completes
- **Expected Output**: Decades of CD-R content organized and timestamped

### 🤖 **PHASE 2: LLM-ASSISTED ORGANIZATION**

#### **PREPARATION STEPS** 🛠️
- Generate file inventories (names, sizes, types, dates)
- Create duplicate detection reports
- Categorize by file type and likely content
- Flag potential duplicates for review

#### **LLM SORTING STRATEGY** 🧠
- **Duplicate Detection**: Hash-based + content analysis
- **Content Categorization**: Photos, documents, music, videos, etc.
- **Quality Assessment**: Keep highest quality versions
- **Naming Standardization**: Consistent file naming schemes
- **Folder Structure**: Logical hierarchy creation

### 📊 **SUCCESS METRICS**
- **Files Consolidated**: Track total count and size
- **Duplicates Removed**: Space saved and cleanup efficiency  
- **Organization Quality**: Logical structure and findability
- **Storage Optimization**: Efficient use of G9 server space

---

## 🏆 **PREVIOUS VICTORY STATUS** ✅

### **Home Server Infrastructure - COMPLETED PERFECTLY**
- ✅ Security: All credentials secured with environment variables
- ✅ Monitoring: Live email alerts operational  
- ✅ Services: All systems green (Jellyfin, Plex, Pi-hole, etc.)
- ✅ Budget: $457/$531 (14% under budget!)

---

## 🚀 **NEXT STEPS**

**Immediate Actions (This Week)**:
1. 🔥 **Monitor active transfers** - **6 rsync processes** running with **121GB** completed (27% done!)
2. 📦 **Saturday Hardware Install** - 4TB M.2 SSD arriving for storage expansion
3. ⚡ **Current targets** - Photos to Import (52GB growing), iPhoto Library (22GB growing)
4. 🛡️ **Transfer completion** - Let current Canvio transfers finish naturally

**Phase 1.5 Goals - HARDWARE UPGRADE WEEKEND**:
- 💾 **Saturday Install**: 4TB M.2 PCIe Gen4 SSD installation in G9 server
- 🔧 **Drive Setup**: Format, mount, and configure new storage partition
- 📂 **Internal Migration**: Move completed transfers to new 4TB drive
- 🆓 **External Drive Liberation**: Retire 1TB USB backup drive permanently
- 🎯 **Storage Optimization**: 6TB total M.2 storage (2TB system + 4TB digital archaeology)

**Phase 2 Goals - POST-HARDWARE**:
- 🎵 **CD-R batch ripping** - Deploy Mac Mini automation to new 4TB storage
- 📀 **Thunderbolt 2TB migration** - Mac Mini → Canvio → 4TB internal transfer
- 🚀 **Complete external retirement** - Both USB drives freed for other uses
- 🤖 **LLM organization prep** - Begin inventory and categorization planning

**Current Status**: **HARDWARE BREAKTHROUGH ACHIEVED!** 💾 **4TB M.2 arriving Saturday** + **active 121GB transfers**! 🚀

### 📋 **LIVE TRANSFER STATUS** ⚡
- **Source**: Canvio (1.8TB Toshiba External) - 446GB total content  
- **Target**: `/mnt/paperless-ssd/digital_consolidation/canvio_transfer/`
- **Available Space**: **1.3TB free** on target SSD - plenty of room! ✅
- **Active Processes**: **6 rsync processes** - Photos to Import + iPhoto Library
- **Current Progress**: **121GB transferred** (+54GB growth!) - **27% complete** 📈
- **Completed Folders**: Mac Mini (34GB) ✅, Save for Migration (13GB) ✅
- **Active Folders**: Photos to Import (52GB growing), iPhoto Library (22GB growing)
- **Hardware Upgrade**: **4TB M.2 SSD arriving Saturday** - $212.15 incredible deal! 💾
- **Next Phase Ready**: **Storage expansion** → **external drive retirement** → **CD-R batch processing**

---

## 🔗 **MAC MINI HUB STRATEGY** ✅ **UPDATED APPROACH**

### **🎯 SIMPLIFIED TRANSFER METHOD** 🔄
**Decision**: Direct drive-to-drive transfers using Mac mini as hub - **MUCH MORE RELIABLE!**

**Why This Works Better**:
- ✅ **No network compatibility issues** - bypasses SMB/legacy protocol headaches
- ✅ **Mac mini accepts legacy connectors** - perfect intermediary for old drives  
- ✅ **Full transfer control** - visual progress, no dropped connections
- ✅ **Batch organization** - can sort files during transfer process

### **🔌 HARDWARE SETUP** 📦
- **Mac mini A1347**: Hub machine (macOS 10.5.8) at `192.168.0.187`
- **Source Drive**: Seagate 2TB with "boxy connector" (legacy interface)
- **Target Drive**: USB 2/3 external drive (portable to G9 server)
- **G9 Ubuntu Server**: Final destination at `192.168.0.182`

### **📋 TRANSFER WORKFLOW** 🚀
**Phase 1**: Mac Mini Hub Transfers
1. **Connect both drives** to Mac mini simultaneously
2. **Create organized folder structure** on USB target drive
3. **Transfer in priority batches** (photos → documents → media → misc)
4. **Document transfer inventory** for each batch

**Phase 2**: USB Drive → G9 Server  
1. **Physical USB drive transfer** to G9 server
2. **Mount and copy** to `/mnt/paperless-ssd/digital_consolidation/`
3. **Verify transfer integrity** before organizing
4. **Continue with LLM-assisted organization** phase

### **🎯 CURRENT STATUS**
- ✅ **Canvio Transfer**: Still in progress (5.1GB/446GB transferred)
- 🔄 **New Priority**: Seagate 2TB → USB drive transfer via Mac mini
- ✅ **Strategy Confirmed**: External-to-external method chosen for reliability

**Next Actions**: Set up Mac mini with both drives and begin systematic transfer! 📂⚡

