# User Accounts & Firewall Permissions

This document lists all user accounts on the home server and their permissions, as well as allowed firewall applications.

---

## User Accounts

| Username           | Role                | OS         | Privileges                | Last Login      |
|--------------------|---------------------|------------|---------------------------|-----------------|
| Admin-8vehma       | Administrator       | Windows    | Full admin, maintenance   | [YYYY-MM-DD]    |
| Mark Sakamoto      | Standard User       | Windows    | Document management       | [YYYY-MM-DD]    |
| gmk                | Admin (default)     | Ubuntu     | Full admin                | [YYYY-MM-DD]    |
| [Add more as needed] |                     |            |                           |                 |

## Firewall Applications (Windows)

| Application/Service         | Allowed? | Ports/Protocols | Notes                      |
|-----------------------------|----------|-----------------|----------------------------|
| Remote Desktop (RDP)        | Yes      | TCP 3389        | User Mode, NLA required    |
| Tailscale                   | Yes      | Any             | VPN, device-based auth     |
| File and Printer Sharing    | Yes      | TCP 445         | Local subnet only          |
| Windows Defender Firewall   | Yes      | System          | Core protection            |
| [Add more as needed]        |          |                 |                            |

---

*Update this file whenever accounts or firewall rules change.*
