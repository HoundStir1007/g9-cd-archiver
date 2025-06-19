#!/bin/bash

# Create Pi-hole directory and subdirectories
mkdir -p ~/pihole/etc-pihole ~/pihole/etc-dnsmasq.d

# Create docker-compose.yml
cat > ~/pihole/docker-compose.yml << 'EOL'
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
    environment:
      TZ: 'America/Los_Angeles'
      WEBPASSWORD: '${PIHOLE_PASSWORD:-changeme}'  # Set via PIHOLE_PASSWORD env var
      FTLCONF_LOCAL_IPV4: '100.91.157.19'  # Your Tailscale IP
    volumes:
      - './etc-pihole:/etc/pihole'
      - './etc-dnsmasq.d:/etc/dnsmasq.d'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
EOL

# Start Pi-hole
cd ~/pihole
docker compose up -d

# Wait for Pi-hole to start
echo "Waiting for Pi-hole to start..."
sleep 30

# Show the admin password info
echo "Pi-hole is now running!"
echo "Web interface: http://100.91.157.19/admin"
echo "Password is set via PIHOLE_PASSWORD environment variable in .env file"
echo ""
echo "To change the password:"
echo "1. Edit pihole/.env and update PIHOLE_PASSWORD"
echo "2. Restart with: docker-compose down && docker-compose up -d"
echo "Or manually: docker exec -it pihole pihole -a -p NEWPASSWORD" 