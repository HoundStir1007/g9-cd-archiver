# Baton Hand-off

**Last Update:** 2025-05-12 20:37:18

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-05-12 20:37:18
- Update baton handoff document - 2025-05-12 18:09:38
- Update baton with G9 setup details
- Update baton handoff document - 2025-05-12 16:47:15
- Update baton handoff document - 2025-05-12 14:52:21

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

- Configure additional Tailscale settings (MagicDNS, subnet routing)
- Install Tailscale on other devices to connect to G9
- Set up file sharing and access controls
- Configure automated backups
- Install and configure required server applications
- Implement monitoring solution for server health
- Document network topology and access methods

## Important Files & Links

*   README.md: Main project documentation
*   home_server_plan.md: Home_Server_Plan
*   g9_setup_checklist.md: G9_Setup_Checklist
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
- All credentials stored in macOS/iOS Passwords app
- G9 Ethernet ports troubleshooting progress:
  - Confirmed G9 is accessible via Tailscale (100.122.141.83)
  - Current issue: Second ethernet port not properly configured
  - Troubleshooting steps to complete:
    1. Configure Internet Connection Sharing on Ethernet (not Ethernet 2)
    2. Select "Allow other network users..." and choose Ethernet 2 as home network
    3. If ICS doesn't work, try creating a bridge:
       - Select both ethernet adapters
       - Right-click and choose "Bridge Connections"
    4. For manual IP config on connected devices (if needed):
       - IP: 192.168.137.x (where x is a unique number between 2-254)
       - Subnet: 255.255.255.0
       - Router/Gateway: 192.168.137.1
       - DNS: 8.8.8.8 and 8.8.4.4
    5. Check firewall settings if connectivity issues persist

---
*This file is automatically updated by the Pass_the_Baton script.*
