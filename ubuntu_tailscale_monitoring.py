#!/usr/bin/env python3
"""
Ubuntu Tailscale Monitoring Script
Monitors Tailscale connection and sends email alerts for important events
Replaces the Windows PowerShell version for Ubuntu systems
"""

import os
import sys
import json
import time
import socket
import smtplib
import logging
import subprocess
from datetime import datetime
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from pathlib import Path

# Configuration
CONFIG = {
    "email": {
        "enabled": True,
        "smtp_server": "smtp.gmail.com",
        "smtp_port": 587,
        "username": os.getenv("SMTP_USERNAME", "msakamoto+homelab@gmail.com"),
        "password": os.getenv("SMTP_PASSWORD", ""),
        "from_address": os.getenv("SMTP_FROM", "msakamoto+homelab@gmail.com"),
        "to_address": os.getenv("SMTP_TO", "msakamoto+alerts@gmail.com"),
        "subject_prefix": "[Tailscale Alert]"
    },
    "monitoring": {
        "check_interval": 300,  # 5 minutes
        "latency_threshold": 100,  # ms
        "log_retention_days": 30,
        "test_destinations": [
            "100.91.157.19",  # Self (Ubuntu server)
            "8.8.8.8"         # Google DNS for internet connectivity
        ]
    },
    "paths": {
        "log_dir": "/var/log/tailscale-monitoring",
        "metrics_dir": "/var/log/tailscale-monitoring/metrics",
        "state_file": "/var/log/tailscale-monitoring/last_state.json"
    }
}

# Set up logging
def setup_logging():
    """Configure logging for the monitoring script"""
    log_dir = CONFIG["paths"]["log_dir"]
    os.makedirs(log_dir, exist_ok=True)
    os.makedirs(CONFIG["paths"]["metrics_dir"], exist_ok=True)
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(f"{log_dir}/tailscale_monitor.log"),
            logging.StreamHandler()
        ]
    )
    return logging.getLogger(__name__)

def send_email_alert(subject, body, priority="Normal"):
    """Send email alert using Gmail SMTP"""
    if not CONFIG["email"]["enabled"]:
        logger.info(f"Email disabled, would send: {subject}")
        return
    
    if not CONFIG["email"]["password"]:
        logger.error("SMTP password not configured. Set SMTP_PASSWORD environment variable.")
        return
    
    try:
        msg = MIMEMultipart()
        msg['From'] = CONFIG["email"]["from_address"]
        msg['To'] = CONFIG["email"]["to_address"]
        msg['Subject'] = f"{CONFIG['email']['subject_prefix']} {subject}"
        
        # Add priority header
        if priority == "High":
            msg['X-Priority'] = "1"
        
        msg.attach(MIMEText(body, 'plain'))
        
        server = smtplib.SMTP(CONFIG["email"]["smtp_server"], CONFIG["email"]["smtp_port"])
        server.starttls()
        server.login(CONFIG["email"]["username"], CONFIG["email"]["password"])
        text = msg.as_string()
        server.sendmail(CONFIG["email"]["from_address"], CONFIG["email"]["to_address"], text)
        server.quit()
        
        logger.info(f"Email alert sent: {subject}")
        
    except Exception as e:
        logger.error(f"Failed to send email alert: {e}")

def get_tailscale_status():
    """Get current Tailscale connection status"""
    status = {
        "connected": False,
        "latency": None,
        "using_derp": False,
        "ip_address": None,
        "last_check": datetime.now().isoformat(),
        "error": None
    }
    
    try:
        # Check if tailscale command exists and is accessible
        result = subprocess.run(["tailscale", "status", "--json"], 
                              capture_output=True, text=True, timeout=10)
        
        if result.returncode == 0:
            tailscale_data = json.loads(result.stdout)
            status["connected"] = True
            
            # Get our IP address
            if "Self" in tailscale_data and "TailscaleIPs" in tailscale_data["Self"]:
                status["ip_address"] = tailscale_data["Self"]["TailscaleIPs"][0]
            
            # Check if using DERP (relay servers)
            if "Self" in tailscale_data:
                status["using_derp"] = tailscale_data["Self"].get("Relay", "") != ""
            
            # Test latency to ourselves (should be very low)
            try:
                ping_result = subprocess.run(
                    ["ping", "-c", "1", "-W", "2", status["ip_address"] or "100.91.157.19"],
                    capture_output=True, text=True, timeout=5
                )
                if ping_result.returncode == 0:
                    # Extract latency from ping output
                    lines = ping_result.stdout.split('\n')
                    for line in lines:
                        if "time=" in line:
                            time_part = line.split("time=")[1].split()[0]
                            status["latency"] = float(time_part.replace("ms", ""))
                            break
            except:
                pass
                
        else:
            status["error"] = f"Tailscale command failed: {result.stderr}"
            
    except subprocess.TimeoutExpired:
        status["error"] = "Tailscale command timeout"
    except Exception as e:
        status["error"] = str(e)
    
    return status

def save_metrics(status):
    """Save current status metrics to file"""
    metrics_file = os.path.join(
        CONFIG["paths"]["metrics_dir"], 
        f"tailscale_metrics_{datetime.now().strftime('%Y-%m-%d')}.json"
    )
    
    with open(metrics_file, "a") as f:
        json.dump(status, f)
        f.write("\n")

def load_previous_state():
    """Load the previous monitoring state"""
    state_file = CONFIG["paths"]["state_file"]
    if os.path.exists(state_file):
        try:
            with open(state_file, "r") as f:
                return json.load(f)
        except:
            pass
    return {"connected": False, "using_derp": False}

def save_current_state(status):
    """Save current state for next comparison"""
    state_file = CONFIG["paths"]["state_file"]
    with open(state_file, "w") as f:
        json.dump({
            "connected": status["connected"],
            "using_derp": status["using_derp"],
            "latency": status["latency"],
            "timestamp": status["last_check"]
        }, f)

def check_for_events(current_status, previous_state):
    """Check for important events and send alerts"""
    
    # Connection lost
    if previous_state["connected"] and not current_status["connected"]:
        send_email_alert(
            "Tailscale Disconnected", 
            f"Tailscale connection was lost at {current_status['last_check']}\n"
            f"Error: {current_status.get('error', 'Unknown')}\n\n"
            f"This may indicate a network issue or power outage.",
            priority="High"
        )
    
    # Connection restored
    if not previous_state["connected"] and current_status["connected"]:
        send_email_alert(
            "Tailscale Reconnected",
            f"Tailscale connection was restored at {current_status['last_check']}\n"
            f"IP Address: {current_status.get('ip_address', 'Unknown')}\n"
            f"Current latency: {current_status.get('latency', 'Unknown')}ms"
        )
    
    # High latency warning
    if (current_status["connected"] and current_status["latency"] and 
        current_status["latency"] > CONFIG["monitoring"]["latency_threshold"]):
        send_email_alert(
            "High Tailscale Latency",
            f"Current latency: {current_status['latency']}ms "
            f"(threshold: {CONFIG['monitoring']['latency_threshold']}ms)\n"
            f"Using DERP relay: {current_status['using_derp']}"
        )
    
    # DERP fallback (usually indicates NAT traversal issues)
    if not previous_state.get("using_derp", False) and current_status["using_derp"]:
        send_email_alert(
            "Tailscale Using DERP Relay",
            f"Connection fell back to DERP relay servers at {current_status['last_check']}\n"
            f"This may indicate NAT traversal issues or firewall blocking direct connections."
        )

def cleanup_old_logs():
    """Remove old log files based on retention policy"""
    retention_days = CONFIG["monitoring"]["log_retention_days"]
    cutoff_time = time.time() - (retention_days * 24 * 60 * 60)
    
    for log_dir in [CONFIG["paths"]["log_dir"], CONFIG["paths"]["metrics_dir"]]:
        if os.path.exists(log_dir):
            for filename in os.listdir(log_dir):
                file_path = os.path.join(log_dir, filename)
                if os.path.isfile(file_path) and os.path.getmtime(file_path) < cutoff_time:
                    try:
                        os.remove(file_path)
                        logger.info(f"Removed old log file: {filename}")
                    except Exception as e:
                        logger.error(f"Failed to remove old log file {filename}: {e}")

def main():
    """Main monitoring function"""
    logger.info("Starting Tailscale monitoring check...")
    
    # Load previous state
    previous_state = load_previous_state()
    
    # Get current status
    current_status = get_tailscale_status()
    
    # Log current status
    if current_status["connected"]:
        logger.info(f"Tailscale: CONNECTED, IP: {current_status.get('ip_address', 'Unknown')}, "
                   f"Latency: {current_status.get('latency', 'Unknown')}ms, "
                   f"DERP: {current_status['using_derp']}")
    else:
        logger.warning(f"Tailscale: DISCONNECTED, Error: {current_status.get('error', 'Unknown')}")
    
    # Save metrics
    save_metrics(current_status)
    
    # Check for events and send alerts
    check_for_events(current_status, previous_state)
    
    # Save current state for next check
    save_current_state(current_status)
    
    # Cleanup old logs (run once per day)
    current_hour = datetime.now().hour
    if current_hour == 2:  # 2 AM
        cleanup_old_logs()
    
    logger.info("Tailscale monitoring check completed")

if __name__ == "__main__":
    logger = setup_logging()
    
    # Verify environment variables are set
    if not CONFIG["email"]["password"]:
        logger.warning("SMTP_PASSWORD environment variable not set. Email alerts will be disabled.")
        logger.info("To enable email alerts:")
        logger.info("  export SMTP_PASSWORD='your_gmail_app_password'")
        logger.info("  export SMTP_USERNAME='msakamoto+homelab@gmail.com'")
        
    try:
        main()
    except KeyboardInterrupt:
        logger.info("Monitoring stopped by user")
    except Exception as e:
        logger.error(f"Monitoring error: {e}")
        sys.exit(1) 