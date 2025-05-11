# Home Server Project 🏠🖥️

## Current Setup
- Small apartment living space
- 5G Internet through Verizon Wireless
- 4 users: myself, wife, and two teenage sons
- Apple devices (iPhones, etc.)

## Available Hardware
- Raspberry Pi
- Mini Windows PC (5 years old)
- Mac Mini (7 years old)
- External hard drives (including a 1TB drive)

## Project Goals
- Primary: Create a paperless document management system
- Primary: Access documents remotely from mobile devices
- Secondary: Provide automatic backups to existing iCloud
- Optional: Explore running a private LLM (if hardware permits)
- Optional: Host custom domain for email and simple websites

## Expanded Home Server Uses (Priority Order) 🚀

### High Interest
1. **Document Management System** (Primary Goal)
   - Paperless-ngx for scanning, OCR, and organizing documents
   - Remote access via Tailscale

2. **Network-Wide Ad Blocking**
   - Pi-hole running on Raspberry Pi
   - Blocks ads for all devices on network without installing software on each
   - Can improve network performance and reduce data usage

3. **Personal Wiki/Knowledge Base**
   - Digital garden for family information
   - Searchable repository of notes, guides, and references
   - Options: BookStack, WikiJS, or Obsidian Publish

4. **Development/Testing Environment**
   - Remote coding environment accessible from anywhere
   - Test projects in isolated environment
   - Options: VS Code Server, code-server, or simple SSH access

5. **Home Backup Server**
   - Central backup location for all family devices
   - Automated backup schedules
   - Not resource intensive - mainly needs storage space
   - Options: Duplicati, Restic, or simple rsync scripts

6. **Home Inventory Management**
   - Track household items, warranties, manuals
   - Searchable database of belongings
   - Options: Grocy, Snipe-IT (simplified), or custom solution

### Medium Interest
7. **Personal VPN Server** (Currently using PIA)
   - Secure connection when away from home
   - Access to home network resources remotely
   - Options: WireGuard, OpenVPN
   - Different from commercial VPN: provides home access rather than anonymity

8. **Minecraft Server**
   - Family gaming server
   - Can run on separate hardware when needed
   - Moderate resource requirements

9. **IoT Device Hub**
   - Local control of smart devices
   - Reduce cloud dependencies
   - Options: Home Assistant (separated from voice control)

10. **Home Energy Monitoring**
    - Track electricity usage
    - Identify energy-saving opportunities
    - Options: Home Assistant integration, IoTaWatt, or OpenEnergyMonitor

### Other Common Server Uses (For Reference)
1. **Media Streaming**
   - Host and stream movies, TV, music
   - Access media from any device
   - High storage requirements

2. **Self-hosted Email/Calendar** (Not Interested)
   - Complete control over communications
   - Avoids vendor lock-in with Google/Microsoft
   - High maintenance and security requirements
   - Risk of emails being marked as spam

3. **Home Surveillance System**
   - Local storage of security camera footage
   - Privacy-focused alternative to cloud services
   - Requires compatible cameras or additional hardware

4. **Print Server**
   - Share printers across network
   - Control access and track usage
   - Simple to set up, low resource needs

## Smart Home Decision ✅
- Will use HomePod Mini for smart home control
- Not integrating with home server (keeping systems separate)
- Simplifies overall project and reduces technical complexity

## Project Philosophy 💡
- **Start simple**: Begin with existing hardware
- **Minimal investment**: Avoid unnecessary purchases
- **Ease of maintenance**: Keep system manageable with minimal time commitment
- **Expandability**: Design for easy scaling if project proves valuable
- **Graceful exit**: Ensure data can be easily migrated if project is discontinued

## Recurring Costs Analysis 💰

| Item | Estimated Cost | Notes |
|------|----------------|-------|
| **Electricity** | $2-10/month | Depends on hardware efficiency & usage patterns |
| **Domain Name** | $10-15/year | Only if email/web hosting is desired |
| **iCloud Storage** | $0 | Already paying for this service |
| **Remote Access Solutions** | $0-5/month | Depends on choice (see options below) |
| **API Costs** (if using cloud AI) | $0-20/month | Varies by usage; many have free tiers |

### Remote Access Options
1. **VPN to Home Network** (Free)
   - OpenVPN or WireGuard on Raspberry Pi
   - Requires port forwarding on router
   - Most private but more technical setup

2. **Self-hosted Solutions** (Free)
   - Nextcloud (documents, calendar, contacts)
   - Can run on Windows PC or Mac Mini
   - Mobile apps available for document access

3. **Tailscale/ZeroTier** (Free for basic use)
   - Mesh VPN that usually works without port forwarding
   - Easy to set up, apps for all platforms
   - Limited to 20 devices on free tier
   - Much better free tier than Twingate (which limits to 5 devices)

4. **Dynamic DNS Service** (Free-$5/month)
   - Makes your home IP accessible via domain name
   - Some routers have built-in support
   - Paid options provide more reliability/features

## Decision Point: Local LLM Requirements ⚠️

Running a private LLM is the most resource-intensive component of this project. Here are the typical requirements:

### LLM Hardware Requirements by Model Size

| Model Size | CPU | RAM | GPU | Storage | Example Models |
|------------|-----|-----|-----|---------|----------------|
| 7B parameters | 4+ cores | 8GB+ | Optional | 16GB+ | Mistral 7B, Llama 2 7B |
| 13B parameters | 8+ cores | 16GB+ | Recommended | 32GB+ | Llama 2 13B, Vicuna 13B |
| 70B parameters | 16+ cores | 32GB+ | Required (16GB+ VRAM) | 140GB+ | Llama 2 70B, Claude Opus |

### Options Based on Existing Hardware

1. **Minimal Approach**: Run small 3-7B models on Windows PC/Mac Mini
   - Usable for basic tasks but limited capabilities
   - May run slowly without GPU
   - Less context window and knowledge

2. **Cloud-Hybrid Approach**: 
   - Use local server for document management, smart home
   - Use services like Ollama.ai, Perplexity, or Claude API for AI
   - Maintains most privacy while getting better AI performance

3. **Hardware Upgrade Path**:
   - Start with document management and smart home automation
   - Add a dedicated LLM machine later only if project proves valuable
   - Common build: 32GB RAM, RTX 4070 GPU, i7/Ryzen 7

### Considerations
- Private LLMs provide maximum privacy but require significant resources
- Self-hosted LLMs may not match commercial models in capability
- The hardware needs for document management and smart home are much more modest

## Potential Uses for Existing Hardware

### Raspberry Pi
- Network monitoring
- Pi-hole for ad blocking
- Basic web server for family websites
- Potential lightweight document indexing
- VPN server for remote access
- Minecraft server (lightweight)

### Mini Windows PC (5 years old)
- Document management system (Paperless-ngx)
- File server
- Backup management
- Development/testing environment
- Personal wiki/knowledge base
- Home inventory system
- Possible lightweight LLM hosting (depending on specs)
- Nextcloud for remote document access

### Mac Mini (7 years old)
- Media server
- Document OCR processing
- Alternative to Windows PC for above tasks
- Possible lightweight LLM hosting (depending on specs)

### External Hard Drives
- Document storage
- Backup storage
- Media storage
- LLM model storage

## Maintenance Considerations 🔧
- **Time investment**: 1-2 hours per week initially, less once stable
- **Skill requirements**: Basic Linux/command line for some components
- **Updates**: Periodic software updates needed for security
- **Monitoring**: Options from fully manual to automated alerts
- **Backup strategy**: Regular backups to prevent data loss

## Prioritized Implementation Plan
1. **Phase 1A**: Core Document Management
   - Set up Paperless-ngx on Windows PC or Mac Mini
   - Configure external drives for document storage
   - Establish backup workflow with iCloud
   - Set up remote access solution for mobile document retrieval (Tailscale)
   - Expected setup time: 1-2 weekends

2. **Phase 1B**: Pi-hole Ad Blocking
   - Install Pi-hole on Raspberry Pi
   - Configure network to use Pi-hole as DNS
   - Expected setup time: 1 day

3. **Phase 2**: Knowledge Base & Development Environment
   - Set up personal wiki system
   - Configure remote development access
   - Add home inventory management
   - Expected setup time: 1 weekend

4. **Phase 3**: Additional Services (Optional)
   - Home backup system
   - Minecraft server
   - IoT hub
   - Energy monitoring
   - Only pursue after core systems are stable

5. **Phase 4**: Evaluate LLM Options (Optional)
   - Only if document system is running well
   - Test lightweight models on existing hardware
   - Research cloud-hybrid approaches if performance is insufficient
   - Only consider hardware upgrades if phase 1 proves valuable

## Next Steps
1. Check specifications of existing hardware:
   - CPU model and clock speed
   - Available RAM
   - Available storage
2. Begin with document management system setup (Paperless-ngx)
   - Select either Windows PC or Mac Mini based on specs
   - Install and configure basic system
3. Test system with a small batch of documents
4. Set up secure remote access for mobile document retrieval (Tailscale)
5. Set up Pi-hole on Raspberry Pi for ad blocking
6. Establish backup workflow to iCloud
7. Evaluate maintenance requirements and satisfaction before proceeding

## Remote Access Implementation 📱
For the goal of "quickly finding a PDF on my phone no matter where I am":

1. **Option A: Paperless-ngx + Tailscale**
   - Paperless-ngx has a mobile-friendly web interface
   - Tailscale creates secure network tunnel to home
   - No port forwarding needed in most cases
   - Free for basic use

2. **Option B: Nextcloud + Document Integration**
   - Nextcloud provides files, calendar, contacts sync
   - Mobile apps for all platforms
   - Can integrate with Paperless-ngx
   - More features but more resource intensive

3. **Option C: VPN + Mobile Apps**
   - OpenVPN/WireGuard on Raspberry Pi
   - Use mobile apps that connect to local network
   - Most technical but most private solution

## Exit Strategy
If maintaining the server becomes burdensome:
- Document management: Export documents to organized folders
- Backup: Consolidate to iCloud or external drives
- Domain/email: Migrate to commercial service

## Questions to Answer
- What are the detailed specifications of your mini Windows PC and Mac Mini?
- What kind of documents will you be scanning/storing?
- Do you have a document scanner or plan to use a mobile app?
- Expected storage needs for documents?
- How tech-comfortable are your family members who will use the system?
- Is your internet connection stable with a consistent IP address?
- Do you have concerns about exposing services to the internet?
- What's your comfort level with Linux administration?
- Do you prefer open-source solutions or are commercial options acceptable? 

## Minimal Cost Paperless-ngx Implementation Plan 🛠️

After evaluating budget considerations, here are concrete options for implementing a minimal yet secure paperless document system:

### Option 1: Repurposed Existing Computer + Virtualization
- Use existing computer hardware
- Install modern hypervisor (VirtualBox/VMware) if supported by hardware
- Run Ubuntu Server 22.04 LTS as virtual machine
- Security maintained through VM even if host OS is older
- Estimated additional cost: $0-50 (external HDD for backup)
- Note: Performance may be limited for document processing

### Option 2: Raspberry Pi 4 Setup (~$150)
- Raspberry Pi 4 (8GB) + case + power supply (~$100)
- USB SSD for storage (~$50 for 500GB)
- Direct installation of Ubuntu Server 22.04 LTS
- Excellent power efficiency for 24/7 operation
- Sufficient performance for document management

### Software Stack (Free)
- Docker + paperless-ngx in containers
- Traefik for secure reverse proxy
- Fail2ban for additional security
- Regular OS security updates

### Remote Access Implementation
- Tailscale VPN (free tier) for secure remote access
- No port forwarding required on home router
- End-to-end encryption of all traffic

### Document Input Methods
- Mobile scanning app → upload to shared folder
- Web upload interface from any device
- Email-to-PDF workflow (optional)

### Backup Strategy
- Local backup to external drive
- Consider Backblaze B2 (~$5/month) for offsite backup
- Regular automated backups

### Security Considerations
- All data encrypted at rest
- Network traffic encrypted via Tailscale
- Regular security updates through Ubuntu LTS
- No direct exposure to internet (no port forwarding)

This implementation provides a secure, accessible system that can grow with future needs while minimizing initial investment. When ready to expand, the same software stack can be migrated to more robust hardware. 