# Network Performance Monitoring Guide

## Overview
This document outlines the procedures and tools for monitoring network performance in our home network setup. Given the current temporary installation with flat cables, regular monitoring is essential to ensure optimal performance.

## Monitoring Schedule

### Daily Checks
1. **Basic Connectivity**
   - Ping test to router (192.168.0.1)
   - Ping test to G9 server (192.168.0.178)
   - Verify Tailscale connectivity
   - Check WiFi signal strength for wireless devices

2. **Quick Performance Tests**
   - Local network speed test between G9 server and computers
   - Latency check to key devices
   - Basic bandwidth usage check

### Weekly Tests
1. **Comprehensive Network Test**
   - Full network throughput test
   - Device-to-device latency mapping
   - WiFi signal strength and quality survey
   - Bandwidth usage patterns

2. **Device-Specific Tests**
   - G9 server performance metrics
   - Apple TV streaming quality
   - Computer network performance
   - WiFi device signal strength

### Monthly Review
1. **Performance Analysis**
   - Trend analysis of network performance
   - Identify any degradation
   - Document issues and solutions
   - Update baseline metrics

## Monitoring Tools

### Built-in Tools
1. **Windows Network Diagnostics**
   ```powershell
   # Basic network diagnostics
   ipconfig /all
   ping 192.168.0.1
   tracert 192.168.0.178
   ```

2. **Router Admin Interface**
   - Check connected devices
   - Monitor bandwidth usage
   - Review WiFi signal strength
   - Check for firmware updates

3. **Tailscale Metrics**
   - Monitor VPN performance
   - Check connection status
   - Review access logs

### Additional Tools to Implement
1. **Network Speed Testing**
   - iperf3 for local network testing
   - Speedtest-cli for internet speed
   - Custom PowerShell scripts for automated testing

2. **Latency Monitoring**
   - PRTG Network Monitor (free version)
   - Custom ping monitoring scripts
   - Device-specific latency tracking

3. **Bandwidth Usage Tracking**
   - Router's built-in bandwidth monitor
   - NetWorx for detailed usage statistics
   - Custom logging scripts

## Performance Thresholds

### Acceptable Ranges
- **Local Network**:
  - Latency: < 5ms
  - Throughput: > 800Mbps (wired)
  - Packet Loss: < 0.1%
  - Jitter: < 2ms

- **WiFi Network**:
  - Signal Strength: > -65dBm
  - Latency: < 10ms
  - Throughput: > 300Mbps
  - Packet Loss: < 0.5%

- **Tailscale VPN**:
  - Latency: < 50ms
  - Throughput: > 100Mbps
  - Packet Loss: < 0.5%

## Monitoring Procedures

### Setting Up Monitoring
1. **Initial Baseline**
   - Document current performance metrics
   - Establish baseline for all key measurements
   - Set up automated monitoring tools
   - Create performance dashboard

2. **Regular Testing**
   - Follow daily/weekly/monthly schedule
   - Document all measurements
   - Compare against baseline
   - Flag any deviations

3. **Issue Resolution**
   - Document any performance issues
   - Investigate root causes
   - Implement solutions
   - Verify improvements

## Documentation

### Performance Logs
- Daily test results
- Weekly comprehensive reports
- Monthly trend analysis
- Issue resolution records

### Baseline Metrics
- Initial network performance measurements
- Device-specific baselines
- Acceptable performance ranges
- Historical performance data

## Future Improvements
1. **Monitoring Automation**
   - Set up automated testing scripts
   - Create performance dashboards
   - Implement alerting system
   - Regular report generation

2. **Tool Integration**
   - Centralize monitoring tools
   - Create unified dashboard
   - Automate data collection
   - Implement trend analysis

3. **Documentation Updates**
   - Regular review of procedures
   - Update baseline metrics
   - Document new tools and methods
   - Maintain performance history

## Notes
- All monitoring should consider the temporary nature of the current setup
- Focus on identifying any performance degradation
- Document all measurements for future reference
- Use monitoring data to plan permanent installation

Last Modified: 2025-05-19
Version: 1.0 