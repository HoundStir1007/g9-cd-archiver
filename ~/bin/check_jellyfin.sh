#!/bin/bash

# Configuration
JELLYFIN_HEALTH_URL="http://192.168.0.182:8096/health"
UPTIME_KUMA_PUSH_URL="http://100.91.157.19:3001/api/push/FsDZQkf7na"
TIMEOUT=5
MAX_RETRIES=2
RETRY_DELAY=10
LOG_FILE="/tmp/jellyfin_health.log"

# Use system curl
CURL="/usr/bin/curl"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

check_jellyfin() {
    local attempt=1
    local success=false
    local start_time
    local end_time
    local response_time
    
    while [ $attempt -le $MAX_RETRIES ] && [ "$success" = false ]; do
        start_time=$($CURL -s https://worldtimeapi.org/api/timezone/America/Los_Angeles | grep -o '"unixtime":[0-9]*' | cut -d':' -f2)
        response=$($CURL -s -w "%{http_code}" --max-time $TIMEOUT "$JELLYFIN_HEALTH_URL" 2>&1)
        end_time=$($CURL -s https://worldtimeapi.org/api/timezone/America/Los_Angeles | grep -o '"unixtime":[0-9]*' | cut -d':' -f2)
        response_time=$(( (end_time - start_time) * 1000 )) # Convert to milliseconds
        
        http_code=${response: -3}
        body=${response:0:${#response}-3}
        
        if [ "$http_code" = "200" ] && [ "$body" = "Healthy" ]; then
            success=true
            log_message "Health check successful (attempt $attempt) - Response time: ${response_time}ms"
            $CURL -s "$UPTIME_KUMA_PUSH_URL?status=up&msg=Healthy&ping=${response_time}" > /dev/null
            break
        else
            log_message "Health check failed (attempt $attempt) - HTTP: $http_code, Body: $body"
            if [ $attempt -lt $MAX_RETRIES ]; then
                log_message "Waiting ${RETRY_DELAY}s before retry..."
                sleep "$RETRY_DELAY"
            fi
        fi
        attempt=$((attempt + 1))
    done
    
    if [ "$success" = false ]; then
        log_message "Health check failed after $MAX_RETRIES attempts"
        $CURL -s "$UPTIME_KUMA_PUSH_URL?status=down&msg=Health+check+failed&ping=0" > /dev/null
        return 1
    fi
    
    return 0
}

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Run health check
check_jellyfin 