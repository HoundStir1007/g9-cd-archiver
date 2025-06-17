#!/usr/bin/env python3
# Ubuntu Server Monitoring Script
# Save to /opt/monitoring/monitor.py

import os
import sys
import json
import time
import socket
import logging
import smtplib
import requests
import subprocess
from datetime import datetime
from logging.handlers import RotatingFileHandler
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from pathlib import Path

# Configuration
CONFIG = {
    # Services to monitor
    "services": [
        {
            "name": "Jellyfin",
            "local_url": "http://192.168.0.182:8096/health",
            "tailscale_url": "http://100.91.157.19:8096/health",
            "expected_content": "Healthy",
            "timeout": 5,
            "retries": 2,
            "retry_delay": 10
        },
        {
            "name": "Paperless-ngx",
            "local_url": "http://192.168.0.178:8000/api/health/",
            "tailscale_url": "http://100.91.157.19:8000/api/health/",
            "expected_content": "",  # Any successful response
            "timeout": 5,
            "retries": 2,
            "retry_delay": 10
        },
        {
            "name": "Plex",
            "local_url": "http://192.168.0.178:32400/identity",
            "tailscale_url": "http://100.91.157.19:32400/identity",
            "expected_content": "",  # Any successful response
            "timeout": 5,
            "retries": 2,
            "retry_delay": 10
        }
    ],
    
    # External connectivity checks
    "external_checks": [
        {"host": "1.1.1.1", "port": 53},  # Cloudflare DNS
        {"host": "8.8.8.8", "port": 53},  # Google DNS
        {"host": "9.9.9.9", "port": 53}   # Quad9 DNS
    ],
    
    # Uptime Kuma push endpoints
    "uptime_kuma": {
        "push_url": "http://100.91.157.19:3001/api/push/",
        "endpoints": {
            "Jellyfin": "FsDZQkf7na",
            "Paperless": "YOUR_PAPERLESS_PUSH_KEY",
            "Plex": "YOUR_PLEX_PUSH_KEY",
            "System": "YOUR_SYSTEM_PUSH_KEY"
        }
    },
    
    # Email notification settings
    "email": {
        "enabled": True,
        "smtp_server": "smtp.gmail.com",
        "smtp_port": 587,
        "username": "msakamoto+homelab@gmail.com",
        "password_file": "/opt/monitoring/secrets/smtp_password.txt",
        "from_address": "msakamoto+homelab@gmail.com",
        "to_address": "msakamoto+alerts@gmail.com",
        "subject_prefix": "[Server Alert]"
    },
    
    # Push notification settings (Pushover)
    "pushover": {
        "enabled": False,
        "api_token": "",
        "user_key": "",
        "priority": 1  # 0=normal, 1=high, 2=emergency
    },
    
    # Discord webhook
    "discord": {
        "enabled": False,
        "webhook_url": ""
    },
    
    # System thresholds
    "thresholds": {
        "cpu_percent": 90,
        "memory_percent": 90,
        "disk_percent": 90,
        "load_average": 4
    },
    
    # Logging
    "logging": {
        "log_dir": "/var/log/monitoring",
        "max_size_mb": 10,
        "backup_count": 5,
        "log_level": "INFO"  # DEBUG, INFO, WARNING, ERROR, CRITICAL
    }
}

# Set up logging
log_dir = "/var/log/monitoring"
log_file = os.path.join(log_dir, "server_monitor.log")
os.makedirs(log_dir, exist_ok=True)

logger = logging.getLogger("ServerMonitor")
logger.setLevel(logging.INFO)
handler = RotatingFileHandler(log_file, maxBytes=1024*1024, backupCount=5)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)

def check_service(service):
    """Check if a service is running and healthy"""
    for attempt in range(service["retries"]):
        try:
            # Try Tailscale URL first
            response = requests.get(service["tailscale_url"], timeout=service["timeout"])
            if response.status_code == 200:
                if service["expected_content"]:
                    if service["expected_content"] in response.text:
                        return True
                else:
                    return True
        except:
            try:
                # Fallback to local URL
                response = requests.get(service["local_url"], timeout=service["timeout"])
                if response.status_code == 200:
                    if service["expected_content"]:
                        if service["expected_content"] in response.text:
                            return True
                    else:
                        return True
            except:
                if attempt < service["retries"] - 1:
                    time.sleep(service["retry_delay"])
                continue
    return False

def check_external_connectivity():
    """Check if we can reach external services"""
    for check in CONFIG["external_checks"]:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(5)
            result = sock.connect_ex((check["host"], check["port"]))
            sock.close()
            if result != 0:
                return False
        except:
            return False
    return True

def push_to_uptime_kuma(service_name, status):
    """Push status updates to Uptime Kuma"""
    try:
        push_key = CONFIG["uptime_kuma"]["endpoints"].get(service_name)
        if push_key:
            push_url = f"{CONFIG['uptime_kuma']['push_url']}{push_key}"
            status_str = "up" if status else "down"
            requests.get(f"{push_url}/{status_str}", timeout=5)
    except Exception as e:
        logger.error(f"Failed to push to Uptime Kuma for {service_name}: {str(e)}")

def main():
    """Main monitoring function"""
    try:
        # Check external connectivity
        external_status = check_external_connectivity()
        logger.info(f"External connectivity: {'UP' if external_status else 'DOWN'}")
        push_to_uptime_kuma("System", external_status)

        # Check each service
        for service in CONFIG["services"]:
            status = check_service(service)
            logger.info(f"{service['name']}: {'UP' if status else 'DOWN'}")
            push_to_uptime_kuma(service["name"], status)

    except Exception as e:
        logger.error(f"Monitoring error: {str(e)}")

if __name__ == "__main__":
    main() 