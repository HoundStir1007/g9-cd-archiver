# 🌐 Browser Options for Shortcuts

## 🎯 **Current Setup**

Your shortcuts now use **Chrome** by default for better performance! 🚀

### **✅ Updated Shortcuts**
- **Jellyfin Web** → Chrome
- **Pi-hole Admin** → Chrome  
- **Uptime Kuma** → Chrome
- **Jellyfin TV Mode** → Chrome (in dual display script)
- **Quick Launcher** → Chrome (for web options)

### **📋 New Chrome-Specific Shortcuts**
- **Jellyfin Chrome** - Direct Chrome access
- **Pi-hole Chrome** - Direct Chrome access
- **Uptime Kuma Chrome** - Direct Chrome access

---

## 🔄 **How to Change Browser**

### **Option 1: Use the Browser Preference Script**
```bash
./set_browser_preference.sh
```
This interactive script lets you:
- Choose between Chrome and Firefox
- See current browser usage
- Update all shortcuts at once

### **Option 2: Manual Updates**
You can manually edit any `.desktop` file on your desktop to change the browser:
```bash
# Example: Change Jellyfin Web to Firefox
sed -i 's/google-chrome/firefox/g' ~/Desktop/Jellyfin\ Web.desktop
```

---

## 🌟 **Browser Comparison**

### **Chrome (Recommended)**
✅ **Better performance** for web apps  
✅ **Improved compatibility** with modern features  
✅ **Better hardware acceleration**  
✅ **More consistent rendering**  
✅ **Faster JavaScript execution**  

### **Firefox (Alternative)**
✅ **Privacy-focused**  
✅ **Open source**  
✅ **Customizable**  
✅ **Good for older systems**  

---

## 🎯 **Current Browser Usage**

### **Desktop Shortcuts**
- **Jellyfin Web**: Chrome
- **Pi-hole Admin**: Chrome
- **Uptime Kuma**: Chrome

### **Scripts**
- **dual_display_jellyfin.sh**: Chrome
- **quick_launcher.sh**: Chrome (web options)

### **Keyboard Shortcuts**
- All web-based shortcuts use Chrome

---

## 🚀 **Quick Commands**

### **Check Current Browser Usage**
```bash
./set_browser_preference.sh
# Choose option 3 to see current usage
```

### **Switch to Firefox**
```bash
./set_browser_preference.sh
# Choose option 2
```

### **Switch to Chrome**
```bash
./set_browser_preference.sh
# Choose option 1
```

### **Test Both Browsers**
You can have both Chrome and Firefox shortcuts:
- **Jellyfin Web** (Chrome)
- **Jellyfin Chrome** (Chrome)
- **Jellyfin Firefox** (Firefox - if you create it)

---

## 💡 **Pro Tips**

1. **Chrome is recommended** for better performance with Jellyfin
2. **Firefox is good** for privacy-focused browsing
3. **You can have both** - create separate shortcuts for each browser
4. **Quick switching** - use the browser preference script
5. **Phone control** still works regardless of browser choice

---

*Your shortcuts are now optimized for Chrome but can easily be changed to Firefox if needed! 🎯* 