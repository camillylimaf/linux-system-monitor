#!/bin/bash

LOG_FILE="logs/system-monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "========================================"
echo "       LINUX SYSTEM MONITOR"
echo "========================================"

echo ""
echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Uptime: $(uptime -p)"

echo ""

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEMORY=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
DISK=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

echo ""
echo "TOP 5 PROCESSES BY CPU:"
ps aux --sort=-%cpu | head -n 6


echo "CPU Usage:       ${CPU}%"
echo "Memory Usage:    ${MEMORY}%"
echo "Disk Usage:      ${DISK}%"

echo "$TIMESTAMP | CPU: ${CPU}% | RAM: ${MEMORY}% | DISK: ${DISK}%" >> "$LOG_FILE"

if (( $(echo "$CPU >= 80" | bc -l) )); then
    echo "WARNING: CPU usage is high!"
fi

if [ "$MEMORY" -ge 80 ]; then
    echo "WARNING: Memory usage is high!"
fi

if [ "$DISK" -ge 80 ]; then
    echo "WARNING: Disk usage is high!"
fi


echo ""

STATUS="OK"

if (( $(echo "$CPU >= 80" | bc -l) )); then
    echo "WARNING: CPU usage is high!"
    STATUS="WARNING"
fi

if [ "$MEMORY" -ge 80 ]; then
    echo "WARNING: Memory usage is high!"
    STATUS="WARNING"
fi

if [ "$DISK" -ge 80 ]; then
    echo "WARNING: Disk usage is high!"
    STATUS="WARNING"
fi

echo ""
echo "STATUS: SYSTEM $STATUS"

echo ""
echo "========================================"
