# Documentation Archive 📚

This directory contains archived documentation that is no longer actively maintained but preserved for reference. This archive serves as a historical record and reference for the Home Server Project.

## Directory Structure

```
archive/
├── checklists/          # Completed checklists and verification documents
├── temporary/           # Temporary configuration files and one-time setups
├── deprecated/          # Superseded documentation and outdated guides
├── snapshots/          # Point-in-time system state documentation
└── README.md           # This file
```

## Archived Documents

### Checklists
- `g9_setup_checklist.md` - Completed G9 setup checklist (moved 2025-05-16)
  - Status: ✅ All items completed
  - Superseded by: Active documentation in network_configuration.md
  - Key achievements: Windows 11 Pro installation, Ubuntu setup, dual-boot configuration
- `remote_desktop_testing_checklist.md` - Completed RDP testing (moved 2025-05-16)
  - Status: ✅ All tests passed
  - Superseded by: Active documentation in network_configuration.md
  - Key achievements: Verified RDP access, tested security settings
- `rdp_testing_checklist.md` - Superseded by remote_desktop_testing_checklist.md
  - Status: ⚠️ Deprecated
  - Reason: Consolidated into more comprehensive testing checklist

### Temporary Files
- `ACLS.txt` - Tailscale ACL configuration (moved 2025-05-16)
  - Status: ✅ Configuration applied
  - Current state: Active in Tailscale admin console
  - Purpose: Reference for ACL policy structure
- `tailscale_acl.md` - Superseded by ACLS.txt (moved 2025-05-16)
  - Status: ⚠️ Deprecated
  - Reason: Replaced by actual ACL configuration file
- `tailscale_config.md` - Superseded by tailscale_configuration.md
  - Status: ⚠️ Deprecated
  - Reason: Merged into comprehensive configuration guide

### Deprecated
- `budget_template.md` - Template no longer in use
  - Status: ⚠️ Deprecated
  - Reason: Replaced by actual budget.md
  - Note: Preserved for future budget planning reference
- `g9_ethernet_configuration.md` - Merged into network_configuration.md
  - Status: ⚠️ Deprecated
  - Reason: Consolidated into comprehensive network documentation
  - Key information: Preserved in network_configuration.md

### Snapshots
- `system_state_20250516.md` - System state documentation (created 2025-05-16)
  - Contains: Network configuration, security settings, and system status
  - Purpose: Historical reference point for system state
  - Related to: Active documentation in network_configuration.md

## Archive Policy

1. **When to Archive**
   - Completed checklists and verification documents
   - Temporary configuration files and one-time setups
   - Superseded documentation and outdated guides
   - System state snapshots for historical reference
   - Deprecated templates and planning documents

2. **Archive Process**
   - Move file to appropriate archive subdirectory
   - Update references in active documentation
   - Add detailed entry to this README
   - Create snapshot if significant system state change
   - Update last modified date
   - Verify all links in active documentation

3. **Accessing Archived Files**
   - All archived files remain readable
   - References in active documentation point to archive location
   - Archived files are not actively maintained
   - Snapshots provide historical context
   - Use archive for reference only, not for active configuration

4. **Documentation Relationships**
   - Active documentation in root directory
   - Archived documents referenced from active docs
   - Snapshots linked to relevant active documentation
   - Cross-references maintained in both directions
   - Version history preserved in archive

## Version Control
- Each archived document retains its original version
- Major changes documented in snapshots
- Active documentation always reflects current state
- Archive serves as historical record
- No modifications to archived files without documentation

## Last Updated
2025-05-16

## Related Documentation
- [Network Configuration](../network_configuration.md)
- [Windows Security Checklist](../windows_security_checklist.md)
- [Tailscale Configuration](../tailscale_configuration.md)
- [Home Server Plan](../home_server_plan.md) 