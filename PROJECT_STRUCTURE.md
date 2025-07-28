# 🗂️ Project Structure Guide

**Last Updated:** 2025-01-28  
**Status:** Reorganized for clarity and efficiency

## 📁 Directory Structure

### **Root Level - Core Documentation**
- `baton.md` - Session handoff log (current status)
- `README.md` - Project overview and status
- `home_server_plan.md` - Master project plan
- `budget.md` - Financial tracking
- `network_configuration.md` - Current network setup
- `tailscale_configuration.md` - VPN configuration
- `MEDIA_CONSOLIDATION_ARCHIVE_RETRIEVAL.md` - 🎬 Media gap filling and archive retrieval strategies

### **🎯 Active Projects** (`active_projects/`)
**Currently being worked on:**
- `gmail_organization_guide.md` - Email organization (in progress)
- `pihole_setup_guide.md` - Network ad blocking (ready to deploy)

### **🔮 Future Projects** (`future_projects/`)
**Planned but not yet started:**
- `email_setup_guide.md` - Automated email processing
- `email_processor.py` - Email to PDF conversion script

### **📚 Archive** (`archive/`)

#### **Completed Guides** (`archive/completed_guides/`)
**Successfully implemented and operational:**
- `plex_setup_guide.md` - Media server (✅ COMPLETE)
- `plex-docker-compose.yml` - Plex configuration
- `plex_troubleshooting.md` - Plex support docs
- `DUAL_SERVER_MEDIA_STRATEGY.md` - Media strategy (✅ COMPLETE)

#### **Research Phase** (`archive/research_phase/`)
**Historical research and planning:**
- `comparison/` - Hardware and software comparisons
- `requirements/` - Original requirements analysis
- `research/` - Technical research documents
- `recommendations/` - Decision documentation
- `power_outage_report.md` - UPS testing results

#### **Windows Era** (`archive/windows_era/`)
**Legacy Windows-focused documentation** (project now Ubuntu-only)

### **🔧 Scripts** (`scripts/`)

#### **Ubuntu Scripts** (`scripts/ubuntu/`)
**Current platform scripts:**
- `setup_auto_updates.sh` - System maintenance
- `setup_fail2ban.sh` - Security hardening
- `setup_ubuntu_firewall.sh` - Firewall configuration
- `setup_ubuntu_rdp.sh` - Remote desktop setup

#### **Archived Windows Scripts** (`scripts/archived_windows/`)
**Legacy PowerShell scripts** (no longer used):
- Various `.ps1` monitoring and maintenance scripts
- Preserved for reference but not actively maintained

### **📊 Maintenance & Logs** (`maintenance_logs/`)
**System maintenance tracking and historical logs**

### **🌐 Web Assets** (`web/`)
**Web interface files and assets**

### **📋 Templates** (`templates/`)
**Reusable configuration templates**

---

## 🎯 Current Project Status

### ✅ **COMPLETED**
- **Plex Media Server** - Fully operational with Apple TV integration
- **Jellyfin Media Server** - Operational with SMB file sharing
- **Samsung SSD Migration** - High-performance storage implemented
- **UPS Power Protection** - Automated backup system operational
- **Network Infrastructure** - Switches and Tailscale configured

### 🔄 **IN PROGRESS**
- **Gmail Organization** - Email structure setup for future automation
- **RetroArch Setup** - Gaming library configuration planned
- **Mac Mini Optimization** - Disc ripping workstation setup planned

### 📋 **NEXT PRIORITIES**
1. **🔐 Devon User Access** - Plex user management setup
2. **💿 Mac Mini Disc Ripping** - Dedicated media digitization station
3. **🎮 RetroArch Shared Directories** - Multi-device gaming setup
4. **🛡️ Pi-hole Deployment** - Network-wide ad blocking

---

## 🧹 Reorganization Benefits

### **✅ Clear Separation**
- **Active** vs **Future** vs **Completed** projects
- **Current platform** (Ubuntu) vs **Legacy** (Windows) scripts
- **Research phase** vs **Implementation phase** documentation

### **✅ Reduced Clutter**
- Root directory focused on current work only
- Historical research properly archived
- Legacy Windows scripts preserved but separated

### **✅ Improved Navigation**
- Logical grouping by project status
- Clear naming conventions
- Comprehensive documentation structure

### **✅ Future-Proof Organization**
- Scalable structure for new projects
- Clear archival process for completed work
- Maintained historical context for troubleshooting

---

## 📝 Usage Guidelines

### **Adding New Projects**
1. **Active projects** → `active_projects/`
2. **Future planning** → `future_projects/`
3. **Completed work** → `archive/completed_guides/`

### **Script Organization**
1. **Ubuntu scripts** → `scripts/ubuntu/`
2. **Legacy/Windows** → `scripts/archived_windows/`
3. **Cross-platform** → `scripts/` (root level)

### **Documentation Updates**
1. **Update `baton.md`** for session handoffs
2. **Update `README.md`** for major milestones
3. **Update this file** when structure changes

---

**🎉 RESULT:** Clean, organized workspace optimized for current Ubuntu-focused home server project with proper historical preservation!