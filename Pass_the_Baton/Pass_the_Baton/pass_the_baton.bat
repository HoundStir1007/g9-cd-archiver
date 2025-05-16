@echo off
REM Cross-platform batch wrapper for Pass_the_Baton
REM For Windows systems

REM Get script directory
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM Check for Python
where python >nul 2>&1
if %ERRORLEVEL% == 0 (
    set PYTHON_CMD=python
) else (
    where py >nul 2>&1
    if %ERRORLEVEL% == 0 (
        set PYTHON_CMD=py
    ) else (
        echo [31m✕ Error: Python not found. Please install Python 3.x[0m
        exit /b 1
    )
)

echo 🚀 Starting Pass_the_Baton using %PYTHON_CMD%...
%PYTHON_CMD% "%SCRIPT_DIR%Pass_the_Baton.py"
if %ERRORLEVEL% NEQ 0 (
    echo [31m✕ An error occurred while running Pass_the_Baton.py[0m
    pause
    exit /b 1
)

echo.
echo 🎉 Process completed successfully!
pause 