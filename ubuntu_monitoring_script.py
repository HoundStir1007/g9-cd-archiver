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
            "retry_delay": 10,
            "push_key": "FsDZQkf7na"  # Existing Jellyfin key
        },
        {
            "name": "Paperless-ngx",
            "local_url": "http://192.168.0.178:8000/api/health/",
            "tailscale_url": "http://100.91.157.19:8000/api/health/",
            "expected_content": "",  # Any successful response
            "timeout": 5,
            "retries": 2,
            "retry_delay": 10,
            "push_key": "96LPqfkbG0"  # Using system key for now
        },
        {
            "name": "Plex",
            "local_url": "http://192.168.0.178:32400/web",
            "tailscale_url": "http://100.91.157.19:32400/web",
            "expected_content": "",  # Any successful response (redirects are OK)
            "timeout": 5,
            "retries": 2,
            "retry_delay": 10,
            "push_key": "YX6Ln8WaAf"  # New Plex key
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
            "Paperless": "96LPqfkbG0",  # Using system key for now
            "Plex": "YX6Ln8WaAf",
            "System": "96LPqfkbG0"
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
    },
    
    # System monitoring configuration
    "system": {
        "push_key": "96LPqfkbG0",  # New System key
        "checks": [
            "cpu_usage",
            "memory_usage",
            "disk_usage",
            "network_status"
        ]
    }
}

# Set up logging
log_dir = "/var/log/monitoring"
log_file = os.path.join(log_dir, "server_monitor.log")
os.makedirs(log_dir, exist_ok=True)

logger = logging.getLogger("ServerMonitor")
logger.setLevel(logging.DEBUG)
handler = RotatingFileHandler(log_file, maxBytes=1024*1024, backupCount=5)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)

def check_service(service):
    """Check if a service is running and healthy"""
    for attempt in range(service["retries"]):
        try:
            # Try Tailscale URL first
            response = requests.get(service["tailscale_url"], timeout=service["timeout"], allow_redirects=True)
            # Accept 200 (OK) or 3xx (redirects) as healthy
            if response.status_code in [200, 301, 302, 303, 307, 308]:
                if service["expected_content"]:
                    if service["expected_content"] in response.text:
                        return True
                else:
                    return True
        except:
            try:
                # Fallback to local URL
                response = requests.get(service["local_url"], timeout=service["timeout"], allow_redirects=True)
                # Accept 200 (OK) or 3xx (redirects) as healthy
                if response.status_code in [200, 301, 302, 303, 307, 308]:
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
    """Push status updates to Uptime Kuma with improved error handling"""
    try:
        push_key = None
        # First try to get the key from the service config
        for service in CONFIG["services"]:
            if service["name"] == service_name and "push_key" in service:
                push_key = service["push_key"]
                break
        # If not found in service config, try endpoints config
        if not push_key:
            push_key = CONFIG["uptime_kuma"]["endpoints"].get(service_name)
        
        if push_key:
            status_str = "up" if status else "down"
            message = f"Service%20{status_str}"
            
            # Try localhost first
            try:
                push_url = f"http://localhost:3001/api/push/{push_key}?status={status_str}&msg={message}"
                response = requests.get(push_url, timeout=2)
                logger.debug(f"Local push response for {service_name}: {response.status_code} - {response.text}")
                if response.status_code != 200:
                    raise Exception(f"Local push failed with status {response.status_code}")
            except Exception as local_e:
                logger.warning(f"Local push failed, trying Tailscale URL: {str(local_e)}")
                # Fallback to Tailscale URL
                push_url = f"http://100.91.157.19:3001/api/push/{push_key}?status={status_str}&msg={message}"
                response = requests.get(push_url, timeout=5)
                logger.debug(f"Tailscale push response for {service_name}: {response.status_code} - {response.text}")
                if response.status_code != 200:
                    raise Exception(f"Tailscale push failed with status {response.status_code}")
    except Exception as e:
        logger.error(f"Failed to push to Uptime Kuma for {service_name}: {str(e)}")
        # Don't re-raise the exception - we want the script to continue running

def check_system_health():
    """Check G9 system health - comprehensive system check"""
    try:
        # Check 1: Basic system responsiveness (always true if script is running)
        system_responsive = True
        
        # Check 2: External connectivity (internet access)
        external_ok = check_external_connectivity()
        
        # Check 3: Critical services are accessible locally
        critical_services_ok = True
        try:
            # Quick check that we can reach local services
            import socket
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(2)
            # Test if we can connect to Uptime Kuma locally
            result = sock.connect_ex(('localhost', 3001))
            sock.close()
            if result != 0:
                critical_services_ok = False
        except:
            critical_services_ok = False
        
        # System is "UP" if it's responsive and either has internet OR local services work
        system_status = system_responsive and (external_ok or critical_services_ok)
        
        logger.info(f"System Health - Responsive: {system_responsive}, External: {external_ok}, Local Services: {critical_services_ok}, Overall: {'UP' if system_status else 'DOWN'}")
        return system_status
        
    except Exception as e:
        logger.error(f"System health check error: {str(e)}")
        return False  # If we can't check, assume down

def main():
    """Main monitoring function"""
    try:
        # Check G9 system health
        system_status = check_system_health()
        push_to_uptime_kuma("System", system_status)

        # Check each service
        for service in CONFIG["services"]:
            status = check_service(service)
            logger.info(f"{service['name']}: {'UP' if status else 'DOWN'}")
            push_to_uptime_kuma(service["name"], status)

    except Exception as e:
        logger.error(f"Monitoring error: {str(e)}")

if __name__ == "__main__":
    main() 