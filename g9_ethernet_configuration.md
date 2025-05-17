# G9 Ethernet Configuration

## Network Layout

### Primary Network (Internet Connection)
- Interface: Ethernet (Intel I226-V)
- Configuration: DHCP
- IP Address: 192.168.0.178
- Subnet Mask: 255.255.255.0
- Gateway: 192.168.0.1
- DNS: 192.168.0.1

### Secondary Network (Apple TV Connection)
- Interface: Ethernet 2 (Intel I226-V #2)
- Configuration: Static (ICS Host)
- IP Address: 192.168.137.1
- Subnet Mask: 255.255.255.0
- Internet Connection Sharing: Enabled

### Apple TV Settings
- IP Address: 192.168.137.2
- Subnet Mask: 255.255.255.0
- Router: 192.168.137.1
- DNS: 192.168.0.1

## Configuration Details

### Internet Connection Sharing (ICS)
1. Primary adapter (Ethernet) shares internet connection
2. Secondary adapter (Ethernet 2) acts as gateway for Apple TV
3. Windows automatically configures:
   - NAT (Network Address Translation)
   - DHCP server disabled (using static IPs)
   - IP forwarding between interfaces

### Resilience Features
- Configuration persists through G9 restarts
- Automatic recovery after power loss
- Fast network restoration (maintains streaming connections)
- No manual intervention required after power/network interruptions

## Important Notes
1. The 192.168.137.x subnet is Windows' default for ICS
2. Both Ethernet ports operate at 1 Gbps
3. Direct connection between G9 and Apple TV provides optimal performance
4. Primary network connectivity is maintained independently

## Troubleshooting
If connection is lost:
1. Verify physical connections
2. Check Windows ICS service status
3. Confirm IP configurations
4. Restart affected devices if needed

## Power Management
- G9 automatically restarts after power loss
- Network services auto-recover
- No manual reconfiguration needed 