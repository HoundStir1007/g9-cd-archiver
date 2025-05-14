--- Archived on: 2025-04-25 02:10:49 ---

# Baton Hand-off

**Last Update:** 2025-04-25 02:09:55

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-04-25 02:09:55
- Initial commit for home server research project

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

- Review and test the recent changes
- Continue development on core features
- Add more comprehensive documentation
- Address any pending TODOs in the codebase

## Important Files & Links

*   README.md: Main project documentation
*   research/server_options.md: Server_Options
*   requirements/needs_assessment.md: Needs_Assessment
*   recommendations/final_recommendation.md: Final_Recommendation
*   Pass_the_Baton/Pass_the_Baton/baton_template.md: Baton_Template
*   Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py: Pass_The_ Baton
*   comparison/solution_comparison.md: Solution_Comparison

## Important Reminders

*(No reminders provided)*

---
*This file is automatically updated by the Pass_the_Baton script.*

--- Archived on: 2023-05-14 ---

# Baton Hand-off

**Last Update:** 2023-05-14

## Session Summary

In this session, we worked on the following:

- Created comprehensive home server plan with prioritized implementation strategy
- Identified existing hardware that can be repurposed (Raspberry Pi, Windows PC, Mac Mini)
- Evaluated multiple use cases with document management as primary focus
- Added network-wide ad blocking (Pi-hole) as second priority
- Included knowledge base and development environment in implementation plan
- Decided to use HomePod Mini for smart home control (keeping separate from server)
- Selected Tailscale for remote access solution (free tier)

## Next Steps

For the next session, consider the following steps:

1. **Hardware Assessment**
   - Check specifications of Windows PC and Mac Mini
   - Determine which device is better suited for document management
   - Verify Raspberry Pi model and capabilities

2. **Begin Implementation**
   - Set up Paperless-ngx on selected device
   - Configure Tailscale for remote access
   - Install Pi-hole on Raspberry Pi

3. **Research Knowledge Base Options**
   - Compare BookStack, WikiJS, and Obsidian Publish
   - Determine hardware requirements for selected option

4. **VM Environment Planning**
   - Select virtualization software (VirtualBox/KVM)
   - Plan resource allocation based on hardware capabilities

## Important Files & Links

*   `home_server_plan.md`: Main project plan with implementation strategy
*   `Pass_the_Baton/baton.md`: This handoff document
*   `Pass_the_Baton/baton_archive.md`: Archive of previous handoffs

## Important Reminders

- Document management is the primary focus - implement this first before expanding
- Using existing hardware is preferred over new purchases
- Remote document access via Tailscale is a key requirement
- The smart home control will be handled by HomePod Mini, not the server
- Pi-hole is a quick win that provides immediate value
- VM environment will be used for development testing without additional hardware

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-10 19:10:01 ---

# Baton Hand-off

**Last Update:** 2024-06-26

## Session Summary

In this session, we worked on the following:

- Developed comprehensive budget breakdown with tiered options
- Selected Synology DS220j with 2x 2TB WD Red drives as minimum viable NAS setup
- Decided on Uptime Kuma as free monitoring solution with notification capabilities
- Created offsite backup strategy using rotating external drives (to be purchased later)
- Established 3-2-1 backup approach with family member storing offsite backup
- Determined UPS is optional for initial setup given home use case
- Added Amazon Basics Standby UPS 800VA as the recommended entry-level UPS for basic power protection
- Explored network redundancy and caching options for improved reliability
- Defined simplified documentation approach using markdown files
- Created testing protocol framework for validating system functionality
- Evaluated DIY vs NAS tradeoffs and confirmed NAS advantages for dual-bay setup
- Determined new equipment is preferable to used/refurbished for reliability

## Recent Decisions

1. **Hardware Selection**
   - New Synology DS220j as primary NAS (~$190-210)
   - 2x 2TB WD Red drives for redundant storage (~$130-140)
   - **GMKtec NucBox G6 Mini PC (16GB/512GB SSD) as Application Server (~$200)**
   - **Amazon Basics Standby UPS 800VA (~$76) for basic battery backup and surge protection**
   - **Existing Mac Mini (Model A1347, est. Mid 2011/Late 2012)**
     - Processor: 2.5 GHz Dual-Core Intel Core i5
     - Current RAM: 4GB (2x2GB) 1600 MHz DDR3 SODIMM
     - Operating System: macOS Catalina 10.15.7 (Updated 2024-06-26)
     - **Constraint:** 4GB RAM limits multitasking. macOS Catalina is nearing end-of-life for security updates.
     - **Role:** Primarily a desktop client for accessing NAS/Pi services. Could potentially serve as a utility machine (e.g., scanning/ripping station connected to the NAS) **but is definitively NOT planned for any server roles** due to performance, OS security concerns, and the decision to use dedicated NAS/Pi hardware.
   - Defer offsite backup drive purchase until storage needs are confirmed

2. **Monitoring & Alerts**
   - Implement Uptime Kuma (running on Raspberry Pi via Docker) for system monitoring
   - Configure text/email notifications for critical events
   - Simple dashboard for system health visualization
   - Low resource requirements suitable for NAS deployment

3. **Backup Strategy**
   - Implement 3-2-1 backup rule (3 copies, 2 media types, 1 offsite)
   - Rotating offsite backup stored with family member
   - Utilize existing iCloud storage (2TB family plan) for cloud component
   - Weekly automated backups with monthly integrity verification

4. **Documentation Approach**
   - Begin with simple markdown files in central repository
   - Focus on critical information: logins, configurations, network settings
   - Potential future migration to self-hosted wiki once system is stable
   - Consider LLM assistance for documentation maintenance

## Next Steps

For the next session, consider the following steps:

1. **Purchase Planning**
   - Confirm exact model and compatibility of selected components
   - Identify best vendors/pricing for Synology DS220j and drives
   - Create timeline for phased purchases if needed
   - Determine any additional accessories required (cables, etc.)

2. **Initial Setup Planning (Expanded)**
   - **Synology NAS (DS220j) Setup:**
     - *Physical:* Install WD Red drives into NAS chassis.
     - *Connections:* Connect NAS to router via Ethernet cable. Connect power adapter.
     - *Power On:* Boot the NAS.
     - *Discovery:* On MacBook Pro, navigate to `find.synology.com` or use Synology Assistant tool to locate NAS on the network.
     - *DSM Install:* Follow the web-based wizard to install the latest DiskStation Manager (DSM) OS.
     - *Admin Account:* Create a strong password for the default `admin` account during setup. **Crucially, create a separate *daily use* administrator account immediately after setup and disable the default `admin` account for security.**
     - *Storage Pool/Volume:* Create a Storage Pool using both drives. Select SHR (Synology Hybrid RAID) for redundancy. Create a single large Volume using the Btrfs file system (enables snapshots and data integrity features).
     - *Network:* Configure a static IP address for the NAS (either via DSM settings or DHCP reservation on your router). Set a descriptive hostname (e.g., `synology-nas`).
     - *User Accounts:* Create individual, non-admin user accounts for yourself and each family member who will access the NAS.
     - *Shared Folders:* Create necessary shared folders (e.g., `Documents`, `Media`, `Backups`, `PiData`, `TimeMachine`) and set appropriate user/group permissions.
     - *Security Hardening:* Review Security Advisor recommendations. Enable automatic DSM updates. Configure the firewall to allow only necessary ports/services.
     - *Package Installation:* Install essential packages from Package Center: Hyper Backup, Synology Drive Server.
   - **Raspberry Pi 5 Setup:**
     - *Hardware Assembly:* Install Pi 5 board into case, attach cooling solution (heatsink/fan), connect USB SSD.
     - *OS Installation:* On MacBook Pro, use Raspberry Pi Imager to flash Raspberry Pi OS (64-bit Lite recommended) onto the USB SSD. Pre-configure user (`pi` or custom), enable SSH, and potentially set hostname/Wi-Fi credentials in the Imager's advanced options.
     - *Connections:* Connect Pi to router via Ethernet (recommended for server). Connect power supply.
     - *First Boot & SSH:* Power on the Pi. Find its IP address (via router interface or network scanning tool like `nmap`). SSH into the Pi from MacBook Pro Terminal (`ssh your_user@<pi-ip-address>`).
     - *Initial Configuration (`raspi-config` & manual):*
       - Run `sudo raspi-config`: Set locale, timezone, keyboard layout (if needed), ensure SSH is enabled under Interface Options.
       - Change default password if necessary (`passwd`).
       - Perform system updates: `sudo apt update && sudo apt full-upgrade -y`.
       - Set static IP address (edit `/etc/dhcpcd.conf` or use router DHCP reservation).
       - Reboot (`sudo reboot`).
     - *Essential Software Installation:* Install Docker (`curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh`), Docker Compose (follow official docs for plugin install), `git`, `nfs-common` (if using NFS for NAS mounts), `cifs-utils` (if using SMB/CIFS for NAS mounts), `ufw` (firewall).
     - *Firewall Configuration:* Configure `ufw`: `sudo ufw allow ssh`, `sudo ufw allow <port_for_service_1>`, `sudo ufw allow <port_for_service_2>`, etc. `sudo ufw enable`.
     - *Mount NAS Shares:* Create mount points on the Pi (e.g., `sudo mkdir -p /mnt/nas/audiobooks`). Edit `/etc/fstab` to automatically mount the corresponding NAS shared folders (using NFS or SMB, ensure NAS permissions allow Pi access). Test mounts with `sudo mount -a`.
   - **Network Integration:**
     - Plan IP address range and assign static IPs/DHCP reservations for NAS and Pi.
     - Ensure MacBook Pro, NAS, and Pi are on the same network subnet initially.
     - Configure router DNS if planning to use Pi-hole/AdGuard later (defer if not implementing now).

3. **Service Prioritization**
   - Define order of service implementation
   - Document dependencies between services
   - Establish success criteria for each service
   - Create testing plan for validation

4. **Integration with Existing Systems**
   - Plan Mac Mini and NAS interaction
   - Document network requirements
   - Prepare iCloud integration strategy
   - Identify potential compatibility issues

## Critical Decisions Needed

Before implementation can begin, these key decisions will determine the entire project path:

1. **Hardware Allocation**
   - Which specific device will run which service? **Decision: Synology NAS (DS220j) for core storage, backups (Hyper Backup), file sync (Synology Drive). Raspberry Pi 5 for applications (Uptime Kuma, CUPS, Actual Budget, Audiobookshelf, potentially Pi-hole/AdGuard via Docker).**
   - Mac Mini vs Windows PC: Which has better specs for document management? **Decision: N/A. NAS handles core document management. Mac Mini is a client/utility machine only.**
   - Raspberry Pi model confirmation: Is it powerful enough for Pi-hole? **Decision: Yes, RPi 5 is sufficient. Alternatively, Pi-hole/AdGuard can run via Docker on the Pi.**
   - Will one device host multiple services or will we distribute across hardware? **Decision: Distribute - NAS for storage/backup essentials, RPi 5 for applications.**
   - **All-in-One Option**: Consider purchasing a dedicated NAS solution (Synology, QNAP) that can run multiple services **Decision: Proceeding with Synology DS220j + Raspberry Pi 5.**

2. **Operating System Strategy**
   - Can we use macOS for most services (user preference)?
   - Which services absolutely require Linux/Windows?
   - Should we use virtualization on macOS to run Linux-only services? **Decision: No, Raspberry Pi 5 will run Linux-based services.**

3. **Storage Architecture**
   - How much storage is needed for document management and file sharing?
   - Will we use external drives, NAS, or internal storage?
   - Backup strategy: local, cloud, or both?

4. **Network Configuration**
   - How will we configure the router for Pi-hole?
   - Will all devices be on the same network?
   - Is the current home internet connection sufficient?

5. **Security Approach**
   - How will we secure access to uploaded files?
   - Authentication strategy for remote access?
   - Will we need VPN beyond Tailscale for any services?

## Simplicity Principles

To ensure the home server remains manageable and sustainable:

1. **Minimize Complexity**
   - Choose solutions with good documentation and active communities
   - Prefer containerized applications (Docker) for easier management
   - Limit the number of different technologies in use
   - Favor managed services where appropriate

2. **Avoid Over-Engineering**
   - Start with essential services and expand only as needed
   - Don't implement features "just because we can"
   - Choose mature, stable software over bleeding-edge options

3. **Prioritize Maintainability**
   - Document all configuration changes
   - Set up automated backups from day one
   - Use standard ports and configurations when possible
   - Implement monitoring for early problem detection

## Exit Strategies

For each component, having a clear exit plan ensures flexibility:

1. **Document Management**
   - Export all documents to standard formats (PDF, TXT)
   - Ensure metadata is exportable to CSV/JSON
   - Backup strategy should make transition to another system straightforward
   - Exit option: Migrate to cloud service like Google Drive/Dropbox

2. **File Sharing**
   - Keep original files in standard formats
   - Maintain regular backups that are system-agnostic
   - Exit option: Switch to Dropbox, Google Drive, or similar service

3. **Pi-hole**
   - Document custom configurations
   - Keep list of blocked domains exportable
   - Exit option: Revert to standard DNS (ISP or public DNS like 1.1.1.1)

4. **Knowledge Base**
   - Select system with standard export formats (Markdown preferred)
   - Avoid proprietary formats when possible
   - Exit option: Export to static files or migrate to hosted wiki

5. **Hardware Repurposing**
   - Document steps to factory reset or repurpose all hardware
   - Keep original OS installation media (or know how to use macOS Recovery)
   - Plan for data wiping if hardware will be sold/donated
   - **Mac Mini A1347:** Currently running macOS Catalina 10.15.7. Can be upgraded to 16GB RAM. Original 500GB HDD confirmed healthy via Disk Utility First Aid (2024-06-26). Ethernet connection verified. **Note: This device will function as a client or utility machine, not a server.**

6. **Domain and DNS**
   - Use registrar with easy transfer process
   - Document all DNS records
   - Exit option: Let domain expire or transfer to another service

## NAS Solutions & LLM Hosting Considerations

### NAS Capabilities Overview (Focus on Selected DS220j)

1. **Entry-Level NAS ($200-400) - Relevant to DS220j**
   - Synology DS220j, QNAP TS-230
   - Good for: Document management (Synology Drive), basic file sharing, media serving (Audio Station, Video Station - limited transcoding), Time Machine backups, Hyper Backup.
   - Limited for: Running multiple/heavy Docker containers, Virtual Machines (not supported), resource-intensive applications (like Plex *transcoding*).
   - **LLM Capability**: Not suitable for running LLMs locally.

2. **Mid-Range NAS ($400-700) - *Not Applicable to Current Plan***
   - Synology DS920+, QNAP TS-453D
   - Good for: All basic services, more robust Docker container support, light VM usage.
   - **LLM Capability**: Could potentially run very small LLMs with limitations.
   - Typical specs: Intel Celeron, 4-8GB RAM (upgradable to 8-16GB).

3. **High-End NAS ($700-1500) - *Not Applicable to Current Plan***
   - Synology DS1621+, QNAP TS-673A
   - Good for: Multiple VMs, extensive containers, heavy transcoding, advanced applications.
   - **LLM Capability**: May run smaller LLMs (7B parameter models) with optimization.
   - Typical specs: AMD Ryzen or Intel Xeon, 8-32GB RAM capacity.

### Potential NAS Benefits (Contextualized for DS220j & RPi Setup)

*(Note: Some features are inherent to DSM on DS220j, others may require RPi or are less performant on entry-level hardware)*

1. **Enhanced Document Management (DS220j: Strong)**
   - **Built-in Apps**: Synology Drive (Dropbox-like functionality) - Core use case.
   - **OCR Capabilities**: Not natively built-in to DS220j; would require companion app or workflow on another machine (e.g., Mac Mini utility).
   - **Version Control**: Automatic file versioning via Synology Drive.
   - **Preview Generation**: Basic thumbnail/preview creation for common formats.

2. **Advanced File Sharing (DS220j: Good)**
   - **User Management**: Create multiple users with different permissions.
   - **Link Sharing**: Generate temporary links with expiration dates.
   - **Upload Portals**: Available via Synology Drive for others to upload files.
   - **Guest Accounts**: Possible with specific permissions.

3. **Backup Superpowers (DS220j: Strong)**
   - **Automated Snapshots**: *Requires Btrfs volume, supported on DS220j.* Point-in-time recovery.
   - **3-2-1 Backup**: Built-in tools (Hyper Backup) for local and cloud backup strategies.
   - **App-Specific Backup**: Hyper Backup can backup some application data.
   - **Disk Redundancy**: RAID/SHR protection against drive failures.

4. **Media Management (DS220j: Basic/Moderate; RPi may supplement)**
   - **Photo Organization**: Synology Photos (AI features may be slower).
   - **Media Streaming**: Audio Station, Video Station (limited *transcoding*). Plex/Emby/Audiobookshelf better run on RPi, accessing NAS storage.
   - **Transcoding**: **DS220j has very limited hardware transcoding.** Direct play preferred. RPi 5 offers better potential here if needed.
   - **Mobile Apps**: Synology provides mobile apps (DS file, DS photo, DS audio, etc.).

5. **Home Automation Hub (DS220j: Limited/None)**
   - **Central Control**: Not a primary function of DS220j. Use HomePod Mini.
   - **Surveillance Station**: **Supported**, but license costs apply beyond 2 cameras. Performance limited by CPU.
   - **Automation Rules**: Minimal built-in NAS automation.
   - **Data Logging**: Not a typical NAS function.

6. **Knowledge Base Advantages (DS220j: Good via Markdown/Drive; RPi for Wiki)**
   - **Wiki Software**: Can run lightweight wikis via Docker *if* needed, but likely better on RPi. **Preferred: Markdown in Synology Drive.**
   - **Notes Applications**: Synology Note Station available.
   - **Collaboration Tools**: Basic collaboration via Synology Office/Drive.
   - **Search Capabilities**: Universal Search package can index files.

7. **Development Perks (DS220j: Very Limited; RPi is focus)**
   - **Container Support**: **Not officially supported via Docker package on DS220j.** Use RPi 5.
   - **CI/CD Options**: Not feasible on DS220j. Use RPi or external services.
   - **Web Hosting**: Basic web station available, but RPi better suited.
   - **Version Control**: Can run Git Server package, but resource-limited. RPi or external services likely better.

### LLM Hosting Requirements (Archived Idea for this Setup)

1. **Hardware Demands for Local LLMs**
   - CPU: Modern multi-core processor (i5/i7/Ryzen 5+ recommended)
   - RAM: Minimum 16GB, 32GB+ preferred for usable performance
   - Storage: Fast SSD for model loading (NVMe preferred)
   - GPU: Highly beneficial, integrated graphics insufficient for good performance
   - **Conclusion:** Neither DS220j nor Raspberry Pi 5 are suitable for running local LLMs effectively. Mac Mini also insufficient without significant upgrades and GPU.

2. **Alternative LLM Approaches (If desired later)**
   - **API-based**: Use external APIs (OpenAI, Anthropic) - requires internet, potential cost.
   - **Cloud solution**: Use cloud services for LLM processing.
   - **Dedicated Machine**: Future possibility if a powerful desktop/server is added.

3. **Cost-Effective LLM + NAS Solution (Archived)**
   - Repurpose existing Mac Mini or PC as dedicated LLM server - **Decision: Mac Mini not suitable.**
   - Add external storage or entry-level NAS for document management - **Decision: Using NAS + RPi.**
   - Connect via local network for integrated experience
   - Estimated total cost: $200-600 depending on existing hardware

## DIY vs. NAS: Feature Comparison

This comparison helps decide between repurposing existing hardware vs. purchasing a dedicated NAS.

| Feature | DIY Home Server | NAS Solution |
|---------|----------------|--------------|
| **Document Management** | ✅ Possible with Paperless-ngx<br>⚠️ Requires manual setup<br>⚠️ Need to configure OCR | ✅ Built-in document apps<br>✅ Integrated OCR out-of-box<br>✅ Version control included |
| **File Sharing** | ✅ Possible with NextCloud/Seafile<br>⚠️ Requires web server setup<br>⚠️ Manual SSL configuration | ✅ Dedicated upload portals<br>✅ Mobile apps included<br>✅ Easy link sharing with expiry |
| **Ad Blocking** | ✅ Pi-hole works great on Raspberry Pi<br>✅ Better customization<br>✅ More block lists | ⚠️ Limited ad-blocking apps<br>⚠️ Not as powerful as Pi-hole<br>✅ Basic DNS filtering |
| **Backups** | ✅ Possible with scripts/tools<br>⚠️ Manual configuration<br>⚠️ No built-in snapshots | ✅ One-click backup setup<br>✅ Automated snapshots<br>✅ Integrated cloud backup |
| **Remote Access** | ✅ Works with Tailscale<br>⚠️ Manual port forwarding<br>⚠️ Security concerns | ✅ Built-in secure access<br>✅ Mobile apps included<br>✅ No port forwarding needed |
| **Knowledge Base** | ✅ Possible with WikiJS/BookStack<br>⚠️ Manual installation<br>⚠️ Database configuration | ✅ Built-in note/wiki apps<br>✅ No database setup needed<br>✅ Mobile access included |
| **Media Streaming** | ✅ Possible with Plex/Jellyfin<br>⚠️ Transcoding limitations<br>⚠️ Manual media organization | ✅ Built-in media server<br>✅ Automatic media organization<br>✅ Photos AI categorization |
| **Development** | ✅ Great flexibility (on RPi/PC)<br>✅ Better performance (on RPi/PC)<br>✅ Full OS access (on RPi/PC) | ⚠️ Limited package options (on NAS)<br>⚠️ Constrained environment (on NAS)<br>✅ Container support (RPi focus) |
| **Ease of Setup** | ⚠️ Requires Linux knowledge<br>⚠️ Multiple configuration files<br>⚠️ Software compatibility issues | ✅ Web-based interface<br>✅ One-click app installs<br>✅ Pre-configured services |
| **Maintenance** | ⚠️ Manual updates<br>⚠️ Potential dependency conflicts<br>⚠️ Troubleshooting complexity | ✅ Automated updates<br>✅ Integrated health monitoring<br>✅ Vendor support available |
| **Hardware Costs** | ✅ Reuse existing hardware (Mac Mini as client)<br>✅ Raspberry Pi Cost<br>✅ Gradual expansion possible | ⚠️ NAS Upfront purchase required<br>⚠️ $200-400 for entry-level NAS<br>✅ Purpose-built reliability |
| **Electricity Usage** | ⚠️ Likely higher (desktop PC)<br>⚠️ Multiple devices needed<br>✅ Raspberry Pi is efficient | ✅ Low power consumption<br>✅ Single device solution<br>✅ Sleep mode support |

### Key Takeaways

1. **DIY Solution Strengths**
   - Lower initial cost (using existing hardware)
   - Greater flexibility and customization
   - Better performance for compute-intensive tasks
   - Pi-hole works exceptionally well on Raspberry Pi

2. **NAS Solution Strengths**
   - Much simpler setup and maintenance
   - All-in-one integrated ecosystem
   - Purpose-built for reliability and energy efficiency
   - Built-in apps require minimal configuration

3. **Hybrid Approach Possibility**
   - Use Raspberry Pi for Pi-hole (best-in-class solution) **and other applications (CUPS, Actual, Audiobookshelf, Uptime Kuma).**
   - Add NAS (DS220j) for document management, file sharing, **backups, and core storage.**
   - Leverage existing Mac Mini/PC **as clients or for specific non-server utility tasks (scanning, ripping).**
   - Connect all with Tailscale for secure remote access.

## Expanded Hybrid Approach

**(Note: This section is less relevant now as the Mac Mini server role is decided against. Keeping for context on potential future *client* or *utility* roles.)**

If finding a Raspberry Pi is difficult **(Decision: RPi 5 selected)**, a hybrid approach using NAS + Mac Mini offers many advantages:

### NAS Role in Hybrid Setup (Beyond Document Management)

1. **Central Storage Hub**
   - Document management with version control
   - File sharing with upload portals for receiving files
   - Media library (photos, videos, music)
   - Time Machine backup destination for all Apple devices

2. **Automated Backup System**
   - Backup destination for Mac Mini and other computers
   - Scheduled snapshot system for point-in-time recovery
   - Cloud backup synchronization (if desired)
   - RAID protection against drive failures

3. **Knowledge Base Platform**
   - Wiki system for documentation (Wiki.js or built-in apps)
   - Note-taking and organization
   - Shared calendars and task management
   - Document collaboration space

4. **Basic Service Hosting**
   - Simple web services via Docker containers **(Not on DS220j, use RPi)**
   - Home automation integrations and history **(Not planned)**
   - Download management (torrents, etc.) - **Possible via Download Station package**
   - Scheduled tasks and automation - **Possible via Task Scheduler**

### Mac Mini Role in Hybrid Setup (Client/Utility Focus)

1. **Performance Computing (Client-side)**
   - Development environment and testing (connecting to NAS/Pi resources)
   - Photo/video editing workstation (accessing media on NAS)
   - Running specific macOS applications.
   - Utility tasks like CD/DVD ripping, scanning directly to NAS shares.

2. **Network Services (Archived Idea - Use RPi)**
   - Pi-hole ad blocking (if no Raspberry Pi available) - **Decision: Use RPi.**
   - VPN server for additional security - **Decision: Use Tailscale.**
   - More complex web applications - **Decision: Use RPi.**
   - Database hosting if needed - **Decision: Use RPi (Docker) or NAS package if light.**

### Alternative to Raspberry Pi

If a Raspberry Pi is unavailable, these options can run Pi-hole:

1. **Virtual Machine on Mac Mini**
   - Run lightweight Linux VM specifically for Pi-hole
   - Minimal resource allocation needed (1 CPU, 512MB RAM)
   - Keep VM always running in background

2. **Docker on NAS**
   - Most mid-range NAS supports Docker
   - Pi-hole has official Docker image
   - Simple to set up with minimal configuration

3. **Pi-hole Alternative on NAS**
   - AdGuard Home (available for many NAS systems)
   - Similar functionality to Pi-hole
   - Native package for Synology/QNAP

### AdGuard Home Details
- **Cost**: Free and open-source (no subscription fees)
- **Installation**: Available as Docker container or native app
- **Resources**: Minimal (64MB RAM, minimal CPU)
- **Features**: DNS filtering, ad blocking, parental controls
- **Differences from Pi-hole**: More modern UI, built-in HTTPS, simpler setup

### Mac Mini Hardware Requirements

| Requirement | Minimum Specs | Recommended Specs | Notes |
|-------------|---------------|-------------------|-------|
| **CPU** | Core 2 Duo | Core i5 or newer | Dual-core minimum for virtualization |
| **RAM** | 4GB | 8GB+ | 8GB+ recommended if running VMs |
| **Storage** | 120GB SSD/HDD | 256GB+ SSD | SSD strongly preferred for performance |
| **macOS** | 10.13 High Sierra | 10.15+ Catalina | Newer OS better for modern tools |
| **Network** | Gigabit Ethernet | Gigabit Ethernet | Wired connection recommended |

#### How to Check Your Mac Mini Specs:
1. Click on Apple menu (🍎) → About This Mac
2. View basic specs on the initial screen (macOS version, processor, memory)
3. Click "System Report" for more detailed information
4. Key sections to check: Hardware (processor, memory, storage) and Network

#### Mac Mini Role Compatibility
Even an older Mac Mini (2012+) should handle:
- **Client tasks**: Accessing NAS/Pi services, web browsing, office apps.
- **Utility tasks**: Scanning, ripping media.
- **Lightweight non-server tasks**.

For more intensive tasks (video editing, etc.), a Mac Mini 2014+ with 8GB+ RAM would be better suited, but still **not as a server**.

## Server Uptime Considerations

### Critical 24/7 Services vs. Flexible Services

| Service | Uptime Needs | Impact of Downtime |
|---------|--------------|-------------------|
| **Pi-hole/AdGuard** | High - needed whenever internet is used | Temporary loss of ad blocking, fallback to regular DNS |
| **Remote Access** | High - needed for accessing away from home | Unable to access files/services remotely during outage |
| **Document Management** | Low/Medium - mostly used on-demand | Documents unavailable during outage, no data loss |
| **File Sharing** | Low/Medium - mostly used on-demand | Files unavailable during outage, uploads would fail |
| **Backups** | Low - can run when system is available | Missed backup window, will run at next opportunity |
| **Knowledge Base** | Low - mostly used on-demand | Content unavailable during outage, no data loss |

### Power Management Options

1. **Scheduled Start/Shutdown for Mac Mini**
   - Built into macOS: System Preferences → Energy Saver → Schedule
   - Set specific times for automatic startup/shutdown
   - Example: Power on at 7am, shut down at 11pm daily
   
2. **Scheduled Power for NAS**
   - Most NAS devices have built-in power schedules
   - Can set different schedules for weekdays/weekends
   - Some allow different schedules for specific services

3. **Auto-Restart After Power Loss**
   - **Mac Mini**: Enable in Recovery Mode → Startup Security Utility → "Allow boot from external or removable media" (varies by model)
   - **NAS Devices**: Typically enabled by default in power settings
   - **Services**: Configure as startup items to auto-launch

4. **UPS (Uninterruptible Power Supply) Options**
   - **Amazon Basics Standby UPS 800VA (~$76):** Provides basic battery backup (6–90 min depending on load) and surge protection. Suitable for safe shutdown of NAS and server during short outages. Not suitable for high-draw equipment or long runtime, but covers the essentials for a home server setup.
   - Basic UPS (~$50-100): Provides 5-15 minutes to safely shut down
   - Mid-range UPS (~$100-200): 30+ minutes of runtime, USB connectivity for automated shutdown
   - Most NAS devices can connect directly to a UPS via USB for controlled shutdown
   - Mac Mini can use software like "UPS Companion" to monitor UPS status

### Balancing Power Usage and Availability

1. **Always-On Approach**
   - Pros: Always available, no waiting for boot-up
   - Cons: Higher power consumption, more wear on hardware
   - Best for: Households with frequent remote access needs

2. **Scheduled Approach**
   - Pros: Reduced power consumption, extended hardware life
   - Cons: Services unavailable during off-hours
   - Best for: Predictable usage patterns (e.g., only needed during evenings/weekends)

3. **On-Demand Approach (Mac Mini)**
   - Use Wake-on-LAN to start Mac Mini remotely when needed
   - Requires another device to send the wake signal
   - Lowest power consumption but requires more technical setup

### Recommended Beginner Setup

For someone new to home servers, a balanced approach would be:
- Keep NAS always on (they're designed for 24/7 operation with low power usage)
- Schedule Mac Mini to run during your active hours **(Optional, as it's primarily a client)**
- Start with basic power protection (surge protector at minimum)
- Consider a UPS later if uptime becomes more important

## Apple Ecosystem Integration

### NAS and iCloud Considerations

1. **iCloud and NAS Complementary Usage**
   - NAS doesn't directly integrate with iCloud backup for iOS devices
   - iCloud continues to handle iOS device backups independently
   - NAS serves as additional/complementary storage solution

2. **Apple Ecosystem Integration Points**
   - **Time Machine Backups**: NAS can be a destination for Mac backups
   - **Photo Library**: Can complement/replace iCloud Photos using Synology Photos or similar
   - **File Sharing**: Can serve as extended storage beyond iCloud Drive limits
   - **HomeKit**: Some NAS models offer limited HomeKit compatibility via apps

3. **iCloud Limitations to Consider**
   - Limited storage space (50GB/$0.99, 200GB/$2.99, 2TB/$9.99 monthly)
   - No versioning for most files (unlike NAS snapshots)
   - No selective sync options for many file types
   - Less granular sharing permissions than NAS solutions

4. **Apple-Friendly NAS Features**
   - **AFP/SMB Support**: Connect directly from Finder
   - **iOS Apps**: Synology/QNAP have dedicated iOS apps
   - **AirPlay**: Many NAS media servers support AirPlay streaming
   - **WebDAV**: Can mount as network drive in macOS

5. **Synology Apple Ecosystem Benefits**
   - **Synology Photos**: Can replace or complement iCloud Photos
   - **Synology Drive**: Dropbox/iCloud Drive alternative with iOS app
   - **DS File**: iOS file browsing app for your NAS content
   - **Moments**: AI photo organization similar to Apple Photos

6. **Recommended Setup for Apple Users**
   - Continue using iCloud for:
     - iOS device backups
     - App data synchronization
     - Documents you need on all devices all the time
   - Use NAS for:
     - Mac Time Machine backups
     - Photo/video library (primary or secondary copy)
     - Large media files
     - Document archives and versioning
     - Extended family sharing
   
7. **Migration Considerations**
   - Photos can be exported from iCloud to NAS photo apps
   - Documents can be moved from iCloud Drive to NAS
   - Create automated sync between selected iCloud and NAS folders
   - Consider bandwidth usage when initially populating NAS from iCloud

## Topics Needing Expansion

The following areas require further discussion or development:

1. **Implementation Timeline** 📅
   - Personal project with no strict deadlines
   - Upgrade components as needed/desired
   - Focus on core functionality first, then expand

2. **Testing Protocol Framework** 🧪
   - Data integrity verification (checksums on important files)
   - Backup restoration test (can you actually restore from backup)
   - Network access test (VPN/Tailscale connectivity)
   - Drive failure simulation (remove one drive to test RAID)
   - Service restart test (all services auto-start properly after reboot)
   - Monitoring alert test (Uptime Kuma notifications work)

3. **Service Configuration Details** ⚙️
   
   **Synology DSM Initial Setup**
   - **First Time Setup**:
     - Connect NAS to router via Ethernet
     - Visit find.synology.com in browser
     - Follow DSM installation wizard
     - Create admin account with strong password
     - Create separate non-admin user accounts for daily use, keeping admin account for administrative tasks only
     - Set up QuickConnect for remote access
   
   **Drive Configuration**
   - Set up SHR (Synology Hybrid RAID) for 2x drives
   - Enable periodic S.M.A.R.T tests and bad sector scans
   - Configure drive hibernation for power savings
   - Create shared folders for documents and backups
   
   **Raspberry Pi 5 Initial Setup & Services**
   - Install Raspberry Pi OS (64-bit recommended) onto USB SSD
   - Initial configuration via SSH (set hostname, static IP recommended)
   - Install Docker and Docker Compose
   - **CUPS Print Server Setup**:
     - Install CUPS package
     - Connect Brother HL-3170CDW via USB
     - Configure CUPS to detect and share printer (enable AirPrint)
   - **Uptime Kuma Setup (via Docker)**:
     - Deploy Uptime Kuma container (adjust volume path as needed):
       ```bash
       docker run -d --restart=always -p 3001:3001 -v uptime-kuma-data:/app/data --name uptime-kuma louislam/uptime-kuma:1
       ```
     - Access via http://<pi-ip-address>:3001
     - Configure monitors for NAS, Pi itself, Router, external site
     - Configure notifications
   - **Actual Budget Setup (via Docker)**:
     - Deploy Actual Budget container (details TBD, check documentation)
     - Plan for data import from Rocket Money CSV export
   - **Audiobookshelf Setup (via Docker)**:
     - Deploy Audiobookshelf container (details TBD, check documentation)
     - Mount NAS audiobook folder as volume for the container
   - **Tailscale Implementation**:
     - Install Tailscale on Raspberry Pi OS
     - Authenticate and enable subnet routing if needed (alternative to NAS handling it)
   
   **Synology Service Adjustments**
   - (If Pi handles Tailscale) Disable Tailscale on Synology to avoid conflicts, or configure carefully.
   - Ensure NAS shared folders (for Audiobookshelf data, Actual Budget backups, etc.) are accessible by the Pi (e.g., via NFS or SMB mount configured on the Pi).

   **Uptime Kuma Setup**
   - Install Docker package from Package Center
   - Deploy Uptime Kuma container:
     ```
     docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1
     ```
   - Access via http://NAS-IP:3001
   - Configure monitors:
     - Basic HTTP/ping for internet connectivity
     - NAS services health check
     - Mac Mini availability check
     - Router admin page or external site (like google.com) to differentiate between local network issues and internet outages
   - Set up notifications via:
     - Email alerts
     - Push notifications to mobile
     - Optional SMS for critical alerts
   
   **Tailscale Implementation**
   - Install Tailscale package from Synology Package Center
   - Authenticate with Tailscale account
   - Configure subnet routing for entire home network access
   - Install Tailscale on all client devices
   - Use MagicDNS for friendly hostnames
   
   **Backup Automation**
   - Configure Hyper Backup package:
     - Create backup task for important shared folders
     - Schedule weekly full backups
     - Enable versioning (keep last 4 versions)
   - Set up Cloud Sync for cloud service integration
   - Configure external drive backup rotation schedule
   - Set up Mac Time Machine backups to NAS

4. **Knowledge Base Implementation** 📚
   
   **Recommended Solution: Markdown in Synology Drive**
   - Create dedicated shared folder for documentation
   - Organize with folder structure:
     ```
     /Documentation
       /Hardware
       /Network
       /Services
       /Procedures
       /Troubleshooting
     ```
   - Use Markdown files with consistent naming:
     - hardware-specs.md
     - network-diagram.md
     - backup-procedures.md
   - Enable versioning in Synology Drive
   - Access/edit via:
     - Synology Drive web interface
     - Synology Drive desktop client
     - Mobile app for viewing on the go
   
   **Documentation Priorities**
   - System credentials (stored securely)
   - Network configuration details
   - Hardware specifications and warranty info
   - Backup schedules and verification procedures
   - Troubleshooting guides for common issues
   
   **Alternative: Wiki.js (if more features needed)**
   - Install via Docker
   - Structured, searchable knowledge base
   - Good mobile experience
   - User authentication
   - More complex setup but better for larger documentation needs

5. **Network Security Model** 🔒
   
   **Access Security**
   - Implement biometric authentication on devices where possible
   - Use Apple/Google account integration for simplified auth
   - Enable 2FA on Synology DSM admin account
   - Create separate user accounts for family members
   - Use strong, unique passwords (password manager recommended)
   
   **Network Security**
   - Create segregated network for IoT devices
   - Keep NAS firmware updated automatically
   - Enable auto-updates for all services
   - Configure firewall on NAS to allow only necessary services
   - Use Tailscale instead of port forwarding for remote access
   
   **Data Security**
   - Enable encryption for sensitive shared folders
   - Implement encrypted backups for offsite storage
   - Use secure erase when decommissioning drives
   - Regular security audits (quarterly recommended)
   - Monitor login attempts and unusual activity
   
   **Security Maintenance**
   - Monthly check for firmware/software updates
   - Quarterly password rotation for critical systems
   - Annual security posture review
   - Maintain incident response plan for potential breaches

6. **Detailed Hardware Comparison** 💻
   - Confirmed: Synology DS220j with 2x 2TB+ WD Red drives
   - Good entry-level choice for document management and backups
   - Expandable later if needed

## Important Files & Links

*   `home_server_plan.md`: Main project plan with implementation strategy
*   `Pass_the_Baton/baton.md`: This handoff document
*   `Pass_the_Baton/baton_archive.md`: Archive of previous handoffs

## Important Reminders

- Document management is the primary focus - implement this first before expanding
- Using existing hardware is preferred over new purchases
- Remote document access via Tailscale is a key requirement
- The smart home control will be handled by HomePod Mini, not the server
- Pi-hole is a quick win that provides immediate value
- VM environment will be used for development testing without additional hardware **(Clarification: If needed, VMs would run on a capable client machine like the MacBook Pro, not the Mac Mini or NAS/Pi)**
- Consider hybrid approach with NAS for document/file management + Mac Mini for other services **(Decision: NAS + RPi for services; Mac Mini as client/utility)**
- Prioritize compatibility with Apple ecosystem

---

## Archived Ideas & Decisions Against

This section logs approaches considered but ultimately decided against to avoid revisiting them unnecessarily.

1.  **Mac Mini as a Server:** The existing Mac Mini (A1347, Mid 2011/Late 2012) will **not** be used for server roles (hosting services like Pi-hole, web apps, VMs, etc.). Reasons: Limited RAM (4GB), aging hardware, macOS Catalina nearing end-of-life for security updates, better suitability of dedicated NAS/RPi hardware. Its role is strictly client/utility.
2.  **DIY-Primary Approach (using only Mac Mini/PC):** While possible, a dedicated NAS (DS220j) was chosen for core storage, backup, and file sync due to its simplicity, reliability, energy efficiency, and built-in features (Synology Drive, Hyper Backup, SHR). The RPi 5 complements this for application hosting.
3.  **Local LLM Hosting:** Running Large Language Models locally is not feasible with the chosen hardware (DS220j, RPi 5, existing Mac Mini) due to significant CPU, RAM, and potential GPU requirements. If LLM integration is desired later, API-based or cloud solutions are the viable options.
4.  **Heavy Docker/VM Usage on NAS:** The selected Synology DS220j is an entry-level NAS and is not suitable for running multiple/heavy Docker containers or virtual machines. Docker hosting will be handled by the Raspberry Pi 5.
5.  **High-Performance Media Transcoding on NAS:** The DS220j has limited hardware transcoding capabilities. Media streaming will rely on direct play or potentially transcoding handled by the Raspberry Pi 5 if needed (e.g., within Plex/Jellyfin/Audiobookshelf running on the Pi).
6.  **Complex Network Services on Mac Mini:** Services like Pi-hole, VPN servers (beyond Tailscale), or complex web apps will be hosted on the Raspberry Pi 5, not the Mac Mini.

*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-10 22:24:23 ---

# Baton Hand-off

**Last Update:** 2025-05-10 19:10:01

## Session Summary

In this session, we worked on the following changes:

- Updated budget document with a phased purchasing approach
- Reorganized priorities to purchase Application Server (GMKtec NucBox G6) first
- Created clear criteria for when to move to subsequent purchases
- Leveraged existing iCloud storage as temporary solution before NAS purchase
- Split Phase 1 into sub-phases (1A for immediate app server, 1B for later NAS components)

These changes focused on improving project functionality and structure while allowing for more budget flexibility.

## Next Steps

For the next session, consider the following steps:

- Research exact specifications and setup requirements for the GMKtec NucBox G6
- Investigate Linux/Docker setup for running Paperless-ngx on the mini PC
- Plan Tailscale configuration to enable remote document access
- Research detailed backup strategies with iCloud before NAS purchase
- Prepare implementation docs for Phase 1A (app server) deployment

## Important Files & Links

*   README.md: Main project documentation
*   home_server_plan.md: Home_Server_Plan
*   budget.md: Budget
*   research/server_options.md: Server_Options
*   requirements/needs_assessment.md: Needs_Assessment
*   recommendations/final_recommendation.md: Final_Recommendation
*   Pass_the_Baton/Pass_the_Baton/baton_template.md: Baton_Template
*   Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py: Pass_The_ Baton
*   comparison/solution_comparison.md: Solution_Comparison

## Important Reminders

- The phased approach prioritizes the application server first, utilizing existing iCloud storage
- NAS purchase decisions should follow criteria specified in budget.md
- Core document management functionality should be implemented before adding additional services
- Maintain iCloud backups throughout the transition to ensure data is protected

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-11 15:48:55 ---

# Baton Hand-off

**Last Update:** [CURRENT_TIMESTAMP]

## Session Summary

In this session, we significantly expanded and added granular detail to the software implementation plan for the incoming G9 NUCBox. Key accomplishments include:

*   Clarified that the G9 NUCBox is expected to arrive with a dual-boot configuration: Windows 11 Pro and Ubuntu.
*   Developed a detailed "Phase 0" for initial system setup, covering critical updates, driver verification, security checks, and OS-specific configurations for both Windows 11 Pro and Ubuntu.
*   Mapped out "Phase 1A: Core Document Management," assigning Paperless-ngx (Docker) and iCloud backups to Windows 11 Pro, and detailing Tailscale setup for both OSs.
*   Detailed "Phase 1B: Pi-hole Ad Blocking" for Ubuntu.
*   Expanded "Phase 2: Knowledge Base, Development Environment, & Audiobook Server" to include:
    *   BookStack (Wiki) on Ubuntu (Docker)
    *   code-server (Remote Development) on Ubuntu
    *   Grocy (Home Inventory) on Ubuntu (Docker)
    *   Audiobookshelf (Audiobook Server) on Ubuntu (Docker)
*   Outlined "Phase 3: Additional Services (Optional)," including Duplicati (Windows), Minecraft Server (Ubuntu), Home Assistant (Ubuntu), and Home Energy Monitoring (Ubuntu/Home Assistant).
*   Briefly scoped "Phase 4: Evaluate LLM Options (Optional)" focusing on experimentation with tools like Ollama on Ubuntu.
*   For each service, we specified the target OS and provided granular step-by-step installation and configuration instructions.

## Next Steps

For the next session, the primary focus will be the actual implementation once the G9 NUCBox arrives:

1.  **Await arrival of the G9 NUCBox.** (The 36-hour countdown is on!)
2.  **Execute Phase 0: Initial System Setup** for both Windows 11 Pro and Ubuntu as per the detailed plan.
3.  **Proceed with Phase 1A: Core Document Management**, setting up Paperless-ngx, iCloud backups, and Tailscale.
4.  **Implement Phase 1B: Pi-hole Ad Blocking** on Ubuntu.
5.  Continue systematically through **Phase 2**, then **Phase 3 (selected services)**, and finally **Phase 4 (LLM evaluation)** if desired.
6.  Thoroughly test each service after its initial setup to ensure functionality.
7.  Maintain clear communication and update documentation as implementation progresses.

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

*(No reminders provided)*

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-11 17:41:59 ---

# Baton Hand-off

**Last Update:** 2025-05-11 15:48:55

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-05-11 15:48:55
- Update baton handoff document - 2025-05-10 22:24:23
- Update baton handoff document - 2025-05-10 19:10:01

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

- Review and test the recent changes
- Continue development on core features
- Add more comprehensive documentation
- Address any pending TODOs in the codebase

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

*(No reminders provided)*

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-12 14:15:21 ---

# Baton Hand-off

**Last Update:** 2025-05-11 17:41:59

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-05-11 17:41:59
- Update baton handoff document - 2025-05-11 15:48:55
- Update baton handoff document - 2025-05-10 22:24:23
- Update baton handoff document - 2025-05-10 19:10:01

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

- Review and test the recent changes
- Continue development on core features
- Add more comprehensive documentation
- Address any pending TODOs in the codebase

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

*(No reminders provided)*

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-12 14:52:21 ---

# Baton Hand-off

**Last Update:** 2025-05-12 14:15:22

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-05-12 14:15:21
- Update baton handoff document - 2025-05-11 17:41:59
- Update baton handoff document - 2025-05-11 15:48:55

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

- Review and test the recent changes
- Continue development on core features
- Add more comprehensive documentation
- Address any pending TODOs in the codebase

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

*(No reminders provided)*

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-12 16:47:16 ---

# Baton Hand-off

**Last Update:** 2023-05-23

## Session Summary

In this session, we worked on the initial setup of the GMKtec NucBox G9 server:

- Completed initial Windows 11 Pro setup and configuration
- Set up Microsoft account and verified connectivity
- Fixed Windows Update time synchronization issue
- Enabled BitLocker encryption and saved recovery key
- Verified device drivers were correctly installed
- Activated Windows Defender security features
- Set computer name to "HOMELAB"
- Installed iCloud for Windows for temporary document backup
- Started exploring OneDrive integration for document storage

## Next Steps

For the next session, consider the following steps:

- Complete remaining Windows updates
- Create local admin account for administrative tasks
- Run full system scan with Windows Defender
- Configure iCloud for document syncing
- Set up Ubuntu dual-boot environment
- Begin installing core services (Paperless-ngx, Docker, etc.)
- Configure static IP and network settings

## Important Files & Links

*   g9_setup_checklist.md: Main setup checklist for the NucBox G9
*   README.md: Main project documentation
*   home_server_plan.md: Home_Server_Plan
*   budget.md: Budget
*   research/server_options.md: Server_Options
*   requirements/needs_assessment.md: Needs_Assessment
*   recommendations/final_recommendation.md: Final_Recommendation
*   Pass_the_Baton/Pass_the_Baton/baton_template.md: Baton_Template
*   Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py: Pass_The_Baton
*   comparison/solution_comparison.md: Solution_Comparison

## Important Reminders

- BitLocker recovery key is saved to Microsoft account and as a PDF (add to documentation when available)
- Using iCloud and OneDrive for temporary document storage until permanent NAS storage is configured
- Will revisit storage configuration in 1-2 weeks for potential additional NVMe drives

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-12 18:09:38 ---

# Baton Hand-off

**Last Update:** 2025-05-12 16:47:16

## Session Summary

In this session, we worked on the initial setup of the GMKtec NucBox G9 server:

- Completed initial Windows 11 Pro setup and configuration
- Set up Microsoft account and verified connectivity
- Fixed Windows Update time synchronization issue
- Enabled BitLocker encryption and saved recovery key
- Verified device drivers were correctly installed
- Activated Windows Defender security features
- Set computer name to "HOMELAB"
- Installed iCloud for Windows for temporary document backup
- Started exploring OneDrive integration for document storage
- Documented important hardware notes (power adapter safety, network daisy-chaining)

## Next Steps

For the next session, consider the following steps:

- Complete remaining Windows updates
- Create local admin account for administrative tasks
- Run full system scan with Windows Defender
- Configure iCloud for document syncing
- Set up Ubuntu dual-boot environment
- Begin installing core services (Paperless-ngx, Docker, etc.)
- Configure static IP and network settings

## Important Files & Links

*   g9_setup_checklist.md: Main setup checklist for the NucBox G9
*   README.md: Main project documentation
*   home_server_plan.md: Home_Server_Plan
*   budget.md: Budget
*   research/server_options.md: Server_Options
*   requirements/needs_assessment.md: Needs_Assessment
*   recommendations/final_recommendation.md: Final_Recommendation
*   Pass_the_Baton/Pass_the_Baton/baton_template.md: Baton_Template
*   Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py: Pass_The_Baton
*   comparison/solution_comparison.md: Solution_Comparison

## Important Reminders

- BitLocker recovery key is saved to Microsoft account and as a PDF (add to documentation when available)
- Using iCloud and OneDrive for temporary document storage until permanent NAS storage is configured
- Will revisit storage configuration in 1-2 weeks for potential additional NVMe drives
- IMPORTANT: The G9 power adapter has a non-standard voltage/wattage - marked with yellow flags to avoid mix-ups with other USB-C devices
- The G9's dual ethernet ports can be used for daisy-chaining network connections (no special configuration needed)

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-12 20:37:18 ---

# Baton Hand-off

**Last Update:** 2025-05-12 18:09:38

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-05-12 18:09:38
- Update baton with G9 setup details
- Update baton handoff document - 2025-05-12 16:47:15
- Update baton handoff document - 2025-05-12 14:52:21
- Update baton handoff document - 2025-05-12 14:15:21

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

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-13 01:36:19 ---

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


--- Archived on: 2025-05-13 22:04:32 ---

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


--- Archived on: 2025-05-13 23:46:47 ---

# Baton Hand-off

**Last Update:** 2025-05-13 22:04:32

## Session Summary

In this session, we worked on the following changes:

- Update baton handoff document - 2025-05-13 22:04:32
- Update baton handoff document - 2025-05-13 01:36:19

These changes focused on improving project functionality and structure.

## Next Steps

For the next session, consider the following steps:

- Review and test the recent changes
- Continue development on core features
- Add more comprehensive documentation
- Address any pending TODOs in the codebase

## Important Files & Links

*   README.md: Main project documentation
*   g9_ethernet_configuration.md: G9_Ethernet_Configuration
*   home_server_plan.md: Home_Server_Plan
*   g9_setup_checklist.md: G9_Setup_Checklist
*   tailscale_configuration.md: Tailscale_Configuration
*   budget.md: Budget
*   research/server_options.md: Server_Options
*   requirements/needs_assessment.md: Needs_Assessment
*   recommendations/final_recommendation.md: Final_Recommendation
*   Pass_the_Baton/Pass_the_Baton/baton_template.md: Baton_Template

## Important Reminders

*(No reminders provided)*

---
*This file is automatically updated by the Pass_the_Baton script.*


--- Archived on: 2025-05-14 00:19:04 ---

# Baton Hand-off

**Last Update:** {timestamp}

## Session Summary

- Updated baton.md and ran Pass_the_Baton.py as requested

These changes focused on maintaining project continuity and documentation.

## Next Steps

- Review and test the recent changes
- Continue development on core features
- Add more comprehensive documentation
- Address any pending TODOs in the codebase

## Important Files & Links

*   README.md: Main project documentation
*   Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py: Handoff script for session transitions
*   baton.md: The handoff document being generated

## Important Reminders

*This file is automatically updated by the Pass_the_Baton script.*
