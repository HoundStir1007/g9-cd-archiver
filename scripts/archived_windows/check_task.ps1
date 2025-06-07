# Simple script to check Tailscale monitoring task

$task = Get-ScheduledTask -TaskName "TailscaleMonitoring" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "Task exists:"
    Write-Host "Status: $($task.State)"
    Write-Host "Last Run: $($task.LastRunTime)"
    Write-Host "Next Run: $($task.NextRunTime)"
} else {
    Write-Host "Task not found"
} 