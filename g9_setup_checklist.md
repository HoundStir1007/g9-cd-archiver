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

### 7. Game Emulation Share (Day 5)
- [ ] Create a dedicated directory structure for emulation files:
    - [ ] Main directory (e.g., `/data/emulation/`)
    - [ ] System subdirectories (e.g., `nes/`, `snes/`, `genesis/`, etc.)
    - [ ] Within each system directory, create both `roms/` and `saves/` directories
- [ ] Set up file sharing via Samba (SMB):
    - [ ] Install Samba if not already installed: `sudo apt install samba samba-common-bin`
    - [ ] Configure Samba by editing `/etc/samba/smb.conf`:
      ```
      [Emulation]
        comment = Emulation Files
        path = /data/emulation
        browseable = yes
        read only = no
        create mask = 0775
        directory mask = 0775
        valid users = @users
      ```
    - [ ] Create a dedicated user for Samba: `sudo smbpasswd -a username`
    - [ ] Add user to users group: `sudo usermod -aG users username`
    - [ ] Set proper permissions on emulation directory:
      ```
      sudo chown -R :users /data/emulation
      sudo chmod -R 2775 /data/emulation
      ```
    - [ ] Restart Samba: `sudo systemctl restart smbd.service nmbd.service`
- [ ] Test accessing the share from different devices:
    - [ ] Windows: `\\server-ip\Emulation` in File Explorer
    - [ ] macOS: Finder → Go → Connect to Server → `smb://server-ip/Emulation`
    - [ ] Linux: `smb://server-ip/Emulation` in file manager or mount using `/etc/fstab`
- [ ] Configure emulators on client devices:
    - [ ] Point ROM directories to the network share location
    - [ ] Configure save directories to the network share location
    - [ ] Test loading a game from the share and creating a save file
    - [ ] Verify the save file is accessible from another device

### 8. Personal Wiki/Knowledge Base (Optional - Day 5-6)
- [ ] Choose wiki software (e.g., BookStack, Wiki.js, Obsidian with sync)
- [ ] Create a dedicated directory for wiki data
- [ ] Create `docker-compose.yml` file for chosen wiki software (if using Docker)
- [ ] Configure and deploy the wiki application
- [ ] Set up initial structure, user accounts, and permissions
- [ ] Start populating with family information, guides, etc.

### 9. PIA VPN Integration (Day 6)
- [ ] Create a dedicated directory for VPN configuration
- [ ] Set up a VPN gateway container:
    - [ ] Create a `docker-compose.yml` file for the VPN container:
      ```yaml
      services:
        vpn-gateway:
          image: dperson/openvpn-client
          container_name: vpn-gateway
          cap_add:
            - NET_ADMIN
          environment:
            - VPN_USER=your_pia_username  # Or use environment variables from .env file
            - VPN_PASS=your_pia_password  # Or use environment variables from .env file
          volumes:
            - ./pia_config:/vpn  # Directory containing PIA .ovpn config files
          ports:
            - "8118:8118"  # If using Privoxy
          restart: unless-stopped
      ```
    - [ ] Download PIA OpenVPN configuration files from your PIA account
    - [ ] Store configuration files in the dedicated directory
- [ ] Test the VPN connection:
    - [ ] Start the VPN container: `docker-compose up -d`
    - [ ] Check if the VPN is connected: `docker logs vpn-gateway`
    - [ ] Verify the external IP is a PIA IP: `docker exec vpn-gateway curl ifconfig.me`
- [ ] Configure other containers to use the VPN connection:
    - [ ] For each container that should use the VPN, add to the `docker-compose.yml`:
      ```yaml
      services:
        # Example for a service that needs privacy (like a download client)
        private-service:
          image: appropriate-image
          container_name: private-service
          network_mode: "service:vpn-gateway"  # Uses the VPN container's network
          depends_on:
            - vpn-gateway
          volumes:
            - ./service_data:/data
          restart: unless-stopped
      ```
- [ ] Test the integrated service through VPN
    - [ ] Start the service container
    - [ ] Verify the service is working and accessible
    - [ ] Confirm the service is using the VPN connection for outgoing traffic

## Phase 4: Server Dashboard (Day 6-7)

- [ ] Choose a server dashboard (e.g., Homer, Homarr, Dashy, Organizr) - **Decision: Homer**
- [ ] Create a dedicated directory for Homer configuration (e.g., `/opt/homer-config` or `~/docker/homer/assets`)
- [ ] Create `docker-compose.yml` file for Homer
    - ```yaml
      services:
        homer:
          image: b4bz/homer
          container_name: homer
          volumes:
            - ./assets:/www/assets # Make sure your local config directory exists and is named 'assets'
          ports:
            - "8080:8080" # Or choose a different host port if 8080 is taken
          # user: "1000:1000" # Optional: Set if you have permission issues with the volume
          restart: unless-stopped
      ```
- [ ] Create initial `assets/config.yml` for Homer, adding links to installed services (Paperless-ngx, Pi-hole, etc.)
- [ ] Pull and run Homer Docker container (`docker-compose up -d`)
- [ ] Access Homer dashboard in a browser and test links
- [ ] Customize Homer (title, theme, add more services) as desired

## Phase 5: Optional Expansions

### 10. Minecraft Server (When desired)
- [ ] Create a dedicated directory for Minecraft server data
- [ ] Choose a Minecraft server Docker image (e.g., `itzg/minecraft-server`)
- [ ] Create `docker-compose.yml` file for the Minecraft server
- [ ] Configure server properties (game mode, difficulty, MOTD, whitelist if needed)
- [ ] Pull and run Minecraft server container
- [ ] Test connecting to the server from Minecraft clients on the local network
- [ ] If remote access needed, configure port forwarding on router or use Tailscale/other VPN

### 11. Development Environment (When needed)
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