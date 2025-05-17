# Remote Desktop Testing Checklist 🖥️

## Windows Remote Desktop

### Connection Setup
- [ ] Enable Remote Desktop on Windows 11 Pro
- [ ] Create local user account (if not using Microsoft account)
- [ ] Install Tailscale on both devices
- [ ] Note Tailscale IP address for the Windows machine
- [ ] Allow Remote Desktop through Windows Firewall

### MacBook Connection Tests
- [ ] Install Microsoft Remote Desktop app from Mac App Store
- [ ] Add new connection with Tailscale IP
- [ ] Configure display options (full screen, resolution)
- [ ] Test connection and login
- [ ] Verify performance and responsiveness
- [ ] Test file transfer/clipboard sharing

## Ubuntu SSH Access

### Server Setup
- [ ] Install SSH server: `sudo apt install openssh-server`
- [ ] Verify SSH service is running: `sudo systemctl status ssh`
- [ ] Configure SSH for key-based authentication
- [ ] Disable password authentication (optional/recommended)
- [ ] Allow SSH through UFW: `sudo ufw allow ssh`

### MacBook SSH Tests
- [ ] Generate SSH key (if needed): `ssh-keygen -t ed25519`
- [ ] Copy key to Ubuntu: `ssh-copy-id username@100.x.x.x`
- [ ] Test SSH connection: `ssh username@100.x.x.x`
- [ ] Test file transfer with SCP: `scp filename username@100.x.x.x:/path/`
- [ ] Create SSH config entry for easier connection

## Ubuntu GUI Access (Optional)

### Server Setup
- [ ] Install xRDP: `sudo apt install xrdp`
- [ ] Enable xRDP service: `sudo systemctl enable --now xrdp`
- [ ] Configure xRDP (if needed)
- [ ] Allow RDP through UFW: `sudo ufw allow 3389/tcp`

### MacBook Connection Tests
- [ ] Add new connection in Microsoft Remote Desktop app
- [ ] Test connection and login
- [ ] Verify performance and responsiveness

## Mobile Device Tests

### iOS/Android Remote Desktop
- [ ] Install Microsoft Remote Desktop app
- [ ] Configure connection with Tailscale IP
- [ ] Test connection and responsiveness
- [ ] Verify touch interface usability

### iOS/Android SSH
- [ ] Install Termius or similar SSH client
- [ ] Configure connection with Tailscale IP
- [ ] Test SSH login and basic commands
- [ ] Save connection for future use

## Performance Tests
- [ ] Test connection on local network
- [ ] Test connection on different networks (e.g., cellular)
- [ ] Measure connection establishment time
- [ ] Test file transfer speeds
- [ ] Test video playback performance
- [ ] Test system responsiveness during resource-intensive tasks

## See Also
- [G9 Setup Checklist](g9_setup_checklist.md)
- [Tailscale Configuration](tailscale_config.md)
- [Home Server Plan](home_server_plan.md)

---
*Last updated: 2025-05-16*
