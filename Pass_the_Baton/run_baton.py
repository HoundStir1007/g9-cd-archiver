#!/usr/bin/env python3
"""
Universal launcher for Pass_the_Baton across all platforms.
Run this from any directory to automatically detect OS and launch the appropriate script.
"""

import os
import platform
import subprocess
import sys

def main():
    # Detect OS
    current_os = platform.system().lower()
    print(f"🖥️ Detected operating system: {platform.system()} ({platform.release()})")
    
    # Get script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    baton_dir = os.path.join(script_dir, "Pass_the_Baton")
    
    if current_os == "windows":
        # Windows
        batch_file = os.path.join(baton_dir, "pass_the_baton.bat")
        try:
            print(f"🚀 Launching Windows batch file: {batch_file}")
            subprocess.run(["cmd", "/c", batch_file], check=True)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error running Windows script: {e}", file=sys.stderr)
            sys.exit(1)
    elif current_os in ["darwin", "linux"]:
        # macOS or Linux
        shell_script = os.path.join(baton_dir, "pass_the_baton.sh")
        try:
            print(f"🚀 Launching Bash script: {shell_script}")
            # Make sure it's executable
            os.chmod(shell_script, 0o755)
            subprocess.run([shell_script], check=True)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error running shell script: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        # Fallback to direct Python execution on unknown platforms
        python_script = os.path.join(baton_dir, "Pass_the_Baton.py")
        try:
            print(f"🚀 Directly launching Python script: {python_script}")
            python_cmd = "python3" if subprocess.run(["which", "python3"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).returncode == 0 else "python"
            subprocess.run([python_cmd, python_script], check=True)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error running Python script: {e}", file=sys.stderr)
            sys.exit(1)
    
    print("✅ Pass_the_Baton completed successfully!")

if __name__ == "__main__":
    main() 