# Test SMTP Configuration
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$smtpUsername = "msakamoto+homelab@gmail.com"
$smtpPassword = ConvertTo-SecureString ((Get-Content "C:\Secure\smtp_password.txt") -replace '\s+', '') -AsPlainText -Force
$smtpCredential = New-Object System.Management.Automation.PSCredential($smtpUsername, $smtpPassword)

$message = @{
    From = $smtpUsername
    To = $smtpUsername
    Subject = "Tailscale Monitoring Test"
    Body = "This is a test email from the Tailscale monitoring system. If you receive this, the SMTP configuration is working correctly."
    SmtpServer = $smtpServer
    Port = $smtpPort
    UseSSL = $true
    Credential = $smtpCredential
}

try {
    Send-MailMessage @message
    Write-Host "Test email sent successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error sending test email: $($_.Exception.Message)" -ForegroundColor Red
} 