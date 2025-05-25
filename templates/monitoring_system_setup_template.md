# Monitoring System Setup Documentation Template

## Overview
This template documents the setup and configuration of the Tailscale monitoring system on Windows 11. It provides a clear, step-by-step guide for installation, configuration, and verification.

---

## 1. Prerequisites
- Windows 11 with administrator privileges
- Tailscale installed and configured
- Gmail App Password for SMTP alerts

## 2. File Locations
- Monitoring script: `scripts/tailscale_monitoring.ps1`
- Setup script: `scripts/setup_tailscale_monitoring.ps1`
- Test script: `scripts/test_monitoring_new.ps1`
- Log directory: `C:\Logs\Tailscale`
- Metrics directory: `C:\Logs\Tailscale\Metrics`
- Secure password: `C:\Secure\smtp_password.txt`

## 3. Setup Steps
1. **Copy scripts to the server:**
   - Place all scripts in the `scripts/` directory on the server.
2. **Set up log and metrics directories:**
   - Ensure `C:\Logs\Tailscale` and `C:\Logs\Tailscale\Metrics` exist.
3. **Store SMTP password securely:**
   - Save the Gmail App Password in `C:\Secure\smtp_password.txt` (restrict permissions).
4. **Run the setup script:**
   - Execute `scripts/setup_tailscale_monitoring.ps1` as Administrator.
   - This creates the scheduled task and configures directories.
5. **Verify scheduled task:**
   - Open Task Scheduler and confirm the monitoring task is present and set to run every 5 minutes.
6. **Test monitoring system:**
   - Run `scripts/test_monitoring_new.ps1` to verify alerts, metrics, and log rotation.

## 4. Configuration Details
- **Alert Email:** msakamoto+homelab@gmail.com
- **Latency Threshold:** 100ms
- **Log Retention:** 30 days
- **Metrics Collection Interval:** 5 minutes

## 5. Verification Checklist
- [ ] Scheduled task exists and runs every 5 minutes
- [ ] Logs and metrics are being written
- [ ] Email alerts are received on failure/threshold breach
- [ ] Log rotation is working (old logs deleted after 30 days)

---

*Update this template as the system evolves or if any configuration changes are made.* 