# Remote Desktop Testing Checklist 🖥️

This checklist ensures complete remote desktop functionality for the GMKtec NucBox G9 server, enabling full headless operation without a monitor or keyboard.

## Current Plan & Progress 🚀

1. ✅ Test Windows Remote Desktop access via Tailscale
2. ⏳ Verify/Install SSH server on Ubuntu during direct access
3. ⏳ Set up method to switch between Windows and Ubuntu remotely

## Prerequisites ✅

- [x] Tailscale installed and configured on both Windows 11 and Ubuntu
- [x] Remote Desktop enabled in Windows 11 settings
- [ ] SSH server installed and configured on Ubuntu
- [ ] VNC or alternative remote desktop solution installed on Ubuntu
- [ ] All network adapters properly configured
- [ ] Server has static IP or reliable DHCP reservation

## Windows 11 Remote Desktop Testing 🪟

- [x] Basic connection
  - [x] Connect to Windows via Tailscale network
  - [ ] Connect to Windows via local network
  - [x] Verify screen resolution and quality

- [x] Functionality testing
  - [x] Open and use applications (Cursor installed and tested)
  - [x] Access system settings
  - [x] Transfer files to/from the server (iCloud Drive folder redirection working)
  - [ ] Run system updates
  - [ ] Change system settings

- [x] Restart operations
  - [x] Initiate restart from within Windows
  - [x] Successfully reconnect after restart (only took 1 minute)
  - [ ] Force restart if system becomes unresponsive

## Ubuntu Remote Desktop Testing 🐧

- [ ] SSH connectivity
  - [ ] Check if SSH server is already installed:
    ```bash
    systemctl status ssh
    ```
  - [ ] If not installed, set it up:
    ```bash
    sudo apt update
    sudo apt install openssh-server
    sudo systemctl enable ssh
    sudo systemctl start ssh
    ```
  - [ ] Get IP addresses:
    ```bash
    ip addr show
    # or
    hostname -I
    ```
  - [ ] Connect via SSH using Tailscale IP
  - [ ] Connect via SSH using local network IP
  - [ ] Verify SSH key authentication works

- [ ] GUI remote desktop (VNC/alternative)
  - [ ] Install xRDP for GUI access:
    ```bash
    sudo apt install xrdp
    sudo systemctl enable xrdp
    sudo systemctl start xrdp
    ```
  - [ ] Connect to Ubuntu GUI remotely
  - [ ] Verify screen resolution and quality
  - [ ] Run graphical applications successfully

- [ ] Functionality testing
  - [ ] Open and use terminal applications
  - [ ] Access system settings
  - [ ] Transfer files using SCP/SFTP
  - [ ] Run system updates
  - [ ] Change system settings

- [ ] Restart operations
  - [ ] Initiate restart from terminal
  - [ ] Successfully reconnect after restart
  - [ ] Force restart if system becomes unresponsive

## OS Switching Tests 🔄

- [ ] From Windows to Ubuntu
  - [ ] Option 1: Set up GRUB customizer on Ubuntu
    ```bash
    sudo apt install grub-customizer
    # Configure to remember last OS selection
    ```
  - [ ] Option 2: Set up boot script on Windows
    ```batch
    @echo off
    bcdedit /set {bootmgr} displaybootmenu yes
    bcdedit /timeout 15
    shutdown /r /t 30 /c "Rebooting to select Ubuntu"
    ```
  - [ ] Access boot menu remotely
  - [ ] Select Ubuntu from boot menu
  - [ ] Successfully boot into Ubuntu
  - [ ] Reconnect via SSH/VNC

- [ ] From Ubuntu to Windows
  - [ ] Set up similar reboot mechanism
  - [ ] Access boot menu remotely
  - [ ] Select Windows from boot menu
  - [ ] Successfully boot into Windows
  - [ ] Reconnect via RDP

## Advanced Test Scenarios 🧪

- [ ] Boot menu access
  - [ ] Test Aurga Viewer connection for BIOS/UEFI access
  - [ ] Configure any necessary BIOS settings remotely

- [ ] Recovery scenarios
  - [ ] Test recovery if Windows RDP fails (alternative access methods)
  - [ ] Test recovery if Ubuntu SSH fails (alternative access methods)
  - [ ] Document emergency recovery procedures

- [ ] Power management
  - [ ] Remotely power off system
  - [ ] Remotely power on system (requires Wake-on-LAN or specialized hardware)
  - [ ] Schedule automatic restarts

## Documentation 📝

- [ ] Document all successful connection methods
- [ ] Document IP addresses and ports for all services
- [ ] Create troubleshooting guide for common remote access issues
- [ ] Note any limitations discovered during testing

## Post-Testing Optimization 🚀

- [ ] Configure services to start automatically after boot
- [ ] Set up automatic login where appropriate
- [ ] Configure backup remote access methods
- [ ] Test system with router reboots to ensure reconnection

## Security Considerations 🔒

- [ ] Review firewall settings on both OS
- [ ] Ensure strong passwords for all remote access accounts
- [ ] Limit RDP/SSH/VNC to Tailscale network where possible
- [ ] Test all connections for encryption and security

## Ubuntu GUI Access

### Server Setup
- [x] Install xRDP: `sudo apt install xrdp`
- [x] Install XFCE4: `sudo apt install xfce4 xfce4-goodies`
- [x] Configure display manager (LightDM)
- [x] Create .xsession file for XFCE4
- [x] Enable xRDP service: `sudo systemctl enable --now xrdp`
- [x] Allow RDP through UFW: `sudo ufw allow 3389/tcp`
- [x] Verify xRDP service status
- [x] Configure desktop environment (XFCE4)

### MacBook Connection Tests
- [ ] Add new connection in Microsoft Remote Desktop app
  - [ ] Test with Tailscale IP (100.91.157.19)
  - [ ] Test with local network IP
- [ ] Test connection and login
- [ ] Verify desktop environment (XFCE4)
- [ ] Test basic functionality:
  - [ ] Window management
  - [ ] File browser
  - [ ] Terminal access
  - [ ] System settings
- [ ] Verify performance and responsiveness
- [ ] Test file transfer capabilities
- [ ] Test clipboard sharing

### Current Status
- Desktop Environment: XFCE4
- Display Manager: LightDM
- xRDP Service: Active and running
- Connection IPs:
  - Tailscale: 100.91.157.19
  - Local: [Available via hostname -I]
- Firewall: Port 3389 open for RDP 