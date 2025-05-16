# Pass_the_Baton Tool

This tool helps manage the hand-off between LLM agent sessions in your project.

## Setup

1.  **Copy Folder:** Place this entire `Pass_the_Baton` folder into the root directory of your project.
2.  **Python:** Ensure you have Python 3 installed and available in your terminal.
3.  **Git:** 
    *   Your project must be a Git repository.
    *   You need a remote repository configured (e.g., on GitHub) and named `origin`.
    *   Ensure your Git credentials (SSH key or HTTPS token/credential manager) are set up correctly for pushing to the remote.

## Cross-Platform Usage (NEW)

This tool now works seamlessly across Windows, macOS, and Linux with platform-specific launchers:

### Option 1: Universal Launcher (Recommended)
From your project root directory, run:
```bash
python Pass_the_Baton/run_baton.py
```
This will automatically detect your operating system and run the appropriate script.

### Option 2: Platform-Specific Launchers

#### On Windows:
```
Pass_the_Baton\Pass_the_Baton\pass_the_baton.bat
```
Or double-click the .bat file in File Explorer.

#### On macOS/Linux:
```bash
chmod +x Pass_the_Baton/Pass_the_Baton/pass_the_baton.sh  # First time only
./Pass_the_Baton/Pass_the_Baton/pass_the_baton.sh
```

### Option 3: Traditional Method
Open your terminal, navigate to your project's root directory, and run:
```bash
python Pass_the_Baton/Pass_the_Baton/Pass_the_Baton.py
```

## How it Works

*   The script automatically detects your operating system and adapts to platform-specific needs.
*   It uses standard `git` commands (`add`, `commit`, `push`) with special handling for Windows when needed.
*   It interacts with two files in your project root:
    *   `baton.md`: The main hand-off file, updated each time the script runs.
    *   `baton_archive.md`: Stores the history of previous `baton.md` contents.
*   If `baton.md` doesn't exist in your project root when the script first runs, it will be created using the `baton_template.md` from this folder.
*   The script handles path differences between operating systems automatically.

## Platform-Specific Features

*   **Windows:** Handles Windows path separators, command execution differences, and Git quirks on Windows environments.
*   **macOS:** Properly manages macOS-specific file attributes and hidden files.
*   **Linux:** Optimized for Linux environments with proper permission handling.

For more detailed information about cross-platform features, see `cross_platform_readme.md` in this directory.

## Important Notes

*   The script assumes it's being run from the project's root directory.
*   The updates made to `baton.md` and `baton_archive.md` during a run are **not** automatically committed by that same run. They will be included the *next* time you run the script or perform a manual commit. 
*   Each time you run the script, it will display your detected operating system information. 