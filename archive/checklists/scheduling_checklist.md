# Maintenance Script Scheduling Checklist

This checklist guides you through scheduling your daily, weekly, and monthly maintenance scripts on both Windows and Ubuntu. Use this as a reference when you're ready to automate log creation!

---

## 🪟 Windows (Task Scheduler)
- [ ] Open Task Scheduler
- [ ] Create a new task for each script (daily, weekly, monthly)
- [ ] Set triggers:
    - [ ] Daily: every day at preferred time
    - [ ] Weekly: every Sunday at preferred time
    - [ ] Monthly: 1st of each month at preferred time
- [ ] Set action:
    - [ ] Program/script: `powershell.exe`
    - [ ] Add arguments: `-ExecutionPolicy Bypass -File "<full path to script>"`
- [ ] Set to run with highest privileges
- [ ] Set to run whether user is logged on or not
- [ ] Test each task manually
- [ ] Check Task Scheduler history/logs for errors

## 🐧 Ubuntu (cron)
- [ ] Open terminal and run `crontab -e`
- [ ] Add lines for each script:
    - [ ] Daily: `0 7 * * * /path/to/daily_maintenance_ubuntu.sh`
    - [ ] Weekly: `0 7 * * 0 /path/to/weekly_maintenance_ubuntu.sh`
    - [ ] Monthly: `0 7 1 * * /path/to/monthly_maintenance_ubuntu.sh`
- [ ] Make scripts executable: `chmod +x /path/to/script.sh`
- [ ] Test each script manually
- [ ] Check cron logs with `grep CRON /var/log/syslog` (or `journalctl` on some systems)

## 📝 Pro Tips
- [ ] Test scripts manually before scheduling
- [ ] Ensure correct file paths and permissions
- [ ] Add git add/commit/push to scripts if you want full automation
- [ ] Document any issues or troubleshooting steps here

---

*Last updated: $(date +%Y-%m-%d)* 