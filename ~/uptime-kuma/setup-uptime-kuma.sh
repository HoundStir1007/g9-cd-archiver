#!/bin/bash

# Create directory for Uptime Kuma
mkdir -p ~/uptime-kuma
cd ~/uptime-kuma

# Create docker-compose.yml
cat > docker-compose.yml << 'EOL'
version: '3'

services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    volumes:
      - ./data:/app/data
    ports:
      - "3001:3001"
    restart: always
    security_opt:
      - no-new-privileges:true
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001"]
      interval: 60s
      retries: 3
      timeout: 10s
EOL

# Start Uptime Kuma
docker-compose up -d

echo "Uptime Kuma is being started!"
echo "Once it's ready, you can access it at: http://100.91.157.19:3001"
echo "You'll need to create an admin account on first login." 