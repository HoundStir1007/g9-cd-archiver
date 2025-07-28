#!/bin/bash

# Jellyfin Scan Progress Monitor
# Usage: ./check_scan_progress.sh

echo "🔍 Jellyfin Scan Progress Check - $(date)"
echo "========================================="

# Check if Jellyfin container is running
if ! docker ps | grep -q jellyfin; then
    echo "❌ Jellyfin container not running"
    exit 1
fi

echo "📊 Recent activity (last 20 lines):"
docker logs jellyfin --tail 20 | grep -E "(scan|library|progress|completed|finished)" || echo "No scan-related messages in recent logs"

echo ""
echo "⚠️ Recent errors (last 10):"
docker logs jellyfin --since="5m" | grep -E "(ERR|ERROR)" | tail -5 || echo "No recent errors"

echo ""
echo "🔄 Current container status:"
docker ps --filter name=jellyfin --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "💡 Next check in 15-30 minutes recommended"
echo "📝 Check Jellyfin dashboard for current percentage" 