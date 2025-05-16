# G9 Setup Checklist 🚀

## Phase 0: Initial System Setup

### Windows 11 Pro
- [ ] Boot and complete initial Windows setup
- [ ] Install all Windows updates
- [ ] Install/update device drivers
- [ ] Enable BitLocker drive encryption
- [ ] Set up Windows Defender and run full scan
- [ ] Create a local admin account
- [ ] Set computer name to "HOMELAB"
- [ ] Install iCloud for Windows (for temporary document backup)
- [ ] Test OneDrive integration (optional)

### Ubuntu
- [ ] Boot and complete Ubuntu setup
- [ ] Update system: `sudo apt update && sudo apt upgrade -y`
- [ ] Install essentials: `sudo apt install -y curl wget git net-tools htop`
- [ ] Configure static IP (optional)
- [ ] Install Docker and Docker Compose
- [ ] Set up SSH key authentication
- [ ] Configure UFW firewall

## Phase 1: Core Services

### Document Management
- [ ] Create directory for Paperless-ngx data
- [ ] Install Docker Desktop (Windows) or Docker (Ubuntu)
- [ ] Create `docker-compose.yml` for Paperless-ngx
- [ ] Configure and run Paperless-ngx
- [ ] Access web UI and complete initial setup
- [ ] Test document upload, OCR, and search
- [ ] Set up iCloud/other backup for documents

### Backup System
- [ ] Install Duplicati or similar backup software
- [ ] Define backup sources and destinations
- [ ] Schedule automated backups
- [ ] Test backup and restore

## Phase 2: Remote Access
- [ ] Install Tailscale on both OSes
- [ ] Authenticate and connect to Tailscale network
- [ ] Test connectivity from MacBook and mobile devices
- [ ] Test remote desktop (Windows) and SSH (Ubuntu)
- [ ] Review Tailscale ACLs (optional)

## Phase 3: Additional Services
- [ ] Install Pi-hole (ad blocking)
- [ ] Set up Samba/NFS for file sharing
- [ ] Set up personal wiki (BookStack, WikiJS, or Obsidian)
- [ ] Set up code-server or VS Code Server
- [ ] Add home inventory/media server as needed

## See Also
- [Home Server Plan](home_server_plan.md)
- [Tailscale Configuration](tailscale_configuration.md)
- [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md)

---
*Last updated: 2025-05-15* 