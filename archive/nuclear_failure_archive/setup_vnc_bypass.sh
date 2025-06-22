#!/bin/bash

# SIMPLE VNC BYPASS - Manual Start
# Bypasses all systemd and package issues

echo "🚀 SIMPLE VNC BYPASS - Manual Start"
echo "Starting VNC server manually..."

# Kill any existing processes
pkill -f x11vnc 2>/dev/null || true
pkill -f Xvfb 2>/dev/null || true

# Start virtual display
echo "📺 Starting virtual display..."
Xvfb :99 -screen 0 1280x720x24 &
XVFB_PID=$!
export DISPLAY=:99

# Wait for display to start
sleep 3

# Start desktop environment
echo "🖥️ Starting XFCE desktop..."
startxfce4 &
XFCE_PID=$!

# Wait for desktop to load
sleep 5

# Start VNC server
echo "🔗 Starting VNC server on port 5901..."
x11vnc -display :99 -rfbport 5901 -passwd ubuntu -shared -forever -noxdamage -bg

echo "✅ VNC Server Started!"
echo ""
echo "📱 Connection Details:"
echo "   VNC URL: vnc://100.91.157.19:5901"
echo "   Password: ubuntu"
echo ""
echo "🔧 To stop VNC:"
echo "   pkill -f x11vnc"
echo "   pkill -f Xvfb"
echo ""
echo "🎯 Try connecting now!" 