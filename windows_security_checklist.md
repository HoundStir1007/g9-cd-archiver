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
- [ ] Recovery Key Security
  - [ ] Store PDF in secure cloud storage
  - [ ] Add recovery key to iOS/macOS Passwords app
  - [ ] Document location of all recovery key copies

### Windows Defender Full Scan
- [x] Initiate Full Scan (Started, in progress)
  - Started from Admin-8vehma account
  - Full system scan running in background
  - Will continue even if user switches
- [ ] Monitor Scan Progress
  - Started: 2025-05-16 21:01
  - Note: Full scan may take several hours
  - Check scan progress periodically
- [ ] Review Scan Results
  - Document any threats found
  - Note threat severity levels
  - Record actions taken for each threat
- [ ] Address Any Findings
  - For each threat:
    - Document the threat name and type
    - Note the affected files/locations
    - Record the action taken (quarantine/remove/allow)
    - Verify threat is resolved
- [ ] Update Scan History
  - Document scan completion time
  - Note any issues encountered
  - Record total threats found and resolved

### Windows Defender Configuration ✅
- [x] Verify Core Protection Features
  - Antivirus Enabled: ✅
  - Real-time Protection: ✅
  - Network Protection: Enabled ✅ (newly configured)
  - Controlled Folder Access: Enabled ✅ (newly configured)
  - PUA Protection: Active ✅
  - Cloud Protection: Active ✅

### Windows Update Check
- [ ] Check Current Update Status
  - Open Windows Update settings
    - Press Windows key + I
    - Navigate to Windows Update
  - Note current Windows version
  - Record last update check time
  - Document any pending updates
- [ ] Review Update History
  - Open Update History
  - Document last successful update
  - Note any failed updates
  - Record any update-related issues
- [ ] Check for Updates
  - Click "Check for updates"
  - Document available updates:
    - Feature updates
    - Quality updates
    - Driver updates
    - Other updates
- [ ] Review Update Details
  - For each update:
    - Note update name and KB number
    - Record update size
    - Document update importance
    - Check for known issues
- [ ] Prepare for Updates
  - Ensure system is plugged into power
  - Verify sufficient disk space
  - Check for open applications
  - Document current system state
- [ ] Install Updates
  - Click "Install now"
  - Document installation start time
  - Monitor installation progress
  - Note any restarts required
- [ ] Post-Update Verification
  - Verify system boots correctly
  - Check all critical applications
  - Document any issues encountered
  - Record update completion time

### Firewall Configuration ✅
- [x] Review Windows Defender Firewall Settings
  - Private Network Profile: Enabled ✅
  - Public Network Profile: Enabled ✅
  - Review needed for:
    - [ ] Remote Desktop rules
    - [ ] Tailscale permissions
    - [ ] File sharing settings

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

### Tailscale Security Configuration
- [ ] Access Control
  - [ ] Review ACL policies in Tailscale admin console
  - [ ] Configure device groups if needed
  - [ ] Set up node sharing permissions
- [ ] Network Security
  - [ ] Enable MagicDNS for secure name resolution
  - [ ] Configure subnet routing for local network access
  - [ ] Review exit node settings
- [ ] Device Management
  - [ ] Review all connected devices
  - [ ] Remove any unused device authorizations
  - [ ] Document each device's purpose and access level
- [ ] Monitoring
  - [ ] Set up alerts for device connections/disconnections
  - [ ] Monitor network usage and patterns
  - [ ] Document any unusual behavior

### Account Security
- [ ] Review User Accounts
  - Verify Admin-8vehma account permissions
  - Confirm standard user account limitations
  - Check password policies
  - Enable PIN/biometric login if available
- [ ] Check Microsoft Account Security
  - Verify 2FA is enabled
  - Review recent sign-in activity
  - Check linked devices
  - Review backup email/phone numbers

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
- BitLocker recovery key saved as "microsoft bitlocker key nucbox.pdf"
- BitLocker recovery key also saved to Microsoft account
- Admin tasks performed with Admin-8vehma account
- Document management done through personal Microsoft account
- G9 has two Tailscale IPs: 100.122.141.83 (Windows) and 100.91.157.19 (Ubuntu)
- ICS is configured on Ethernet (sharing) to Ethernet 2
- All credentials are stored in iOS/macOS Passwords app
- Windows Defender enhanced security features enabled (2025-05-16)

## See Also
- [G9 Setup Checklist](g9_setup_checklist.md)
- [Remote Desktop Testing Checklist](remote_desktop_testing_checklist.md)
- [Home Server Plan](home_server_plan.md)

---
*Last updated: 2025-05-16* 