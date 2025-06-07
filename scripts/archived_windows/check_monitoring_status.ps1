# Script to check Tailscale monitoring system status and activity

Write-Host "Checking Tailscale monitoring system status..."
Write-Host "----------------------------------------"

# Check task status
$task = Get-ScheduledTask -TaskName "TailscaleMonitoring" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "[OK] Task Status:"
    Write-Host "     Current State: $($task.State)"
    
    $taskInfo = Get-ScheduledTaskInfo -TaskName "TailscaleMonitoring" -ErrorAction SilentlyContinue
    if ($taskInfo) {
        Write-Host "     Last Run Time: $($taskInfo.LastRunTime)"
        Write-Host "     Last Run Result: $($taskInfo.LastTaskResult)"
        Write-Host "     Next Run Time: $($taskInfo.NextRunTime)"
    }
} else {
    Write-Host "[ERROR] Monitoring task not found"
    exit 1
}

# Check log directory
$logPath = "C:\Logs\Tailscale"
Write-Host "`n[INFO] Log Directory ($logPath):"
if (Test-Path $logPath) {
    $logFiles = Get-ChildItem -Path $logPath -File | Sort-Object LastWriteTime -Descending
    if ($logFiles) {
        Write-Host "     Found $($logFiles.Count) log files"
        Write-Host "     Most recent log: $($logFiles[0].Name) (Last modified: $($logFiles[0].LastWriteTime))"
        
        # Show last few lines of most recent log if it exists
        if ($logFiles[0].Length -gt 0) {
            Write-Host "`n     Last 5 lines of most recent log:"
            Get-Content $logFiles[0].FullName -Tail 5 | ForEach-Object {
                Write-Host "     $_"
            }
        }
    } else {
        Write-Host "     No log files found yet"
    }
} else {
    Write-Host "     [ERROR] Log directory not found"
}

# Check metrics directory
$metricsPath = "C:\Logs\Tailscale\Metrics"
Write-Host "`n[INFO] Metrics Directory ($metricsPath):"
if (Test-Path $metricsPath) {
    $metricFiles = Get-ChildItem -Path $metricsPath -File | Sort-Object LastWriteTime -Descending
    if ($metricFiles) {
        Write-Host "     Found $($metricFiles.Count) metric files"
        Write-Host "     Most recent metric: $($metricFiles[0].Name) (Last modified: $($metricFiles[0].LastWriteTime))"
        
        # Show last few lines of most recent metric file if it exists
        if ($metricFiles[0].Length -gt 0) {
            Write-Host "`n     Last 5 lines of most recent metrics:"
            Get-Content $metricFiles[0].FullName -Tail 5 | ForEach-Object {
                Write-Host "     $_"
            }
        }
    } else {
        Write-Host "     No metric files found yet"
    }
} else {
    Write-Host "     [ERROR] Metrics directory not found"
}

# Check if monitoring script exists
$monitoringScript = Join-Path $PSScriptRoot "tailscale_monitoring.ps1"
Write-Host "`n[INFO] Monitoring Script:"
if (Test-Path $monitoringScript) {
    Write-Host "     Script exists: $monitoringScript"
    Write-Host "     Last modified: $((Get-Item $monitoringScript).LastWriteTime)"
} else {
    Write-Host "     [ERROR] Monitoring script not found"
}

Write-Host "`n----------------------------------------"
Write-Host "Check complete. Review the output above for any issues."
Write-Host "If no log or metric files are found, wait a few minutes for the task to run."
Write-Host "----------------------------------------" 