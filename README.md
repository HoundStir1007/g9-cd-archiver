# Home Server Project 🏠🖥️

This project documents the successful implementation of a personal home server setup using a GMKtec NucBox G9 mini PC running Ubuntu 24.10.

## 🎉 **PROJECT STATUS: UBUNTU-FOCUSED ARCHITECTURE OPERATIONAL!** ✅

**Status as of 2025-06-07:** All services running reliably on Ubuntu with excellent power outage recovery performance!

## 📋 Project Status

### ✅ **COMPLETED PHASES**

#### Phase 1: Core Infrastructure ✅
- ✅ GMKtec NucBox G9 mini PC purchased and configured
- ✅ Ubuntu 24.10 as primary server platform
- ✅ Network infrastructure with UPS protection and switch expansion
- ✅ Tailscale remote access configured and operational
- ✅ System security implemented (UFW, automatic updates)

#### Phase 2: Document Management ✅ 🎉
- ✅ **PAPERLESS-NGX FULLY OPERATIONAL**
  - ✅ Document processing with OCR and Tika integration
  - ✅ Mobile scanning via Swift Paperless iPhone app
  - ✅ Web interface accessible via both local and Tailscale networks
  - ✅ Samsung SSD storage with automated backup system
  - ✅ Django Admin interface for advanced configuration
  - ✅ Consume folder workflow for automatic document processing

#### Phase 3: Media Management ✅ 🎬
- ✅ **JELLYFIN MEDIA SERVER OPERATIONAL**
  - ✅ Hardware-accelerated transcoding (Intel Quick Sync)
  - ✅ SMB file sharing for drag-and-drop media management
  - ✅ Multiple media libraries (movies, TV, home videos, music, books)
  - ✅ Mobile apps for streaming anywhere via Tailscale

### 🎯 **CURRENT FOCUS: Optimization & Enhancement**
- 📱 **ACTIVE:** PhotoSort workflow for media organization
- 🛡️ **PLANNED:** Pi-hole setup for network-wide ad blocking
- 📚 **FUTURE:** Personal wiki/knowledge base implementation
- 🔄 **FUTURE:** Enhanced monitoring and automation

## 💰 Budget Summary
- **Total Spent:** $457 (including PhotoSort app)
- **Budget Status:** ✅ 14% under maximum budget  
- **Hardware Phase:** ✅ COMPLETE - All planned purchases finished
- **Value Achievement:** ✅ Enterprise-grade home server with media management

## 🖥️ System Configuration

### Hardware (Final)
- **Server:** GMKtec NucBox G9 (Intel Twin Lake N150, 12GB DDR5, 512GB + 2TB NVMe)
- **Storage:** Samsung 990 EVO 2TB SSD (enterprise endurance)
- **Power:** APC BN450M UPS (270W protection) - **POWER OUTAGE TESTED ✅**
- **Network:** 8-port switch (media center) + 5-port switch (bedroom)

### Network Access
- **Local Network:** 
  - Paperless-ngx: http://192.168.0.178:8000
  - Jellyfin: http://192.168.0.178:8096
- **Remote Access (Tailscale):**
  - Paperless-ngx: http://100.91.157.19:8000  
  - Jellyfin: http://100.91.157.19:8096
- **SSH Management:** `ssh gmk@100.91.157.19`
- **SMB File Sharing:** `smb://100.91.157.19` (Finder integration)

### Operating System
- **Ubuntu 24.10:** Primary server platform (Tailscale IP: 100.91.157.19)
  - All services and monitoring consolidated on Ubuntu
  - Proven reliability during power outages
  - Simplified architecture without dual-OS complexity

## 🗂️ Project Structure

### Active Documentation
- [`home_server_plan.md`](home_server_plan.md) - Overall project plan and current status
- [`budget.md`](budget.md) - Complete budget breakdown including PhotoSort
- [`baton.md`](baton.md) - Session-to-session progress tracking
- [`power_outage_report.md`](power_outage_report.md) - Infrastructure validation results

### Media Strategy Documentation
- [`DUAL_SERVER_MEDIA_STRATEGY.md`](DUAL_SERVER_MEDIA_STRATEGY.md) - Plex + Jellyfin approach
- [`gmail_organization_guide.md`](gmail_organization_guide.md) - Email workflow preparation

### Configuration Files
- [`network_configuration.md`](network_configuration.md) - Complete network setup details
- [`tailscale_configuration.md`](tailscale_configuration.md) - Remote access configuration

### Archived Documentation
- [`archive/`](archive/README.md) - Completed setup guides and checklists

## 🚀 What's Working Right Now

### Document Management (Production Ready)
- **Document Upload:** Web interface and mobile app
- **OCR Processing:** Automatic text recognition and searchability
- **Remote Access:** Secure access from anywhere via Tailscale
- **Mobile Scanning:** iPhone app integration for document capture
- **Auto-Processing:** Consume folder for batch document import
- **Backup System:** Automated daily backups with 100% reliability

### Media Management (Production Ready)
- **Media Server:** Jellyfin with hardware transcoding
- **File Management:** SMB sharing with native Finder integration
- **Mobile Streaming:** iOS/Android apps with remote access
- **Content Organization:** Movies, TV, home videos, music, books libraries

### Infrastructure
- **Power Protection:** UPS provides automatic recovery from outages ✅ TESTED
- **Network Coverage:** Comprehensive gigabit ethernet throughout home
- **Ubuntu Platform:** Simplified, reliable server architecture
- **Remote Management:** SSH access for system administration

## 📋 Quick Reference

### Accessing Your System
```bash
# Remote SSH access (Ubuntu)
ssh gmk@100.91.157.19

# Web interfaces
# Paperless-ngx: http://100.91.157.19:8000 (or http://192.168.0.178:8000)
# Jellyfin: http://100.91.157.19:8096 (or http://192.168.0.178:8096)

# SMB file sharing (macOS Finder)
# Connect to: smb://100.91.157.19

# Check system status
docker ps                    # Container status
tailscale status            # Network connectivity
uptime                      # System stability
```

### Key File Locations
- **Paperless Data:** Samsung SSD `/mnt/paperless-ssd/paperless/`
- **Jellyfin Data:** Samsung SSD `/mnt/paperless-ssd/jellyfin/`
- **Media Libraries:** `/jellyfin-media/` (via SMB)
- **Backup Location:** USB drive `/media/paperless-storage/`

## 🔄 Development Workflow

This project uses a "Pass the Baton" system documented in [`baton.md`](baton.md) to track progress between work sessions and maintain continuity across different development phases.

## 📞 Support & Resources

- [Paperless-ngx Documentation](https://docs.paperless-ngx.com/)
- [Jellyfin Documentation](https://jellyfin.org/docs/)
- [Tailscale Documentation](https://tailscale.com/kb/)
- [PhotoSort App](https://apps.apple.com/us/app/photosort-size-quality-sort/id6739038077)

## ⚠️ Important Notes

- **Power:** G9 uses specific USB-C adapter - do not substitute
- **Architecture:** Ubuntu-only approach for simplified operations
- **Network:** Two 2.5GbE ports for high-performance connections
- **Storage:** Samsung SSD with automated backup protection
- **Access:** System accessible remotely via Tailscale from anywhere

## 🎯 Project Success Metrics

✅ **Budget:** Completed 14% under maximum budget  
✅ **Functionality:** 100% of document + media management goals achieved  
✅ **Reliability:** Power outage tested - perfect automatic recovery  
✅ **Usability:** Daily document scanning and media streaming operational  
✅ **Architecture:** Simplified Ubuntu-focused design proven reliable  

## 🏆 **Power Outage Validation**

**Recent power outage testing proved the infrastructure investment:**
- ✅ **Automatic Recovery:** All services resumed without intervention
- ✅ **Zero Data Loss:** Samsung SSD + backup system preserved everything  
- ✅ **Continuous Operation:** 4+ days stable uptime since recovery
- ✅ **Service Availability:** Paperless-ngx and Jellyfin immediately accessible

---

*Last updated: 2025-06-07*  
*🎉 Ubuntu-focused architecture proven reliable in real-world conditions!*  
*Current focus: PhotoSort optimization and media workflow enhancement* 