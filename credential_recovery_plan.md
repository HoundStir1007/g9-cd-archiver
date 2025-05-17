# Credential Recovery Plan

This document describes the process for recovering access to all critical credentials for the Home Server Project.

---

## 1. Password Manager Access
- Primary credentials are stored in the iOS/macOS Passwords app.
- Ensure iCloud Keychain is enabled on all Apple devices.
- If access is lost:
  - Use another Apple device signed into the same iCloud account.
  - Use Apple ID account recovery at https://iforgot.apple.com/.
  - Contact Apple Support if needed.

## 2. Backup Locations
- BitLocker recovery key: Stored in Microsoft Account, PDF in cloud storage, and in Passwords app.
- Tailscale credentials: Stored in Passwords app and Tailscale admin console.
- Admin account passwords: Stored in Passwords app and (optionally) a printed copy in a secure location.

## 3. Emergency Steps
- If all digital access is lost, use printed backup (if available) or trusted family member’s device with shared access.
- For Microsoft Account, use recovery email/phone.
- For iCloud, use recovery contact or Apple Support.

## 4. Regular Review
- Review and update this plan quarterly or after any major change.
- Test recovery steps annually.

---

*Keep this file up to date and store a printed copy in a secure location if possible.*
