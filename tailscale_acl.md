# Tailscale ACL Configuration

## Device Groups

### Home Infrastructure Group
- Members:
  - nucboxg9 (Windows) - 100.122.141.83
  - gmk-g9 (Linux) - 100.91.157.19
- Purpose: Core home server infrastructure
- Access Level: High (internal services, subnet routing)

### Development Devices Group
- Members:
  - macbook-pro (macOS) - 100.73.233.88
- Purpose: Development and management
- Access Level: High (administrative access)

## ACL Rules

### Base Rules
1. Allow all devices to communicate with each other within the same group
2. Allow Development Devices to access Home Infrastructure
3. Enable subnet routing for Home Infrastructure group
4. Allow external access to specified services only

### Subnet Access
- Home Network: 192.168.0.0/24
  - Allowed by: All authenticated devices
  - Purpose: Local network access

### Service Rules
1. SSH Access (Port 22)
   - Allowed from: Development Devices
   - Target: Home Infrastructure

2. Remote Desktop (Port 3389)
   - Allowed from: Development Devices
   - Target: nucboxg9

3. HTTP/HTTPS (Ports 80, 443)
   - Allowed from: All authenticated devices
   - Target: Home Infrastructure

## Exit Node Configuration
- Primary: None (default)
- Backup: None
- Policy: No exit node functionality needed at this time

## Implementation Steps
1. Create device groups in admin console
2. Apply base ACL rules
3. Configure subnet access
4. Test connectivity between groups
5. Verify service access
6. Document final configuration

## Monitoring
- Enable connection logging
- Set up email alerts for:
  - New device connections
  - Failed access attempts
  - Configuration changes

## Review Schedule
- Monthly review of:
  - Device inventory
  - ACL rules
  - Access patterns
  - Security incidents 