# Baton Hand-off

**Last Update:** 2025-05-13 03:25:30

## Session Summary

In this session, we worked on the following changes:

- Successfully installed and configured Ubuntu 24.10 (Oracular) on G9
- Configured GRUB bootloader for dual-boot with Windows 11
- Updated system password for enhanced security
- Successfully configured Tailscale MagicDNS and subnet routing
- Successfully configured G9 ethernet port for daisy-chaining
- Created detailed documentation for G9 ethernet port configuration
- Created comprehensive guide for Tailscale advanced configuration
- Update baton handoff document - 2025-05-13 03:25:30
- Update baton handoff document - 2025-05-13 02:45:20
- Update baton handoff document - 2025-05-13 01:36:19
- Update baton with G9 setup details and next steps

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

1. Verify Boot Configuration:
   - Test booting into both Ubuntu and Windows 11
   - Verify GRUB menu appears and functions correctly
   - Document any boot-related issues if they occur

2. Ubuntu Initial Setup:
   - Run system updates: `sudo apt update && sudo apt upgrade -y`
   - Install essential packages: curl, wget, git, net-tools, htop
   - Configure static IP if needed
   - Install Docker and Docker Compose
   - Set up SSH for remote access

3. Security Configuration:
   - Configure UFW firewall
   - Set up SSH key authentication
   - Disable password authentication for SSH
   - Document all new credentials in iOS Passwords app

4. Continue with Previous Plans:
   - Install Tailscale on Ubuntu and test connectivity
   - Set up document management system (Paperless-ngx)
   - Configure backup system (Duplicati)
   - Test MagicDNS and subnet routing functionality

## Important Files & Links

*   README.md: Main project documentation
*   home_server_plan.md: Home_Server_Plan
*   g9_setup_checklist.md: G9_Setup_Checklist
*   g9_ethernet_configuration.md: G9_Ethernet_Port_Configuration
*   tailscale_configuration.md: Tailscale_Advanced_Configuration
*   budget.md: Budget
*   research/server_options.md: Server_Options
*   requirements/needs_assessment.md: Needs_Assessment
*   recommendations/final_recommendation.md: Final_Recommendation
*   Pass_the_Baton/Pass_the_Baton/baton_template.md: Baton_Template
*   Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py: Pass_The_ Baton
*   comparison/solution_comparison.md: Solution_Comparison

## Important Reminders

- G9 NUC setup progress:
  - Windows 11 installed and updated
  - BitLocker encryption enabled
  - Admin account created (Admin-8vehma)
  - Mark Sakamoto account changed to standard user
  - Tailscale installed and configured (IP: 100.122.141.83)
  - Tailscale unattended mode enabled for persistent connection
  - OneDrive configured with HomeServer directory junction
  - Ethernet port daisy-chaining successfully configured using Internet Connection Sharing (ICS)
  - Ubuntu 24.10 (Oracular) installed in dual-boot configuration
  - GRUB configured on both boot devices
  - New Ubuntu password stored in iOS Passwords app
- All credentials stored in macOS/iOS Passwords app
- G9 Ethernet ports configuration:
  - Successfully configured Internet Connection Sharing on Ethernet adapter
  - Second ethernet port (Ethernet 2) now functioning as expected with IP 192.168.137.1
  - Devices connected to second ethernet port receive IP addresses via DHCP in 192.168.137.x range
  - Detailed configuration steps documented in g9_ethernet_configuration.md
- Tailscale advanced configuration:
  - MagicDNS enabled for easier device naming using hostnames
  - Subnet routing configured for 192.168.137.0/24 network
  - IP forwarding enabled on G9 Ethernet adapters
  - Devices on 192.168.137.x subnet can now be accessed through Tailscale
- Hardware notes:
  - Keyboard and monitor still needed for initial Ubuntu setup
  - Can boot into Ubuntu using F7 during startup

---
*This file is automatically updated by the Pass_the_Baton script.*
