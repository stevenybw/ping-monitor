#!/bin/bash

LOG_DIR="/var/log/ping-monitor"
LOG_FILE="$LOG_DIR/ping.log"
HOSTS=("8.8.8.8" "1.1.1.1" "google.com" "baidu.com")

mkdir -p "$LOG_DIR"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    for HOST in "${HOSTS[@]}"; do
        PING_RESULT=$(ping -c 1 -W 2 "$HOST" 2>/dev/null)
        if [ $? -eq 0 ]; then
            RTT=$(echo "$PING_RESULT" | grep 'time=' | sed -E 's/.*time=([0-9.]+) ms.*/\1/')
            echo "$TIMESTAMP - $HOST - OK - ${RTT}ms" >> "$LOG_FILE"
        else
            echo "$TIMESTAMP - $HOST - FAIL" >> "$LOG_FILE"
        fi
    done
    sleep 10
done

