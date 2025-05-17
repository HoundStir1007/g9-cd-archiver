# Tailscale Configuration Guide 🌐

## Overview
Tailscale creates a secure, private network connection between your server and client devices, allowing remote access without port forwarding. For complete network configuration details, see [network_configuration.md](network_configuration.md).

## Installation Steps

## Current Status
- Tailscale installed on G9 (Windows 11)
- Tailscale installed on MacBook Pro
- Basic connectivity established between devices
- Unattended mode enabled on G9 for persistent connection

## Testing Connectivity
1. On MacBook Pro, run: `ping 100.122.141.83` (G9's Windows Tailscale IP)
2. Test SSH connection to Ubuntu: `ssh username@100.91.157.19`
3. Test Remote Desktop to Windows: Connect to 100.122.141.83 in Remote Desktop app

## Advanced Configuration

### Subnet Routing (Optional)
To access devices on your home network through Tailscale:
1. Run on G9: `sudo tailscale up --advertise-routes=192.168.0.0/24,192.168.137.0/24`
2. Enable subnet routes in the Tailscale admin console
3. Test by accessing another home device through the G9

### ACL Configuration (Optional)
For enhanced security, configure access controls in the Tailscale admin console:
- Restrict which devices can communicate with each other
- Create device groups for easier management
- Set up node sharing for temporary access

## See Also
- [Network Configuration](network_configuration.md): Complete network setup and security details
- [Windows Security Checklist](windows_security_checklist.md): Security implementation status
- [Archive Documentation](archive/README.md): Archived and historical documentation

### Archived Documentation
- [Tailscale ACL Configuration](archive/temporary/ACLS.txt): Tailscale access control settings
- [Remote Desktop Testing](archive/checklists/remote_desktop_testing_checklist.md): Completed RDP testing

## Important Notes
- Network configuration is documented in [network_configuration.md](network_configuration.md)
- Current Tailscale IPs:
  - Windows: 100.122.141.83
  - Ubuntu: 100.91.157.19
- Direct connection established with MacBook Pro (28.1ms latency)
- DERP fallback configured (Los Angeles: 45.2ms)

---
*Last updated: 2025-05-16* 