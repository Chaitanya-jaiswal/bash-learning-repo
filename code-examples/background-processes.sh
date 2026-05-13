#!/bin/bash
# Background Processes Example

echo "=== Background Processes ==="
echo ""

sleep 10 &
pid1=$!
echo "Process 1 started (PID: $pid1)"

sleep 10 &
pid2=$!
echo "Process 2 started (PID: $pid2)"

sleep 2
echo "Running processes:"
ps aux | grep "sleep" | grep -v grep

kill $pid1
sleep 1

echo "Waiting for process 2..."
wait $pid2
echo "Process 2 completed"

echo ""
echo "=== Multiple processes ==="
for i in {1..3}; do
    (
        echo "Process $i starting"
        sleep 2
        echo "Process $i done"
    ) &
done

echo "Waiting for all..."
wait
echo "All done"
