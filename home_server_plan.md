# Home Server Plan 🏠🖥️

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
2. **Document Management**
   - Install Paperless-ngx (Windows or Ubuntu)
   - Test scanning, OCR, and remote access
   - Set up iCloud/other backup for documents
3. **Network Services**
   - Install Pi-hole (ad blocking)
   - Set up Samba/NFS for file sharing
   - Configure personal wiki (BookStack, WikiJS, or Obsidian)
4. **Development & Expansion**
   - Set up code-server or VS Code Server
   - Add home inventory, media server, or other services as needed
   - Experiment with local LLMs if hardware allows

## Priorities
- Start with existing hardware
- Focus on document management and remote access first
- Add services only after core is stable

## See Also
- [G9 Setup Checklist](g9_setup_checklist.md)
- [Tailscale Configuration](tailscale_configuration.md)
- [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md)
- [Budget](budget.md)

---
*Last updated: 2025-05-15* 