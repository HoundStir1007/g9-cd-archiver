# Ubuntu Internet Connection Sharing (ICS) Setup Checklist

This checklist covers the steps to share your Ubuntu machine's internet connection from Ethernet Port 1 (main network) to Ethernet Port 2 (Apple TV), using the same static IPs as your previous Windows ICS setup.

---

## 1. Assign Static IP to Ethernet 2
- [ ] Identify the device name for Ethernet 2 (e.g., `ip addr` → `enp3s0`, `eth1`, etc.)
- [ ] Edit your Netplan config (usually in `/etc/netplan/*.yaml`) or use NetworkManager GUI
- [ ] Set static IP for Ethernet 2 (example):
  ```yaml
  network:
    version: 2
    ethernets:
      eth1:  # Replace with your actual device name
        addresses: [192.168.137.1/24]
        dhcp4: no
  ```
- [ ] Apply Netplan changes:
  ```sh
  sudo netplan apply
  ```

## 2. Enable IP Forwarding
- [ ] Enable temporarily:
  ```sh
  echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
  ```
- [ ] Make permanent (edit `/etc/sysctl.conf`):
  - Add or uncomment:
    ```
    net.ipv4.ip_forward=1
    ```

## 3. Set Up NAT (Masquerading)
- [ ] Identify your internet-facing interface (Ethernet 1, e.g., `eth0`)
- [ ] Run:
  ```sh
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  ```
  (Replace `eth0` with your actual interface name)
- [ ] (Optional) Save iptables rules to persist after reboot (see Ubuntu docs or ask for help)

---

## References
- Apple TV static IP: `192.168.137.2`
- Ubuntu Ethernet 2 static IP: `192.168.137.1`
- Netmask: `255.255.255.0`
- Gateway for Apple TV: `192.168.137.1`
- DNS: `8.8.8.8` or your preferred DNS

---

*Checklist created for quick ICS setup and troubleshooting. For more details or automation, ask your LLM assistant! 🚀*