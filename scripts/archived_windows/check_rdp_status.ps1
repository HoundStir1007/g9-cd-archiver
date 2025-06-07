# Script to check and document Remote Desktop status and settings

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Create output directory if it doesn't exist
$outputDir = "C:\Logs\RDP"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outputFile = Join-Path $outputDir "rdp_status_$timestamp.txt"

# Function to write output to both console and file
function Write-Output {
    param([string]$Message)
    $Message | Out-File -FilePath $outputFile -Append
    Write-Host $Message
}

Write-Output "Remote Desktop Status Report"
Write-Output "Generated: $(Get-Date)"
Write-Output "----------------------------------------"

# Get Windows version information
Write-Output "`nWindows Version Information:"
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
Write-Output "OS Name: $($osInfo.Caption)"
Write-Output "Version: $($osInfo.Version)"
Write-Output "Build Number: $($osInfo.BuildNumber)"
Write-Output "Architecture: $($osInfo.OSArchitecture)"

# Get RDP client version
Write-Output "`nRemote Desktop Client Information:"
$rdpClient = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Terminal Server Client" -ErrorAction SilentlyContinue
if ($rdpClient) {
    Write-Output "RDP Client Version: $($rdpClient.Version)"
} else {
    Write-Output "RDP Client Version: Not found in registry"
}

# Get RDP server settings
Write-Output "`nRemote Desktop Server Settings:"
$rdpServer = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -ErrorAction SilentlyContinue
if ($rdpServer) {
    Write-Output "RDP Server Enabled: $($rdpServer.fDenyTSConnections -eq 0)"
    Write-Output "User Authentication Required: $($rdpServer.UserAuthentication -eq 1)"
}

# Get RDP security settings
Write-Output "`nRemote Desktop Security Settings:"
$rdpSecurity = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -ErrorAction SilentlyContinue
if ($rdpSecurity) {
    Write-Output "Security Layer: $($rdpSecurity.SecurityLayer)"
    Write-Output "Encryption Level: $($rdpSecurity.MinEncryptionLevel)"
    Write-Output "User Authentication: $($rdpSecurity.UserAuthentication)"
}

# Get firewall rules for RDP
Write-Output "`nFirewall Rules for Remote Desktop:"
$firewallRules = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*Remote Desktop*" }
foreach ($rule in $firewallRules) {
    Write-Output "Rule: $($rule.DisplayName)"
    Write-Output "  Enabled: $($rule.Enabled)"
    Write-Output "  Direction: $($rule.Direction)"
    Write-Output "  Action: $($rule.Action)"
    Write-Output "  Profile: $($rule.Profile)"
}

# Get current RDP sessions
Write-Output "`nCurrent Remote Desktop Sessions:"
$sessions = Get-CimInstance -ClassName Win32_LogonSession | Where-Object { $_.LogonType -eq 10 }
if ($sessions) {
    foreach ($session in $sessions) {
        $user = Get-CimInstance -ClassName Win32_UserAccount | Where-Object { $_.SID -eq $session.ReferencedDomainName + "\" + $session.AuthenticationPackage }
        Write-Output "Session ID: $($session.LogonId)"
        Write-Output "  User: $($user.Name)"
        Write-Output "  Start Time: $($session.StartTime)"
    }
} else {
    Write-Output "No active Remote Desktop sessions"
}

# Export registry settings
Write-Output "`nExporting RDP Registry Settings..."
$regExportPath = Join-Path $outputDir "rdp_registry_$timestamp.reg"
$regPaths = @(
    "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server",
    "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp",
    "HKLM\SOFTWARE\Microsoft\Terminal Server Client"
)

foreach ($path in $regPaths) {
    $regFile = Join-Path $outputDir "rdp_registry_$($path.Replace('\', '_'))_$timestamp.reg"
    reg export $path $regFile /y | Out-Null
    Write-Output "Exported: $path to $regFile"
}

Write-Output "`n----------------------------------------"
Write-Output "Report saved to: $outputFile"
Write-Output "Registry exports saved to: $outputDir"
Write-Output "----------------------------------------"

# Create system restore point
Write-Output "`nCreating System Restore Point..."
$restorePointDesc = "Pre-RDP Update Check - $timestamp"
Checkpoint-Computer -Description $restorePointDesc -RestorePointType "APPLICATION_INSTALL"
Write-Output "System restore point created: $restorePointDesc" 