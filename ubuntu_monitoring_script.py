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

# Ensure log directory exists
os.makedirs(CONFIG["logging"]["log_dir"], exist_ok=True)

# Configure logging
log_file = os.path.join(CONFIG["logging"]["log_dir"], "server_monitor.log")
log_handler = RotatingFileHandler(
    log_file,
    maxBytes=CONFIG["logging"]["max_size_mb"] * 1024 * 1024,
    backupCount=CONFIG["logging"]["backup_count"]
)

logging.basicConfig(
    level=getattr(logging, CONFIG["logging"]["log_level"]),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[log_handler]
)

logger = logging.getLogger("server_monitor")

class ServerMonitor:
    def __init__(self, config):
        self.config = config
        self.last_notification = {}  # Track when notifications were last sent
        self.service_status = {}     # Track service status for change detection
        
    def check_service(self, service):
        """Check a service's health using both local and Tailscale URLs"""
        name = service["name"]
        urls = [service["local_url"], service["tailscale_url"]]
        expected_content = service["expected_content"]
        timeout = service["timeout"]
        retries = service["retries"]
        retry_delay = service["retry_delay"]
        
        logger.info(f"Checking {name} health...")
        
        for url in urls:
            for attempt in range(retries + 1):
                try:
                    response = requests.get(url, timeout=timeout)
                    
                    if response.status_code == 200:
                        if not expected_content or expected_content in response.text:
                            logger.info(f"{name} is healthy (URL: {url})")
                            return True, f"{name} is healthy"
                        else:
                            logger.warning(f"{name} returned unexpected content (URL: {url})")
                    else:
                        logger.warning(f"{name} returned status code {response.status_code} (URL: {url})")
                        
                    if attempt < retries:
                        logger.info(f"Retrying {name} in {retry_delay} seconds... (Attempt {attempt+1}/{retries})")
                        time.sleep(retry_delay)
                        
                except requests.exceptions.RequestException as e:
                    logger.warning(f"Error connecting to {name} at {url}: {str(e)}")
                    if attempt < retries:
                        logger.info(f"Retrying {name} in {retry_delay} seconds... (Attempt {attempt+1}/{retries})")
                        time.sleep(retry_delay)
        
        return False, f"{name} is not responding"
    
    def check_external_connectivity(self):
        """Check connectivity to external services"""
        for check in self.config["external_checks"]:
            host = check["host"]
            port = check["port"]
            
            try:
                socket.create_connection((host, port), timeout=5)
                logger.info(f"External connectivity to {host}:{port} successful")
                return True
            except (socket.timeout, socket.error) as e:
                logger.warning(f"External connectivity to {host}:{port} failed: {str(e)}")
        
        return False
    
    def check_system_resources(self):
        """Check system resources (CPU, memory, disk)"""
        issues = []
        
        try:
            # Check CPU load
            load = os.getloadavg()[0]
            if load > self.config["thresholds"]["load_average"]:
                issues.append(f"High CPU load: {load}")
            
            # Check disk space
            df = subprocess.check_output(['df', '-h', '/']).decode('utf-8')
            lines = df.strip().split('\n')
            disk_usage = int(lines[1].split()[4].rstrip('%'))
            if disk_usage > self.config["thresholds"]["disk_percent"]:
                issues.append(f"Low disk space: {disk_usage}% used")
            
            # Check memory (requires psutil which may need to be installed)
            try:
                import psutil
                memory_percent = psutil.virtual_memory().percent
                if memory_percent > self.config["thresholds"]["memory_percent"]:
                    issues.append(f"High memory usage: {memory_percent}%")
            except ImportError:
                logger.warning("psutil not installed, skipping memory check")
                
        except Exception as e:
            logger.error(f"Error checking system resources: {str(e)}")
            issues.append(f"Error checking system resources: {str(e)}")
        
        return issues
    
    def push_to_uptime_kuma(self, service_name, status, msg=""):
        """Push status to Uptime Kuma"""
        try:
            if service_name in self.config["uptime_kuma"]["endpoints"]:
                push_key = self.config["uptime_kuma"]["endpoints"][service_name]
                push_url = f"{self.config['uptime_kuma']['push_url']}{push_key}"
                
                if status:
                    push_url += "?status=up"
                else:
                    push_url += "?status=down"
                    
                if msg:
                    push_url += f"&msg={msg}"
                
                response = requests.get(push_url, timeout=10)
                if response.status_code == 200:
                    logger.info(f"Successfully pushed status to Uptime Kuma for {service_name}")
                else:
                    logger.warning(f"Failed to push status to Uptime Kuma for {service_name}: {response.status_code}")
            else:
                logger.warning(f"No Uptime Kuma push key configured for {service_name}")
        except Exception as e:
            logger.error(f"Error pushing to Uptime Kuma for {service_name}: {str(e)}")
    
    def send_email_notification(self, subject, message):
        """Send email notification"""
        if not self.config["email"]["enabled"]:
            return
        
        try:
            # Read password from file
            password_file = Path(self.config["email"]["password_file"])
            if not password_file.exists():
                logger.error(f"Email password file not found: {password_file}")
                return
                
            password = password_file.read_text().strip()
            
            msg = MIMEMultipart()
            msg["From"] = self.config["email"]["from_address"]
            msg["To"] = self.config["email"]["to_address"]
            msg["Subject"] = f"{self.config['email']['subject_prefix']} {subject}"
            
            msg.attach(MIMEText(message, "plain"))
            
            with smtplib.SMTP(self.config["email"]["smtp_server"], self.config["email"]["smtp_port"]) as server:
                server.starttls()
                server.login(self.config["email"]["username"], password)
                server.send_message(msg)
                
            logger.info(f"Email notification sent: {subject}")
        except Exception as e:
            logger.error(f"Failed to send email notification: {str(e)}")
    
    def send_pushover_notification(self, title, message, priority=None):
        """Send Pushover notification"""
        if not self.config["pushover"]["enabled"]:
            return
            
        try:
            if priority is None:
                priority = self.config["pushover"]["priority"]
                
            data = {
                "token": self.config["pushover"]["api_token"],
                "user": self.config["pushover"]["user_key"],
                "title": title,
                "message": message,
                "priority": priority
            }
            
            response = requests.post("https://api.pushover.net/1/messages.json", data=data, timeout=10)
            if response.status_code == 200:
                logger.info(f"Pushover notification sent: {title}")
            else:
                logger.warning(f"Failed to send Pushover notification: {response.status_code}")
        except Exception as e:
            logger.error(f"Error sending Pushover notification: {str(e)}")
    
    def send_discord_notification(self, title, message):
        """Send Discord notification"""
        if not self.config["discord"]["enabled"]:
            return
            
        try:
            data = {
                "content": f"**{title}**\n{message}"
            }
            
            response = requests.post(
                self.config["discord"]["webhook_url"],
                json=data,
                headers={"Content-Type": "application/json"},
                timeout=10
            )
            
            if response.status_code == 204:
                logger.info(f"Discord notification sent: {title}")
            else:
                logger.warning(f"Failed to send Discord notification: {response.status_code}")
        except Exception as e:
            logger.error(f"Error sending Discord notification: {str(e)}")
    
    def send_notification(self, title, message, service_name=None, is_recovery=False):
        """Send notification through all configured channels"""
        current_time = time.time()
        
        # Rate limiting - don't send notifications for the same service too frequently
        if service_name:
            if service_name in self.last_notification:
                # Only allow one notification per hour for the same service
                if current_time - self.last_notification[service_name] < 3600 and not is_recovery:
                    logger.info(f"Skipping notification for {service_name} due to rate limiting")
                    return
            
            self.last_notification[service_name] = current_time
        
        # Format the message with timestamp
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        formatted_message = f"[{timestamp}] {message}"
        
        # Send through all enabled channels
        self.send_email_notification(title, formatted_message)
        
        # Set higher priority for failures, normal for recovery
        pushover_priority = 0 if is_recovery else self.config["pushover"]["priority"]
        self.send_pushover_notification(title, formatted_message, pushover_priority)
        
        self.send_discord_notification(title, formatted_message)
    
    def run_monitoring_cycle(self):
        """Run a complete monitoring cycle"""
        logger.info("Starting monitoring cycle")
        
        # Check external connectivity first
        external_connectivity = self.check_external_connectivity()
        if not external_connectivity:
            logger.warning("External connectivity check failed")
            self.send_notification(
                "External Connectivity Lost",
                "The server cannot reach external services. This may indicate a network or internet issue.",
                service_name="external_connectivity"
            )
            self.push_to_uptime_kuma("System", False, "External connectivity lost")
        else:
            self.push_to_uptime_kuma("System", True)
        
        # Check each service
        for service in self.config["services"]:
            name = service["name"]
            status, message = self.check_service(service)
            
            # Detect status changes
            previous_status = self.service_status.get(name, None)
            self.service_status[name] = status
            
            # Push status to Uptime Kuma
            self.push_to_uptime_kuma(name, status, message if not status else "")
            
            # Send notifications on status change
            if previous_status is not None and previous_status != status:
                if status:  # Recovery
                    self.send_notification(
                        f"{name} Recovered",
                        f"{name} service is now operational.",
                        service_name=name,
                        is_recovery=True
                    )
                else:  # Failure
                    self.send_notification(
                        f"{name} Down",
                        f"{name} service is not responding. {message}",
                        service_name=name
                    )
            elif previous_status is None and not status:
                # First check and service is down
                self.send_notification(
                    f"{name} Down",
                    f"{name} service is not responding. {message}",
                    service_name=name
                )
        
        # Check system resources
        resource_issues = self.check_system_resources()
        if resource_issues:
            issue_message = "System resource issues detected:\n" + "\n".join(resource_issues)
            logger.warning(issue_message)
            self.send_notification(
                "System Resource Warning",
                issue_message,
                service_name="system_resources"
            )
        
        logger.info("Monitoring cycle completed")

def main():
    """Main function to run the monitoring script"""
    monitor = ServerMonitor(CONFIG)
    
    # Log startup
    logger.info("Server monitoring script started")
    
    try:
        # Run once if called directly
        monitor.run_monitoring_cycle()
    except Exception as e:
        logger.critical(f"Unhandled exception in monitoring cycle: {str(e)}", exc_info=True)
        monitor.send_notification(
            "Monitoring System Error",
            f"The monitoring system encountered an error: {str(e)}",
            service_name="monitoring_system"
        )

if __name__ == "__main__":
    main() 