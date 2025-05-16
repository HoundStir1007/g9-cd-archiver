#!/bin/bash

# Cross-platform Bash wrapper for Pass_the_Baton
# For macOS and Linux systems

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check for Python
if command -v python3 &>/dev/null; then
    PYTHON_CMD=python3
elif command -v python &>/dev/null; then
    PYTHON_CMD=python
else
    echo "❌ Error: Python not found. Please install Python 3.x"
    exit 1
fi

echo "🚀 Starting Pass_the_Baton using $PYTHON_CMD..."
$PYTHON_CMD "$SCRIPT_DIR/Pass_the_Baton.py" 