# Test script for Tailscale monitoring system

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Import the monitoring script
. "$PSScriptRoot\tailscale_monitoring.ps1"

Write-Host "Testing Tailscale monitoring system..."
Write-Host "----------------------------------------"

# Test 1: Check if monitoring script can be loaded
Write-Host "`nTest 1: Script Loading"
try {
    $status = Get-TailscaleStatus
    Write-Host "✓ Script loaded successfully"
    Write-Host "  Current status:"
    Write-Host "  - Connected: $($status.Connected)"
    Write-Host "  - Latency: $($status.Latency)ms"
    Write-Host "  - Using DERP: $($status.DERP)"
}
catch {
    Write-Host "✗ Script loading failed: $_"
    exit 1
}

# Test 2: Test email alert system
Write-Host "`nTest 2: Email Alert System"
try {
    Send-TailscaleAlert -Subject "Test Alert" -Body "This is a test alert from the Tailscale monitoring system." -Priority "Normal"
    Write-Host "✓ Test email sent successfully"
    Write-Host "  Please check msakamoto+homelab@gmail.com for the test email"
}
catch {
    Write-Host "✗ Email alert test failed: $_"
    Write-Host "  Please verify SMTP settings and password"
    exit 1
}

# Test 3: Test metrics collection
Write-Host "`nTest 3: Metrics Collection"
try {
    Save-TailscaleMetrics -Status $status
    $metricsFile = Join-Path $config.MetricsPath "tailscale_metrics_$(Get-Date -Format 'yyyy-MM-dd').json"
    if (Test-Path $metricsFile) {
        Write-Host "✓ Metrics saved successfully"
        Write-Host "  File: $metricsFile"
        Get-Content $metricsFile | Write-Host
    }
    else {
        Write-Host "✗ Metrics file not created"
        exit 1
    }
}
catch {
    Write-Host "✗ Metrics collection test failed: $_"
    exit 1
}

# Test 4: Test log cleanup
Write-Host "`nTest 4: Log Cleanup"
try {
    # Create a test log file older than retention period
    $oldLogPath = Join-Path $config.LogPath "test_old.log"
    "Test log content" | Set-Content $oldLogPath
    (Get-Item $oldLogPath).LastWriteTime = (Get-Date).AddDays(-($config.LogRetentionDays + 1))
    
    Clear-OldLogs
    
    if (-not (Test-Path $oldLogPath)) {
        Write-Host "✓ Log cleanup working correctly"
    }
    else {
        Write-Host "✗ Log cleanup failed - old log still exists"
        exit 1
    }
}
catch {
    Write-Host "✗ Log cleanup test failed: $_"
    exit 1
}

# Test 5: Test scheduled task
Write-Host "`nTest 5: Scheduled Task"
try {
    $task = Get-ScheduledTask -TaskName "TailscaleMonitoring" -ErrorAction Stop
    Write-Host "✓ Scheduled task exists"
    Write-Host "  Status: $($task.State)"
    Write-Host "  Last Run: $($task.LastRunTime)"
    Write-Host "  Next Run: $($task.NextRunTime)"
}
catch {
    Write-Host "✗ Scheduled task not found"
    Write-Host "  Please run setup_tailscale_monitoring.ps1 as administrator"
    exit 1
}

Write-Host "`nAll tests completed successfully!"
Write-Host "The Tailscale monitoring system is ready for use."
Write-Host "----------------------------------------"
Write-Host "Next steps:"
Write-Host "1. Monitor the system for 24 hours to verify alerts"
Write-Host "2. Review the metrics file daily to ensure proper collection"
Write-Host "3. Check the scheduled task runs after system restart"
Write-Host "4. Verify email alerts are received for all conditions" 