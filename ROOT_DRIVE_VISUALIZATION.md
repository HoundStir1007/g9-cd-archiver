# 🖥️ **ROOT DRIVE SPACE VISUALIZATION** - 56GB Total

## 📊 **DISK SPACE BREAKDOWN**

```
┌─────────────────────────────────────────────────────────────────┐
│                    ROOT DRIVE (56GB)                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │   SYSTEM    │ │    USER     │ │   CACHE     │            │
│  │   (35GB)    │ │   (2.6GB)  │ │   (1.4GB)  │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │   LOGS      │ │   TEMP      │ │ AVAILABLE   │            │
│  │   (286MB)   │ │   (461MB)   │ │  (5.7GB)   │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 **DETAILED BREAKDOWN**

### **🔧 SYSTEM FILES (35GB - 62%)**
```
/usr/lib      → 3.0GB  (Libraries & Dependencies)
/usr/share    → 1.9GB  (Shared Data & Documentation)
/usr/bin      → 649MB  (Executables)
/usr/src      → 328MB  (Source Code)
/var/lib      → 2.1GB  (Application Data)
/usr/libexec  → 118MB  (System Executables)
/usr/sbin     → 95MB   (System Binaries)
/usr/include  → 29MB   (Header Files)
```

### **👤 USER FILES (2.6GB - 5%)**
```
/home/mark/Desktop     → 1.6GB  (Your Workspace)
/home/mark/snap        → 791MB  (Firefox + Snap Apps)
/home/mark/Applications → 183MB  (Cursor AppImage)
/home/mark/Pictures    → 1.5MB  (Images)
```

### **🗂️ CACHE & TEMP (1.4GB - 2.5%)**
```
/var/cache   → 133MB  (Package Cache)
/var/log     → 286MB  (System Logs)
/tmp         → 461MB  (Temporary Files)
/var/snap    → 5.7MB  (Snap Cache)
```

### **💾 AVAILABLE SPACE (5.7GB - 10%)**
- **Current free space**: 5.7GB
- **Critical threshold**: <2GB
- **Status**: ⚠️ **TIGHT BUT MANAGEABLE**

## 🧹 **CLEANUP OPPORTUNITIES**

### **🟢 SAFE CLEANUP (Immediate)**
```
Firefox Snap        → 778MB  (Remove: sudo snap remove firefox)
Temp Files          → 461MB  (Clear: sudo rm -rf /tmp/*)
User Cache          → 100MB  (Clear: rm -rf ~/.cache/*)
Package Cache       → 133MB  (Clear: sudo apt clean)
Total Safe Cleanup  → 1.5GB  (27% space recovery)
```

### **🟡 MODERATE CLEANUP (When convenient)**
```
Workspace Move      → 1.6GB  (Move to storage drive)
Old Logs           → 200MB  (Clear: sudo journalctl --vacuum-time=7d)
Total Moderate     → 1.8GB  (32% space recovery)
```

### **🔴 AGGRESSIVE CLEANUP (Last resort)**
```
Snap Apps          → 800MB  (Remove unused snaps)
Source Code        → 328MB  (Remove: sudo apt autoremove --purge)
Total Aggressive   → 1.1GB  (20% space recovery)
```

## 📈 **VISUAL PIE CHART**

```
                    ROOT DRIVE USAGE
                    
    ┌─────────────────────────────────────────┐
    │ ██████████████████████████████████████ │ 62% System
    │ ██████████████████████████████████████ │ (35GB)
    │                                         │
    │ ██████████████████████████████████████ │ 10% Available
    │ ██████████████████████████████████████ │ (5.7GB)
    │                                         │
    │ ██████████████████████████████████████ │ 5% User Files
    │ ██████████████████████████████████████ │ (2.6GB)
    │                                         │
    │ ██████████████████████████████████████ │ 2.5% Cache
    │ ██████████████████████████████████████ │ (1.4GB)
    │                                         │
    │ ██████████████████████████████████████ │ 20% Other
    │ ██████████████████████████████████████ │ (11.3GB)
    └─────────────────────────────────────────┘
```

## 🛠️ **UBUNTU TOOLS LIKE TREESIZE PRO**

### **1. GUI Tools (Install with sudo apt install)**:
```bash
# Disk Usage Analyzer (like TreeSize Pro)
baobab

# File Manager with disk usage
sudo apt install filelight
```

### **2. Command Line Tools**:
```bash
# NCurses Disk Usage (interactive)
ncdu

# Tree view with sizes
tree -h --du

# Simple disk usage
du -h | sort -hr | head -20
```

### **3. Real-time Monitoring**:
```bash
# Watch disk usage changes
watch -n 1 'df -h /'

# Monitor specific directories
watch -n 5 'du -sh /home/mark/* /var/* 2>/dev/null'
```

## 🎯 **RECOMMENDED ACTION PLAN**

### **Phase 1: Immediate (Safe)**
1. **Remove Firefox snap** (778MB)
2. **Clear temp files** (461MB)
3. **Clear user cache** (100MB)

### **Phase 2: When Convenient**
1. **Move workspace** to storage drive (1.6GB)
2. **Clear old logs** (200MB)

### **Phase 3: Long-term**
1. **Install ncdu** for better visualization
2. **Set up monitoring** for proactive cleanup
3. **Consider workspace relocation** to storage drive

---

**📊 SUMMARY**: Your 56GB drive is well-utilized but manageable. Focus on the 1.5GB of safe cleanup first, then consider workspace relocation for the biggest space win! 🚀 