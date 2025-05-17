# System State Snapshot - 2025-05-16 📸

This document captures the system state as of May 16, 2025, serving as a historical reference point.

## System Overview
- **Hostname**: nucboxg9
- **Operating System**: Windows 11 Pro (10.0.26100)
- **Last Update**: 2025-05-16 21:15
- **System Role**: Home Server / Development Environment

## Network Configuration
### Active Interfaces
1. **Primary Network (Ethernet)**
   - IPv4: 192.168.0.178
   - Gateway: 192.168.0.1
   - Purpose: Internet access
   - Status: Active

2. **Secondary Network (Ethernet 2)**
   - IPv4: 192.168.137.1
   - Purpose: ICS for Apple TV
   - Status: Active
   - Connected Device: Apple TV (192.168.137.2)

3. **Tailscale Network**
   - Windows IP: 100.122.141.83
   - Ubuntu IP: 100.91.157.19 (offline)
   - Status: Active
   - Direct Connection: MacBook Pro (28.1ms latency)

### Network Services
- **ICS**: Enabled and stable
- **Remote Desktop**: Configured and tested
- **File Sharing**: Configured for local network
- **Tailscale**: Active with ACL policies

## Security Status
### Windows Defender
- **Full Scan**: In progress (started 2025-05-16 21:01)
- **Core Protection**: All features enabled
- **Network Protection**: Enabled
- **Controlled Folder Access**: Enabled

### Firewall
- **Private Profile**: Enabled
- **Public Profile**: Enabled
- **Custom Rules**: 
  - Remote Desktop
  - Tailscale
  - File Sharing

### Tailscale Security
- **ACL Policy**: Applied and active
- **Device Groups**: 
  - homeinfra (G9 devices)
  - dev (MacBook Pro)
- **MagicDNS**: Enabled
- **DERP**: Los Angeles (45.2ms)

## User Accounts
1. **Admin-8vehma**
   - Role: Local Administrator
   - Last Login: 2025-05-16 22:03
   - Purpose: System maintenance

2. **Personal Microsoft Account**
   - Role: Standard User
   - Last Login: 2025-05-14
   - Features: BitLocker, OneDrive
   - 2FA: Enabled

## System Features
- **BitLocker**: Enabled
- **Windows Hello**: PIN configured
- **Dual Boot**: Windows 11 Pro / Ubuntu 24.10
- **Power Management**: Automatic restart enabled

## Documented Changes
- Network configuration consolidated
- Security checklist completed
- Tailscale ACLs configured
- Archive system implemented

## Related Documentation
- [Network Configuration](../../network_configuration.md)
- [Windows Security Checklist](../../windows_security_checklist.md)
- [Tailscale Configuration](../../tailscale_configuration.md)

---
*Snapshot created: 2025-05-16 22:50:00*
*This is a point-in-time snapshot and should be used for historical reference only.* 