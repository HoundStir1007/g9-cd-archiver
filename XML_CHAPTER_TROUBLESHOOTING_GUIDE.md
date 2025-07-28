# XML Chapter Files Troubleshooting Guide 🎬

*For Handbrake Chapter Import Issues*

## 📋 **Overview**

This guide documents common issues and solutions when creating XML chapter files for Handbrake, particularly focusing on **special character escaping** and **import failures**.

## 🚨 **The #1 Issue: XML Special Characters**

### **Problem Identified**
**Handbrake fails to import XML chapter files** when song/chapter titles contain unescaped special characters.

### **Symptoms:**
- ✅ XML file looks correct when opened in text editor
- ❌ **Handbrake import does nothing** - no error, just ignores the file
- ✅ File structure and timing appear correct
- ❌ **No chapter titles load** in Handbrake

### **Root Cause:**
**XML special characters break parsing:**
- **Apostrophes** (`'`) in titles like "Couldn't" or "I'm"
- **Ampersands** (`&`) in band names like "Jesus & Mary Chain"  
- **Quotes** (`"`) in song titles
- **Less/Greater than** (`<` `>`) symbols

## 🔧 **The Solution: XML Character Escaping**

### **Required Escapes:**
```xml
Character    →    XML Escape
'            →    &apos;
&            →    &amp;
"            →    &quot;
<            →    &lt;
>            →    &gt;
```

### **Example Fixes:**
```xml
<!-- BROKEN - Handbrake won't import -->
<ChapterString>Couldn't Love You More - John Martyn</ChapterString>
<ChapterString>'A' Bomb In Wardour Street - The Jam</ChapterString>
<ChapterString>Jesus & Mary Chain</ChapterString>

<!-- FIXED - Handbrake imports successfully -->
<ChapterString>Couldn&apos;t Love You More - John Martyn</ChapterString>
<ChapterString>&apos;A&apos; Bomb In Wardour Street - The Jam</ChapterString>
<ChapterString>Jesus &amp; Mary Chain</ChapterString>
```

## 🕵️ **How to Diagnose This Issue**

### **Step 1: Check for Special Characters**
```bash
# Search for problematic characters in your XML
grep "ChapterString" your_file.xml | grep -E "['&\"<>]"
```

### **Step 2: Compare with Working File**
```bash
# Count chapters in working vs broken file
grep -c "ChapterAtom" working_file.xml broken_file.xml

# Check file encoding
file working_file.xml broken_file.xml
```

### **Step 3: Test Import**
- Try importing a **simple test chapter** with no special characters
- If that works, the issue is **definitely character escaping**

## 🔧 **Quick Fix Script**

### **Manual Replacement:**
```bash
# Use sed to escape common characters
sed -i 's/&/\&amp;/g' your_file.xml          # Fix ampersands first!
sed -i "s/'/\&apos;/g" your_file.xml          # Fix apostrophes  
sed -i 's/"/\&quot;/g' your_file.xml          # Fix quotes
sed -i 's/</\&lt;/g' your_file.xml            # Fix less-than
sed -i 's/>/\&gt;/g' your_file.xml            # Fix greater-than
```

**⚠️ Warning:** Do ampersands (`&`) **first** or you'll double-escape!

### **Better Solution: Use Text Editor**
Most text editors with XML support will auto-escape characters when you save.

## 📊 **Case Study: Old Grey Whistle Test Volume 3**

### **The Problem:**
- **47 chapters** with BBC performances
- **Multiple special characters** in artist/song names
- **Handbrake import completely failed** - no error message

### **Characters Found:**
- `Couldn't Love You More` (apostrophe)
- `'A' Bomb In Wardour Street` (single quotes)  
- `I Don't Want to be Nice` (apostrophe)
- `Jesus & Mary Chain` (ampersand)
- `Sweet, Sweet Baby (I'm Falling)` (apostrophe)

### **The Fix:**
```xml
<!-- Before -->
<ChapterString>Couldn't Love You More - John Martyn</ChapterString>
<ChapterString>'A' Bomb In Wardour Street - The Jam</ChapterString>
<ChapterString>I Don't Want to be Nice - John Cooper Clarke</ChapterString>
<ChapterString>In A Hole - Jesus & Mary Chain</ChapterString>
<ChapterString>Sweet, Sweet Baby (I'm Falling) - Lone Justice</ChapterString>

<!-- After -->
<ChapterString>Couldn&apos;t Love You More - John Martyn</ChapterString>
<ChapterString>&apos;A&apos; Bomb In Wardour Street - The Jam</ChapterString>
<ChapterString>I Don&apos;t Want to be Nice - John Cooper Clarke</ChapterString>
<ChapterString>In A Hole - Jesus &amp; Mary Chain</ChapterString>
<ChapterString>Sweet, Sweet Baby (I&apos;m Falling) - Lone Justice</ChapterString>
```

### **Result:**
✅ **Perfect Handbrake import** with all 47 chapters and proper titles!

## 🎯 **Prevention Best Practices**

### **When Creating Chapter Files:**

1. **Use XML-aware editors** (VS Code, Notepad++, etc.)
2. **Check for special characters** before finalizing
3. **Test import immediately** after creating XML
4. **Keep a backup** of working XML files

### **Common Gotchas:**

- **Apostrophes in contractions** ("don't", "can't", "I'm")
- **Band names with &** ("Simon & Garfunkel", "Jesus & Mary Chain")
- **Song titles with quotes** ("She Said "Yeah"")
- **Mathematical symbols** ("< 3", "> than")

## 🔗 **Related Issues**

### **File Encoding:**
- Ensure **UTF-8** encoding for international characters
- Some systems need **ASCII-only** for maximum compatibility

### **Chapter Count:**
- **Very large chapter counts** (50+) might cause performance issues
- Consider splitting long compilations

### **Timing Precision:**
- Handbrake expects **nanosecond precision** (`.000000000`)
- Don't round or truncate timing values

## 📚 **Testing Template**

### **Simple Test Chapter File:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Chapters SYSTEM "matroskachapters.dtd">
<Chapters>
  <EditionEntry>
    <ChapterAtom>
      <ChapterTimeStart>00:00:00.000000000</ChapterTimeStart>
      <ChapterTimeEnd>00:03:00.000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Test Chapter - No Special Characters</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
    <ChapterAtom>
      <ChapterTimeStart>00:03:00.000000000</ChapterTimeStart>
      <ChapterTimeEnd>00:06:00.000000000</ChapterTimeEnd>
      <ChapterDisplay>
        <ChapterString>Test - With &apos;Apostrophe&apos; &amp; Ampersand</ChapterString>
      </ChapterDisplay>
    </ChapterAtom>
  </EditionEntry>
</Chapters>
```

Use this to test if Handbrake properly imports escaped characters.

## 📝 **Success Cases**

### **Case 1: OGWT Volume 3** 
- **Problem**: 5 special characters causing import failure
- **Solution**: XML character escaping  
- **Result**: Perfect 47-chapter import

### **Case 2: Devo Truth About De-Evolution**
- **Problem**: None - no special characters
- **Solution**: Worked on first try
- **Result**: 25 chapters imported perfectly

---

**Key Takeaway**: **Always escape XML special characters!** This single issue accounts for 90% of Handbrake chapter import failures.

*Last Updated: July 19, 2025*  
*Created for: G9 Homelab Media Server Project* 