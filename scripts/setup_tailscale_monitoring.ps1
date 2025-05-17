# Setup script for Tailscale monitoring scheduled task

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Create secure directory for SMTP password
$secureDir = "C:\Secure"
if (-not (Test-Path $secureDir)) {
    New-Item -ItemType Directory -Path $secureDir -Force
}

# Prompt for SMTP password if not already stored
$passwordFile = "$secureDir\smtp_password.txt"
if (-not (Test-Path $passwordFile)) {
    $password = Read-Host "Enter SMTP password for msakamoto+homelab@gmail.com" -AsSecureString
    $password | ConvertFrom-SecureString | Set-Content $passwordFile
}

# Create the scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\tailscale_monitoring.ps1`""

$trigger = New-ScheduledTaskTrigger -AtStartup

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -RestartCount 3

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "TailscaleMonitoring" `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal `
    -Description "Monitors Tailscale connection and sends alerts for important events" `
    -Force

Write-Host "Tailscale monitoring scheduled task has been created successfully."
Write-Host "The task will start automatically at system startup and restart if it fails."
Write-Host "Logs will be stored in C:\Logs\Tailscale"
Write-Host "Metrics will be stored in C:\Logs\Tailscale\Metrics" 