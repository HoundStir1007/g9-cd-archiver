# Home Server Project 🏠🖥️

This project documents the successful implementation of a personal home server setup using a GMKtec NucBox G9 mini PC.

## 🎉 **PROJECT MILESTONE: DOCUMENT MANAGEMENT COMPLETE!** ✅

**Status as of 2025-05-30:** Paperless-ngx is fully operational with mobile scanning, remote access, and OCR processing!

## 📋 Project Status

### ✅ **COMPLETED PHASES**

#### Phase 1: Core Infrastructure ✅
- ✅ GMKtec NucBox G9 mini PC purchased and configured
- ✅ Dual-boot system with Windows 11 Pro and Ubuntu 24.10
- ✅ Network infrastructure with UPS protection and switch expansion
- ✅ Tailscale remote access configured for both operating systems
- ✅ Basic system security implemented (BitLocker, Windows Defender, UFW)

#### Phase 2: Document Management ✅ 🎉
- ✅ **PAPERLESS-NGX FULLY OPERATIONAL**
  - ✅ Document processing with OCR and Tika integration
  - ✅ Mobile scanning via Swift Paperless iPhone app
  - ✅ Web interface accessible via both local and Tailscale networks
  - ✅ External storage configured with SSD migration capability
  - ✅ Django Admin interface for advanced configuration
  - ✅ Consume folder workflow for automatic document processing

### 🎯 **CURRENT PRIORITY: Network Services**
- 🔧 **CRITICAL:** Fix Tailscale monitoring system (power outage alerts)
- 🛡️ **IMMEDIATE:** Pi-hole setup for network-wide ad blocking
- 📚 **HIGH:** Personal wiki/knowledge base implementation
- 🔄 **MEDIUM:** Automated backup strategy development

### 📝 **FUTURE EXPANSION**
- Development environment (code-server)
- Home inventory management
- File sharing (Samba/NFS)
- Optional: Local LLM experimentation

## 💰 Budget Summary
- **Total Spent:** ~$450 (87% of maximum budget)
- **Budget Status:** ✅ Under budget by $76  
- **Hardware Phase:** ✅ COMPLETE - All planned purchases finished
- **Value Achievement:** ✅ Professional-grade home server under $500

## 🖥️ System Configuration

### Hardware (Final)
- **Server:** GMKtec NucBox G9 (Intel Twin Lake N150, 12GB DDR5, 512GB + 2TB NVMe)
- **Storage:** Samsung 990 EVO 2TB SSD (high endurance)
- **Power:** APC BN450M UPS (270W protection)
- **Network:** 8-port switch (media center) + 5-port switch (bedroom)

### Network Access
- **Local Network:** http://192.168.0.178:8000 (when at home)
- **Remote Access:** http://100.91.157.19:8000 (via Tailscale from anywhere)
- **SSH Management:** `ssh gmk@100.91.157.19` (Ubuntu administration)
- **Mobile Integration:** Swift Paperless app for document scanning

### Operating Systems
- **Windows 11 Pro:** Tailscale IP 100.122.141.83 (available via dual-boot)
- **Ubuntu 24.10:** Tailscale IP 100.91.157.19 (primary for services)

## 🗂️ Project Structure

### Active Documentation
- [`home_server_plan.md`](home_server_plan.md) - Overall project plan and current status
- [`budget.md`](budget.md) - Final budget breakdown and purchase summary
- [`baton.md`](baton.md) - Session-to-session progress tracking
- [`pihole_setup_guide.md`](pihole_setup_guide.md) - Next phase implementation guide

### Configuration Files
- [`network_configuration.md`](network_configuration.md) - Complete network setup details
- [`tailscale_configuration.md`](tailscale_configuration.md) - Remote access configuration  
- [`windows_security_checklist.md`](windows_security_checklist.md) - Security implementation status

### Archived Documentation
- [`archive/`](archive/README.md) - Completed checklists and obsolete guides
- [`scripts/`](scripts/) - Automation scripts and utilities

## 🚀 What's Working Right Now

### Document Management (Production Ready)
- **Document Upload:** Web interface and mobile app
- **OCR Processing:** Automatic text recognition and searchability
- **Remote Access:** Secure access from anywhere via Tailscale
- **Mobile Scanning:** iPhone app integration for document capture
- **Auto-Processing:** Consume folder for batch document import

### Infrastructure
- **Power Protection:** UPS provides automatic recovery from outages
- **Network Coverage:** Comprehensive gigabit ethernet throughout home
- **Dual Operating Systems:** Windows and Ubuntu available via dual-boot
- **Remote Management:** SSH access for system administration

## 📋 Quick Reference

### Accessing Your System
```bash
# Remote SSH access (Ubuntu)
ssh gmk@100.91.157.19

# Web interfaces
# Paperless-ngx: http://100.91.157.19:8000 (or http://192.168.0.178:8000)
# Future Pi-hole: http://100.91.157.19/admin (planned)

# Check system status
docker ps                    # Container status
tailscale status            # Network connectivity
```

### Key File Locations
- **Paperless Data:** External drive `/media/paperless-storage/`
- **Docker Configs:** `~/paperless-ngx/docker-compose.yml`
- **Consume Folder:** `/media/paperless-storage/paperless/consume/`
- **Project Docs:** This repository

## 🔄 Development Workflow

This project uses a "Pass the Baton" system documented in [`baton.md`](baton.md) to track progress between work sessions and maintain continuity across different development phases.

## 📞 Support & Resources

- [Paperless-ngx Documentation](https://docs.paperless-ngx.com/)
- [Tailscale Documentation](https://tailscale.com/kb/)
- [Pi-hole Documentation](https://docs.pi-hole.net/) (next phase)
- [Archive Documentation](archive/README.md) (completed guides)

## ⚠️ Important Notes

- **Power:** G9 uses specific USB-C adapter - do not substitute
- **Dual-Boot:** Only one OS runs at a time (not virtualized)
- **Network:** Two 2.5GbE ports configured for internet + Apple TV ICS
- **Storage:** External drive ready for SSD migration when needed
- **Access:** System accessible remotely via Tailscale from anywhere

## 🎯 Project Success Metrics

✅ **Budget:** Completed under budget (87% of maximum)  
✅ **Functionality:** 100% of document management goals achieved  
✅ **Timeline:** Delivered ahead of schedule  
✅ **Usability:** Daily document scanning and processing operational  
✅ **Scalability:** Foundation ready for additional services  

---

*Last updated: 2025-05-30*  
*🎉 Major milestone: Document management phase complete and production-ready!*  
*Next focus: Network services (Pi-hole, wiki, automated backups)* 