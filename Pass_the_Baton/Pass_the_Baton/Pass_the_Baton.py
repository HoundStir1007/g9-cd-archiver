import subprocess
import datetime
import os
import sys
import shutil
import json
import re
import platform

# --- Configuration ---
BATON_FILENAME = "baton.md"
ARCHIVE_FILENAME = "baton_archive.md"
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
TEMPLATE_FILENAME = os.path.join(SCRIPT_DIR, "baton_template.md")
MAX_LINES = 200  # Maximum number of lines allowed in baton.md

# OS Detection
CURRENT_OS = platform.system().lower()  # 'windows', 'darwin' (macOS), or 'linux'
IS_WINDOWS = CURRENT_OS == 'windows'
IS_MAC = CURRENT_OS == 'darwin'
IS_LINUX = CURRENT_OS == 'linux'

print(f"🖥️ Detected operating system: {platform.system()} ({platform.release()})")
# --- End Configuration ---

def run_command(command):
    """Executes a shell command and returns its output with OS-specific handling."""
    try:
        # Special handling for Windows shell commands if needed
        if IS_WINDOWS and not isinstance(command, str) and command[0] == "git":
            # Some Windows environments might need shell=True for git commands
            print(f"🏃 Running: {' '.join(command)}")
            result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8', shell=True)
        else:
            print(f"🏃 Running: {' '.join(command) if isinstance(command, list) else command}")
            result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8')
        
        return result.stdout.strip()
    except FileNotFoundError:
        print(f"❌ Error: Command not found: {command[0] if isinstance(command, list) else command}. Is Git installed and in PATH?", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running command: {' '.join(command) if isinstance(command, list) else command}", file=sys.stderr)
        # Don't exit for commit errors if there's nothing to commit
        if not (isinstance(command, list) and command[1] == 'commit' and 'nothing to commit' in e.stderr):
             sys.exit(1)
        else:
            print("🤷 No changes detected to commit.")
            return None # Indicate nothing was committed
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)

def check_git_repo():
    """Checks if the current directory is a Git repository."""
    print("🔍 Checking for Git repository...")
    try:
        # Handle potential Windows-specific issues with Git
        if IS_WINDOWS:
            try:
                run_command(["git", "rev-parse", "--is-inside-work-tree"])
            except Exception:
                # Try with shell=True as a fallback on Windows
                run_command("git rev-parse --is-inside-work-tree")
        else:
            run_command(["git", "rev-parse", "--is-inside-work-tree"])
        
        print("✅ Git repository found.")
    except Exception:
        print("❌ Error: Not a Git repository. Please run this script from the root of your project.", file=sys.stderr)
        sys.exit(1)

def ensure_baton_file():
    """Ensures baton.md exists, copying from template if necessary."""
    if not os.path.exists(BATON_FILENAME):
        print(f"📋 '{BATON_FILENAME}' not found. Creating from template...")
        try:
            shutil.copyfile(TEMPLATE_FILENAME, BATON_FILENAME)
            print(f"✅ '{BATON_FILENAME}' created.")
        except Exception as e:
            print(f"❌ Error copying template: {e}", file=sys.stderr)
            sys.exit(1)

def check_file_size():
    """Checks if baton.md exceeds line limit and archives if necessary."""
    if not os.path.exists(BATON_FILENAME):
        return True
        
    with open(BATON_FILENAME, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    if len(lines) >= MAX_LINES:
        print(f"⚠️ {BATON_FILENAME} has reached {len(lines)} lines (limit: {MAX_LINES})")
        print("📦 Archiving current content...")
        
        # Create archive filename with date
        date_str = datetime.datetime.now().strftime("%Y_%m")
        archive_name = f"baton_archive_{date_str}.md"
        
        # Append to archive
        with open(archive_name, 'a', encoding='utf-8') as archive:
            archive.write(f"\n\n--- Archived on: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ---\n\n")
            archive.writelines(lines)
            
        # Clear baton.md
        with open(BATON_FILENAME, 'w', encoding='utf-8') as f:
            f.write("# Baton - Project Tracking & Handoff Document 🚀\n\n")
            
        print(f"✅ Content archived to {archive_name}")
        return True
    return True

def git_operations():
    """Performs git add, commit, and push without user input."""
    print("\n--- Git Operations ---")
    
    # Generate a timestamp-based commit message
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    commit_message = f"Update baton handoff document - {timestamp}"
    print(f"Using commit message: {commit_message}")

    # Handle OS-specific Git operations
    if IS_WINDOWS:
        try:
            run_command(["git", "add", "."])
        except Exception:
            # Try alternative method on Windows if needed
            run_command("git add .")
    else:
        run_command(["git", "add", "."])

    # Commit changes with OS-specific handling if needed
    if IS_WINDOWS:
        try:
            commit_result = run_command(["git", "commit", "-m", f'"{commit_message}"'])
        except Exception:
            # Try alternative method on Windows
            commit_result = run_command(f'git commit -m "{commit_message}"')
    else:
        commit_result = run_command(["git", "commit", "-m", commit_message])

    # Actually push to remote
    if commit_result is not None:  # Only push if there was something to commit
        print("🚀 Pushing changes to remote...")
        if IS_WINDOWS:
            try:
                run_command(["git", "push"])
            except Exception:
                # Try alternative method on Windows
                run_command("git push")
        else:
            run_command(["git", "push"])
        print("✅ Changes pushed to remote successfully.")
    
    return True

def main():
    """Main execution flow."""
    print(f"🏃 Kicking off Pass_the_Baton on {platform.system()}! 🏃💨")
    check_git_repo()
    ensure_baton_file()
    check_file_size()  # Check and archive if needed
    git_operations()  # Git operations are the final step
    print("\n🎉 Baton passed successfully! The next agent is ready to go! 🎉")

if __name__ == "__main__":
    main() 