# Pass_the_Baton Tool

This tool helps manage the hand-off between LLM agent sessions in your project.

## Setup

1.  **Copy Folder:** Place this entire `Pass_the_Baton` folder into the root directory of your project.
2.  **Python:** Ensure you have Python 3 installed and available in your terminal.
3.  **Git:** 
    *   Your project must be a Git repository.
    *   You need a remote repository configured (e.g., on GitHub) and named `origin`.
    *   Ensure your Git credentials (SSH key or HTTPS token/credential manager) are set up correctly for pushing to the remote.

## Usage

1.  **Save Files:** Before running the script, make sure all your code changes are saved in your editor (Cursor usually handles this).
2.  **Run Script:** Open your terminal, navigate to your project's root directory, and run the script:
    ```bash
    python Pass_the_Baton/Pass_the_Baton.py
    ```
3.  **Follow Prompts:** The script will guide you through:
    *   Committing your current changes with a message you provide.
    *   Pushing the changes to your remote repository (`origin`).
    *   Archiving the previous `baton.md` content.
    *   Updating `baton.md` with a new timestamp and information you provide (Session Summary, Next Steps, Important Files, Reminders).

## How it Works

*   The script uses standard `git` commands (`add`, `commit`, `push`).
*   It interacts with two files in your project root:
    *   `baton.md`: The main hand-off file, updated each time the script runs.
    *   `baton_archive.md`: Stores the history of previous `baton.md` contents.
*   If `baton.md` doesn't exist in your project root when the script first runs, it will be created using the `baton_template.md` from this folder.

## Important Notes

*   The script assumes it's being run from the project's root directory.
*   The updates made to `baton.md` and `baton_archive.md` during a run are **not** automatically committed by that same run. They will be included the *next* time you run the script or perform a manual commit. 