# G9 Ethernet Port Configuration Guide 🌐

## Overview
The GMKtec NucBox G9 has dual 2.5GbE network ports that can be used for daisy-chaining devices. This guide will walk through configuring Internet Connection Sharing (ICS) to allow devices connected to the second ethernet port to access the internet through the G9.

## Current Status
- G9 is accessible via Tailscale (IP: 100.122.141.83)
- First ethernet port (Ethernet) is connected to the network and working
- Second ethernet port (Ethernet 2) is showing an APIPA address (169.254.x.x), indicating no proper network configuration

## Configuration Steps

### Method 1: Internet Connection Sharing (ICS)

1. **Access Network Connections**
   - Press `Win + R` to open Run dialog
   - Type `ncpa.cpl` and press Enter
   - This opens the Network Connections control panel

2. **Configure Internet Connection Sharing**
   - Right-click on the first ethernet adapter (labeled "Ethernet" - the one connected to your router)
   - Select "Properties"
   - Click on the "Sharing" tab
   - Check the box for "Allow other network users to connect through this computer's Internet connection"
   - In the dropdown menu, select "Ethernet 2" (the second ethernet port)
   - Click "OK" to apply the settings

3. **Verify Configuration**
   - The second ethernet port (Ethernet 2) should now have an IP address of 192.168.137.1
   - This is now acting as a DHCP server for devices connected to this port

4. **Connect Device to Second Port**
   - Connect your device (e.g., AppleTV, computer) to the second ethernet port
   - The device should automatically receive an IP address in the 192.168.137.x range
   - Test internet connectivity on the connected device

### Method 2: Network Bridge (Alternative)

If ICS doesn't work as expected, try creating a network bridge:

1. **Access Network Connections**
   - Press `Win + R` to open Run dialog
   - Type `ncpa.cpl` and press Enter

2. **Create Network Bridge**
   - Hold Ctrl and select both ethernet adapters (Ethernet and Ethernet 2)
   - Right-click on either selected adapter
   - Choose "Bridge Connections"
   - Windows will create a new "Network Bridge" adapter

3. **Verify Bridge Configuration**
   - The Network Bridge should automatically obtain an IP address from your router
   - Both ethernet ports now function as a single network interface

### Manual IP Configuration (If Needed)

For devices connected to the second ethernet port that need manual configuration:

- IP Address: 192.168.137.x (where x is a unique number between 2-254)
- Subnet Mask: 255.255.255.0
- Default Gateway: 192.168.137.1
- DNS Servers: 8.8.8.8 and 8.8.4.4

## Troubleshooting

1. **Check Windows Firewall**
   - If connectivity issues persist, check Windows Firewall settings
   - Ensure that the "Private" network profile is enabled for both ethernet adapters
   - Consider temporarily disabling the firewall to test if it's causing the issue

2. **Restart Network Services**
   - Open Command Prompt as Administrator
   - Run the following commands:
     ```
     net stop sharedaccess
     net start sharedaccess
     ```

3. **Verify Network Adapters**
   - Open Device Manager
   - Expand "Network adapters"
   - Ensure both ethernet adapters are functioning properly (no warning icons)
   - Update drivers if necessary

## Notes
- Devices connected through the G9 will lose connectivity if the G9 is powered off
- The G9 must remain powered on for the daisy-chained device to maintain internet connectivity
- This configuration effectively turns the G9 into a simple network switch for connected devices

## Next Steps After Configuration
- Test connectivity with multiple devices
- Configure additional Tailscale settings (MagicDNS, subnet routing)
- Install Tailscale on other devices to connect to the G9 network 