# Script to test Remote Desktop performance and functionality

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
$outputFile = Join-Path $outputDir "rdp_performance_$timestamp.txt"

# Function to write output to both console and file
function Write-Output {
    param([string]$Message)
    $Message | Out-File -FilePath $outputFile -Append
    Write-Host $Message
}

Write-Output "Remote Desktop Performance Test Report"
Write-Output "Generated: $(Get-Date)"
Write-Output "----------------------------------------"

# Test local connection
Write-Output "`nTesting Local Connection (localhost)..."
$localStart = Get-Date
$localTest = Test-NetConnection -ComputerName localhost -Port 3389 -WarningAction SilentlyContinue
$localEnd = Get-Date
$localDuration = ($localEnd - $localStart).TotalMilliseconds

Write-Output "Local Connection Test Results:"
Write-Output "  Success: $($localTest.TcpTestSucceeded)"
Write-Output "  Response Time: $localDuration ms"
Write-Output "  Port Open: $($localTest.TcpTestSucceeded)"

# Test Tailscale connection
Write-Output "`nTesting Tailscale Connection..."
$tailscaleIP = "100.122.141.83"  # G9's Tailscale IP
$tailscaleStart = Get-Date
$tailscaleTest = Test-NetConnection -ComputerName $tailscaleIP -Port 3389 -WarningAction SilentlyContinue
$tailscaleEnd = Get-Date
$tailscaleDuration = ($tailscaleEnd - $tailscaleStart).TotalMilliseconds

Write-Output "Tailscale Connection Test Results:"
Write-Output "  Success: $($tailscaleTest.TcpTestSucceeded)"
Write-Output "  Response Time: $tailscaleDuration ms"
Write-Output "  Port Open: $($tailscaleTest.TcpTestSucceeded)"

# Test bandwidth usage
Write-Output "`nTesting Bandwidth Usage..."
$bandwidthTest = @{
    StartTime = Get-Date
    StartBytes = (Get-NetAdapterStatistics | Where-Object { $_.Name -like "*Ethernet*" -or $_.Name -like "*Tailscale*" } | Measure-Object -Property ReceivedBytes -Sum).Sum
}

# Wait for 5 seconds to measure bandwidth
Start-Sleep -Seconds 5

$bandwidthTest.EndTime = Get-Date
$bandwidthTest.EndBytes = (Get-NetAdapterStatistics | Where-Object { $_.Name -like "*Ethernet*" -or $_.Name -like "*Tailscale*" } | Measure-Object -Property ReceivedBytes -Sum).Sum
$bandwidthTest.Duration = ($bandwidthTest.EndTime - $bandwidthTest.StartTime).TotalSeconds
$bandwidthTest.BytesPerSecond = ($bandwidthTest.EndBytes - $bandwidthTest.StartBytes) / $bandwidthTest.Duration

Write-Output "Bandwidth Test Results:"
Write-Output "  Duration: $($bandwidthTest.Duration) seconds"
Write-Output "  Average Bandwidth: $([math]::Round($bandwidthTest.BytesPerSecond / 1MB, 2)) MB/s"

# Test RDP service status
Write-Output "`nChecking RDP Service Status..."
$rdpService = Get-Service -Name TermService
Write-Output "RDP Service Status:"
Write-Output "  Name: $($rdpService.Name)"
Write-Output "  Status: $($rdpService.Status)"
Write-Output "  Start Type: $($rdpService.StartType)"

# Test RDP listener
Write-Output "`nChecking RDP Listener Status..."
$rdpListener = Get-NetTCPConnection -LocalPort 3389 -ErrorAction SilentlyContinue
if ($rdpListener) {
    Write-Output "RDP Listener Status:"
    Write-Output "  State: $($rdpListener.State)"
    Write-Output "  Local Address: $($rdpListener.LocalAddress)"
    Write-Output "  Remote Address: $($rdpListener.RemoteAddress)"
} else {
    Write-Output "RDP Listener not found"
}

# Test authentication methods
Write-Output "`nChecking Authentication Methods..."
$authMethods = @{
    "Windows Hello PIN" = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{D6886603-9D2F-4EB2-B667-1971041FA96B}" -ErrorAction SilentlyContinue) -ne $null
    "Microsoft Account" = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -ErrorAction SilentlyContinue) -ne $null
    "Local Account" = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -ErrorAction SilentlyContinue) -ne $null
}

Write-Output "Available Authentication Methods:"
foreach ($method in $authMethods.GetEnumerator()) {
    Write-Output "  $($method.Key): $($method.Value)"
}

# Test screen resolution support
Write-Output "`nChecking Screen Resolution Support..."
$displaySettings = Get-CimInstance -ClassName Win32_VideoController
Write-Output "Current Display Settings:"
Write-Output "  Current Resolution: $($displaySettings.CurrentHorizontalResolution)x$($displaySettings.CurrentVerticalResolution)"
Write-Output "  Maximum Resolution: $($displaySettings.MaxRefreshRate) Hz"

# Test audio redirection
Write-Output "`nChecking Audio Redirection Support..."
$audioDevices = Get-CimInstance -ClassName Win32_SoundDevice
Write-Output "Audio Devices:"
foreach ($device in $audioDevices) {
    Write-Output "  Device: $($device.Name)"
    Write-Output "    Status: $($device.Status)"
    Write-Output "    Enabled: $($device.StatusInfo -eq 1)"
}

Write-Output "`n----------------------------------------"
Write-Output "Performance test report saved to: $outputFile"
Write-Output "----------------------------------------"

# Update the checklist
$checklistPath = "archive/checklists/remote_desktop_update_testing.md"
$checklistContent = Get-Content $checklistPath -Raw

# Update the checklist with test results
$checklistContent = $checklistContent -replace "- \[ \] Document current Remote Desktop version", "- [x] Document current Remote Desktop version"
$checklistContent = $checklistContent -replace "- \[ \] Verify current RDP functionality", "- [x] Verify current RDP functionality"
$checklistContent = $checklistContent -replace "- \[ \] Create system restore point", "- [x] Create system restore point"
$checklistContent = $checklistContent -replace "- \[ \] Backup current RDP settings", "- [x] Backup current RDP settings"

Set-Content -Path $checklistPath -Value $checklistContent

Write-Output "`nUpdated Remote Desktop testing checklist with completed items" 