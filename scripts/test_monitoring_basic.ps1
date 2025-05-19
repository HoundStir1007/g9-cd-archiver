# Basic test script for Tailscale monitoring system

# Check for administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

Write-Host "Testing Tailscale monitoring system..."
Write-Host "----------------------------------------"

# Test 1: Check monitoring script
$monitoringScript = Join-Path $PSScriptRoot "tailscale_monitoring.ps1"
if (Test-Path $monitoringScript) {
    Write-Host "[OK] Monitoring script found at: $monitoringScript"
} else {
    Write-Host "[ERROR] Monitoring script not found"
    exit 1
}

# Test 2: Check scheduled task
$task = Get-ScheduledTask -TaskName "TailscaleMonitoring" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "[OK] Scheduled task exists"
    Write-Host "     Status: $($task.State)"
    Write-Host "     Last Run: $($task.LastRunTime)"
    Write-Host "     Next Run: $($task.NextRunTime)"
} else {
    Write-Host "[ERROR] Scheduled task not found"
    exit 1
}

# Test 3: Check directories
$logPath = "C:\Logs\Tailscale"
$metricsPath = "C:\Logs\Tailscale\Metrics"

if (Test-Path $logPath) {
    Write-Host "[OK] Log directory exists: $logPath"
} else {
    Write-Host "[ERROR] Log directory not found"
    exit 1
}

if (Test-Path $metricsPath) {
    Write-Host "[OK] Metrics directory exists: $metricsPath"
} else {
    Write-Host "[ERROR] Metrics directory not found"
    exit 1
}

Write-Host "`nBasic tests completed successfully!"
Write-Host "The monitoring system appears to be set up correctly."
Write-Host "----------------------------------------" 