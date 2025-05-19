# Simple test script for Tailscale monitoring system

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

Write-Host "Testing Tailscale monitoring system..."
Write-Host "----------------------------------------"

# Test 1: Check if monitoring script exists
$monitoringScript = Join-Path $PSScriptRoot "tailscale_monitoring.ps1"
if (Test-Path $monitoringScript) {
    Write-Host "✓ Monitoring script found at: $monitoringScript"
} else {
    Write-Host "✗ Monitoring script not found"
    exit 1
}

# Test 2: Check if scheduled task exists
try {
    $task = Get-ScheduledTask -TaskName "TailscaleMonitoring" -ErrorAction Stop
    Write-Host "✓ Scheduled task exists"
    Write-Host "  Status: $($task.State)"
    Write-Host "  Last Run: $($task.LastRunTime)"
    Write-Host "  Next Run: $($task.NextRunTime)"
} catch {
    Write-Host "✗ Scheduled task not found"
    exit 1
}

# Test 3: Check if log directories exist
$logPath = "C:\Logs\Tailscale"
$metricsPath = "C:\Logs\Tailscale\Metrics"

if (Test-Path $logPath) {
    Write-Host "✓ Log directory exists: $logPath"
} else {
    Write-Host "✗ Log directory not found"
    exit 1
}

if (Test-Path $metricsPath) {
    Write-Host "✓ Metrics directory exists: $metricsPath"
} else {
    Write-Host "✗ Metrics directory not found"
    exit 1
}

Write-Host "`nBasic tests completed successfully!"
Write-Host "The monitoring system appears to be set up correctly."
Write-Host "----------------------------------------" 