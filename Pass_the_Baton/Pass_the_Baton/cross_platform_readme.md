# 🏃‍♂️ Pass_the_Baton - Cross-Platform Guide 🏃‍♀️

## Overview
Pass_the_Baton is a utility that helps document and transition between work sessions. This cross-platform version works seamlessly across macOS, Windows, and Linux.

## How to Run

### On macOS/Linux:
1. Open Terminal
2. Navigate to the Pass_the_Baton directory
3. Make the script executable (first time only):
   ```
   chmod +x pass_the_baton.sh
   ```
4. Run:
   ```
   ./pass_the_baton.sh
   ```

### On Windows:
1. Open Command Prompt or PowerShell
2. Navigate to the Pass_the_Baton directory
3. Run:
   ```
   pass_the_baton.bat
   ```
   
Alternatively, you can double-click on `pass_the_baton.bat` in File Explorer.

### Direct Python Method (All Platforms):
If you prefer to run the Python script directly:
```
python Pass_the_Baton.py
```

## Requirements
- Python 3.x
- Git

## Platform-Specific Notes

### macOS
- Ensures compatibility with macOS directories and file patterns
- Properly handles hidden files (those starting with `.`)

### Windows
- Accommodates Windows-specific command execution
- Handles Windows path separators (`\` vs `/`)
- Applies special Git command handling when needed
- Ignores Windows-specific temporary files

### Linux
- Works with standard Linux paths and command execution
- Detects Linux-specific environment characteristics

## Troubleshooting

### Common Issues:
- **Git command not found**: Ensure Git is installed and in your system PATH
- **Permission denied**: For macOS/Linux, ensure you've made the script executable with `chmod +x pass_the_baton.sh`
- **Python not found**: Ensure Python 3.x is installed and in your system PATH

### Windows-Specific:
- If experiencing Git issues on Windows, try running in Git Bash instead of Command Prompt
- If command execution fails, try running with administrator privileges

### macOS-Specific:
- If experiencing "Operation not permitted" errors, check System Preferences > Security & Privacy > Privacy > Full Disk Access and add Terminal

## File Paths
The script automatically handles path differences between operating systems, so files will be found and displayed correctly regardless of platform.

---

*This cross-platform implementation was added to improve compatibility across different operating systems.* 