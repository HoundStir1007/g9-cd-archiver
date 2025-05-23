# Script to check Tailscale monitoring task with admin privileges

# Check for administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Running as non-administrator. Some information may not be visible."
}

Write-Host "Checking Tailscale monitoring task..."
Write-Host "----------------------------------------"

# Check the task
$task = Get-ScheduledTask -TaskName "TailscaleMonitoring" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "[OK] Task exists:"
    Write-Host "     Status: $($task.State)"
    Write-Host "     Last Run: $($task.LastRunTime)"
    Write-Host "     Next Run: $($task.NextRunTime)"
    
    # Check task details
    $taskDetails = Get-ScheduledTaskInfo -TaskName "TailscaleMonitoring" -ErrorAction SilentlyContinue
    if ($taskDetails) {
        Write-Host "`nTask Details:"
        Write-Host "     Last Run Result: $($taskDetails.LastTaskResult)"
        Write-Host "     Last Run Time: $($taskDetails.LastRunTime)"
        Write-Host "     Next Run Time: $($taskDetails.NextRunTime)"
    }
} else {
    Write-Host "[ERROR] Task not found"
    Write-Host "Please run setup_tailscale_monitoring.ps1 as Administrator"
}

# Check if directories exist
Write-Host "`nChecking directories..."
$logPath = "C:\Logs\Tailscale"
$metricsPath = "C:\Logs\Tailscale\Metrics"

if (Test-Path $logPath) {
    Write-Host "[OK] Log directory exists: $logPath"
} else {
    Write-Host "[ERROR] Log directory not found"
}

if (Test-Path $metricsPath) {
    Write-Host "[OK] Metrics directory exists: $metricsPath"
} else {
    Write-Host "[ERROR] Metrics directory not found"
} 