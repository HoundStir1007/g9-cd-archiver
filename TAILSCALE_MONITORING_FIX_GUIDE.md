# 🚨 Tailscale Monitoring System Fix Guide

## Quick Start - Run This First! 🚀

**On your Windows G9 system:**

1. **Copy the diagnostic script** to your Windows machine:
   - Transfer `fix_tailscale_monitoring.ps1` to the G9
   - Or copy/paste the content into a new PowerShell file

2. **Run as Administrator:**
   ```powershell
   # Right-click PowerShell -> "Run as Administrator"
   cd C:\
   .\fix_tailscale_monitoring.ps1
   ```

## Expected Issues and Fixes 🔧

### 1. Gmail App Password Missing ❌
**Symptom:** SMTP test fails  
**Fix:** 
1. Go to [Google Account Security](https://myaccount.google.com/security)
2. Enable 2-Factor Authentication (if not already enabled)
3. Generate App Password for "Mail"
4. Save password to: `C:\Secure\smtp_password.txt` (plain text)

### 2. Scheduled Task Not Running ❌  
**Symptom:** Task test fails or shows wrong state  
**Fix:**
1. Copy monitoring scripts from archived location:
   ```powershell
   # Copy scripts to active location
   New-Item -ItemType Directory -Path "C:\Scripts\Tailscale" -Force
   Copy-Item ".\scripts\archived_windows\*.ps1" "C:\Scripts\Tailscale\"
   ```
2. Run setup script as Administrator:
   ```powershell
   cd C:\Scripts\Tailscale
   .\setup_tailscale_monitoring.ps1
   ```

### 3. No Log Activity ❌
**Symptom:** No recent logs in `C:\Logs\Tailscale`  
**Fix:**
1. Test monitoring script manually:
   ```powershell
   cd C:\Scripts\Tailscale
   .\tailscale_monitoring.ps1
   ```
2. Check for errors in output
3. Verify Tailscale is running and connected

### 4. Incorrect IP Addresses ⚠️
**Issue:** Script might be pinging wrong Tailscale IPs  
**Current IPs from baton:**
- Ubuntu: `100.91.157.19` 
- Windows: `100.122.141.83`

## Step-by-Step Fix Process 📋

### Phase 1: Diagnosis
```powershell
# Run diagnostic script
.\fix_tailscale_monitoring.ps1
```

### Phase 2: Gmail Setup (if needed)
1. Create Gmail App Password
2. Save to `C:\Secure\smtp_password.txt`
3. Test: Re-run diagnostic script

### Phase 3: Script Setup (if needed)
```powershell
# Create directories
New-Item -ItemType Directory -Path "C:\Scripts\Tailscale" -Force
New-Item -ItemType Directory -Path "C:\Logs\Tailscale" -Force
New-Item -ItemType Directory -Path "C:\Secure" -Force

# Copy monitoring scripts
Copy-Item "scripts\archived_windows\*.ps1" "C:\Scripts\Tailscale\"

# Run setup
cd C:\Scripts\Tailscale
.\setup_tailscale_monitoring.ps1
```

### Phase 4: Verification
```powershell
# Check task status
Get-ScheduledTask -TaskName "TailscaleMonitoring"

# Check task info
Get-ScheduledTaskInfo -TaskName "TailscaleMonitoring"

# Manual test
cd C:\Scripts\Tailscale
.\tailscale_monitoring.ps1
```

## Success Indicators ✅

After fixing, you should see:
- ✅ SMTP test email received in Gmail
- ✅ Tailscale connectivity confirmed  
- ✅ Scheduled task in "Ready" state
- ✅ Recent log files in `C:\Logs\Tailscale`
- ✅ Recent metrics in `C:\Logs\Tailscale\Metrics`

## Common Issues & Solutions 🔍

**PowerShell Execution Policy:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Tailscale Not Found:**
- Verify Tailscale is installed and running
- Check Windows Services for "Tailscale"

**Task Scheduler Issues:**
- Check Windows Event Viewer -> Task Scheduler logs
- Verify task runs under SYSTEM account with highest privileges

## Testing the Fix 🧪

**Simulate Power Outage Test:**
1. Stop Tailscale service temporarily
2. Check if monitoring detects disconnection
3. Check if email alert is sent
4. Restart Tailscale service
5. Verify reconnection alert

**Quick Status Check:**
```powershell
cd C:\Scripts\Tailscale
.\check_monitoring_status.ps1
```

## Files Created/Modified 📁

- `C:\Scripts\Tailscale\*.ps1` - Active monitoring scripts
- `C:\Logs\Tailscale\*.log` - Monitoring logs
- `C:\Logs\Tailscale\Metrics\*.json` - Performance metrics
- `C:\Secure\smtp_password.txt` - Gmail app password
- Task Scheduler: "TailscaleMonitoring" scheduled task

---

## Quick Commands Summary 🎯

```powershell
# 1. Diagnose
.\fix_tailscale_monitoring.ps1

# 2. Setup (if needed)
New-Item -ItemType Directory -Path "C:\Scripts\Tailscale" -Force
Copy-Item "scripts\archived_windows\*.ps1" "C:\Scripts\Tailscale\"
cd C:\Scripts\Tailscale
.\setup_tailscale_monitoring.ps1

# 3. Test
.\check_monitoring_status.ps1

# 4. Manual run
.\tailscale_monitoring.ps1
```

**🎉 Once working, you'll get email alerts for power outages and connectivity issues!**