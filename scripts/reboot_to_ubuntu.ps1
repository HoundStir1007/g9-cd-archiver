# Script to reboot into Ubuntu
# Must be run as Administrator

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Set GRUB to show boot menu and select Ubuntu
Write-Host "Configuring GRUB to boot into Ubuntu..."
bcdedit /set {bootmgr} displaybootmenu yes
bcdedit /timeout 5
bcdedit /set {bootmgr} path \EFI\ubuntu\grubx64.efi

# Schedule a reboot in 30 seconds
Write-Host "System will reboot in 30 seconds to boot into Ubuntu..."
shutdown /r /t 30 /c "Rebooting to Ubuntu"

Write-Host "After reboot, Ubuntu will be selected automatically."
Write-Host "You can connect to Ubuntu using Microsoft Remote Desktop at: 100.91.157.19" 