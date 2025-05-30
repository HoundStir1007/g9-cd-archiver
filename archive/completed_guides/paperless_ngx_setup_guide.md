# 📄 Paperless-ngx Quick Setup Guide for G9

**Target System:** GMKtec NucBox G9 (Ubuntu 24.10)  
**Storage Strategy:** External drive now → Samsung SSD migration Wednesday  
**Estimated Setup Time:** 40-50 minutes (including external drive setup)  
**Prerequisites:** External USB drive (50GB+ free), Docker, Docker Compose  

---

## 🎯 Why Ubuntu for Paperless-ngx?

While your G9 defaults to Windows 11 Pro, Ubuntu is the better choice for Paperless-ngx because:
- ✅ Better Docker performance and compatibility
- ✅ Lower resource usage (more RAM for document processing)
- ✅ Easier maintenance and updates
- ✅ Better file system handling for document storage
- ✅ Can still access via Tailscale from your MacBook

---

## 🚀 Quick Start (30 minutes to documents!)

### Step 0: External Drive Setup (10 minutes)
**Using external storage until your Samsung SSD arrives Wednesday!**

```bash
# First, let's see what drives are available
lsblk
sudo fdisk -l

# Look for your external drive (usually /dev/sdb, /dev/sdc, etc.)
# Choose a drive with at least 50GB free space

# Format the drive (REPLACE /dev/sdX with your actual drive!)
# ⚠️  WARNING: This will erase the drive! Back up any important data first!
sudo mkfs.ext4 -L "paperless-storage" /dev/sdX1

# Create mount point
sudo mkdir -p /media/paperless-storage

# Mount the drive
sudo mount /dev/sdX1 /media/paperless-storage

# Get the UUID for permanent mounting
UUID=$(sudo blkid /dev/sdX1 -s UUID -o value)
echo "Drive UUID: $UUID"

# Add to fstab for automatic mounting
echo "UUID=$UUID /media/paperless-storage ext4 defaults,noatime,user 0 2" | sudo tee -a /etc/fstab

# Set permissions
sudo chown -R $USER:$USER /media/paperless-storage
mkdir -p /media/paperless-storage/paperless/{data,media,postgres,export,consume}

echo "✅ External drive ready at /media/paperless-storage"
```

**Alternative: Use existing external drive without formatting**
```bash
# If you have an existing drive with free space:
sudo mkdir -p /media/paperless-storage
sudo mount /dev/sdX1 /media/paperless-storage  # Replace sdX1 with your drive
mkdir -p /media/paperless-storage/paperless/{data,media,postgres,export,consume}
```

### Step 1: Boot into Ubuntu (5 minutes)
```bash
# From Windows, reboot and select Ubuntu in GRUB menu
# Or use the reboot script if available:
# .\scripts\reboot_to_ubuntu.ps1
```

### Step 2: Prepare Ubuntu Environment (10 minutes)
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker if not already installed
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin

# Create paperless directory
mkdir -p ~/paperless-ngx
cd ~/paperless-ngx
```

### Step 3: Create Docker Compose Configuration (5 minutes)
```bash
# Create the docker-compose.yml file with external storage
cat > docker-compose.yml << 'EOF'
version: "3.4"
services:
  broker:
    image: docker.io/library/redis:7
    restart: unless-stopped
    volumes:
      # Keep Redis on internal storage for speed
      - redisdata:/data

  db:
    image: docker.io/library/postgres:15
    restart: unless-stopped
    volumes:
      # PostgreSQL data on external drive
      - /media/paperless-storage/paperless/postgres:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: paperless
      POSTGRES_USER: paperless
      POSTGRES_PASSWORD: paperless

  webserver:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    restart: unless-stopped
    depends_on:
      - db
      - broker
    ports:
      - "8000:8000"
    volumes:
      # Large data on external drive
      - /media/paperless-storage/paperless/data:/usr/src/paperless/data
      - /media/paperless-storage/paperless/media:/usr/src/paperless/media
      - /media/paperless-storage/paperless/export:/usr/src/paperless/export
      - /media/paperless-storage/paperless/consume:/usr/src/paperless/consume
    environment:
      PAPERLESS_REDIS: redis://broker:6379
      PAPERLESS_DBHOST: db
      PAPERLESS_TIKA_ENABLED: 1
      PAPERLESS_TIKA_GOTENBERG_ENDPOINT: http://gotenberg:3000
      PAPERLESS_TIKA_ENDPOINT: http://tika:9998
      PAPERLESS_TIME_ZONE: America/Los_Angeles
      PAPERLESS_OCR_LANGUAGE: eng
      PAPERLESS_SECRET_KEY: change-me-to-something-secure
      PAPERLESS_URL: http://100.91.157.19:8000
      PAPERLESS_ALLOWED_HOSTS: 100.91.157.19,localhost
      # Optimize for external storage
      PAPERLESS_TASK_WORKERS: 1
      PAPERLESS_THREADS_PER_WORKER: 1

  gotenberg:
    image: docker.io/gotenberg/gotenberg:7.10
    restart: unless-stopped
    command:
      - "gotenberg"
      - "--chromium-disable-javascript=true"
      - "--chromium-allow-list=file:///tmp/.*"

  tika:
    image: ghcr.io/paperless-ngx/tika:latest
    restart: unless-stopped

volumes:
  # Only Redis stays as Docker volume (on internal storage)
  redisdata:
EOF

# Verify external storage is mounted
if [ ! -d "/media/paperless-storage/paperless" ]; then
    echo "❌ External storage not found! Please complete Step 0 first."
    exit 1
fi

echo "✅ Docker Compose configured for external storage"
```

### Step 4: Start Paperless-ngx (5 minutes)
```bash
# Start the services
docker compose up -d

# Wait for services to start (about 2-3 minutes)
echo "Waiting for services to start..."
sleep 180

# Create admin user
docker compose exec webserver python3 manage.py createsuperuser
# Follow prompts to create username/password
```

### Step 5: Access and Test (5 minutes)
```bash
# Check if services are running
docker compose ps

# Get your Tailscale IP
tailscale ip -4

# Access Paperless-ngx at: http://100.91.157.19:8000
echo "Access Paperless-ngx at: http://$(tailscale ip -4):8000"
```

---

## 🔧 Configuration & Usage

### Initial Setup in Web Interface
1. **Login:** Use the admin credentials you created
2. **Settings → General:**
   - Set your timezone
   - Configure OCR language (English is default)
3. **Settings → Mail:**
   - Configure email settings for notifications (optional)
4. **Settings → Storage:**
   - Review storage paths (defaults are fine)

### Adding Documents
**Method 1: Web Upload**
- Click "Upload" in the web interface
- Drag and drop PDFs, images, or office documents

**Method 2: Consume Folder**
```bash
# Copy documents to the consume folder
cp /path/to/document.pdf ~/paperless-ngx/consume/

# Paperless will automatically process them
```

**Method 3: Email (Advanced)**
- Configure email consumption in settings
- Email documents to a dedicated address

### Document Organization
- **Tags:** Create tags for categories (Bills, Receipts, Manuals, etc.)
- **Document Types:** Set up types (Invoice, Contract, Receipt, etc.)
- **Correspondents:** Add people/companies you exchange documents with
- **Storage Paths:** Organize how files are stored on disk

---

## 📱 Remote Access Setup

### From Your MacBook
1. **Web Access:** http://100.91.157.19:8000 (via Tailscale)
2. **Mobile App:** Install "Paperless Mobile" from App Store
   - Server URL: http://100.91.157.19:8000
   - Use your admin credentials

### Scanning Documents
**Option 1: Scanner to Consume Folder**
- Set up network scanner to save to `~/paperless-ngx/consume/`
- Documents auto-process when saved

**Option 2: Mobile Scanning**
- Use Paperless Mobile app to scan with phone camera
- Documents upload and process automatically

**Option 3: Desktop Scanning**
- Scan to your MacBook
- Copy files to consume folder via Tailscale/SSH

---

## 🔒 Security & Backup

### Basic Security
```bash
# Change the secret key in docker-compose.yml
# Generate a secure key:
openssl rand -base64 32

# Update PAPERLESS_SECRET_KEY in docker-compose.yml
# Restart services:
docker compose down && docker compose up -d
```

### Backup Strategy
```bash
# Create backup script
cat > backup-paperless.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/$USER/paperless-backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

# Export documents and database
cd ~/paperless-ngx
docker compose exec -T webserver document_exporter /usr/src/paperless/export/

# Create backup archive
tar -czf "$BACKUP_DIR/paperless_backup_$DATE.tar.gz" \
    export/ \
    docker-compose.yml

echo "Backup created: $BACKUP_DIR/paperless_backup_$DATE.tar.gz"
EOF

chmod +x backup-paperless.sh

# Run backup
./backup-paperless.sh
```

---

## 🚀 Next Steps After Setup

### Immediate (First Week)
1. **Upload test documents** to verify OCR and search
2. **Create basic tags** (Bills, Receipts, Manuals, Personal)
3. **Set up mobile app** for easy document capture
4. **Configure backup script** to run weekly

### Short-term (First Month)
1. **Bulk import** existing documents from iCloud/OneDrive
2. **Set up email consumption** for automatic bill processing
3. **Configure advanced OCR** for better text recognition
4. **Create document workflows** for common document types

### Long-term
1. **API integration** with other services
2. **Advanced tagging** and classification rules
3. **Workflow automation** for document processing
4. **Integration with accounting software** (if needed)

---

## 🆘 Troubleshooting

### Common Issues
**Services won't start:**
```bash
# Check logs
docker compose logs

# Restart services
docker compose down && docker compose up -d
```

**External drive not mounted:**
```bash
# Check if drive is mounted
df -h | grep paperless-storage

# Remount if needed
sudo mount /dev/sdX1 /media/paperless-storage

# Check fstab entry
grep paperless-storage /etc/fstab
```

**Permission errors on external drive:**
```bash
# Fix ownership
sudo chown -R $USER:$USER /media/paperless-storage

# Check permissions
ls -la /media/paperless-storage/paperless/
```

**Slow performance on external drive:**
```bash
# Check drive speed
sudo hdparm -tT /dev/sdX1

# Optimize mount options
sudo umount /media/paperless-storage
sudo mount -o defaults,noatime,data=writeback /dev/sdX1 /media/paperless-storage
```

**Can't access web interface:**
```bash
# Check if port is open
sudo ufw allow 8000

# Verify Tailscale IP
tailscale ip -4
```

**OCR not working:**
```bash
# Check Tika service
docker compose logs tika

# Restart OCR services
docker compose restart tika gotenberg
```

### Performance Optimization
```bash
# If processing is slow, allocate more resources
# Edit docker-compose.yml and add:
# deploy:
#   resources:
#     limits:
#       memory: 2G
#     reservations:
#       memory: 1G
```

---

## 🔄 SSD Migration Guide (For Wednesday!)

When your Samsung 990 EVO arrives, here's how to migrate everything:

### Step 1: Prepare New SSD (10 minutes)
```bash
# Stop Paperless services
cd ~/paperless-ngx
docker compose down

# Install and format new SSD (assuming it's /dev/nvme0n1)
sudo mkfs.ext4 -L "paperless-ssd" /dev/nvme0n1p1

# Create new mount point
sudo mkdir -p /mnt/paperless-ssd
sudo mount /dev/nvme0n1p1 /mnt/paperless-ssd

# Set permissions
sudo chown -R $USER:$USER /mnt/paperless-ssd
mkdir -p /mnt/paperless-ssd/paperless/{data,media,postgres,export,consume}
```

### Step 2: Migrate Data (15-30 minutes)
```bash
# Copy all data to new SSD
echo "Starting data migration..."
rsync -av --progress /media/paperless-storage/paperless/ /mnt/paperless-ssd/paperless/

# Verify copy completed successfully
echo "Verifying migration..."
diff -r /media/paperless-storage/paperless/ /mnt/paperless-ssd/paperless/
```

### Step 3: Update Configuration (5 minutes)
```bash
# Update docker-compose.yml paths
sed -i 's|/media/paperless-storage|/mnt/paperless-ssd|g' docker-compose.yml

# Update fstab for permanent mounting
UUID=$(sudo blkid /dev/nvme0n1p1 -s UUID -o value)
echo "UUID=$UUID /mnt/paperless-ssd ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab

# Remove old external drive from fstab (optional)
sudo sed -i '/paperless-storage/d' /etc/fstab
```

### Step 4: Test and Cleanup (10 minutes)
```bash
# Start services with new storage
docker compose up -d

# Wait for startup
sleep 60

# Test access
curl -f http://100.91.157.19:8000 && echo "✅ Migration successful!"

# Optional: Remove old data after confirming everything works
# sudo rm -rf /media/paperless-storage/paperless/
```

**Total Migration Time: ~30-45 minutes with zero data loss!**

---

## 🚀 External Drive Performance Tips

### Recommended External Drives
- **USB 3.0+ required** (USB 2.0 will be too slow)
- **SSD external drives** perform much better than HDD
- **USB-C drives** often have better sustained performance

### Performance Optimization
```bash
# Check your drive's performance
sudo hdparm -tT /dev/sdX1

# For better performance, remount with optimized options
sudo umount /media/paperless-storage
sudo mount -o defaults,noatime,data=writeback /dev/sdX1 /media/paperless-storage
```

### Expected Performance
- **USB 3.0 HDD:** Document processing ~30-60 seconds
- **USB 3.0 SSD:** Document processing ~10-20 seconds  
- **Internal SSD:** Document processing ~5-10 seconds

---

## 📋 Quick Reference

### Useful Commands
```bash
# View logs
docker compose logs -f webserver

# Restart services
docker compose restart

# Update Paperless-ngx
docker compose pull && docker compose up -d

# Access database
docker compose exec db psql -U paperless paperless

# Manual document processing
docker compose exec webserver python3 manage.py document_consumer
```

### Important URLs
- **Web Interface:** http://100.91.157.19:8000
- **Admin Panel:** http://100.91.157.19:8000/admin/
- **API Documentation:** http://100.91.157.19:8000/api/

### Default Locations
- **Documents:** `~/paperless-ngx/consume/` (input)
- **Exports:** `~/paperless-ngx/export/` (output)
- **Config:** `~/paperless-ngx/docker-compose.yml`

---

*Setup guide created for GMKtec NucBox G9 - Ubuntu 24.10*  
*Tailscale IP: 100.91.157.19 | Default Port: 8000* 