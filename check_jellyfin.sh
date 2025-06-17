#!/bin/bash

# Configuration
JELLYFIN_URLS=(
    "http://192.168.0.182:8096/health"  # Local network
    "http://100.91.157.19:8096/health"  # Tailscale
)
UPTIME_KUMA_PUSH_URL="http://100.91.157.19:3001/api/push/FsDZQkf7na"
TIMEOUT=5
MAX_RETRIES=2
RETRY_DELAY=10
LOG_FILE="/var/log/jellyfin/health_check.log"
LOG_MAX_SIZE=10485760  # 10MB in bytes
LOG_ROTATE_COUNT=5

# Ensure we have required tools
command -v curl >/dev/null 2>&1 || { echo "curl is required but not installed. Aborting." >&2; exit 1; }
command -v date >/dev/null 2>&1 || { echo "date is required but not installed. Aborting." >&2; exit 1; }

# Rotate log if it exceeds max size
rotate_log() {
    if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE") -gt $LOG_MAX_SIZE ]; then
        for i in $(seq $((LOG_ROTATE_COUNT-1)) -1 1); do
            [ -f "${LOG_FILE}.$i" ] && mv "${LOG_FILE}.$i" "${LOG_FILE}.$((i+1))"
        done
        [ -f "$LOG_FILE" ] && mv "$LOG_FILE" "${LOG_FILE}.1"
    fi
}

log_message() {
    local level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

check_jellyfin_endpoint() {
    local url="$1"
    local attempt=1
    local success=false
    local start_time
    local end_time
    local response_time
    
    while [ $attempt -le $MAX_RETRIES ] && [ "$success" = false ]; do
        start_time=$(date +%s%N)
        response=$(curl -s -w "%{http_code}" --max-time $TIMEOUT "$url" 2>&1)
        curl_status=$?
        end_time=$(date +%s%N)
        response_time=$(( (end_time - start_time) / 1000000 )) # Convert to milliseconds
        
        if [ $curl_status -ne 0 ]; then
            log_message "ERROR" "Curl failed for $url (attempt $attempt) - Exit code: $curl_status"
            attempt=$((attempt + 1))
            [ $attempt -le $MAX_RETRIES ] && sleep "$RETRY_DELAY"
            continue
        fi
        
        http_code=${response: -3}
        body=${response:0:${#response}-3}
        
        if [ "$http_code" = "200" ] && [ "$body" = "Healthy" ]; then
            success=true
            log_message "INFO" "Health check successful for $url (attempt $attempt) - Response time: ${response_time}ms"
            return 0
        else
            log_message "WARN" "Health check failed for $url (attempt $attempt) - HTTP: $http_code, Body: $body"
            [ $attempt -lt $MAX_RETRIES ] && {
                log_message "INFO" "Waiting ${RETRY_DELAY}s before retry..."
                sleep "$RETRY_DELAY"
            }
        fi
        attempt=$((attempt + 1))
    done
    
    return 1
}

main() {
    # Ensure log directory exists
    mkdir -p "$(dirname "$LOG_FILE")"
    rotate_log
    
    log_message "INFO" "Starting Jellyfin health check"
    
    local success=false
    local fastest_response=999999
    
    # Try all endpoints
    for url in "${JELLYFIN_URLS[@]}"; do
        if check_jellyfin_endpoint "$url"; then
            success=true
            response_time=$((end_time - start_time))
            [ $response_time -lt $fastest_response ] && fastest_response=$response_time
        fi
    done
    
    if [ "$success" = true ]; then
        log_message "INFO" "At least one endpoint is healthy. Sending success to Uptime Kuma"
        curl -s "$UPTIME_KUMA_PUSH_URL?status=up&msg=Healthy&ping=${fastest_response}" > /dev/null
        exit 0
    else
        log_message "ERROR" "All endpoints failed health check"
        curl -s "$UPTIME_KUMA_PUSH_URL?status=down&msg=All+endpoints+failed&ping=0" > /dev/null
        exit 1
    fi
}

# Run the main function
main 