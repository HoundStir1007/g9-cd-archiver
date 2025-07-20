# 🚀 **NCdu Usage Guide** - Your TreeSize Pro for Ubuntu

## **📊 What is NCdu?**
**NCdu** (NCurses Disk Usage) is an interactive disk usage analyzer - think TreeSize Pro for the command line! It provides:
- **Interactive navigation** through directories
- **Visual size representation** with ASCII bars
- **Real-time scanning** and analysis
- **File deletion** capabilities (with safety confirmations)

## **🎯 Quick Start Commands**

### **🔍 Basic Scans**:
```bash
# Scan your home directory (safest start)
ncdu ~

# Scan current directory
ncdu .

# Scan root filesystem (system-wide analysis)
sudo ncdu /

# Scan specific directory
ncdu /home/mark/Desktop
```

### **⚙️ Advanced Options**:
```bash
# Exclude system files and caches
ncdu ~ --exclude-kernfs --exclude-caches

# Export results to file
ncdu -o disk_report.txt ~

# Read-only mode (safer)
ncdu -r ~

# Follow symlinks
ncdu -L ~
```

## **🎮 Interactive Controls**

### **Navigation**:
- **↑/↓ arrows**: Navigate up/down directories
- **Enter**: Drill down into selected directory
- **← (left arrow)**: Go back to parent directory
- **→ (right arrow)**: Enter selected directory

### **Actions**:
- **d**: Delete selected file/directory (with confirmation)
- **?**: Show help screen
- **q**: Quit ncdu
- **r**: Refresh current directory

### **Display**:
- **g**: Toggle between human-readable and exact sizes
- **c**: Toggle between showing count and size
- **a**: Toggle between showing apparent and actual size

## **📈 Visual Output Example**

```
ncdu 1.19 ~ Use the arrow keys to navigate, press ? for help
--- /home/mark ---------------------------------------------------------------
    2.6 GiB [##################] /home/mark
    1.6 GiB [##########] Desktop
    791 MiB [#####] snap
    183 MiB [##] Applications
      1.5 MiB [ ] Pictures
      168 KiB [ ] private_keys
       28 KiB [ ] Downloads
        4.0 KiB [ ] Videos
        4.0 KiB [ ] Templates
        4.0 KiB [ ] Public
        4.0 KiB [ ] paperless-ngx
        4.0 KiB [ ] Music
        4.0 KiB [ ] Documents
```

## **🎯 Recommended Usage Patterns**

### **1. Home Directory Analysis**:
```bash
# Start here - safe and informative
ncdu ~
```

### **2. Workspace Analysis**:
```bash
# Check your current project
ncdu /home/mark/Desktop/home_server_research
```

### **3. System-Wide Analysis**:
```bash
# Full system scan (requires sudo)
sudo ncdu / --exclude-kernfs --exclude-caches
```

### **4. Specific Directory Deep Dive**:
```bash
# Focus on specific areas
ncdu /var/log
ncdu /tmp
ncdu ~/.cache
```

## **🔧 Advanced Features**

### **Export Results**:
```bash
# Save scan results for later analysis
ncdu -o home_scan.txt ~

# Import previous scan
ncdu -f home_scan.txt
```

### **Exclude Patterns**:
```bash
# Exclude specific file types
ncdu ~ --exclude "*.log" --exclude "*.tmp"

# Exclude from file
ncdu ~ --exclude-from exclude_patterns.txt
```

### **Batch Mode**:
```bash
# Non-interactive scan with output
ncdu -r -o report.txt ~
```

## **🎯 Your Root Drive Analysis Commands**

### **Quick System Check**:
```bash
# Safe system scan
sudo ncdu / --exclude-kernfs --exclude-caches

# Focus on user directories
ncdu /home/mark

# Check system directories
sudo ncdu /var /usr /tmp
```

### **Cleanup Discovery**:
```bash
# Find large files in home
ncdu ~

# Check temp directories
ncdu /tmp
ncdu ~/.cache

# Check snap storage
ncdu /var/snap
```

## **🚨 Safety Tips**

### **Before Using**:
1. **Start with home directory**: `ncdu ~`
2. **Use read-only mode**: `ncdu -r ~`
3. **Exclude system files**: `--exclude-kernfs`

### **When Deleting**:
1. **Always confirm**: NCdu asks before deleting
2. **Start small**: Delete individual files first
3. **Test with safe directories**: Try `~/.cache` first

### **Best Practices**:
1. **Scan before cleanup**: Know what you're deleting
2. **Use read-only first**: `ncdu -r` to explore safely
3. **Export results**: Save scans for comparison

## **🎯 Your Action Plan**

### **Phase 1: Exploration**:
```bash
# 1. Explore your home directory
ncdu ~

# 2. Check your workspace
ncdu /home/mark/Desktop

# 3. Look at system directories
sudo ncdu /var /tmp
```

### **Phase 2: Cleanup**:
```bash
# 1. Check cache directories
ncdu ~/.cache
ncdu /tmp

# 2. Look for large files
ncdu ~ --exclude "*.log"

# 3. System cleanup
sudo ncdu /var/log
```

### **Phase 3: Monitoring**:
```bash
# Export baseline
ncdu -o baseline_scan.txt ~

# Compare later
ncdu -f baseline_scan.txt
```

---

**🎉 You now have TreeSize Pro power in Ubuntu!** Use `ncdu ~` to start exploring your disk usage interactively. The visual bars make it easy to spot the biggest space hogs! 🚀 