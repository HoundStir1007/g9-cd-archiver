# Home Server Research Project 🏠🖥️

This project organizes research, planning, and implementation of a personal home server setup using a GMKtec NucBox G9 mini PC.

## 📋 Project Status

### Current Implementation
- ✅ GMKtec NucBox G9 mini PC purchased and set up
- ✅ Dual-boot system with Windows 11 Pro and Ubuntu
- ✅ Tailscale remote access configured for both operating systems
- ✅ Basic system security implemented (BitLocker, Windows Defender)
- ✅ iCloud for Windows installed for temporary document storage
- ✅ Remote desktop access working from MacBook Pro

### In Progress
- 🔄 Document management system setup (Paperless-ngx)
- 🔄 Backup strategy implementation
- 🔄 Ubuntu system hardening and Docker setup

### Planned Features
- 📝 Network-wide ad blocking (Pi-hole)
- 📝 Personal wiki/knowledge base
- 📝 Development environment
- 📝 Home inventory management
- 📝 Optional: Local LLM experimentation

## 🗂️ Project Structure

- `requirements/` - Documentation of needs, use cases, and constraints
- `research/` - Research on hardware, software, and configurations
- `comparison/` - Comparison of different solutions
- `recommendations/` - Final recommendations based on research
- `Pass_the_Baton/` - Scripts and templates for project handoff documentation

## 📚 Key Documentation

- [Home Server Plan](home_server_plan.md) - Overall project plan and goals
- [G9 Setup Checklist](g9_setup_checklist.md) - Detailed implementation checklist
- [G9 Ethernet Configuration](g9_ethernet_configuration.md) - Network setup details
- [Tailscale Configuration](tailscale_configuration.md) - Remote access setup
- [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md) - Remote access testing
- [Budget](budget.md) - Project budget and cost analysis

## 🔑 Remote Access Information

The G9 server is accessible remotely via Tailscale:

- **Windows 11 Pro**: Tailscale IP 100.122.141.83
- **Ubuntu**: Tailscale IP 100.91.157.19

Both operating systems can be accessed via:
- Remote Desktop (Windows)
- SSH (Ubuntu)

## 🚀 Getting Started

1. Review the [Home Server Plan](home_server_plan.md) to understand project goals
2. Check the [G9 Setup Checklist](g9_setup_checklist.md) for implementation status
3. Follow the [Tailscale Configuration](tailscale_configuration.md) guide to set up remote access
4. Use the [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md) to verify connectivity

## 📝 Project Philosophy

- **Start simple**: Begin with existing hardware
- **Minimal investment**: Avoid unnecessary purchases
- **Ease of maintenance**: Keep system manageable with minimal time commitment
- **Expandability**: Design for easy scaling if project proves valuable
- **Graceful exit**: Ensure data can be easily migrated if project is discontinued

## 🔄 Development Workflow

This project uses a "Pass the Baton" system to track progress between work sessions. Each session is documented in `baton.md` and archived in `baton_archive.md`. The `Pass_the_Baton.py` script automates this process.

## 📞 Support & Resources

- [Tailscale Documentation](https://tailscale.com/kb/)
- [Paperless-ngx Documentation](https://docs.paperless-ngx.com/)
- [Pi-hole Documentation](https://docs.pi-hole.net/)
- [Docker Documentation](https://docs.docker.com/)

## ⚠️ Important Notes

- The G9 uses a specific USB-C power adapter with non-standard voltage/wattage
- DO NOT use any other USB-C power adapter with the G9
- DO NOT use the G9 power adapter with any other USB-C devices
- The G9 has dual 2.5GbE network ports that can be used for daisy-chaining
- Only one operating system can be running at a time (dual-boot system, not virtualized)

---

*Last updated: 2025-05-15* 