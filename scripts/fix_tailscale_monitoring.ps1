# Tailscale Monitoring System Diagnostic and Fix Script
# Run this script as Administrator on the Windows G9 system

param(
    [switch]$DiagnoseOnly,
    [switch]$Force
)

Write-Host "🔧 Tailscale Monitoring System Fix Script" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ ERROR: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Running as Administrator - Good!" -ForegroundColor Green

# Configuration
$config = @{
    ScriptDir = "C:\Scripts\Tailscale"
    LogPath = "C:\Logs\Tailscale"
    MetricsPath = "C:\Logs\Tailscale\Metrics"
    SecureDir = "C:\Secure"
    TaskName = "TailscaleMonitoring"
    AlertEmail = "msakamoto+homelab@gmail.com"
}

# Function to test Gmail SMTP connectivity
function Test-SMTPConnection {
    Write-Host "`n🧪 Testing Gmail SMTP connection..." -ForegroundColor Yellow
    
    $passwordFile = "$($config.SecureDir)\smtp_password.txt"
    if (-not (Test-Path $passwordFile)) {
        Write-Host "❌ SMTP password file not found at: $passwordFile" -ForegroundColor Red
        Write-Host "💡 You need to create a Gmail App Password:" -ForegroundColor Yellow
        Write-Host "   1. Go to Google Account Settings > Security" -ForegroundColor Gray
        Write-Host "   2. Enable 2-Factor Authentication" -ForegroundColor Gray
        Write-Host "   3. Generate App Password for 'Mail'" -ForegroundColor Gray
        Write-Host "   4. Save password to: $passwordFile (plain text)" -ForegroundColor Gray
        return $false
    }
    
    try {
        $smtpPassword = ConvertTo-SecureString (Get-Content $passwordFile) -AsPlainText -Force
        $smtpCredential = New-Object System.Management.Automation.PSCredential($config.AlertEmail, $smtpPassword)
        
        # Test SMTP connection
        $testMessage = @{
            From = $config.AlertEmail
            To = $config.AlertEmail
            Subject = "[TEST] Tailscale Monitoring System Test"
            Body = "This is a test email sent at $(Get-Date). If you receive this, SMTP is working correctly!"
            SmtpServer = "smtp.gmail.com"
            Port = 587
            UseSSL = $true
            Credential = $smtpCredential
        }
        
        Send-MailMessage @testMessage
        Write-Host "✅ SMTP test email sent successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ SMTP test failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to test Tailscale connectivity
function Test-TailscaleConnectivity {
    Write-Host "`n🧪 Testing Tailscale connectivity..." -ForegroundColor Yellow
    
    # Check if Tailscale adapter exists
    $tailscaleAdapter = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*Tailscale*"} -ErrorAction SilentlyContinue
    if (-not $tailscaleAdapter) {
        Write-Host "❌ Tailscale network adapter not found" -ForegroundColor Red
        return $false
    }
    
    Write-Host "✅ Tailscale adapter found: $($tailscaleAdapter.Name)" -ForegroundColor Green
    Write-Host "   Status: $($tailscaleAdapter.Status)" -ForegroundColor Gray
    
    # Test connection to known Tailscale IPs
    $testIPs = @("100.91.157.19", "100.122.141.83")  # Ubuntu and Windows IPs from baton
    
    foreach ($ip in $testIPs) {
        try {
            $ping = Test-Connection -ComputerName $ip -Count 1 -ErrorAction Stop
            Write-Host "✅ Ping to $ip successful: $($ping.ResponseTime)ms" -ForegroundColor Green
        }
        catch {
            Write-Host "⚠️ Ping to $ip failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Check Tailscale status
    $tailscalePath = @(
        "C:\Windows\System32\tailscale.exe",
        "C:\Program Files\Tailscale\tailscale.exe",
        "C:\Program Files (x86)\Tailscale\tailscale.exe"
    )
    
    $validPath = $null
    foreach ($path in $tailscalePath) {
        if (Test-Path $path) {
            $validPath = $path
            break
        }
    }
    
    if ($validPath) {
        Write-Host "✅ Tailscale executable found: $validPath" -ForegroundColor Green
        try {
            $status = & $validPath status --json | ConvertFrom-Json
            Write-Host "✅ Tailscale status retrieved successfully" -ForegroundColor Green
            return $validPath
        }
        catch {
            Write-Host "⚠️ Could not get Tailscale status: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Tailscale executable not found in standard locations" -ForegroundColor Red
    }
    
    return $validPath
}

# Function to check current scheduled task
function Test-ScheduledTask {
    Write-Host "`n🧪 Checking scheduled task status..." -ForegroundColor Yellow
    
    $task = Get-ScheduledTask -TaskName $config.TaskName -ErrorAction SilentlyContinue
    if ($task) {
        Write-Host "✅ Task exists: $($config.TaskName)" -ForegroundColor Green
        Write-Host "   State: $($task.State)" -ForegroundColor Gray
        
        $taskInfo = Get-ScheduledTaskInfo -TaskName $config.TaskName -ErrorAction SilentlyContinue
        if ($taskInfo) {
            Write-Host "   Last Run: $($taskInfo.LastRunTime)" -ForegroundColor Gray
            Write-Host "   Last Result: $($taskInfo.LastTaskResult)" -ForegroundColor Gray
            Write-Host "   Next Run: $($taskInfo.NextRunTime)" -ForegroundColor Gray
        }
        
        # Check if task is enabled and ready
        if ($task.State -eq "Ready") {
            Write-Host "✅ Task is ready to run" -ForegroundColor Green
            return $true
        } else {
            Write-Host "⚠️ Task state is not 'Ready': $($task.State)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "❌ Scheduled task not found: $($config.TaskName)" -ForegroundColor Red
        return $false
    }
}

# Function to check log activity
function Test-LogActivity {
    Write-Host "`n🧪 Checking log and metrics activity..." -ForegroundColor Yellow
    
    $logActive = $false
    $metricsActive = $false
    
    # Check log directory
    if (Test-Path $config.LogPath) {
        $logFiles = Get-ChildItem -Path $config.LogPath -File | Sort-Object LastWriteTime -Descending
        if ($logFiles) {
            $recentLogs = $logFiles | Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-2) }
            if ($recentLogs) {
                Write-Host "✅ Recent log activity found ($($recentLogs.Count) files in last 2 hours)" -ForegroundColor Green
                $logActive = $true
            } else {
                Write-Host "⚠️ No recent log activity (last log: $($logFiles[0].LastWriteTime))" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ No log files found" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Log directory not found: $($config.LogPath)" -ForegroundColor Red
    }
    
    # Check metrics directory
    if (Test-Path $config.MetricsPath) {
        $metricFiles = Get-ChildItem -Path $config.MetricsPath -File | Sort-Object LastWriteTime -Descending
        if ($metricFiles) {
            $recentMetrics = $metricFiles | Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-2) }
            if ($recentMetrics) {
                Write-Host "✅ Recent metrics activity found ($($recentMetrics.Count) files in last 2 hours)" -ForegroundColor Green
                $metricsActive = $true
            } else {
                Write-Host "⚠️ No recent metrics activity (last metric: $($metricFiles[0].LastWriteTime))" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ No metric files found" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Metrics directory not found: $($config.MetricsPath)" -ForegroundColor Red
    }
    
    return ($logActive -and $metricsActive)
}

# Main diagnostic function
function Start-Diagnosis {
    Write-Host "`n🔍 Starting comprehensive diagnosis..." -ForegroundColor Cyan
    
    $results = @{
        SMTPWorking = Test-SMTPConnection
        TailscaleWorking = Test-TailscaleConnectivity
        TaskWorking = Test-ScheduledTask
        LogsActive = Test-LogActivity
    }
    
    Write-Host "`n📊 Diagnosis Results:" -ForegroundColor Cyan
    Write-Host "=====================" -ForegroundColor Cyan
    
    foreach ($test in $results.Keys) {
        $status = if ($results[$test]) { "✅ PASS" } else { "❌ FAIL" }
        $color = if ($results[$test]) { "Green" } else { "Red" }
        Write-Host "$status $test" -ForegroundColor $color
    }
    
    $passCount = ($results.Values | Where-Object { $_ -eq $true }).Count
    $totalCount = $results.Count
    
    Write-Host "`n📈 Overall Status: $passCount/$totalCount tests passed" -ForegroundColor Cyan
    
    if ($passCount -eq $totalCount) {
        Write-Host "🎉 All systems operational! Monitoring should be working." -ForegroundColor Green
    } else {
        Write-Host "⚠️ Issues detected. Run with -Force to attempt automatic fixes." -ForegroundColor Yellow
    }
    
    return $results
}

# Fix function
function Start-Fixes {
    param([hashtable]$DiagnosisResults)
    
    Write-Host "`n🔧 Starting automatic fixes..." -ForegroundColor Cyan
    
    # Create required directories
    @($config.ScriptDir, $config.LogPath, $config.MetricsPath, $config.SecureDir) | ForEach-Object {
        if (-not (Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ -Force | Out-Null
            Write-Host "✅ Created directory: $_" -ForegroundColor Green
        }
    }
    
    # Copy monitoring scripts to active location
    $sourceDir = Join-Path $PSScriptRoot "archived_windows"
    if (Test-Path $sourceDir) {
        Write-Host "📁 Copying monitoring scripts to active location..." -ForegroundColor Yellow
        
        $scriptFiles = @("tailscale_monitoring.ps1", "setup_tailscale_monitoring.ps1", "check_monitoring_status.ps1")
        foreach ($file in $scriptFiles) {
            $source = Join-Path $sourceDir $file
            $dest = Join-Path $config.ScriptDir $file
            if (Test-Path $source) {
                Copy-Item $source $dest -Force
                Write-Host "✅ Copied: $file" -ForegroundColor Green
            }
        }
    }
    
    # Update monitoring script with correct paths and IPs
    $monitoringScript = Join-Path $config.ScriptDir "tailscale_monitoring.ps1"
    if (Test-Path $monitoringScript) {
        Write-Host "🔧 Updating monitoring script configuration..." -ForegroundColor Yellow
        # This would involve updating the script with current Tailscale path and IPs
        # For now, we'll note what needs to be updated
        Write-Host "⚠️ Manual update needed: Update IP addresses in monitoring script" -ForegroundColor Yellow
    }
    
    Write-Host "`n✅ Fixes completed!" -ForegroundColor Green
}

# Main execution
Write-Host "`n🚀 Starting Tailscale monitoring system check..." -ForegroundColor Cyan

$diagnosisResults = Start-Diagnosis

if (-not $DiagnoseOnly -and $Force) {
    Start-Fixes -DiagnosisResults $diagnosisResults
}

Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "==============" -ForegroundColor Cyan

if (-not $diagnosisResults.SMTPWorking) {
    Write-Host "1. Set up Gmail App Password:" -ForegroundColor Yellow
    Write-Host "   - Go to Google Account > Security > App passwords" -ForegroundColor Gray
    Write-Host "   - Generate password for 'Mail'" -ForegroundColor Gray
    Write-Host "   - Save to: $($config.SecureDir)\smtp_password.txt" -ForegroundColor Gray
}

if (-not $diagnosisResults.TaskWorking) {
    Write-Host "2. Recreate scheduled task:" -ForegroundColor Yellow
    Write-Host "   - Run setup_tailscale_monitoring.ps1 as Administrator" -ForegroundColor Gray
}

if (-not $diagnosisResults.LogsActive) {
    Write-Host "3. Manual test:" -ForegroundColor Yellow
    Write-Host "   - Run monitoring script manually to test" -ForegroundColor Gray
    Write-Host "   - Check Windows Event Viewer for errors" -ForegroundColor Gray
}

Write-Host "`n🎯 Run this script with -Force to attempt automatic fixes" -ForegroundColor Cyan
Write-Host "🎯 Run with -DiagnoseOnly to skip fixes and only check status" -ForegroundColor Cyan

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "🔧 Tailscale Monitoring Fix Complete!" -ForegroundColor Cyan 