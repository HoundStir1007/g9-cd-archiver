# 📄 Paperless-ngx Quick Setup Guide for G9

**Target System:** GMKtec NucBox G9 (Ubuntu 24.10)  
**Estimated Setup Time:** 30-45 minutes  
**Prerequisites:** Docker, Docker Compose, basic Ubuntu familiarity  

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
# Create the docker-compose.yml file
cat > docker-compose.yml << 'EOF'
version: "3.4"
services:
  broker:
    image: docker.io/library/redis:7
    restart: unless-stopped
    volumes:
      - redisdata:/data

  db:
    image: docker.io/library/postgres:15
    restart: unless-stopped
    volumes:
      - pgdata:/var/lib/postgresql/data
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
      - data:/usr/src/paperless/data
      - media:/usr/src/paperless/media
      - ./export:/usr/src/paperless/export
      - ./consume:/usr/src/paperless/consume
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
  data:
  media:
  pgdata:
  redisdata:
EOF

# Create consume directory for document uploads
mkdir -p consume export
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