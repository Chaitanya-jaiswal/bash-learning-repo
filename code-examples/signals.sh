#!/bin/bash
# Signals Example

temp_file="/tmp/signal_demo_$$"

cleanup() {
    echo ""
    echo "Cleanup: Removing temporary files..."
    rm -f "$temp_file"
    echo "Cleanup complete"
    exit 0
}

trap cleanup SIGTERM SIGINT EXIT

echo "=== Signals and Cleanup ==="
echo "Process PID: $$"
echo ""

status_handler() {
    echo ""
    echo "=== Status Dump ==="
    echo "Current time: $(date)"
    echo "Process: $$"
    echo "Lines written: $(wc -l < "$temp_file" 2>/dev/null || echo 0)"
}

trap status_handler SIGUSR1

echo "Running process (Ctrl+C to exit or kill -SIGUSR1 $$ for status)"
echo ""

count=0
while [ $count -lt 10 ]; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Iteration $count" >> "$temp_file"
    count=$((count + 1))
    sleep 1
done

echo "Process completed normally"
