# GMKtec NucBox G9 Software Setup Checklist 🚀

## Phase 1: Initial Setup & Core Services

### 1. Base System Setup (Day 1)
- [ ] Choose and Install Operating System (Ubuntu Server recommended, consider dual boot with Windows if needed)
- [ ] Configure network settings (Static IP Address for G9)
- [ ] Create user accounts (admin and daily user)
- [ ] Implement basic security hardening (firewall, SSH key authentication)
- [ ] Install essential utilities:
    - [ ] `openssh-server` (if not included by default)
    - [ ] Docker Engine
    - [ ] Docker Compose

### 2. Storage Configuration (Day 1-2)
- [ ] Verify 512GB system SSD is correctly partitioned and formatted
- [ ] If M.2 NVMe drives added to NAS bays:
    - [ ] Initialize and format new M.2 NVMe SSDs
    - [ ] Create storage pool(s) (e.g., using ZFS or mdadm if not using a NAS OS)
    - [ ] Configure RAID level if applicable (e.g., RAID 1 for redundancy if 2+ drives)
    - [ ] Create file systems on the storage pool(s)
    - [ ] Set up mount points for NAS storage
- [ ] If using a NAS-focused OS (like TrueNAS Scale or OpenMediaVault) on the G9:
    - [ ] Configure storage pools and datasets/shares through the NAS OS interface.

### 3. Document Management (Days 2-3)
- [ ] Create a dedicated directory for Paperless-ngx data (e.g., on your NAS storage)
- [ ] Create `docker-compose.yml` file for Paperless-ngx
- [ ] Configure Paperless-ngx environment variables (paths, user, etc.)
- [ ] Pull and run Paperless-ngx Docker container(s) (`docker-compose up -d`)
- [ ] Access Paperless-ngx web UI and complete initial setup
- [ ] Configure OCR language(s) and settings
- [ ] Set up document correspondents, tags, and document types
- [ ] Test document uploading, processing (OCR), and searching

### 4. Remote Access (Day 3)
- [ ] Sign up for a Tailscale account (if you haven't already)
- [ ] Install Tailscale on the G9 server
- [ ] Authenticate and connect the G9 to your Tailscale network (`sudo tailscale up`)
- [ ] Install Tailscale on client devices (laptop, phone)
- [ ] Test accessing Paperless-ngx remotely via its Tailscale IP address
- [ ] Review Tailscale ACLs for access control (optional, good for security)
- [ ] Once remote access is confirmed stable, relocate G9 to its final server position and operate headless.

## Phase 2: Additional Services

### 5. Network Ad Blocking (Day 4)
- [ ] Create a dedicated directory for Pi-hole data
- [ ] Create `docker-compose.yml` file for Pi-hole
- [ ] Configure Pi-hole environment variables (especially `WEBPASSWORD`)
- [ ] Pull and run Pi-hole Docker container (`docker-compose up -d`)
- [ ] Access Pi-hole admin interface and complete setup
- [ ] Configure your router's DHCP settings to use G9's IP as the DNS server
- [ ] Test ad blocking on multiple devices
- [ ] Add essential domains to whitelist if needed

### 6. Backup System (Day 4-5)
- [ ] Decide on backup software (e.g., Duplicati, Restic, Kopia, or NAS OS built-in tools)
- [ ] Install and configure chosen backup software (likely in Docker if not part of OS)
- [ ] Define backup sources (Paperless-ngx data, Pi-hole configs, other critical data)
- [ ] Define backup destinations (e.g., iCloud via rclone, separate external drive, another NAS/server)
- [ ] Schedule automated backups
- [ ] Perform an initial full backup
- [ ] Test a file/directory restoration procedure

### 7. Personal Wiki/Knowledge Base (Optional - Day 5-6)
- [ ] Choose wiki software (e.g., BookStack, Wiki.js, Obsidian with sync)
- [ ] Create a dedicated directory for wiki data
- [ ] Create `docker-compose.yml` file for chosen wiki software (if using Docker)
- [ ] Configure and deploy the wiki application
- [ ] Set up initial structure, user accounts, and permissions
- [ ] Start populating with family information, guides, etc.

## Phase 3: Optional Expansions

### 8. Minecraft Server (When desired)
- [ ] Create a dedicated directory for Minecraft server data
- [ ] Choose a Minecraft server Docker image (e.g., `itzg/minecraft-server`)
- [ ] Create `docker-compose.yml` file for the Minecraft server
- [ ] Configure server properties (game mode, difficulty, MOTD, whitelist if needed)
- [ ] Pull and run Minecraft server container
- [ ] Test connecting to the server from Minecraft clients on the local network
- [ ] If remote access needed, configure port forwarding on router or use Tailscale/other VPN

### 9. Development Environment (When needed)
- [ ] Choose remote development solution (e.g., VS Code Server via `code-server` Docker image)
- [ ] Create `docker-compose.yml` for `code-server`
- [ ] Configure `code-server` (password, project directories)
- [ ] Deploy `code-server`
- [ ] Access from browser and test development workflow
- [ ] Set up Git integration

---
**Notes:**
- Adapt paths and configurations to your specific setup.
- Refer to official documentation for each software component.
- Take notes of all configurations, passwords, and important settings!
- Backup regularly, especially before major changes. 