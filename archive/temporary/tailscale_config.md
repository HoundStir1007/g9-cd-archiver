# Tailscale Configuration Guide 🌐

## Overview
Tailscale creates a secure, private network connection between your server and client devices, allowing remote access without port forwarding.

## Installation Steps

### G9 Windows 11 Pro
1. Download Tailscale from https://tailscale.com/download/windows
2. Run the installer and follow the prompts
3. Sign in with your preferred identity provider (Google, Microsoft, GitHub, etc.)
4. Authorize the device in your Tailscale account

### G9 Ubuntu
1. Run: `curl -fsSL https://tailscale.com/install.sh | sh`
2. Run: `sudo tailscale up`
3. Follow the login link to authenticate the device
4. Verify connection with `tailscale status`

### MacBook Pro (Client)
1. Download Tailscale from https://tailscale.com/download/macos
2. Install and run the application
3. Sign in with the same account used for the G9
4. Verify connection to the Tailscale network

### Mobile Devices (Optional)
1. Install Tailscale from the App Store or Google Play
2. Sign in with the same account
3. Allow VPN configuration when prompted

## Testing Connectivity
1. On MacBook Pro, run: `ping 100.x.x.x` (using G9's Tailscale IP)
2. Test SSH connection to Ubuntu: `ssh username@100.x.x.x`
3. Test Remote Desktop to Windows: Connect to the Tailscale IP in Remote Desktop app

## Advanced Configuration

### Subnet Routing (Optional)
To access devices on your home network through Tailscale:
1. Run on G9: `sudo tailscale up --advertise-routes=192.168.1.0/24`
2. Enable subnet routes in the Tailscale admin console
3. Test by accessing another home device through the G9

### ACL Configuration (Optional)
For enhanced security, configure access controls in the Tailscale admin console:
- Restrict which devices can communicate with each other
- Create device groups for easier management
- Set up node sharing for temporary access

## See Also
- [G9 Setup Checklist](g9_setup_checklist.md)
- [Home Server Plan](home_server_plan.md)
- [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md)

---
*Last updated: 2025-05-16*
