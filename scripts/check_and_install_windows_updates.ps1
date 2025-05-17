# Script to check for and install Windows Updates (including RDP updates)
# Logs results and updates the checklist

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Import Windows Update module if available
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
}
Import-Module PSWindowsUpdate

# Create output directory if it doesn't exist
$outputDir = "C:\Logs\RDP"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = Join-Path $outputDir "windows_update_$timestamp.txt"

function Write-Log {
    param([string]$Message)
    $Message | Out-File -FilePath $logFile -Append
    Write-Host $Message
}

Write-Log "Windows Update Check and Install Report"
Write-Log "Generated: $(Get-Date)"
Write-Log "----------------------------------------"

# Check for available updates
Write-Log "Checking for available updates..."
$updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot

if ($updates) {
    Write-Log "Updates found:"
    foreach ($update in $updates) {
        Write-Log "  - $($update.Title) ($($update.KB))"
    }
    Write-Log "----------------------------------------"
    $proceed = Read-Host "Proceed with installing these updates? (Y/N)"
    if ($proceed -match '^[Yy]$') {
        Write-Log "Installing updates..."
        Install-WindowsUpdate -AcceptAll -IgnoreReboot -AutoReboot | Out-File -FilePath $logFile -Append
        Write-Log "Updates installed."
    } else {
        Write-Log "Update installation cancelled by user."
    }
} else {
    Write-Log "No updates available."
}

Write-Log "----------------------------------------"
Write-Log "Update check and install process complete."
Write-Log "Log saved to: $logFile"

# Update the checklist
$checklistPath = "archive/checklists/remote_desktop_update_testing.md"
$checklistContent = Get-Content $checklistPath -Raw
$checklistContent = $checklistContent -replace "- \[ \] Check for available updates", "- [x] Check for available updates"
$checklistContent = $checklistContent -replace "- \[ \] Install Windows Updates", "- [x] Install Windows Updates"
Set-Content -Path $checklistPath -Value $checklistContent

Write-Log "Checklist updated with completed update steps." 