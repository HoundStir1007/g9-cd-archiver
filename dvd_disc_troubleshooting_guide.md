# 🔧 DVD Disc Reading Troubleshooting Guide

## 🎯 **ISSUE**: DVD spins but doesn't appear in desktop sidebar

**Your exact symptom**: Disc spins up when inserted, eventually stops, but no disc icon appears in file manager sidebar like with other discs.

---

## 🚀 **QUICK DIAGNOSTIC STEPS**

### **Step 1: Check if drive sees the disc at all**
```bash
# Check if drive detects ANY disc
lsblk | grep sr0

# Check dmesg for disc insertion messages
dmesg | tail -20 | grep -i "dvd\|cdrom\|sr0"

# Try to get basic disc info
sudo blkid /dev/sr0
```

### **Step 2: Test manual mount attempts**
```bash
# Create temporary mount point
sudo mkdir -p /mnt/dvd_test

# Try mounting as various formats
sudo mount -t iso9660 /dev/sr0 /mnt/dvd_test
# OR try as UDF format
sudo mount -t udf /dev/sr0 /mnt/dvd_test

# Check if anything mounted
ls -la /mnt/dvd_test

# Clean up when done
sudo umount /mnt/dvd_test 2>/dev/null
sudo rmdir /mnt/dvd_test
```

### **Step 3: Use your existing disc detection tools**
Since you already have the G9 ripper scripts, let's use their detection logic:

```bash
# Use the detection from your g9_cd_ripper.sh
cdparanoia -Q 2>&1

# Check DVD with HandBrake scan
HandBrakeCLI -i /dev/sr0 -t 0 2>&1 | head -10
```

---

## 🔍 **COMMON CAUSES & SOLUTIONS**

### **1. 🔐 Copy Protection (CSS/Region Lock)**
**Symptoms**: Drive spins, then stops, no mounting
**Solution**: 
```bash
# Install libdvdcss2 if not already present
sudo apt update
sudo apt install libdvdcss2

# Try your existing DVD ripper which handles CSS
./g9_dvd_ripper.sh
```

### **2. 📀 Disc Format Issues**
**Possible formats causing problems**:
- **DVD+R/DVD-R**: Older finalization issues
- **DVD-RAM**: Not all drives support
- **Dual-layer discs**: Compatibility problems
- **Foreign region DVDs**: Region lock issues

**Test**:
```bash
# Check what format the drive thinks it is
sudo dvd+rw-mediainfo /dev/sr0
```

### **3. 🧹 Physical Disc Issues**
**Check for**:
- **Scratches**: Especially on data side
- **Fingerprints**: Clean with soft cloth, radial motion
- **Label side damage**: Can affect data integrity
- **Warping**: Disc not perfectly flat

**Quick cleaning**:
- Use soft, lint-free cloth
- Clean from center outward (NOT circular motion)
- Use isopropyl alcohol if needed

### **4. ⚙️ Drive Compatibility**
**Your USB optical drive might**:
- Not support this specific disc format
- Have firmware issues with certain brands
- Need lens cleaning

**Test with your existing tools**:
```bash
# Use your DVD salvage script for problematic discs
./salvage_dvd_content.sh
```

---

## 🛠️ **ADVANCED TROUBLESHOOTING**

### **Option 1: Force Read with ddrescue**
For seriously damaged discs:
```bash
# Install ddrescue if needed
sudo apt install gddrescue

# Create disc image bypassing errors
sudo ddrescue -d -r3 /dev/sr0 disc_image.iso rescue.log

# Mount the image instead
sudo mount -o loop disc_image.iso /mnt/dvd_test
```

### **Option 2: Use your existing salvage workflow**
Your `dvd_salvage_summary.md` shows you've handled damaged discs before:
```bash
# Try the salvage script which has multiple extraction methods
./salvage_dvd_content.sh

# Or use dvdbackup directly (what your script uses)
sudo dvdbackup -i /dev/sr0 -o /tmp/dvd_test -M
```

### **Option 3: Drive-specific commands**
```bash
# Reset the drive
sudo eject /dev/sr0
sleep 2
# Reinsert disc manually

# Check drive capabilities
sudo cdrdao device-info /dev/sr0

# Try reading as data CD instead of DVD
sudo isoinfo -d -i /dev/sr0
```

---

## 🎯 **SPECIFIC TO YOUR SETUP**

Based on your existing scripts, try this workflow:

### **Use Your G9 Detection Logic**
```bash
# From your g9_cd_ripper.sh detect_disc_type function
# Check if it's detected as audio, data, or unknown
sleep 2  # Let disc settle
if cdparanoia -Q 2>&1 | grep -q "track"; then
    echo "Detected as audio CD"
elif sudo mount -o ro /dev/sr0 /mnt 2>/dev/null; then
    echo "Detected as data disc"
    sudo umount /mnt 2>/dev/null
else
    echo "Unknown or problematic disc"
fi
```

### **Try Your HandBrake Detection**
```bash
# From your g9_dvd_ripper.sh
# This will tell you if it's a video DVD
HandBrakeCLI -i /dev/sr0 -t 0 --min-duration 10 2>&1 | grep -E "(^\+|duration|size)"
```

---

## 🚨 **WHEN ALL ELSE FAILS**

### **Hardware Issues**
1. **Try the disc in another drive** (computer, standalone player)
2. **Try other discs in your drive** (to isolate drive vs. disc)
3. **USB connection**: Try different USB port, check power

### **Last Resort: Professional Recovery**
If the disc contains irreplaceable content:
- Consider professional data recovery services
- Some have specialized equipment for damaged optical media

---

## 📝 **NEXT STEPS**

1. **Start with Step 1 diagnostics** above
2. **Try the manual mount** in Step 2  
3. **Use your existing g9_dvd_ripper.sh** - it has good error handling
4. **If still failing**, try the salvage script approach

**Report back with**:
- Output from `lsblk | grep sr0`
- Any error messages from mount attempts
- Whether other discs work in the same drive

This should help identify whether it's a disc problem, format issue, or drive compatibility problem! 🔍✨ 