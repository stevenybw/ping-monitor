#!/bin/bash

LOG_DIR="/var/log/ping-monitor"
LOG_FILE="$LOG_DIR/ping.log"
HOSTS=("8.8.8.8" "1.1.1.1" "google.com" "baidu.com")

mkdir -p "$LOG_DIR"

# 获取 Wi-Fi SSID（在 WSL 中）
get_ssid_if_wifi() {
    SSID=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0//powershell.exe -Command "(netsh wlan show interfaces) -match '^\s*SSID\s*:'" \
        | tr -d '\r' \
        | tr -s ' ' \
        | cut -d ' ' -f 4)
    echo "$SSID"
}

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    for HOST in "${HOSTS[@]}"; do
        TARGET_IP=$(getent ahosts "$HOST" | awk '{ print $1; exit }')
        IFACE=$(ip route get "$TARGET_IP" 2>/dev/null | grep -oP 'dev \K\S+')
        IFACE_IP=$(ip -o -4 addr show dev "$IFACE" 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

        # 如果是 eth0（WSL 默认接口），尝试取 SSID
        SSID=""
        if [[ "$IFACE" == "eth0" ]]; then
            SSID=$(get_ssid_if_wifi)
        fi

        PING_RESULT=$(ping -c 1 -W 2 "$HOST" 2>/dev/null)
        if [ $? -eq 0 ]; then
            RTT=$(echo "$PING_RESULT" | grep 'time=' | sed -E 's/.*time=([0-9.]+) ms.*/\1/')
            echo "$TIMESTAMP - $HOST ($TARGET_IP) - OK - ${RTT}ms - IFACE=$IFACE - IFACE_IP=${IFACE_IP:-N/A} - SSID=${SSID:-N/A}" >> "$LOG_FILE"
        else
            echo "$TIMESTAMP - $HOST ($TARGET_IP) - FAIL - IFACE=$IFACE - IFACE_IP=${IFACE_IP:-N/A} - SSID=${SSID:-N/A}" >> "$LOG_FILE"
        fi
    done
    sleep 10
done