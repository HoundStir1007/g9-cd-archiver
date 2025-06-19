# Environment Variables Setup Guide 🔐

**Status**: ⚠️ **GMAIL PASSWORD SETUP STILL NEEDED** for email alerts to work!

## 🚨 **CRITICAL MISSING STEP:**

While we secured all the **structure** for Gmail passwords, **you still need to set up the actual Gmail App Password!**

---

## 📋 **Gmail App Password Setup Process:**

### **Step 1: Enable Gmail App Password** 🔑
1. Go to **Google Account settings**: https://myaccount.google.com/
2. **Security → 2-Step Verification** (must be enabled first!)
3. **Security → App passwords**
4. Generate new app password for **"Home Server Monitoring"**
5. Save the **16-character password** (NOT your regular Gmail password!)

### **Step 2: Deploy Passwords to Systems** 📤

#### **A. Ubuntu Server** (for Tailscale monitoring emails):
```bash
# SSH to Ubuntu server
ssh your_server

# Edit the environment file
sudo nano /opt/tailscale-monitoring/.env

# Set this line:
SMTP_PASSWORD=your_16_character_app_password_here
```

#### **B. Local Monitoring** (ubuntu_monitoring_script.py):
```bash
# In project root directory
cp env_template_example.md .env
nano .env

# Set this line:
SMTP_PASSWORD=your_16_character_app_password_here
```

#### **C. Pi-hole** (already done ✅):
```bash
# Already secured in pihole/.env
```

---

## 📊 **Current Security Status:**

| System | Password Security | Status |
|--------|-------------------|---------|
| **Pi-hole** | ✅ Environment variables | **SECURE** |
| **SMTP (ubuntu_monitoring_script.py)** | ✅ Environment variables | **STRUCTURE READY** |
| **SMTP (ubuntu_tailscale_monitoring.py)** | ✅ Environment variables | **STRUCTURE READY** |
| **Gmail App Password** | ❌ **NEEDS SETUP** | **⚠️ PENDING** |

---

## 🎯 **Template for .env files:**

```bash
# SMTP Configuration for Email Alerts
SMTP_PASSWORD=your_gmail_app_password_here
SMTP_USERNAME=msakamoto+homelab@gmail.com
SMTP_FROM=msakamoto+homelab@gmail.com
SMTP_TO=msakamoto+alerts@gmail.com

# Pi-hole Admin Password
PIHOLE_PASSWORD=your_secure_pihole_password_here
```

---

## 🔍 **Why This Matters:**

- **Email alerts for power outages** won't work without this
- **Tailscale monitoring notifications** won't work without this  
- **System health alerts** won't work without this

**This is the FINAL STEP to make monitoring 100% operational!** 🚀

---

**Once Gmail app password is set up → ALL monitoring systems will have complete email alert functionality!** ✨ 