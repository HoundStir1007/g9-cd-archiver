# Setup script for Tailscale monitoring scheduled task

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

Write-Host "Setting up Tailscale monitoring system..."
Write-Host "----------------------------------------"

# Create secure directory for SMTP password
$secureDir = "C:\Secure"
if (-not (Test-Path $secureDir)) {
    Write-Host "Creating secure directory for SMTP password..."
    New-Item -ItemType Directory -Path $secureDir -Force
}

# Create log and metrics directories
$logPath = "C:\Logs\Tailscale"
$metricsPath = "C:\Logs\Tailscale\Metrics"

Write-Host "Creating log and metrics directories..."
if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath -Force
    Write-Host "Created log directory: $logPath"
} else {
    Write-Host "Log directory already exists: $logPath"
}

if (-not (Test-Path $metricsPath)) {
    New-Item -ItemType Directory -Path $metricsPath -Force
    Write-Host "Created metrics directory: $metricsPath"
} else {
    Write-Host "Metrics directory already exists: $metricsPath"
}

# Prompt for SMTP password if not already stored
$passwordFile = "$secureDir\smtp_password.txt"
if (-not (Test-Path $passwordFile)) {
    Write-Host "`nPlease enter SMTP password for msakamoto+homelab@gmail.com"
    $password = Read-Host "Enter password" -AsSecureString
    $password | ConvertFrom-SecureString | Set-Content $passwordFile
    Write-Host "SMTP password stored securely"
}

# Create the scheduled task
Write-Host "`nCreating scheduled task..."
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\tailscale_monitoring.ps1`""

# Create both startup and interval triggers
$startupTrigger = New-ScheduledTaskTrigger -AtStartup
$intervalTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration ([TimeSpan]::FromDays(3650))  # 10 years

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -RestartCount 3

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

try {
    Register-ScheduledTask -TaskName "TailscaleMonitoring" `
        -Action $action `
        -Trigger @($startupTrigger, $intervalTrigger) `
        -Settings $settings `
        -Principal $principal `
        -Description "Monitors Tailscale connection and sends alerts for important events. Runs at startup and every 5 minutes." `
        -Force

    Write-Host "`nSetup completed successfully!"
    Write-Host "----------------------------------------"
    Write-Host "Tailscale monitoring scheduled task has been created"
    Write-Host "The task will start automatically at system startup and restart if it fails"
    Write-Host "The task will run every 5 minutes"
    Write-Host "Logs will be stored in: $logPath"
    Write-Host "Metrics will be stored in: $metricsPath"
    Write-Host "----------------------------------------"
} catch {
    Write-Error "Failed to create scheduled task: $_"
    exit 1
} 