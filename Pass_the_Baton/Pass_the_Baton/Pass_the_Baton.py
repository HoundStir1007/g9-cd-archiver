import subprocess
import datetime
import os
import sys
import shutil
import json
import re

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
        return result.stdout.strip()
    except FileNotFoundError:
        print(f"❌ Error: Command not found: {command[0]}. Is Git installed and in PATH?", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running command: {' '.join(command)}", file=sys.stderr)
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

def git_operations():
    """Performs git add, commit, and push without user input."""
    print("\n--- Git Operations ---")
    
    # Generate a timestamp-based commit message
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    commit_message = f"Update baton handoff document - {timestamp}"
    print(f"Using commit message: {commit_message}")

    run_command(["git", "add", "."])
    commit_result = run_command(["git", "commit", "-m", commit_message])

    # Actually push to remote
    if commit_result is not None:  # Only push if there was something to commit
        print("🚀 Pushing changes to remote...")
        run_command(["git", "push"])
        print("✅ Changes pushed to remote successfully.")
    
    return True

def archive_baton():
    """Appends the current baton contents to the archive file."""
    print("\n--- Archiving Baton ---")
    if os.path.exists(BATON_FILENAME):
        try:
            with open(BATON_FILENAME, 'r', encoding='utf-8') as baton_file:
                content = baton_file.read()
            
            with open(ARCHIVE_FILENAME, 'a', encoding='utf-8') as archive_file:
                timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                archive_file.write(f"\n\n--- Archived on: {timestamp} ---\n\n")
                archive_file.write(content)
            print(f"✅ Archived previous content to '{ARCHIVE_FILENAME}'.")
        except Exception as e:
            print(f"❌ Error archiving baton: {e}", file=sys.stderr)
            # Non-fatal, proceed with updating baton
    else:
        print(f"🤷 '{BATON_FILENAME}' does not exist, nothing to archive.")

def get_recent_git_changes():
    """Get recent git changes to help the LLM understand what was worked on."""
    try:
        # Get commits from last 24 hours or last 10 commits, whichever is fewer
        recent_commits = run_command(["git", "log", "--pretty=format:%s", "--since=24.hours", "-10"])
        
        # Count total commits to avoid errors with HEAD~n references
        commit_count = 0
        try:
            commit_count_output = run_command(["git", "rev-list", "--count", "HEAD"])
            commit_count = int(commit_count_output.strip())
        except Exception:
            # If we can't count commits, assume there's only 1
            commit_count = 1
        
        # Get list of modified files - adjust history depth based on available commits
        modified_files = []
        if commit_count > 1:
            # If we have more than 1 commit, check files changed in last commit
            try:
                depth = min(5, commit_count - 1)  # Don't go further back than available history
                modified_files = run_command(["git", "diff", "--name-only", f"HEAD~{depth}", "HEAD"])
                modified_files = modified_files.split("\n") if modified_files else []
            except Exception as e:
                print(f"⚠️ Warning: Error getting modified files: {e}")
        else:
            # For new repos with only 1 commit, get all tracked files
            try:
                modified_files = run_command(["git", "ls-tree", "-r", "HEAD", "--name-only"])
                modified_files = modified_files.split("\n") if modified_files else []
            except Exception as e:
                print(f"⚠️ Warning: Error listing tracked files: {e}")
        
        return {
            "recent_commits": recent_commits.split("\n") if recent_commits else [],
            "modified_files": modified_files
        }
    except Exception as e:
        print(f"⚠️ Warning: Could not get recent git changes: {e}")
        return {"recent_commits": [], "modified_files": []}

def find_important_files():
    """Find and return potential important files in the project."""
    important_extensions = ['.py', '.js', '.jsx', '.ts', '.tsx', '.html', '.css', '.md', '.json']
    important_files = []
    
    try:
        # Find main project files
        for root, _, files in os.walk('.'):
            if '.git' in root or 'node_modules' in root or '__pycache__' in root:
                continue
                
            for file in files:
                file_path = os.path.join(root, file)
                # Skip the baton files themselves
                if file == BATON_FILENAME or file == ARCHIVE_FILENAME:
                    continue
                    
                if any(file.endswith(ext) for ext in important_extensions):
                    # Only include relatively small files
                    if os.path.getsize(file_path) < 1000000:  # 1MB limit
                        important_files.append(file_path.replace('./', '', 1))
        
        # Prioritize files that seem most important
        prioritized_files = []
        for file in important_files:
            if re.search(r'(main|index|app)\.(py|js|jsx|ts|tsx)$', file):
                prioritized_files.insert(0, file)
            elif file.endswith('README.md'):
                prioritized_files.insert(0, file)
            else:
                prioritized_files.append(file)
                
        return prioritized_files[:10]  # Return at most 10 important files
    except Exception as e:
        print(f"⚠️ Warning: Error finding important files: {e}")
        return []

def get_llm_generated_content():
    """Generate content for the baton handoff using LLM-like approach."""
    print("\n--- 🤖 Generating Baton Content with AI ---")
    
    try:
        # Get context for the AI
        git_changes = get_recent_git_changes()
        important_files = find_important_files()
        
        # In a real implementation, this would call an actual LLM API
        # For now, we'll generate a placeholder that shows the structure
        
        # 1. Generate Session Summary based on git history
        if git_changes["recent_commits"]:
            commits_text = "\n".join([f"- {commit}" for commit in git_changes["recent_commits"][:5]])
            summary = f"In this session, we worked on the following changes:\n\n{commits_text}\n\nThese changes focused on improving project functionality and structure."
        else:
            summary = "This session focused on initial project setup and planning for future development."
        
        # 2. Generate Next Steps based on modified files and project state
        next_steps = "For the next session, consider the following steps:\n\n"
        next_steps += "- Review and test the recent changes\n"
        next_steps += "- Continue development on core features\n"
        next_steps += "- Add more comprehensive documentation\n"
        next_steps += "- Address any pending TODOs in the codebase"
        
        # 3. Generate Important Files & Links
        links = []
        for file_path in important_files:
            if file_path.endswith('README.md'):
                links.append(f"{file_path}: Main project documentation")
            elif re.search(r'(main|index|app)\.(py|js|jsx|ts|tsx)$', file_path):
                links.append(f"{file_path}: Core application entry point")
            else:
                # Generate a simple description based on the filename
                name = os.path.basename(file_path)
                desc = f"{''.join(' ' + c if c.isupper() else c for c in os.path.splitext(name)[0]).strip().title()}"
                links.append(f"{file_path}: {desc}")
        
        links_formatted = "\n".join([f"*   {link}" for link in links])
        if not links_formatted:
            links_formatted = "*(No important files identified)*"
    except Exception as e:
        print(f"⚠️ Warning: Error generating content: {e}")
        # Fallback content when there's an issue with git or file analysis
        summary = "This session focused on setting up the Pass_the_Baton system for seamless handoffs between work sessions."
        next_steps = "For the next session, consider the following steps:\n\n"
        next_steps += "- Review the baton handoff system and provide feedback\n"
        next_steps += "- Continue development of core project features\n"
        next_steps += "- Update this file with more specific details about the project"
        links_formatted = "*   Pass_the_Baton/Pass_the_Baton.py: Handoff script for session transitions\n"
        links_formatted += "*   baton.md: The handoff document being generated\n"
        links_formatted += "*   README.md: Add this file with project documentation"
    
    # 4. Reminders - Leave blank for now, as these are usually more project-specific
    reminders = ""
    
    print("✅ AI content generation complete!")
    
    return {
        "summary": summary,
        "next_steps": next_steps,
        "links_formatted": links_formatted,
        "reminders": reminders
    }

def update_baton():
    """Updates the baton.md file with AI-generated content without user input."""
    print("\n--- Update Baton ---")
    
    # Generate content with LLM-like approach
    content = get_llm_generated_content()
    summary = content["summary"]
    next_steps = content["next_steps"]
    links_formatted = content["links_formatted"]
    reminders = content["reminders"]
    
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
    print("🏃 Kicking off Pass_the_Baton! 🏃💨")
    check_git_repo()
    ensure_baton_file() # Ensure baton exists before archiving/updating
    git_operations()
    archive_baton()
    update_baton()
    print("\n🎉 Baton passed successfully! The next agent is ready to go! 🎉")


if __name__ == "__main__":
    main() 