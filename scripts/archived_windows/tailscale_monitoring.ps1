# Tailscale Monitoring Script
# Purpose: Monitor Tailscale connections and send alerts for important events

# Configuration
$config = @{
    AlertEmail = "msakamoto+homelab@gmail.com"
    LatencyThreshold = 100  # ms
    LogRetentionDays = 30
    MetricsInterval = 300   # 5 minutes
    LogPath = "C:\Logs\Tailscale"
    MetricsPath = "C:\Logs\Tailscale\Metrics"
}

# Create log directories if they don't exist
if (-not (Test-Path $config.LogPath)) {
    New-Item -ItemType Directory -Path $config.LogPath -Force
}
if (-not (Test-Path $config.MetricsPath)) {
    New-Item -ItemType Directory -Path $config.MetricsPath -Force
}

# Function to send email alerts
function Send-TailscaleAlert {
    param (
        [string]$Subject,
        [string]$Body,
        [string]$Priority = "Normal"
    )
    
    $smtpServer = "smtp.gmail.com"
    $smtpPort = 587
    $smtpUsername = "msakamoto+homelab@gmail.com"
    $smtpPassword = ConvertTo-SecureString (Get-Content "C:\Secure\smtp_password.txt") -AsPlainText -Force
    $smtpCredential = New-Object System.Management.Automation.PSCredential($smtpUsername, $smtpPassword)
    
    $message = @{
        From = $smtpUsername
        To = $config.AlertEmail
        Subject = "[Tailscale Alert] $Subject"
        Body = $Body
        Priority = $Priority
        SmtpServer = $smtpServer
        Port = $smtpPort
        UseSSL = $true
        Credential = $smtpCredential
    }
    
    Send-MailMessage @message
}

# Function to check Tailscale connection status
function Get-TailscaleStatus {
    $status = @{
        Connected = $false
        Latency = $null
        DERP = $false
        LastCheck = Get-Date
        Error = $null
    }
    
    try {
        $tailscale = Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*Tailscale*"}
        $status.Connected = ($tailscale.Status -eq "Up")
        
        if ($status.Connected) {
            $ping = Test-Connection -ComputerName "100.73.233.88" -Count 1 -ErrorAction Stop
            $status.Latency = $ping.ResponseTime
            
            # Check if using DERP
            $derpStatus = & "C:\Windows\System32\Tailscale\tailscale.exe" status --json | ConvertFrom-Json
            $status.DERP = $derpStatus.DERP
        }
    }
    catch {
        $status.Error = $_.Exception.Message
    }
    
    return $status
}

# Function to collect and store metrics
function Save-TailscaleMetrics {
    param (
        [hashtable]$Status
    )
    
    $metrics = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Connected = $Status.Connected
        Latency = $Status.Latency
        UsingDERP = $Status.DERP
        Error = $Status.Error
    }
    
    $metricsFile = Join-Path $config.MetricsPath "tailscale_metrics_$(Get-Date -Format 'yyyy-MM-dd').json"
    $metrics | ConvertTo-Json | Add-Content $metricsFile
}

# Function to check for and alert on important events
function Test-TailscaleEvents {
    param (
        [hashtable]$CurrentStatus,
        [hashtable]$PreviousStatus
    )
    
    # Check for disconnection
    if ($PreviousStatus.Connected -and -not $CurrentStatus.Connected) {
        Send-TailscaleAlert -Subject "Tailscale Disconnected" -Body "Tailscale connection was lost at $(Get-Date)" -Priority "High"
    }
    
    # Check for reconnection
    if (-not $PreviousStatus.Connected -and $CurrentStatus.Connected) {
        Send-TailscaleAlert -Subject "Tailscale Reconnected" -Body "Tailscale connection was restored at $(Get-Date)" -Priority "Normal"
    }
    
    # Check for high latency
    if ($CurrentStatus.Latency -and $CurrentStatus.Latency -gt $config.LatencyThreshold) {
        Send-TailscaleAlert -Subject "High Tailscale Latency" -Body "Current latency: $($CurrentStatus.Latency)ms (threshold: $($config.LatencyThreshold)ms)" -Priority "Normal"
    }
    
    # Check for DERP fallback
    if (-not $PreviousStatus.DERP -and $CurrentStatus.DERP) {
        Send-TailscaleAlert -Subject "Tailscale Using DERP" -Body "Connection fell back to DERP at $(Get-Date)" -Priority "Normal"
    }
}

# Function to clean up old logs
function Clear-OldLogs {
    $cutoffDate = (Get-Date).AddDays(-$config.LogRetentionDays)
    Get-ChildItem -Path $config.LogPath -Filter "*.log" | 
        Where-Object { $_.LastWriteTime -lt $cutoffDate } | 
        Remove-Item -Force
}

# Main monitoring loop
function Start-TailscaleMonitoring {
    $previousStatus = Get-TailscaleStatus
    
    while ($true) {
        $currentStatus = Get-TailscaleStatus
        Save-TailscaleMetrics -Status $currentStatus
        Test-TailscaleEvents -CurrentStatus $currentStatus -PreviousStatus $previousStatus
        
        # Clean up old logs daily at midnight
        if ((Get-Date).Hour -eq 0 -and (Get-Date).Minute -eq 0) {
            Clear-OldLogs
        }
        
        $previousStatus = $currentStatus
        Start-Sleep -Seconds $config.MetricsInterval
    }
}

# Start monitoring if script is run directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Start-TailscaleMonitoring
} 