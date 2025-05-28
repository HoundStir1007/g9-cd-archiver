# Swift Paperless Optimization Guide 📱📄

*Optimized for bulk document migration - Wednesday SSD setup*

## 🎯 **Pre-Migration Setup (Do This Now)**

### **1. Swift Paperless App Configuration**
```
Server URL: http://100.91.157.19:8000
Username: [your admin username]
Password: [your admin password]
```

### **2. Paperless-ngx Server Optimization**
Before Wednesday's migration, optimize these settings via Django Admin:

**Document Processing Settings:**
- **OCR Language**: Set to your primary language(s)
- **Filename Format**: Already configured as `{created_year}-{created_month:02d}-{created_day:02d}_{correspondent}_{title}`
- **Auto-matching**: Enable for correspondents, document types, and tags

**Performance Settings:**
- **Parallel Tasks**: Set to 2-3 (optimal for G9 hardware)
- **OCR Mode**: "redo" for best quality on important docs
- **Thumbnail Quality**: "high" for better mobile preview

### **3. Document Organization Strategy**
Create these basic categories BEFORE bulk scanning:

**Document Types:**
- Bills & Utilities
- Financial Statements  
- Medical Records
- Legal Documents
- Receipts
- Manuals & Warranties
- Personal Documents

**Correspondents:**
- Major utilities (electric, gas, water)
- Banks and financial institutions
- Insurance companies
- Healthcare providers
- Government agencies

**Tags:**
- Year-based: 2023, 2024, 2025
- Status: pending, processed, archived
- Priority: important, urgent, reference

## 📱 **Swift Paperless Bulk Scanning Workflow**

### **Optimal Scanning Settings**
```
Resolution: 300 DPI (balance of quality/speed)
Color Mode: Auto (color for important docs, B&W for text)
File Format: PDF (best for Paperless-ngx)
Multi-page: Enable for document batches
Auto-crop: Enable for consistent edges
```

### **Bulk Scanning Strategy**

**Phase 1: High-Priority Documents (Day 1)**
- Financial statements (last 2 years)
- Tax documents
- Insurance policies
- Medical records

**Phase 2: Regular Documents (Day 2-3)**
- Utility bills
- Receipts and warranties
- Personal correspondence
- Reference materials

**Phase 3: Archive Documents (Ongoing)**
- Older documents
- Manuals and guides
- Historical records

### **Scanning Session Optimization**

**Preparation:**
1. **Sort documents** by type before scanning
2. **Remove staples/clips** for better scan quality
3. **Group similar documents** for batch processing
4. **Have good lighting** - natural light is best

**Scanning Technique:**
1. **Batch similar documents** (10-20 pages max per session)
2. **Use consistent naming** while scanning
3. **Preview each page** before finalizing
4. **Upload immediately** to avoid storage issues

**Quality Control:**
- **Check OCR accuracy** on first few documents
- **Adjust lighting/angle** if text isn't clear
- **Rescan blurry pages** immediately
- **Verify upload success** before deleting originals

## 🔧 **Swift Paperless App Optimization**

### **App Settings for Bulk Work**
```
Auto-upload: Enable
Upload quality: High
Batch size: 10-15 documents
Background upload: Enable
Cellular upload: Disable (use WiFi only)
```

### **Workflow Shortcuts**
1. **Create document templates** for common types
2. **Use voice-to-text** for quick titles
3. **Set up quick tags** for common categories
4. **Enable auto-date detection** from document content

### **Storage Management**
- **Clear app cache** before big sessions
- **Monitor phone storage** during bulk scanning
- **Upload frequently** to avoid local storage issues
- **Delete local copies** after successful upload

## 📊 **Progress Tracking**

### **Daily Goals**
- **Day 1 (Wednesday)**: 50-75 high-priority documents
- **Day 2**: 100-150 regular documents  
- **Day 3**: 200+ archive documents
- **Ongoing**: 20-30 documents per session

### **Quality Metrics**
- **OCR Accuracy**: >95% for typed documents
- **Upload Success**: 100% (retry failed uploads)
- **Proper Categorization**: All documents tagged/typed
- **Searchability**: Test search function regularly

## 🚀 **Advanced Tips**

### **Batch Processing Tricks**
1. **Use document separators** (colored paper) between different types
2. **Scan cover sheets** with document info for complex batches
3. **Create naming conventions** before starting
4. **Use timer** to maintain steady pace (avoid fatigue)

### **Mobile Optimization**
- **Close other apps** during scanning sessions
- **Enable Do Not Disturb** to avoid interruptions
- **Use airplane mode + WiFi** to reduce cellular interference
- **Keep phone plugged in** during long sessions

### **Error Recovery**
- **Save failed uploads** to retry later
- **Keep original documents** until verification complete
- **Document any OCR errors** for manual correction
- **Test search functionality** after each batch

## 📋 **Wednesday Migration Checklist**

### **Morning Setup (30 minutes)**
- [ ] Boot G9 into Ubuntu
- [ ] Verify Paperless-ngx is running
- [ ] Test Swift Paperless connection
- [ ] Configure document categories
- [ ] Set up workspace with good lighting

### **Scanning Session (2-4 hours)**
- [ ] Start with 10 test documents
- [ ] Verify OCR quality and upload success
- [ ] Begin bulk scanning by priority
- [ ] Take breaks every 45 minutes
- [ ] Monitor storage and upload progress

### **Evening Verification (30 minutes)**
- [ ] Verify all uploads successful
- [ ] Test search functionality
- [ ] Check document categorization
- [ ] Plan next day's batch
- [ ] Backup any local files

## 🎯 **Success Metrics**

**By End of Week:**
- 500+ documents scanned and processed
- 95%+ OCR accuracy rate
- All documents properly categorized
- Search functionality working perfectly
- Mobile workflow optimized for daily use

**Long-term Goals:**
- Daily document processing routine
- Zero paper backlog
- Efficient mobile scanning workflow
- Automated backup and organization

---

*Ready for Wednesday's SSD migration and bulk document processing!* 🚀📄 