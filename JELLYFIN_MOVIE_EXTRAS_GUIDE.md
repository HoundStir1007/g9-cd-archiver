# 🎬 Jellyfin Movie Extras Organization Guide

## 📋 **Overview**

Jellyfin has excellent support for movie extras, just like Plex! Extras appear in a dedicated section below the main movie, making it easy to access bonus content, deleted scenes, interviews, and more.

## 🎯 **Recommended Folder Structure**

### **Option 1: Movie Folders (RECOMMENDED)** ✅
```
movies/
├── A Mighty Wind (2003)/
│   ├── A Mighty Wind (2003).mp4              # Main movie
│   ├── A Mighty Wind (2003) - deleted scenes.mp4
│   ├── A Mighty Wind (2003) - behind the scenes.mp4
│   └── A Mighty Wind (2003) - interview.mp4
├── Clueless (1995)/
│   ├── Clueless (1995).mp4                   # Main movie
│   └── Clueless (1995) - bonus feature.mp4
└── ...
```

### **Option 2: Flat Structure with Naming** 
```
movies/
├── A Mighty Wind (2003).mp4                  # Main movie
├── A Mighty Wind (2003) - deleted scenes.mp4 # Extra
├── A Mighty Wind (2003) - interview.mp4      # Extra
├── Clueless (1995).mp4                       # Main movie
└── Clueless (1995) - bonus feature.mp4       # Extra
```

## 🏷️ **Jellyfin Extras Naming Conventions**

### **Automatic Detection Patterns:**
- `Movie Name (Year) - extra.mp4`
- `Movie Name (Year) - deleted scenes.mp4`
- `Movie Name (Year) - behind the scenes.mp4`
- `Movie Name (Year) - interview.mp4`
- `Movie Name (Year) - commentary.mp4`
- `Movie Name (Year) - trailer.mp4`
- `Movie Name (Year) - tv spot.mp4`
- `Movie Name (Year) - featurette.mp4`

### **Extra Types Supported:**
- **deleted scenes** - Removed scenes from the movie
- **behind the scenes** - Making-of content
- **interview** - Cast/crew interviews
- **commentary** - Audio commentary tracks
- **trailer** - Movie trailers
- **tv spot** - TV advertisements
- **featurette** - Short bonus features
- **extra** - Generic bonus content

## 🎬 **Your Current Movies with Extras**

Based on your movie collection, here are examples that would benefit from organization:

### **A Mighty Wind (2003)**
- `A Mighty Wind.mp4` (2.3GB) - Main movie
- `A Mighty Wind (1).mp4` (500MB) - Extra
- `A Mighty Wind tv.mp4` (125MB) - TV spot

### **Organized Structure:**
```
A Mighty Wind (2003)/
├── A Mighty Wind (2003).mp4
├── A Mighty Wind (2003) - A Mighty Wind (1).mp4
└── A Mighty Wind (2003) - A Mighty Wind tv.mp4
```

## 🛠️ **Organization Script**

I've created `organize_movie_extras.sh` that will:

1. **Create movie folders** for each main movie
2. **Move main movies** into their folders
3. **Identify and move extras** with proper naming
4. **Preserve file relationships** between movies and extras

### **Running the Script:**
```bash
chmod +x organize_movie_extras.sh
./organize_movie_extras.sh
```

## 🎯 **Jellyfin Configuration**

### **Library Settings:**
1. **Go to Jellyfin Admin** → Libraries
2. **Edit Movies library**
3. **Enable "Extras"** in library settings
4. **Set "Extras" folder** to same as movies folder

### **Extras Display:**
- Extras appear **below the main movie** in Jellyfin
- **Separate section** labeled "Extras"
- **Individual play buttons** for each extra
- **Metadata support** for extra titles and descriptions

## 📊 **Benefits of Organization**

### **For Jellyfin:**
- ✅ **Automatic detection** of extras
- ✅ **Clean interface** with organized extras
- ✅ **Metadata support** for extra content
- ✅ **Easy navigation** between movie and extras

### **For File Management:**
- ✅ **Logical grouping** of related content
- ✅ **Easy backup** of complete movie packages
- ✅ **Clear organization** for future additions
- ✅ **Consistent naming** across all movies

## 🔧 **Manual Organization Steps**

If you prefer to organize manually:

### **Step 1: Create Movie Folders**
```bash
mkdir -p "/media/mark/3c5d26b1-5918-4bb2-8930-fe6fa0447fcb1/jellyfin/media/movies/A Mighty Wind (2003)"
```

### **Step 2: Move Main Movie**
```bash
mv "A Mighty Wind.mp4" "A Mighty Wind (2003)/A Mighty Wind (2003).mp4"
```

### **Step 3: Move Extras**
```bash
mv "A Mighty Wind (1).mp4" "A Mighty Wind (2003)/A Mighty Wind (2003) - A Mighty Wind (1).mp4"
mv "A Mighty Wind tv.mp4" "A Mighty Wind (2003)/A Mighty Wind (2003) - A Mighty Wind tv.mp4"
```

## 🎉 **Expected Results**

After organization, in Jellyfin you'll see:

### **Movie Page Layout:**
- **Main movie** at the top with play button
- **Movie metadata** (title, year, description, etc.)
- **Extras section** below with:
  - "A Mighty Wind (2003) - A Mighty Wind (1)" (play button)
  - "A Mighty Wind (2003) - A Mighty Wind tv" (play button)

### **File Structure:**
```
movies/
├── A Mighty Wind (2003)/
│   ├── A Mighty Wind (2003).mp4
│   ├── A Mighty Wind (2003) - A Mighty Wind (1).mp4
│   └── A Mighty Wind (2003) - A Mighty Wind tv.mp4
└── [other movies...]
```

---

**Last Updated**: January 28, 2025  
**Status**: Ready to organize movie extras  
**Next Focus**: Run organization script and update Jellyfin library 