# Windows Security & Updates Checklist 🛡️

## Initial Security Scan & Updates

### Account Structure Documentation ✅
- [x] Document Account Setup
  - Personal Microsoft Account:
    - Standard user privileges
    - BitLocker management
    - OneDrive integration
    - Primary document management
  - Admin-8vehma Account:
    - Local administrator privileges
    - System maintenance and updates
    - Security configuration
    - Service installation and setup

### BitLocker Verification ✅
- [x] Verify BitLocker Status
  - BitLocker enabled on personal Microsoft Account
  - Recovery key saved as "microsoft bitlocker key nucbox.pdf"
  - Recovery key backed up to Microsoft Account
- [x] Recovery Key Security
  - [x] Store PDF in secure cloud storage
    - Options:
      - OneDrive (Personal Microsoft Account)
      - iCloud Drive (if using Apple ecosystem)
      - Ensure cloud storage is 2FA protected
  - [x] Add recovery key to iOS/macOS Passwords app
    - Open Passwords app
    - Add new secure note
    - Title: "G9 BitLocker Recovery Key"
    - Include key ID and full recovery key
    - Add to designated group/folder
  - [x] Document location of all recovery key copies
    - Create recovery key location inventory:
      - Microsoft Account (online backup)
      - PDF file location
      - Cloud storage location
      - Password manager entry
    - Note access methods for each location
    - Document recovery process

### Windows Defender Full Scan
- [x] Initiate Full Scan (Started, in progress)
  - Started from Admin-8vehma account
  - Full system scan running in background
  - Will continue even if user switches
- [x] Monitor Scan Progress
  - Started: 2025-05-16 21:01
  - Completed: 2025-05-16 20:07
  - Duration: 1 hour 13 minutes
  - Files scanned: 974,120
- [x] Review Scan Results
  - 0 threats found
  - No action required
- [x] Address Any Findings
  - No threats detected; no action needed
- [x] Update Scan History
  - Scan completed successfully on 2025-05-16 at 8:07 PM
  - Duration: 1 hour 13 minutes
  - 974,120 files scanned
  - 0 threats found
  - No issues encountered

### Windows Defender Configuration ✅
- [x] Verify Core Protection Features
  - Antivirus Enabled: ✅
  - Real-time Protection: ✅
  - Network Protection: Enabled ✅ (newly configured)
  - Controlled Folder Access: Enabled ✅ (newly configured)
  - PUA Protection: Active ✅
  - Cloud Protection: Active ✅

### Windows Update Check ✅
- [x] Check Current Update Status (Priority 1)
  - Windows Update service status: Running ✅
  - Windows version: 10.0.26100
  - Last update check: 2025-05-16 21:15
  - Updates checked and documented ✅
- [x] Review Update History (Priority 2)
  - [x] Open Update History
  - [x] Document recent updates:
    - Last successful update
    - Failed updates (if any)
    - Pending restarts
  - [x] Check for patterns in failed updates
- [x] Check for Updates (Priority 1)
  - [x] Click "Check for updates" in Windows Settings
  - [x] Document found updates:
    - Security updates
    - Feature updates
    - Optional updates
    - Driver updates
  - [x] Note download sizes
  - [x] Document update priorities
- [x] Prepare System (Priority 1)
  - [x] Verify power connection ✓
  - [x] Check disk space
  - [x] Document open applications
  - [x] Save all work
  - [x] Note current system state
- [x] Install Updates
  - [x] Start installation
  - [x] Document start time
  - [x] Monitor progress
  - [x] Note required restarts
  - [x] Record any errors

### Firewall Configuration ✅
- [x] Review Windows Defender Firewall Settings
  - Private Network Profile: Enabled ✅
  - Public Network Profile: Enabled ✅
  - Review needed for:
    - [x] Remote Desktop rules (see [network_configuration.md](network_configuration.md))
    - [x] Tailscale permissions (see [network_configuration.md](network_configuration.md))
    - [x] File sharing settings (see [network_configuration.md](network_configuration.md))

### Network Security ✅
- [x] Verify Tailscale Configuration
  - Current Status:
    - Windows (100.122.141.83): Connected ✅
    - Ubuntu (100.91.157.19): Offline (expected)
    - Direct connection established with MacBook Pro
    - Optimal DERP latency (Los Angeles: 45.2ms)
  - Network Features:
    - IPv4 Connectivity: ✅
    - IPv6 Connectivity: ✅
    - UDP Communication: ✅
    - No Captive Portal: ✅
    - PMP Probe: Failed (non-critical)
    - MagicDNS: Enabled ✅
  - For complete network configuration, see [network_configuration.md](network_configuration.md)

### Tailscale Security Configuration
- [x] Access Control (Priority 1)
  - [x] Review ACL policies in Tailscale admin console
    - Groups created: homeinfra (G9 devices), dev (MacBook Pro)
    - Rules: dev can access homeinfra, homeinfra can communicate internally
    - Policy updated and saved 2025-05-16
  - [x] Configure device groups
    - Home Infrastructure: nucboxg9, gmk-g9
    - Development Devices: macbook-pro
    - Permissions set as planned
  - [x] Set up node sharing permissions
    - Not needed for current setup; revisit if sharing with external users
- [x] Network Security (Priority 2)
  - [x] Enable MagicDNS ✅
    - MagicDNS already enabled and configured
    - Verified in [network_configuration.md](network_configuration.md)
  - [x] Configure subnet routing
    - Current network layout documented in [network_configuration.md](network_configuration.md):
      - Primary network: 192.168.0.x (DHCP)
      - Secondary network: 192.168.137.x (ICS)
    - Direct connection established with MacBook Pro (192.168.0.214)
    - Optimal DERP latency: Los Angeles (28.1ms)
    - IPv4 and IPv6 connectivity verified
  - [x] Review exit node settings
    - Current setup doesn't require exit nodes
    - Direct connections preferred for better performance
    - DERP fallback configured (Los Angeles: 28.1ms)
- [x] Device Management (Priority 3)
  - [x] Review connected devices
    - Current device inventory (as of 2025-05-16 22:36):
      1. nucboxg9 (Windows)
         - Tailscale IP: 100.122.141.83
         - Status: Connected
         - Purpose: Home Server
      2. gmk-g9 (Linux)
         - Tailscale IP: 100.91.157.19
         - Status: Offline (expected)
         - Purpose: Linux environment
      3. macbook-pro (macOS)
         - Tailscale IP: 100.73.233.88
         - Status: Active (Direct connection)
         - Local IP: 192.168.0.214
         - Purpose: Development machine
    - [x] Verify each device's purpose
    - [x] Remove unused authorizations
  - [x] Document device inventory
    - Device name and purpose documented
    - IP addresses (Tailscale and local) recorded
    - Access levels and permissions set
    - Last connection date: 2025-05-16
- [ ] Monitoring (Priority 4)
  - [ ] Configure connection alerts
    - [ ] Set up email notifications
    - [ ] Define alert conditions
    - [ ] Test alert system
  - [ ] Monitor network usage
    - [ ] Review current metrics
    - [ ] Set up usage alerts
    - [ ] Document baseline patterns
  - [ ] Implement logging
    - [ ] Configure log retention
    - [ ] Set up log analysis
    - [ ] Document review procedures

### Account Security
- [x] Review User Accounts
  - [x] Verify Admin-8vehma account permissions
    - Status: Enabled, Last logon: 2025-05-16 22:03
    - Administrator privileges confirmed
  - [x] Confirm standard user account limitations
    - Mark Sakamoto account: Enabled, Last logon: 2025-05-14
    - Standard user privileges confirmed
  - [x] Check password policies
    - Strong password requirements enabled
    - Regular password changes enforced
  - [x] Enable PIN/biometric login if available
    - Windows Hello PIN configured
    - Biometric login available but not configured (as per security policy)
- [x] Check Microsoft Account Security
  - [x] Verify 2FA is enabled
    - Two-factor authentication active
    - Authenticator app configured
  - [x] Review recent sign-in activity
    - Last sign-in: 2025-05-16
    - No suspicious activity detected
  - [x] Check linked devices
    - Current devices verified
    - Unused devices removed
  - [x] Review backup email/phone numbers
    - Recovery options verified
    - Backup contact methods confirmed

## Remote Desktop Update Testing
- [ ] Test Update Initiation via RDP
  - Connect to G9 via Remote Desktop
  - Attempt to check for updates
  - Verify update installation
  - Document any limitations
- [ ] Test Update Installation via RDP
  - Monitor update progress remotely
  - Verify system restart handling
  - Test reconnection after restart
  - Document connection recovery time

## Ongoing Maintenance Schedule

### Daily Checks
- [ ] Quick Scan (if configured)
- [ ] Check for critical updates
- [ ] Review Windows Security status
- [ ] Monitor system performance

### Weekly Tasks
- [ ] Run Windows Defender quick scan
- [ ] Check for new updates
- [ ] Review update history
- [ ] Verify Windows Security settings
- [ ] Check system health report

### Monthly Tasks
- [ ] Run Windows Defender full scan
- [ ] Review and clean update history
- [ ] Verify all security features
- [ ] Check system restore points
- [ ] Review event logs for issues
- [ ] Review and update BitLocker configuration
- [ ] Check Microsoft account security status
- [ ] Verify Tailscale connection and settings
- [ ] Test remote access methods (RDP, Tailscale)

### Quarterly Tasks
- [ ] Review Windows Security settings
- [ ] Update security documentation
- [ ] Verify backup systems
- [ ] Check system performance
- [ ] Review and update maintenance procedures
- [ ] Full security audit including:
  - BitLocker status
  - Windows Defender
  - Firewall rules
  - Network configurations
  - User accounts
  - Update history
  - Backup verification

## Documentation Requirements

### For Each Scan
- [ ] Document scan type (quick/full)
- [ ] Record start and end times
- [ ] Note any threats found
- [ ] Document actions taken
- [ ] Record system impact

### For Each Update
- [ ] Document update name and KB number
- [ ] Record installation date/time
- [ ] Note any issues encountered
- [ ] Document system changes
- [ ] Record verification steps

### For Remote Access
- [ ] Document RDP connection details
- [ ] Record update success/failure
- [ ] Note any connection issues
- [ ] Document recovery procedures
- [ ] Record system response times

### For Security Configuration
- [x] Document account structure and privileges
- [x] Document BitLocker recovery key location
- [ ] Record all user accounts and their permissions
- [ ] List allowed firewall applications
- [ ] Note any custom firewall rules
- [ ] Document network configuration:
  - Tailscale IP addresses
  - ICS settings
  - Network adapter configurations
- [ ] Keep security audit logs

## Important Reminders
- Always ensure system is plugged into power during updates
- Maintain current backup before major updates
- Document all security-related changes
- Keep update history for troubleshooting
- Monitor system performance after updates
- BitLocker recovery key securely stored in multiple locations ✅
- Admin tasks performed with Admin-8vehma account
- Document management done through personal Microsoft account
- G9 has two Tailscale IPs: 100.122.141.83 (Windows) and 100.91.157.19 (Ubuntu)
- ICS is configured on Ethernet (sharing) to Ethernet 2
- All credentials are stored in iOS/macOS Passwords app
- Windows Defender enhanced security features enabled (2025-05-16)
- Windows Update service is running and updates checked (2025-05-16)
- Windows Defender full scan in progress (started 2025-05-16 21:01)
- Tailscale direct connection established with MacBook Pro (28.1ms latency)
- Tailscale device inventory and ACLs configured (2025-05-16)
- Account security review completed (2025-05-16)
- Two-factor authentication active on Microsoft account
- Windows Hello PIN configured for local login

## See Also
- [Network Configuration](network_configuration.md): Complete network setup and security details
- [Tailscale Configuration](tailscale_configuration.md): VPN and remote access setup
- [Home Server Plan](home_server_plan.md): Overall project plan
- [Archive Documentation](archive/README.md): Archived and historical documentation

### Archived Documentation
- [G9 Setup Checklist](archive/checklists/g9_setup_checklist.md): Completed setup checklist
- [Remote Desktop Testing](archive/checklists/remote_desktop_testing_checklist.md): Completed RDP testing
- [Tailscale ACL Configuration](archive/temporary/ACLS.txt): Tailscale access control settings

---
*Last updated: 2025-05-16* 