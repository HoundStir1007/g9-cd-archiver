import subprocess
import datetime
import os
import sys
import shutil

# --- Configuration ---
BATON_FILENAME = "baton.md"
ARCHIVE_FILENAME = "baton_archive.md"
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
TEMPLATE_FILENAME = os.path.join(SCRIPT_DIR, "baton_template.md")
# --- End Configuration ---

def run_command(command):
    """Executes a shell command and returns its output."""
    try:
        print(f"🏃 Running: {' '.join(command)}")
        result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8')
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print(result.stderr, file=sys.stderr)
        return result.stdout.strip()
    except FileNotFoundError:
        print(f"❌ Error: Command not found: {command[0]}. Is Git installed and in PATH?", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running command: {' '.join(command)}", file=sys.stderr)
        print(f"Return code: {e.returncode}", file=sys.stderr)
        print(f"Output:
{e.output}", file=sys.stderr)
        print(f"Stderr:
{e.stderr}", file=sys.stderr)
        # Don't exit for commit errors if there's nothing to commit
        if not (command[1] == 'commit' and 'nothing to commit' in e.stderr):
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

def get_multiline_input(prompt):
    """Gets multi-line input from the user."""
    print(f"{prompt} (Enter an empty line when finished):")
    lines = []
    while True:
        try:
            line = input()
            if line == "":
                break
            lines.append(line)
        except EOFError: # Handles cases like piping input
            break
    # Ensure newline character is correctly handled
    return "\\n".join(lines)

def get_commit_message():
    """Gets the commit message from the user."""
    while True:
        # Ensure prompt string is correctly terminated
        message = input("Enter commit message: ")
        if message:
            return message
        print("Commit message cannot be empty.")


def git_operations():
    """Performs git add, commit, and push."""
    print("\n--- Git Operations ---")
    commit_message = get_commit_message()

    run_command(["git", "add", "."])
    commit_result = run_command(["git", "commit", "-m", commit_message])

    # Only push if something was committed
    if commit_result is not None:
        print("🚀 Pushing to remote 'origin'...")
        # Attempt to get the current branch name for a more specific push
        try:
            current_branch = run_command(["git", "rev-parse", "--abbrev-ref", "HEAD"])
            run_command(["git", "push", "origin", current_branch])
        except Exception as e:
             # Ensure f-string is correctly terminated
             print(f"Warning: Could not automatically determine branch or push failed: {e}", file=sys.stderr)
             print("Attempting generic push...")
             try:
                 run_command(["git", "push", "origin"])
             except Exception as push_err:
                 # Ensure f-string is correctly terminated
                 print(f"❌ Push failed: {push_err}. Please push manually.", file=sys.stderr)
                 # Decide if this should be fatal - maybe not, baton can still be updated.
                 # sys.exit(1)
        print("✅ Pushed successfully.")
    else:
        print("✅ No changes committed, skipping push.")


def archive_baton():
    """Appends the current baton contents to the archive file."""
    print("\n--- Archiving Baton ---")
    if os.path.exists(BATON_FILENAME):
        try:
            with open(BATON_FILENAME, 'r', encoding='utf-8') as baton_file:
                content = baton_file.read()
            
            with open(ARCHIVE_FILENAME, 'a', encoding='utf-8') as archive_file:
                timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                archive_file.write(f"

--- Archived on: {timestamp} ---

")
                archive_file.write(content)
            print(f"✅ Archived previous content to '{ARCHIVE_FILENAME}'.")
        except Exception as e:
            print(f"❌ Error archiving baton: {e}", file=sys.stderr)
            # Non-fatal, proceed with updating baton
    else:
        print(f"🤷 '{BATON_FILENAME}' does not exist, nothing to archive.")


def update_baton():
    """Prompts user for details and updates the baton.md file."""
    print("\n--- Update Baton ---")
    print("Please provide details for the next session:")

    summary = get_multiline_input("📝 Session Summary:")
    next_steps = get_multiline_input("🚀 Next Steps:")
    links_input = get_multiline_input("🔗 Important Files & Links (one per line, e.g., `path/to/file.py`: Description):")
    reminders = get_multiline_input("📌 Important Reminders:")

    # Format links nicely
    # Ensure newline character is correctly handled in join and f-string formatting is correct
    links_formatted = "\n".join([f"*   {line.strip()}" for line in links_input.splitlines() if line.strip()])
    if not links_formatted:
         links_formatted = "*(No links provided)*"


    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    new_content = f"""# Baton Hand-off

**Last Update:** {timestamp}

## Session Summary

{summary if summary else "*(No summary provided)*"}

## Next Steps

{next_steps if next_steps else "*(No next steps provided)*"}

## Important Files & Links

{links_formatted}

## Important Reminders

{reminders if reminders else "*(No reminders provided)*"}

---
*This file is automatically updated by the Pass_the_Baton script.*
"""

    try:
        with open(BATON_FILENAME, 'w', encoding='utf-8') as baton_file:
            baton_file.write(new_content)
        print(f"✅ '{BATON_FILENAME}' updated successfully.")
    except Exception as e:
        print(f"❌ Error writing to '{BATON_FILENAME}': {e}", file=sys.stderr)
        sys.exit(1)


def main():
    """Main execution flow."""
    print(" Kicking off Pass_the_Baton! 🏃💨")
    check_git_repo()
    ensure_baton_file() # Ensure baton exists before archiving/updating
    git_operations()
    archive_baton()
    update_baton()
    print("\n🎉 Baton passed successfully! The next agent is ready to go! 🎉")


if __name__ == "__main__":
    main() 