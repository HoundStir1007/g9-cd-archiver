# Maintenance Automation Script
# This script automates daily checks and weekly maintenance tasks

# Configuration
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkspacePath = Split-Path -Parent $ScriptPath
$LogPath = Join-Path $WorkspacePath "maintenance_logs"
$DailyLogTemplate = Join-Path $LogPath "daily_check_template.md"
$WeeklyLogTemplate = Join-Path $LogPath "weekly_report_template.md"
$MonthlyLogTemplate = Join-Path $LogPath "monthly_report_template.md"
$ScanTime = "02:00"  # 2 AM
$WeeklyScanDay = "Sunday"
$WeeklyScanTime = "03:00"  # 3 AM

# Create log directory if it doesn't exist
if (-not (Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath -Force
    Write-Host "Created log directory: $LogPath"
}

function Get-SystemMetrics {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue
    $memory = Get-Counter '\Memory\% Committed Bytes In Use' -ErrorAction SilentlyContinue
    $disk = Get-PSDrive C -ErrorAction SilentlyContinue
    
    return @{
        CPU = [math]::Round($cpu.CounterSamples.CookedValue, 2)
        Memory = [math]::Round($memory.CounterSamples.CookedValue, 2)
        DiskFree = [math]::Round($disk.Free / 1GB, 2)
        DiskTotal = [math]::Round($disk.Used / 1GB, 2)
    }
}

function Get-NetworkStatus {
    $tailscale = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*Tailscale*"} -ErrorAction SilentlyContinue
    $ics = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*Ethernet 2*"} -ErrorAction SilentlyContinue
    
    return @{
        TailscaleStatus = if ($tailscale.Status -eq "Up") { "ACTIVE" } else { "INACTIVE" }
        TailscaleLatency = (Test-Connection -ComputerName "100.73.233.88" -Count 1 -ErrorAction SilentlyContinue).ResponseTime
        ICSStatus = if ($ics.Status -eq "Up") { "ACTIVE" } else { "INACTIVE" }
        ActiveConnections = (Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue).Count
    }
}

function Get-SecurityStatus {
    $defender = Get-MpComputerStatus -ErrorAction SilentlyContinue
    
    return @{
        RealTimeProtection = if ($defender.RealTimeProtectionEnabled) { "ENABLED" } else { "DISABLED" }
        NetworkProtection = if ($defender.NetworkProtectionEnabled) { "ENABLED" } else { "DISABLED" }
        ControlledFolderAccess = if ($defender.ControlledFolderAccessEnabled) { "ENABLED" } else { "DISABLED" }
        ProtectionStatus = if ($defender.AntivirusEnabled -and $defender.RealTimeProtectionEnabled) { "GOOD" } else { "ATTENTION NEEDED" }
    }
}

function Start-QuickScan {
    # Start a quick scan and wait for completion
    Start-MpScan -ScanType QuickScan
    while ((Get-MpScan).ScanState -eq "Running") {
        Start-Sleep -Seconds 30
    }
    return (Get-MpScan)
}

function Get-WindowsUpdateStatus {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software'")
    
    $criticalUpdates = $searchResult.Updates | Where-Object { $_.MsrcSeverity -eq "Critical" }
    $securityUpdates = $searchResult.Updates | Where-Object { $_.Categories | Where-Object { $_.Name -eq "Security Updates" } }
    $featureUpdates = $searchResult.Updates | Where-Object { $_.Categories | Where-Object { $_.Name -eq "Feature Packs" } }
    $driverUpdates = $searchResult.Updates | Where-Object { $_.Categories | Where-Object { $_.Name -eq "Drivers" } }
    
    $lastUpdateCheck = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Detect" -Name "LastSuccessTime" -ErrorAction SilentlyContinue).LastSuccessTime
    
    return @{
        CriticalUpdatesAvailable = $criticalUpdates.Count -gt 0
        UpdateCount = $searchResult.Updates.Count
        LastCheck = if ($lastUpdateCheck) { $lastUpdateCheck.ToString("HH:mm:ss") } else { "Unknown" }
        PendingRestart = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Detect" -Name "LastSuccessTime" -ErrorAction SilentlyContinue).LastSuccessTime
        SecurityUpdates = $securityUpdates.Count
        FeatureUpdates = $featureUpdates.Count
        DriverUpdates = $driverUpdates.Count
    }
}

function Get-SystemEvents {
    $startTime = (Get-Date).AddDays(-1)
    $criticalEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1; StartTime=$startTime} -ErrorAction SilentlyContinue
    $errorEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=$startTime} -ErrorAction SilentlyContinue
    $warningEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Level=3; StartTime=$startTime} -ErrorAction SilentlyContinue
    
    return @{
        CriticalEvents = $criticalEvents.Count
        ErrorEvents = $errorEvents.Count
        WarningEvents = $warningEvents.Count
        RecentEvents = @(
            $criticalEvents | Select-Object -First 5 | ForEach-Object {
                @{
                    Time = $_.TimeCreated
                    Level = "Critical"
                    Message = $_.Message
                }
            }
            $errorEvents | Select-Object -First 5 | ForEach-Object {
                @{
                    Time = $_.TimeCreated
                    Level = "Error"
                    Message = $_.Message
                }
            }
        )
    }
}

function Get-NetworkMetrics {
    $tailscale = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*Tailscale*"} -ErrorAction SilentlyContinue
    $ics = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*Ethernet 2*"} -ErrorAction SilentlyContinue
    
    $tailscaleMetrics = if ($tailscale) {
        $bytesReceived = (Get-Counter "\Network Interface($($tailscale.Name))\Bytes Received/sec" -ErrorAction SilentlyContinue).CounterSamples.CookedValue
        $bytesSent = (Get-Counter "\Network Interface($($tailscale.Name))\Bytes Sent/sec" -ErrorAction SilentlyContinue).CounterSamples.CookedValue
        @{
            Status = if ($tailscale.Status -eq "Up") { "ACTIVE" } else { "INACTIVE" }
            Latency = (Test-Connection -ComputerName "100.73.233.88" -Count 1 -ErrorAction SilentlyContinue).ResponseTime
            BandwidthIn = [math]::Round($bytesReceived / 1MB, 2)
            BandwidthOut = [math]::Round($bytesSent / 1MB, 2)
        }
    } else {
        @{
            Status = "INACTIVE"
            Latency = $null
            BandwidthIn = 0
            BandwidthOut = 0
        }
    }
    
    $icsMetrics = if ($ics) {
        $bytesReceived = (Get-Counter "\Network Interface($($ics.Name))\Bytes Received/sec" -ErrorAction SilentlyContinue).CounterSamples.CookedValue
        $bytesSent = (Get-Counter "\Network Interface($($ics.Name))\Bytes Sent/sec" -ErrorAction SilentlyContinue).CounterSamples.CookedValue
        @{
            Status = if ($ics.Status -eq "Up") { "ACTIVE" } else { "INACTIVE" }
            BandwidthIn = [math]::Round($bytesReceived / 1MB, 2)
            BandwidthOut = [math]::Round($bytesSent / 1MB, 2)
            ConnectedClients = (Get-NetTCPConnection -State Established -InterfaceIndex $ics.ifIndex -ErrorAction SilentlyContinue).Count
        }
    } else {
        @{
            Status = "INACTIVE"
            BandwidthIn = 0
            BandwidthOut = 0
            ConnectedClients = 0
        }
    }
    
    return @{
        Tailscale = $tailscaleMetrics
        ICS = $icsMetrics
        ActiveConnections = (Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue).Count
    }
}

function Get-ScanResults {
    $scan = Get-MpScan
    $threats = Get-MpThreatDetection
    
    return @{
        ScanTime = $scan.ScanStartTime.ToString("HH:mm:ss")
        Duration = if ($scan.ScanEndTime) { 
            [math]::Round(($scan.ScanEndTime - $scan.ScanStartTime).TotalMinutes, 2)
        } else { "In Progress" }
        ThreatsFound = $threats.Count
        ActionTaken = if ($threats.Count -gt 0) {
            ($threats | ForEach-Object { $_.ThreatName + " -> " + $_.ActionTaken }) -join "; "
        } else { "None" }
        RecentThreats = if ($threats.Count -gt 0) {
            ($threats | Select-Object -First 5 | ForEach-Object {
                "$($_.ThreatName) ($($_.DetectionTime))"
            }) -join "; "
        } else { "None" }
    }
}

function New-DailyLog {
    $date = Get-Date -Format "yyyy-MM-dd"
    $time = Get-Date -Format "HH:mm:ss"
    $metrics = Get-SystemMetrics
    $network = Get-NetworkMetrics
    $security = Get-SecurityStatus
    $updates = Get-WindowsUpdateStatus
    $events = Get-SystemEvents
    $scan = Get-ScanResults
    
    $logContent = Get-Content $DailyLogTemplate -Raw
    $logContent = $logContent -replace "\[DATE\]", $date
    $logContent = $logContent -replace "\[TIME\]", $time
    $logContent = $logContent -replace "\[DURATION\]", "$($scan.Duration) minutes"
    $logContent = $logContent -replace "\[NUMBER\]", $scan.ThreatsFound
    $logContent = $logContent -replace "\[ACTION\]", $scan.ActionTaken
    $logContent = $logContent -replace "\[YES/NO\]", $(if ($updates.CriticalUpdatesAvailable) { "YES" } else { "NO" })
    $logContent = $logContent -replace "\[UPDATE_COUNT\]", $updates.UpdateCount
    $logContent = $logContent -replace "\[LAST_CHECK\]", $updates.LastCheck
    $logContent = $logContent -replace "\[PENDING_RESTART\]", $(if ($updates.PendingRestart) { "YES" } else { "NO" })
    $logContent = $logContent -replace "\[ENABLED/DISABLED\]", $security.RealTimeProtection
    $logContent = $logContent -replace "\[GOOD/ATTENTION NEEDED\]", $security.ProtectionStatus
    $logContent = $logContent -replace "\[NONE/DETAILS\]", $scan.RecentThreats
    $logContent = $logContent -replace "\[PERCENTAGE\]", "$($metrics.CPU)%"
    $logContent = $logContent -replace "\[MEMORY_PERCENTAGE\]", "$($metrics.Memory)%"
    $logContent = $logContent -replace "\[FREE/TOTAL\]", "$($metrics.DiskFree)GB/$($metrics.DiskTotal)GB"
    $logContent = $logContent -replace "\[MS\]", "$($network.Tailscale.Latency)"
    $logContent = $logContent -replace "\[ACTIVE/INACTIVE\]", $network.ICS.Status
    $logContent = $logContent -replace "\[CONNECTIONS\]", $network.ActiveConnections
    $logContent = $logContent -replace "\[NAME\]", "Admin-8vehma"
    $logContent = $logContent -replace "\[NEXT DATE\]", (Get-Date).AddDays(1).ToString("yyyy-MM-dd")
    
    # Add system events to notes if any
    if ($events.CriticalEvents -gt 0 -or $events.ErrorEvents -gt 0) {
        $eventsNote = "`n## System Events`n"
        $eventsNote += "- Critical Events: $($events.CriticalEvents)`n"
        $eventsNote += "- Error Events: $($events.ErrorEvents)`n"
        $eventsNote += "- Warning Events: $($events.WarningEvents)`n"
        $eventsNote += "`nRecent Events:`n"
        foreach ($event in $events.RecentEvents) {
            $eventsNote += "- [$($event.Time)] $($event.Level): $($event.Message)`n"
        }
        $logContent = $logContent -replace "\[ADD ANY ADDITIONAL NOTES OR OBSERVATIONS\]", $eventsNote
    } else {
        $logContent = $logContent -replace "\[ADD ANY ADDITIONAL NOTES OR OBSERVATIONS\]", "No significant events to report."
    }
    
    $logFile = "$LogPath\daily_check_$date.md"
    $logContent | Out-File $logFile -Encoding UTF8
    return $logFile
}

function New-WeeklyLog {
    $startDate = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
    $endDate = (Get-Date).ToString("yyyy-MM-dd")
    $metrics = Get-SystemMetrics
    $network = Get-NetworkStatus
    $security = Get-SecurityStatus
    
    $logContent = Get-Content $WeeklyLogTemplate -Raw
    $logContent = $logContent -replace "\[START_DATE\]", $startDate
    $logContent = $logContent -replace "\[END_DATE\]", $endDate
    # Add more replacements for weekly metrics
    
    $logFile = "$LogPath\weekly_report_$endDate.md"
    $logContent | Out-File $logFile -Encoding UTF8
    return $logFile
}

function Get-MonthlyMetrics {
    $startDate = (Get-Date).AddMonths(-1)
    $endDate = Get-Date
    
    # Get system uptime percentage
    $uptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    $totalTime = $endDate - $uptime
    $uptimePercentage = [math]::Round(($totalTime.TotalHours / ($endDate - $startDate).TotalHours) * 100, 2)
    
    # Get scan statistics
    $scans = Get-MpScan | Where-Object { $_.ScanStartTime -ge $startDate }
    $fullScans = $scans | Where-Object { $_.ScanType -eq "FullScan" }
    $quickScans = $scans | Where-Object { $_.ScanType -eq "QuickScan" }
    
    # Get threat statistics
    $threats = Get-MpThreatDetection | Where-Object { $_.DetectionTime -ge $startDate }
    $quarantined = $threats | Where-Object { $_.ActionTaken -eq "Quarantine" }
    $removed = $threats | Where-Object { $_.ActionTaken -eq "Remove" }
    $allowed = $threats | Where-Object { $_.ActionTaken -eq "Allow" }
    
    # Get update statistics
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $installedUpdates = $updateSearcher.QueryHistory(0, 1000) | Where-Object { $_.Date -ge $startDate }
    
    $securityUpdates = $installedUpdates | Where-Object { $_.Categories | Where-Object { $_.Name -eq "Security Updates" } }
    $featureUpdates = $installedUpdates | Where-Object { $_.Categories | Where-Object { $_.Name -eq "Feature Packs" } }
    $driverUpdates = $installedUpdates | Where-Object { $_.Categories | Where-Object { $_.Name -eq "Drivers" } }
    
    # Get network statistics
    $networkEvents = Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-NetworkProfile'; StartTime=$startDate} -ErrorAction SilentlyContinue
    $disconnections = $networkEvents | Where-Object { $_.Message -like "*disconnected*" }
    $reconnections = $networkEvents | Where-Object { $_.Message -like "*connected*" }
    
    # Get performance metrics
    $cpuMetrics = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 720 | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    $memoryMetrics = Get-Counter '\Memory\% Committed Bytes In Use' -SampleInterval 1 -MaxSamples 720 | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    
    return @{
        UptimePercentage = $uptimePercentage
        FullScanCount = $fullScans.Count
        QuickScanCount = $quickScans.Count
        ThreatCount = $threats.Count
        QuarantinedCount = $quarantined.Count
        RemovedCount = $removed.Count
        AllowedCount = $allowed.Count
        UpdateCount = $installedUpdates.Count
        SecurityUpdateCount = $securityUpdates.Count
        FeatureUpdateCount = $featureUpdates.Count
        DriverUpdateCount = $driverUpdates.Count
        DisconnectCount = $disconnections.Count
        ReconnectCount = $reconnections.Count
        CPUAvg = [math]::Round(($cpuMetrics | Measure-Object -Average).Average, 2)
        CPUPeak = [math]::Round(($cpuMetrics | Measure-Object -Maximum).Maximum, 2)
        CPUIdle = [math]::Round(100 - ($cpuMetrics | Measure-Object -Average).Average, 2)
        MemoryAvg = [math]::Round(($memoryMetrics | Measure-Object -Average).Average, 2)
        MemoryPeak = [math]::Round(($memoryMetrics | Measure-Object -Maximum).Maximum, 2)
        MemoryAvailable = [math]::Round((Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory / 1GB, 2)
    }
}

function Get-MonthlyNetworkMetrics {
    $startDate = (Get-Date).AddMonths(-1)
    $endDate = Get-Date
    
    # Get Tailscale metrics
    $tailscaleEvents = Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Tailscale'; StartTime=$startDate} -ErrorAction SilentlyContinue
    $derpFallbacks = $tailscaleEvents | Where-Object { $_.Message -like "*DERP*" }
    
    # Get ICS metrics
    $icsEvents = Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-NetworkProfile'; StartTime=$startDate} -ErrorAction SilentlyContinue
    $icsUptime = $icsEvents | Where-Object { $_.Message -like "*Ethernet 2*" }
    
    # Calculate network stability
    $totalTime = ($endDate - $startDate).TotalHours
    $disconnectionTime = ($icsEvents | Where-Object { $_.Message -like "*disconnected*" }).Count * 0.1 # Assuming average 6-minute disconnection
    $stabilityRating = [math]::Round((($totalTime - $disconnectionTime) / $totalTime) * 100, 2)
    
    return @{
        StabilityRating = $stabilityRating
        DERPCount = $derpFallbacks.Count
        ICSUptime = [math]::Round(($icsUptime | Where-Object { $_.Message -like "*connected*" }).Count / ($icsUptime.Count / 2) * 100, 2)
    }
}

function New-MonthlyLog {
    $date = Get-Date
    $startDate = $date.AddMonths(-1).ToString("yyyy-MM-dd")
    $endDate = $date.ToString("yyyy-MM-dd")
    $month = $date.ToString("MMMM")
    $year = $date.ToString("yyyy")
    
    $metrics = Get-MonthlyMetrics
    $networkMetrics = Get-MonthlyNetworkMetrics
    $security = Get-SecurityStatus
    $events = Get-SystemEvents
    
    # Determine system status
    $systemStatus = if ($metrics.ThreatCount -gt 0 -or $security.ProtectionStatus -ne "GOOD") {
        "ATTENTION NEEDED"
    } elseif ($metrics.UptimePercentage -lt 95 -or $networkMetrics.StabilityRating -lt 95) {
        "ATTENTION NEEDED"
    } else {
        "GOOD"
    }
    
    $logContent = Get-Content $MonthlyLogTemplate -Raw
    $logContent = $logContent -replace "\[MONTH\]", $month
    $logContent = $logContent -replace "\[YEAR\]", $year
    $logContent = $logContent -replace "\[START_DATE\]", $startDate
    $logContent = $logContent -replace "\[END_DATE\]", $endDate
    $logContent = $logContent -replace "\[GOOD/ATTENTION NEEDED/CRITICAL\]", $systemStatus
    $logContent = $logContent -replace "\[UPTIME_PERCENTAGE\]", "$($metrics.UptimePercentage)%"
    $logContent = $logContent -replace "\[SECURITY_STATUS\]", $security.ProtectionStatus
    $logContent = $logContent -replace "\[NETWORK_STABILITY\]", "$($networkMetrics.StabilityRating)%"
    $logContent = $logContent -replace "\[RESOURCE_STATUS\]", if ($metrics.CPUAvg -gt 80 -or $metrics.MemoryAvg -gt 80) { "HIGH" } else { "NORMAL" }
    
    # Security Overview replacements
    $logContent = $logContent -replace "\[FULL_SCAN_COUNT\]", $metrics.FullScanCount
    $logContent = $logContent -replace "\[QUICK_SCAN_COUNT\]", $metrics.QuickScanCount
    $logContent = $logContent -replace "\[THREAT_COUNT\]", $metrics.ThreatCount
    $logContent = $logContent -replace "\[QUARANTINED_COUNT\]", $metrics.QuarantinedCount
    $logContent = $logContent -replace "\[REMOVED_COUNT\]", $metrics.RemovedCount
    $logContent = $logContent -replace "\[ALLOWED_COUNT\]", $metrics.AllowedCount
    
    # Network Security replacements
    $logContent = $logContent -replace "\[STABILITY_RATING\]", "$($networkMetrics.StabilityRating)%"
    $logContent = $logContent -replace "\[DISCONNECT_COUNT\]", $networkMetrics.DisconnectCount
    $logContent = $logContent -replace "\[RECONNECT_COUNT\]", $networkMetrics.ReconnectCount
    $logContent = $logContent -replace "\[DERP_COUNT\]", $networkMetrics.DERPCount
    $logContent = $logContent -replace "\[ICS_UPTIME\]", "$($networkMetrics.ICSUptime)%"
    
    # System Performance replacements
    $logContent = $logContent -replace "\[CPU_AVG\]", $metrics.CPUAvg
    $logContent = $logContent -replace "\[CPU_PEAK\]", $metrics.CPUPeak
    $logContent = $logContent -replace "\[CPU_IDLE\]", $metrics.CPUIdle
    $logContent = $logContent -replace "\[MEMORY_AVG\]", $metrics.MemoryAvg
    $logContent = $logContent -replace "\[MEMORY_PEAK\]", $metrics.MemoryPeak
    $logContent = $logContent -replace "\[MEMORY_AVAILABLE\]", $metrics.MemoryAvailable
    
    # Add more replacements for other metrics...
    
    $logFile = "$LogPath\monthly_report_$($date.ToString('yyyy-MM')).md"
    $logContent | Out-File $logFile -Encoding UTF8
    return $logFile
}

# Main execution
$currentTime = Get-Date
$isWeeklyScanDay = $currentTime.DayOfWeek -eq $WeeklyScanDay
$isMonthlyReportDay = $currentTime.Day -eq 1  # Generate monthly report on the first day of each month

# Create daily log
$dailyLog = New-DailyLog
Write-Host "Daily log created: $dailyLog"

# If it's weekly scan day, perform weekly tasks
if ($isWeeklyScanDay) {
    $weeklyLog = New-WeeklyLog
    Write-Host "Weekly log created: $weeklyLog"
    
    # Perform weekly scan
    $scan = Start-QuickScan
    Write-Host "Weekly scan completed. Status: $($scan.ScanState)"
}

# If it's monthly report day, generate monthly report
if ($isMonthlyReportDay) {
    $monthlyLog = New-MonthlyLog
    Write-Host "Monthly report created: $monthlyLog"
}

# Create scheduled tasks
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath\maintenance_automation.ps1`""
$trigger = New-ScheduledTaskTrigger -Daily -At $ScanTime
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd

# Register the daily task
$taskName = "HomeServerMaintenance"
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Updated existing scheduled task: $taskName"
} else {
    Write-Host "Creating new scheduled task: $taskName"
}
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -User "Admin-8vehma" -RunLevel Highest

Write-Host "Maintenance tasks scheduled successfully"
Write-Host "Log directory: $LogPath"
Write-Host "Script path: $ScriptPath"
Write-Host "Workspace path: $WorkspacePath" 