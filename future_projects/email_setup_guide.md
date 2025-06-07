# 📧 Email Handling Setup for Paperless-ngx

## Overview

This guide provides multiple approaches to handle emails effectively in your Paperless-ngx system, solving the Gotenberg .eml processing issues.

## 🎯 Option 1: Direct Email Import (RECOMMENDED)

### Setup IMAP Email Accounts

1. **Access Admin Interface**
   ```
   http://100.91.157.19:8000/admin/
   ```

2. **Navigate to Mail Accounts**
   - Go to `Paperless Mail` → `Mail Accounts`
   - Click `Add Mail Account`

3. **Gmail Configuration Example**
   ```yaml
   Basic Settings:
   - Name: "Medical Documents - Gmail"
   - IMAP Server: imap.gmail.com
   - IMAP Port: 993
   - IMAP Security: SSL
   - Username: your-email@gmail.com
   - Password: [Gmail App Password]
   
   Processing Settings:
   - Folder: "Paperless" (create this folder in Gmail)
   - Action after processing: "Mark as Read"
   - Attachment processing: "Process all attachments"
   - Subject prefix: "DOC:" (optional)
   ```

4. **Create Gmail App Password**
   ```bash
   # In Gmail:
   # 1. Go to Google Account settings
   # 2. Security → 2-Step Verification 
   # 3. App passwords → Generate app password
   # 4. Use this password in Paperless-ngx (not your regular password)
   ```

### Email Organization Strategy

1. **Create Gmail Folders**
   - `Paperless/Medical` - Medical documents
   - `Paperless/Financial` - Bills, receipts
   - `Paperless/Personal` - Important personal docs

2. **Set Up Gmail Filters**
   ```
   From: *veterinary*
   → Move to: Paperless/Medical
   → Add label: Medical
   
   From: *billing* OR *invoice*
   → Move to: Paperless/Financial
   → Add label: Financial
   ```

## 🔧 Option 2: Email Forwarding Setup

### Dedicated Paperless Email

1. **Create New Gmail Account**
   - `yourname.paperless@gmail.com`
   - Use this exclusively for document processing

2. **Set Up Auto-Forwarding Rules**
   ```
   In your main Gmail:
   Filters → Create Filter
   - From: valley.veterinary@example.com
   - Forward to: yourname.paperless@gmail.com
   - Delete original (optional)
   ```

3. **Configure Paperless-ngx**
   - Monitor the dedicated account
   - Process all emails automatically

## 🚀 Option 3: Automated .eml Processing

### Install Email Processor

1. **Copy Script to Server**
   ```bash
   scp email_processor.py gmk@100.91.157.19:/home/gmk/scripts/
   ```

2. **Install Dependencies**
   ```bash
   ssh gmk@100.91.157.19
   sudo apt update
   sudo apt install wkhtmltopdf python3-pip
   pip3 install pdfkit
   ```

3. **Set Up Automated Processing**
   ```bash
   # Create cron job for automatic .eml conversion
   crontab -e
   
   # Add this line (runs every 5 minutes):
   */5 * * * * /usr/bin/python3 /home/gmk/scripts/email_processor.py /media/paperless-storage/paperless/consume/
   ```

### Manual Usage
```bash
# Convert single .eml file manually:
python3 email_processor.py /media/paperless-storage/paperless/consume/
```

## 📱 Option 4: Mobile Email Processing

### iOS Shortcut Setup

1. **Create iOS Shortcut**
   ```
   Shortcut Name: "Send to Paperless"
   
   Actions:
   1. Get Contents of Email
   2. Save to Files (Paperless folder)
   3. Convert to PDF
   4. Upload to Paperless consume folder
   ```

### Email App Integration
- Forward emails directly to consume email address
- Use "Save to Files" → Paperless folder
- Auto-sync to server

## 🔑 Gmail App Password Setup

### Step-by-Step Instructions

1. **Enable 2-Factor Authentication**
   ```
   Google Account → Security → 2-Step Verification → Turn On
   ```

2. **Generate App Password**
   ```
   Google Account → Security → App passwords
   Select app: Mail
   Select device: Other (Paperless-ngx)
   → Generate
   ```

3. **Use App Password**
   - Copy the 16-character password
   - Use this in Paperless-ngx (not your regular Gmail password)

## 📋 Testing Your Setup

### Verify Email Processing

1. **Send Test Email**
   ```bash
   # Check if email account is working:
   ssh gmk@100.91.157.19
   docker exec paperless-ngx-webserver-1 python manage.py mail_fetcher --dry-run
   ```

2. **Monitor Processing**
   ```bash
   # Watch logs for email processing:
   docker logs paperless-ngx-webserver-1 -f | grep -i mail
   ```

3. **Test Document Creation**
   - Send an email to your configured folder
   - Check if document appears in Paperless-ngx within 5 minutes

## 🎯 Recommended Workflow

### For Medical Documents (like Valley Veterinary)

1. **Email Arrives** → Auto-sorted to `Paperless/Medical` folder
2. **Paperless-ngx Fetches** → Converts to searchable PDF
3. **Auto-Tagged** → "Medical", "Valley Veterinary Hospital"
4. **Instantly Searchable** → OCR processed and indexed

### For Financial Documents

1. **Bills/Receipts** → Auto-sorted to `Paperless/Financial`
2. **Auto-Processing** → Date extraction, amount detection
3. **Smart Filing** → Automatic correspondent and tag assignment

## 🔧 Troubleshooting

### Common Issues

1. **Gmail Authentication Failed**
   ```bash
   # Solution: Check app password, not regular password
   # Verify 2FA is enabled
   ```

2. **Emails Not Processing**
   ```bash
   # Check mail fetcher logs:
   docker logs paperless-ngx-webserver-1 | grep mail_fetcher
   ```

3. **PDF Conversion Errors**
   ```bash
   # Verify wkhtmltopdf installation:
   wkhtmltopdf --version
   ```

## 🎉 Benefits of Proper Email Setup

- **Zero Manual Work** - Emails automatically become searchable documents
- **No More .eml Errors** - Bypasses Gotenberg formatting issues  
- **Smart Organization** - Auto-tagging and correspondent assignment
- **Mobile Friendly** - Forward emails from your phone
- **Backup Strategy** - All important emails preserved as PDFs

---

**Next Steps:** Choose your preferred option and follow the setup instructions. Option 1 (Direct Email Import) is recommended for most users! 