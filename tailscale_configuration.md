# Tailscale Advanced Configuration Guide 🔒

## Overview
Tailscale is already installed on the G9 (IP: 100.122.141.83) and your MacBook Pro. This guide will walk through configuring additional Tailscale features to enhance your homelab's connectivity.

## Current Status
- Tailscale installed on G9 (Windows 11)
- Tailscale installed on MacBook Pro
- Basic connectivity established between devices
- Unattended mode enabled on G9 for persistent connection

## Advanced Configuration Steps

### 1. Enable MagicDNS

MagicDNS allows you to access your Tailscale devices by name instead of IP address.

#### On Tailscale Admin Console:
1. Log in to the Tailscale admin console at https://login.tailscale.com/admin/dns
2. Navigate to the "DNS" tab
3. Under "MagicDNS," click "Enable MagicDNS"
4. Click "Save" to apply the changes

#### Testing MagicDNS:
- From your MacBook Pro, open Terminal
- Try pinging your G9 by name: `ping homelab` (assuming the G9's hostname is "homelab")
- If MagicDNS is working, you should get responses from your G9's Tailscale IP

### 2. Configure Subnet Routing

Subnet routing allows devices on your local network to access your Tailscale network without installing Tailscale on each device.

#### On the G9 (Windows 11):
1. Open Command Prompt as Administrator
2. Run the following command to advertise your local subnet:
   ```
   tailscale up --advertise-routes=192.168.1.0/24
   ```
   (Replace 192.168.1.0/24 with your actual local subnet)

#### On Tailscale Admin Console:
1. Log in to the Tailscale admin console at https://login.tailscale.com/admin/machines
2. Find your G9 in the list of devices
3. Click on the G9 to view its details
4. Under "Subnet routes," you should see the subnet you advertised
5. Click "Approve" to enable subnet routing

#### Enable IP Forwarding on G9:
1. Open PowerShell as Administrator
2. Run the following command to check if IP forwarding is enabled:
   ```
   Get-NetIPInterface | Select-Object InterfaceAlias, AddressFamily, ConnectionState, Forwarding
   ```
3. If forwarding is disabled, enable it with:
   ```
   Set-NetIPInterface -InterfaceAlias "Ethernet" -Forwarding Enabled
   Set-NetIPInterface -InterfaceAlias "Tailscale" -Forwarding Enabled
   ```

#### Testing Subnet Routing:
- From a device on your Tailscale network (e.g., your MacBook Pro), try accessing a device on your local network
- For example, if you have a printer at 192.168.1.100, try pinging it from your MacBook Pro

### 3. Configure Exit Nodes

Exit nodes allow you to route all your internet traffic through another Tailscale device, which can be useful for accessing region-restricted content or enhancing privacy.

#### On the G9 (Windows 11):
1. Open Command Prompt as Administrator
2. Run the following command to enable the G9 as an exit node:
   ```
   tailscale up --advertise-exit-node
   ```

#### On Tailscale Admin Console:
1. Log in to the Tailscale admin console
2. Navigate to the "Access Controls" tab
3. Add the following to your policy file:
   ```json
   {
     "autoApprovers": {
       "exitNode": ["your-tailscale-username@example.com"]
     }
   }
   ```
4. Click "Save" to apply the changes

#### Using the Exit Node:
1. On your MacBook Pro, click the Tailscale icon in the menu bar
2. Click "Use Exit Node"
3. Select your G9 from the list of available exit nodes
4. Your internet traffic will now be routed through the G9

### 4. Install Tailscale on Mobile Devices

#### On iOS:
1. Open the App Store
2. Search for "Tailscale"
3. Download and install the Tailscale app
4. Open the app and sign in with your Tailscale account
5. Allow the VPN configuration when prompted

#### On Android:
1. Open the Google Play Store
2. Search for "Tailscale"
3. Download and install the Tailscale app
4. Open the app and sign in with your Tailscale account
5. Allow the VPN configuration when prompted

### 5. Configure Tailscale ACLs (Access Control Lists)

ACLs allow you to control which devices can communicate with each other on your Tailscale network.

#### On Tailscale Admin Console:
1. Log in to the Tailscale admin console
2. Navigate to the "Access Controls" tab
3. Modify the ACL policy to restrict access as needed. For example:
   ```json
   {
     "acls": [
       {
         "action": "accept",
         "users": ["*"],
         "ports": ["*:*"]
       }
     ]
   }
   ```
4. For more granular control:
   ```json
   {
     "acls": [
       {
         "action": "accept",
         "users": ["your-tailscale-username@example.com"],
         "ports": ["homelab:22", "homelab:80", "homelab:443"]
       }
     ]
   }
   ```
5. Click "Save" to apply the changes

## Troubleshooting

### Common Issues:

1. **MagicDNS not working:**
   - Ensure MagicDNS is enabled in the admin console
   - Try flushing your DNS cache:
     - On macOS: `sudo killall -HUP mDNSResponder`
     - On Windows: `ipconfig /flushdns`

2. **Subnet routing not working:**
   - Verify IP forwarding is enabled on the G9
   - Check firewall settings on the G9
   - Ensure the subnet route is approved in the admin console

3. **Exit node connection issues:**
   - Verify the exit node is online
   - Check if the exit node is approved in the admin console
   - Try disconnecting and reconnecting to Tailscale

## Next Steps

After configuring these Tailscale features:
1. Test accessing G9 services remotely using Tailscale
2. Set up additional services on the G9 (Paperless-ngx, Pi-hole, etc.)
3. Consider setting up Tailscale SSH for secure remote access to the G9
4. Document all configurations in your homelab wiki/documentation 