# 🛡️ Pi-hole Setup Guide - Personal Testing Phase

**Target System:** GMKtec NucBox G9 (Ubuntu 25.04)  
**Strategy:** Personal device testing first, family rollout later  
**Estimated Setup Time:** 20-30 minutes  
**Access:** http://100.91.157.19/admin (Tailscale) or http://192.168.0.178/admin (local)

---

## 🎯 **Why Personal Testing First?**

**Smart Implementation Strategy:**
- ✅ **Learn the system** without family pressure
- ✅ **Build whitelist** based on your real usage patterns  
- ✅ **Understand what breaks** before affecting others
- ✅ **Demonstrate benefits** when ready for family rollout
- ✅ **Zero family impact** during testing phase

---

## 🚀 **Quick Installation (15 minutes)**

### **Step 1: SSH to Ubuntu System**
```bash
# From your MacBook
ssh gmk@100.91.157.19
```

### **Step 2: Install Pi-hole**
```bash
# Download and run the automated installer
curl -sSL https://install.pi-hole.net | bash
```

**Installation Prompts - Recommended Answers:**
- **Upstream DNS Provider:** Cloudflare (1.1.1.1) or Google (8.8.8.8)
- **Blocklists:** Keep default selections (good starting point)
- **Admin Web Interface:** Yes
- **Web Server:** Yes (lighttpd)
- **Query Logging:** Yes
- **Privacy Mode:** Show everything (for testing)

### **Step 3: Note Your Admin Password**
```bash
# The installer will show your admin password at the end
# Save this password - you'll need it for the web interface

# If you miss it, reset with:
pihole -a -p
```

### **Step 4: Configure Firewall**
```bash
# Allow Pi-hole web interface
sudo ufw allow 80/tcp
sudo ufw allow 53/tcp
sudo ufw allow 53/udp

# Check firewall status
sudo ufw status
```

---

## 📱 **Configure Your Devices (Personal Testing)**

### **Your MacBook DNS Setup**
```bash
# System Preferences → Network → Advanced → DNS
# Add these DNS servers (in order):
# Primary: 100.91.157.19 (your Pi-hole)
# Secondary: 1.1.1.1 (Cloudflare backup)
```

**Or via command line:**
```bash
# Get your network service name
networksetup -listallnetworkservices

# Set DNS for Wi-Fi (adjust service name if different)
sudo networksetup -setdnsservers "Wi-Fi" 100.91.157.19 1.1.1.1

# Verify settings
networksetup -getdnsservers "Wi-Fi"
```

### **Your iPhone DNS Setup**
```
Settings → Wi-Fi → [Your Network] → Configure DNS → Manual
Remove existing DNS servers
Add: 100.91.157.19
Add: 1.1.1.1 (backup)
Save
```

### **Test DNS Resolution**
```bash
# From your MacBook, test Pi-hole is working
nslookup doubleclick.net 100.91.157.19
# Should return 0.0.0.0 (blocked)

nslookup google.com 100.91.157.19  
# Should return normal IP (allowed)
```

---

## 🎛️ **Pi-hole Web Interface Setup**

### **Access the Admin Panel**
- **Tailscale:** http://100.91.157.19/admin
- **Local Network:** http://192.168.0.178/admin
- **Login:** Use the password from installation

### **Initial Configuration**
1. **Settings → DNS:**
   - Upstream DNS: Cloudflare (1.1.1.1, 1.0.0.1)
   - Enable DNSSEC if desired
   - Rate limiting: 1000/60s (default is fine)

2. **Settings → Blocklists:**
   - Start with default lists (good balance)
   - Can add more aggressive lists later

3. **Settings → Privacy:**
   - Show everything (for testing phase)
   - Can increase privacy later

### **Key Features to Explore**
- **Query Log:** See what's being blocked in real-time
- **Top Blocked Domains:** Understand what ads you're avoiding
- **Network Overview:** See all devices using Pi-hole
- **Whitelist/Blacklist:** Add exceptions as needed

---

## 🧪 **Testing Your Setup**

### **Verify Ad Blocking is Working**
```bash
# Test known ad domains (should be blocked)
nslookup doubleclick.net 100.91.157.19
nslookup googleadservices.com 100.91.157.19
nslookup facebook.com 100.91.157.19  # Should work (not blocked)

# Test from browser - visit ad-heavy sites
# You should see fewer ads and faster loading
```

### **Common Test Sites**
- **News sites:** CNN, BBC (should load faster, fewer ads)
- **YouTube:** May still show some ads (harder to block)
- **Shopping sites:** Should work normally
- **Social media:** Should work but with less tracking

### **Monitor Pi-hole Logs**
```bash
# Watch live query log
pihole -t

# Check Pi-hole status
pihole status

# View recent queries
pihole -q
```

---

## 🔧 **Troubleshooting Common Issues**

### **Site Not Loading Properly**
1. **Check Pi-hole Query Log:** See what's being blocked
2. **Temporary Whitelist:** Add domain to whitelist
3. **Disable Pi-hole:** `pihole disable 5m` (5 minutes)
4. **Test without Pi-hole:** Change DNS to 1.1.1.1 temporarily

### **Whitelist a Domain**
```bash
# Via command line
pihole -w example.com

# Via web interface
# Admin Panel → Whitelist → Add domain
```

### **Common Domains to Whitelist**
- **Shopping:** `*.amazon.com`, `*.paypal.com`
- **Social Media:** `*.facebook.com` (for sharing buttons)
- **News Sites:** Site-specific tracking domains
- **Streaming:** Service-specific domains if issues

---

## 📊 **Personal Testing Checklist**

### **Week 1: Basic Testing**
- [ ] Browse your normal websites
- [ ] Check email, social media, news sites
- [ ] Test online shopping and payments
- [ ] Note any broken functionality
- [ ] Build initial whitelist

### **Week 2: Advanced Testing**
- [ ] Test mobile apps on iPhone
- [ ] Try streaming services
- [ ] Test work-related sites/apps
- [ ] Monitor query logs for patterns
- [ ] Fine-tune blocklists

### **Document Your Experience**
- **Sites that broke:** Keep a list for family discussion
- **Performance improvements:** Note faster loading
- **Ad reduction:** Screenshot before/after if helpful
- **Whitelist needed:** Document essential exceptions

---

## 🏠 **Family Rollout Preparation**

### **When Ready for Family (Week 3+)**

**Option 1: Individual Device Setup**
- Configure DNS on each family member's devices
- They can opt out by changing back to automatic DNS

**Option 2: Router-Level (Network-Wide)**
```bash
# Change router's DNS settings to:
# Primary DNS: 100.91.157.19 (your Pi-hole)
# Secondary DNS: 1.1.1.1 (backup)
# This affects ALL devices on the network
```

### **Family Discussion Points**
- **Benefits:** "I've been testing ad-blocking for 2 weeks..."
- **Issues found:** "Here are the 3 sites that needed whitelisting..."
- **Easy fixes:** "I can whitelist anything in 30 seconds..."
- **Opt-out available:** "You can always change your device DNS..."

---

## 🎯 **Expected Results**

### **Immediate Benefits**
- **Faster browsing:** Pages load quicker without ads
- **Less data usage:** Especially noticeable on mobile
- **Cleaner experience:** Fewer pop-ups and banners
- **Better privacy:** Reduced tracking across sites

### **Potential Issues**
- **Social sharing buttons:** May not work on some sites
- **Some mobile games:** Ad-supported features might break
- **News sites:** Some have aggressive ad-block detection
- **E-commerce:** Recommendation engines might have issues

### **Pi-hole Statistics to Expect**
- **Queries blocked:** 15-25% of total DNS queries
- **Top blocked domains:** Google/Facebook tracking, ad networks
- **Performance:** Minimal impact on internet speed
- **Uptime:** Should be 99.9%+ (very reliable)

---

## 🔄 **Maintenance & Updates**

### **Weekly Tasks**
```bash
# Update Pi-hole and blocklists
pihole -up

# Check for system updates
sudo apt update && sudo apt upgrade
```

### **Monthly Tasks**
- Review query logs for new patterns
- Update blocklists if needed
- Check whitelist for unused entries
- Monitor system performance

---

## 🚀 **Ready to Start?**

**Your implementation plan:**
1. **Today:** Install Pi-hole (20 minutes)
2. **This week:** Configure your devices and test
3. **Next week:** Fine-tune based on usage patterns
4. **Week 3:** Family discussion with real data
5. **Week 4:** Family rollout (if desired)

**Remember:** This is YOUR test environment. Break things, learn the system, and build confidence before involving the family!

**Next Steps:**
- SSH to your G9 and run the Pi-hole installer
- Configure your MacBook and iPhone DNS
- Start browsing and see the difference!

*The ad-free internet experience awaits!* 🎉 