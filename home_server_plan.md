# Home Server Plan 🏠🖥️

## Project Overview
This document outlines the plan for setting up and maintaining a personal home server using the GMKtec NucBox G9 mini PC.

## Current Status
- ✅ Hardware acquired and set up
- ✅ Operating systems installed (Windows 11 Pro / Ubuntu 24.10)
- ✅ Network configuration completed
- ✅ Security measures implemented
- ✅ Remote access configured
- ✅ Documentation system established
- ✅ **PAPERLESS-NGX FULLY OPERATIONAL** 🎉

## Implementation Status
For detailed implementation status, see:
- [Network Configuration](network_configuration.md): Complete network setup
- [Windows Security Checklist](windows_security_checklist.md): Security implementation
- [Tailscale Configuration](tailscale_configuration.md): Remote access setup

### Archived Documentation
- [System State Snapshot](archive/snapshots/system_state_20250516.md): Current system state
- [G9 Setup Checklist](archive/checklists/g9_setup_checklist.md): Completed setup tasks
- [Remote Desktop Testing](archive/checklists/remote_desktop_testing_checklist.md): RDP verification
- [Archive Documentation](archive/README.md): Complete archive information

## Project Goals
- Create a paperless document management system
- Enable secure remote access from anywhere
- Provide automatic and manual backups
- Support family knowledge base, ad blocking, and optional LLM experimentation

## Available Hardware
- GMKtec NucBox G9 (dual-boot: Windows 11 Pro & Ubuntu)
- Raspberry Pi
- Mac Mini
- External hard drives

## Project Phases
1. **Core Setup**
   - Set up G9 with both OSes
   - Secure both systems (encryption, firewall, updates)
   - Configure Tailscale for remote access
2. **Document Management** ✅ **COMPLETE**
   - ✅ Install Paperless-ngx (Ubuntu with external storage)
   - ✅ Test scanning, OCR, and remote access
   - ✅ Set up mobile app and consume folder workflow
3. **Network Services**
   - Install Pi-hole (ad blocking)
   - Set up Samba/NFS for file sharing
   - Configure personal wiki (BookStack, WikiJS, or Obsidian)
4. **Development & Expansion**
   - Set up code-server or VS Code Server
   - Add home inventory, media server, or other services as needed
   - Experiment with local LLMs if hardware allows

## Current Priorities (Updated 2025-05-25)
- ✅ Document management and remote access **COMPLETE**
- 🎯 **Next Phase:** Network services (Pi-hole, wiki, file sharing)
- 🔧 **Critical:** Fix Tailscale monitoring system
- 🚀 **Ready for:** Additional services on stable foundation

## See Also
- [G9 Setup Checklist](g9_setup_checklist.md)
- [Tailscale Configuration](tailscale_configuration.md)
- [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md)
- [Budget](budget.md)

## Maintenance Plan
- Daily: Security checks, backup verification
- Weekly: System updates, performance monitoring
- Monthly: Full security audit, documentation review
- Quarterly: Hardware maintenance, system optimization

## Documentation Structure
- Active documentation in root directory
- Archived documentation in [archive/](archive/README.md)
- System state snapshots in [archive/snapshots/](archive/snapshots/)
- Checklists and verification in [archive/checklists/](archive/checklists/)

## Related Documentation
- [Network Configuration](network_configuration.md): Network setup and security
- [Windows Security Checklist](windows_security_checklist.md): Security implementation
- [Tailscale Configuration](tailscale_configuration.md): Remote access setup
- [Archive Documentation](archive/README.md): Archived and historical documentation

---
*Last updated: 2025-05-25*
*Major milestone: Paperless-ngx fully operational and production-ready*
*For current system state, see [Baton Handoff Log](baton.md)* 