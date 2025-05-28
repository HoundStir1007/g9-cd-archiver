# Home Server Project 🏠🖥️

This project organizes research, planning, and implementation of a personal home server setup using a GMKtec NucBox G9 mini PC.

## 📋 Project Status (Updated 2025-05-25)

### ✅ **MAJOR MILESTONE: PAPERLESS-NGX COMPLETE!** 🎉

### Current Implementation
- ✅ GMKtec NucBox G9 mini PC purchased and set up
- ✅ Dual-boot system with Windows 11 Pro and Ubuntu
- ✅ Tailscale remote access configured for both operating systems
- ✅ Basic system security implemented (BitLocker, Windows Defender)
- ✅ Remote desktop access working from MacBook Pro
- ✅ **PAPERLESS-NGX FULLY OPERATIONAL** 
  - ✅ Document processing with OCR and Tika
  - ✅ Mobile scanning via iPhone app
  - ✅ Web interface accessible via Tailscale
  - ✅ External storage with SSD migration path
  - ✅ Django Admin for advanced configuration

### Next Priority Phase
- 🎯 Network-wide ad blocking (Pi-hole)
- 🎯 Personal wiki/knowledge base
- 🔧 **CRITICAL:** Fix Tailscale monitoring system
- 🎯 Automated backup strategy

### Future Expansion
- 📝 Development environment (code-server)
- 📝 Home inventory management
- 📝 File sharing (Samba/NFS)
- 📝 Optional: Local LLM experimentation

## 🗂️ Project Structure

- `requirements/` - Documentation of needs, use cases, and constraints
- `research/` - Research on hardware, software, and configurations
- `comparison/` - Comparison of different solutions
- `recommendations/` - Final recommendations based on research
- `Pass_the_Baton/` - Scripts and templates for project handoff documentation
- `archive/` - Archived documentation (see [Archive README](archive/README.md))

## 📚 Key Documentation

- [Home Server Plan](home_server_plan.md) - Overall project plan and goals
- [Network Configuration](network_configuration.md) - Complete network setup and security details
- [Tailscale Configuration](tailscale_configuration.md) - Remote access setup
- [Windows Security Checklist](windows_security_checklist.md) - Security implementation status
- [Budget](budget.md) - Project budget and cost analysis

### Archived Documentation
- [G9 Setup Checklist](archive/checklists/g9_setup_checklist.md) - Completed setup checklist
- [Remote Desktop Testing](archive/checklists/remote_desktop_testing_checklist.md) - Completed RDP testing
- [Tailscale ACL Configuration](archive/temporary/ACLS.txt) - Tailscale access control settings

## 📋 Quick Reference

### System Details
- **Hardware**: Intel NUC 9 Pro (G9)
- **Operating Systems**:
- **Windows 11 Pro**: Tailscale IP 100.122.141.83
- **Ubuntu**: Tailscale IP 100.91.157.19

Both operating systems can be accessed via:
- Remote Desktop (Windows)
- SSH (Ubuntu)

## 🚀 Getting Started

1. Review the [Home Server Plan](home_server_plan.md) to understand project goals
2. Follow the [Network Configuration](network_configuration.md) guide for detailed network setup
3. Follow the [Tailscale Configuration](tailscale_configuration.md) guide to set up remote access
4. Review the [Windows Security Checklist](windows_security_checklist.md) for security status

## 📝 Project Philosophy

- **Start simple**: Begin with existing hardware
- **Minimal investment**: Avoid unnecessary purchases
- **Ease of maintenance**: Keep system manageable with minimal time commitment
- **Expandability**: Design for easy scaling if project proves valuable
- **Graceful exit**: Ensure data can be easily migrated if project is discontinued

## 🔄 Development Workflow

This project uses a "Pass the Baton" system to track progress between work sessions. Each session is documented in `baton.md` and archived in `baton_archive.md`. The `Pass_the_Baton.py` script automates this process.

## 📞 Support & Resources

- [Network Configuration](network_configuration.md): Detailed network setup and security
- [Tailscale Documentation](https://tailscale.com/kb/)
- [Paperless-ngx Documentation](https://docs.paperless-ngx.com/)
- [Pi-hole Documentation](https://docs.pi-hole.net/)
- [Docker Documentation](https://docs.docker.com/)
- [Archive Documentation](archive/README.md): Archived and historical documentation

## ⚠️ Important Notes

- The G9 uses a specific USB-C power adapter with non-standard voltage/wattage
- DO NOT use any other USB-C power adapter with the G9
- DO NOT use the G9 power adapter with any other USB-C devices
- The G9 has dual 2.5GbE network ports configured for:
  - Primary (Ethernet): Internet access (192.168.0.178)
  - Secondary (Ethernet 2): ICS for Apple TV (192.168.137.1)
- Only one operating system can be running at a time (dual-boot system, not virtualized)
- Network configuration is documented in [network_configuration.md](network_configuration.md)

---

*Last updated: 2025-05-25*  
*🎉 Major milestone achieved: Paperless-ngx fully operational and production-ready!* 