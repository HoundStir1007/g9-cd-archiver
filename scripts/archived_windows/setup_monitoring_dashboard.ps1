# Setup script for Tailscale monitoring dashboard
# This script sets up the Python environment and installs required packages for the web dashboard

# Ensure script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Configuration
$config = @{
    DashboardPath = "C:\Dashboard"
    PythonVersion = "3.11"
    RequirementsFile = "requirements.txt"
    VirtualEnvName = "dashboard_env"
}

# Create dashboard directory if it doesn't exist
if (-not (Test-Path $config.DashboardPath)) {
    New-Item -ItemType Directory -Path $config.DashboardPath -Force
    Write-Host "Created dashboard directory: $($config.DashboardPath)"
}

# Create virtual environment
$venvPath = Join-Path $config.DashboardPath $config.VirtualEnvName
if (-not (Test-Path $venvPath)) {
    Write-Host "Creating Python virtual environment..."
    python -m venv $venvPath
}

# Activate virtual environment and install requirements
$activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
$requirementsPath = Join-Path $PSScriptRoot "..\web\requirements.txt"

if (Test-Path $activateScript) {
    Write-Host "Installing required packages..."
    & $activateScript
    pip install -r $requirementsPath
} else {
    Write-Error "Failed to find virtual environment activation script"
    exit 1
}

# Create dashboard service
$serviceName = "TailscaleDashboard"
$serviceExists = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if (-not $serviceExists) {
    Write-Host "Creating Windows service for dashboard..."
    $pythonPath = Join-Path $venvPath "Scripts\python.exe"
    $scriptPath = Join-Path $PSScriptRoot "..\web\dashboard.py"
    
    New-Service -Name $serviceName `
                -BinaryPathName "$pythonPath $scriptPath" `
                -DisplayName "Tailscale Monitoring Dashboard" `
                -StartupType Automatic `
                -Description "Web dashboard for Tailscale monitoring system"
}

Write-Host "`nDashboard setup completed successfully!"
Write-Host "----------------------------------------"
Write-Host "Next steps:"
Write-Host "1. Start the dashboard service: Start-Service TailscaleDashboard"
Write-Host "2. Access the dashboard at http://localhost:5000"
Write-Host "3. Configure firewall to allow access if needed"
Write-Host "4. Review logs at C:\Dashboard\logs" 