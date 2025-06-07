@echo off
cd /d %~dp0..
call C:\Dashboard\dashboard_env\Scripts\activate.bat
python web\dashboard.py 