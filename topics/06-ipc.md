# Topic 6: Interprocess Communication (IPC)

**Status**: ✅ Ready to Learn  
**Duration**: 3-4 hours  
**Prerequisites**: [Topic 5: File Operations](05-file-operations.md)  
**Next Topic**: [Topic 7: Error Handling (Coming Soon)](07-error-handling.md)

---

## Table of Contents

- [What Is IPC?](#what-is-ipc)
- [Background Processes](#background-processes)
- [Process Management](#process-management)
- [Signals](#signals)
- [Named Pipes (FIFOs)](#named-pipes-fifos)
- [Process Communication](#process-communication)
- [Your Library Project](#your-library-project)
- [Practice Exercises](#practice-exercises)
- [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)

---

## What Is IPC?

**IPC (Interprocess Communication)** allows separate processes to communicate with each other. For your library project:

- **bootstrap.sh** starts library processes
- **user.sh** sends requests to libraries
- **manage.sh** queries library status
- Libraries communicate with each other

This requires IPC mechanisms!

### IPC Methods

| Method | Use Case |
|--------|----------|
| **Pipes** | Pass data between processes in same session |
| **Named Pipes (FIFOs)** | Persistent communication between processes |
| **Signals** | Send notifications to processes |
| **Files** | Simple read/write coordination |
| **Message Queues** | Structured message passing |
| **Sockets** | Network communication |

---

## Background Processes

### Running Process in Background

```bash
#!/bin/bash

# Run command in background
command &

# Example: Start library process
./library 1 &

# Example: Start multiple libraries
./library 1 &
./library 2 &
./library 3 &
```

### Wait for Background Processes

```bash
#!/bin/bash

# Start processes
./library 1 &
pid1=$!

./library 2 &
pid2=$!

# Wait for specific process
wait $pid1

# Wait for all background processes
wait

# Get exit status
wait $pid1
status=$?
```

### Example: bootstrap.sh Pattern

```bash
#!/bin/bash

num_libraries=$1

# Start N library processes
for i in $(seq 1 $num_libraries); do
    ./library $i $num_libraries catalog$i.csv &
    echo "Started library $i (PID: $!)"
done

# Wait for all to start
sleep 2

# Display running processes
echo "Running libraries:"
ps aux | grep "./library" | grep -v grep

# Wait for all processes
wait
echo "All libraries stopped"
```

---

## Process Management

### Check Running Processes

```bash
#!/bin/bash

# List all processes with "library" in name
ps aux | grep library | grep -v grep

# Count running libraries
ps aux | grep "./library" | grep -v grep | wc -l

# Get PID of process
pgrep -f "./library 1"
```

### Get Process ID

```bash
#!/bin/bash

# Get PID of last background process
./library 1 &
pid=$!
echo "Library 1 started with PID: $pid"

# Store multiple PIDs
./library 1 &
lib1_pid=$!

./library 2 &
lib2_pid=$!

echo "Library 1: $lib1_pid"
echo "Library 2: $lib2_pid"
```

### Foreground vs Background

```bash
#!/bin/bash

# Foreground (wait for completion)
./slow_process
echo "Done waiting"

# Background (continue immediately)
./slow_process &
echo "Process started"

# Can continue with other tasks
./another_process
```

---

## Signals

### Send Signals to Processes

```bash
#!/bin/bash

# Send SIGTERM (graceful stop)
kill $pid

# Send SIGKILL (force stop)
kill -9 $pid

# Send SIGUSR1 (custom signal)
kill -SIGUSR1 $pid

# Kill by process name
pkill -f "library"
```

### Common Signals

| Signal | Number | Meaning |
|--------|--------|---------|
| SIGTERM | 15 | Terminate gracefully |
| SIGKILL | 9 | Force kill (can't ignore) |
| SIGSTOP | 19 | Pause process |
| SIGCONT | 18 | Resume process |
| SIGUSR1 | 10 | User-defined |
| SIGUSR2 | 12 | User-defined |

### Trap Signals in Script

```bash
#!/bin/bash

# Handle cleanup on exit
trap cleanup EXIT

cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/library_*.fifo
    pkill -f "./library"
}

# Your code here
./library 1 &

# Cleanup will run when script exits
```

### Example: manage.sh Pattern

```bash
#!/bin/bash

operation=$1

case $operation in
    stop)
        echo "Stopping all libraries..."
        pkill -f "./library"
        wait
        echo "All libraries stopped"
        ;;
    status)
        echo "Running libraries:"
        ps aux | grep "./library" | grep -v grep | wc -l
        ;;
    *)
        echo "Usage: $0 {stop|status}"
        ;;
esac
```

---

## Named Pipes (FIFOs)

A **FIFO** (First In, First Out) is a named pipe that processes can read from and write to.

### Create FIFO

```bash
#!/bin/bash

# Create named pipe
mkfifo /tmp/library_1.fifo

# Write to FIFO (in background)
echo "borrow alice 1984" > /tmp/library_1.fifo &

# Read from FIFO (in another process/terminal)
cat < /tmp/library_1.fifo

# Delete FIFO
rm /tmp/library_1.fifo
```

### FIFO Communication Pattern

```bash
#!/bin/bash

# Create FIFO for library
library_fifo="/tmp/library_1.fifo"
mkfifo "$library_fifo"

# Library process (reads requests)
{
    while read request; do
        echo "Library received: $request"
        response="OK"
        echo "$response" > /tmp/library_1_response.fifo
    done
} < "$library_fifo" &

library_pid=$!

# Client sends request
echo "borrow alice 1984" > "$library_fifo"

# Wait for response
response=$(cat < /tmp/library_1_response.fifo)
echo "Response: $response"

# Cleanup
kill $library_pid
rm "$library_fifo" /tmp/library_1_response.fifo
```

### Example: User Requests to Library

```bash
#!/bin/bash
# user.sh pattern

library_id=$1
username=$2
operation=$3
book=$4

request_fifo="/tmp/library_${library_id}_request.fifo"
response_fifo="/tmp/library_${library_id}_response_$$.fifo"

# Create response FIFO for this request
mkfifo "$response_fifo"

# Send request
echo "$username|$operation|$book" > "$request_fifo"

# Wait for response (with timeout)
timeout 5 cat "$response_fifo"
status=$?

# Cleanup
rm "$response_fifo"

exit $status
```

---

## Process Communication

### File-Based Communication

```bash
#!/bin/bash

# Library writes status to file
echo "books_available=100" > /tmp/library_1.status

# Manager reads status
source /tmp/library_1.status
echo "Library 1 has $books_available books"
```

### Signal-Based Status Dump

```bash
#!/bin/bash
# Library process

library_id=1
status_file="/tmp/library_${library_id}.status"

# Handle SIGUSR1 - dump status
trap "dump_status" SIGUSR1

dump_status() {
    {
        echo "pid=$$"
        echo "library_id=$library_id"
        echo "books_available=100"
        echo "users_registered=5"
        date
    } > "$status_file"
}

# Main loop
while true; do
    sleep 1
done
```

In manage.sh:
```bash
#!/bin/bash

library_pid=$(pgrep -f "./library 1")

if [ -n "$library_pid" ]; then
    # Send SIGUSR1 signal
    kill -SIGUSR1 $library_pid
    
    # Wait a moment for status to be written
    sleep 1
    
    # Read status
    cat /tmp/library_1.status
fi
```

### Pipe-Based Communication

```bash
#!/bin/bash

# Parent process
{
    echo "request 1"
    echo "request 2"
    echo "request 3"
} | while read request; do
    # Process each request
    echo "Processing: $request"
done
```

---

## Your Library Project

### Architecture with IPC

```
bootstrap.sh
    ├── Start library 1 (background process)
    ├── Start library 2 (background process)
    └── Start library 3 (background process)

user.sh
    ├── Send borrow request to library via FIFO
    └── Wait for response

manage.sh
    ├── Send SIGUSR1 to libraries to dump status
    ├── Read status files
    └── Display results
```

### bootstrap.sh with IPC

```bash
#!/bin/bash

num_libraries=$1
books_file=$2

# Create catalog files
while IFS=',' read -r title author year; do
    # Distribute books to libraries
    lib_id=$(( (${#title} % num_libraries) + 1 ))
    echo "$title,$author,$year" >> "catalog_$lib_id.csv"
done < "$books_file"

# Start libraries with FIFOs
for i in $(seq 1 $num_libraries); do
    mkfifo "/tmp/library_${i}_request.fifo"
    mkfifo "/tmp/library_${i}_response.fifo"
    
    ./library $i $num_libraries "catalog_$i.csv" &
    echo "Started library $i (PID: $!)"
done

wait
```

### user.sh with IPC

```bash
#!/bin/bash

username=$1
library_id=$2
operation=$3
book=$4

request_fifo="/tmp/library_${library_id}_request.fifo"
response_fifo="/tmp/library_${library_id}_response.fifo"

# Send request
echo "$username|$operation|$book" > "$request_fifo"

# Wait for response
response=$(cat < "$response_fifo")

if [ "$response" = "OK" ]; then
    echo "Operation successful"
    exit 0
else
    echo "Operation failed: $response"
    exit 1
fi
```

### manage.sh with IPC

```bash
#!/bin/bash

operation=$1

case $operation in
    status)
        echo "=== Library Status ==="
        for pid in $(pgrep -f "./library"); do
            kill -SIGUSR1 $pid 2>/dev/null
        done
        sleep 1
        for status_file in /tmp/library_*.status; do
            if [ -f "$status_file" ]; then
                echo "--- $(basename $status_file) ---"
                cat "$status_file"
            fi
        done
        ;;
    stop)
        echo "Stopping all libraries..."
        pkill -f "./library"
        wait
        rm -f /tmp/library_*.fifo /tmp/library_*.status
        echo "Cleanup complete"
        ;;
esac
```

---

## Practice Exercises

### Exercise 6.1: Background Processes

**Description**: Start multiple background processes and manage them.

**Solution**:
```bash
#!/bin/bash

# Start background processes
for i in {1..3}; do
    (
        for j in {1..5}; do
            echo "Process $i: iteration $j"
            sleep 1
        done
    ) &
    pids[$i]=$!
done

# Wait for all
echo "Waiting for processes to complete..."
for pid in "${pids[@]}"; do
    wait $pid
done

echo "All done"
```

---

### Exercise 6.2: Signals and Cleanup

**Description**: Create a process that handles signals gracefully.

**Solution**:
```bash
#!/bin/bash

# Create temp file
temp_file="/tmp/process_temp_$$"

# Handle cleanup on exit
cleanup() {
    echo "Cleaning up..."
    rm -f "$temp_file"
    exit 0
}

trap cleanup SIGTERM SIGINT

# Main loop
echo "Process running (PID: $$)"
while true; do
    echo "$(date)" >> "$temp_file"
    sleep 1
done
```

Test:
```bash
./script.sh &
kill $!  # Send SIGTERM
```

---

### Exercise 6.3: Create and Use FIFO

**Description**: Create a FIFO and communicate between processes.

**Solution**:
```bash
#!/bin/bash

fifo="/tmp/test.fifo"

# Create FIFO
mkfifo "$fifo"

# Writer (background)
{
    sleep 1
    echo "Message 1"
    sleep 1
    echo "Message 2"
    sleep 1
    echo "Message 3"
} > "$fifo" &

writer_pid=$!

# Reader
{
    while read line; do
        echo "Received: $line"
    done
} < "$fifo"

wait $writer_pid
rm "$fifo"
```

---

### Exercise 6.4: Simple Library Communication

**Description**: Simulate user.sh sending request to library.sh via FIFO.

**Solution**:
```bash
#!/bin/bash

lib_fifo="/tmp/library.fifo"

# Create FIFO
mkfifo "$lib_fifo"

# Library process (in background)
{
    echo "Library started (PID: $$)"
    while read request; do
        echo "Library processed: $request"
    done
} < "$lib_fifo" &

lib_pid=$!

# User sends request
sleep 1
echo "borrow alice 1984" > "$lib_fifo"

sleep 1
echo "return alice 1984" > "$lib_fifo"

# Cleanup
sleep 1
kill $lib_pid 2>/dev/null
rm "$lib_fifo"
```

---

### Exercise 6.5: Process Status with Signals

**Description**: Use signals to get process status.

**Solution**:
```bash
#!/bin/bash

status_file="/tmp/process.status"
pid_file="/tmp/process.pid"

# Process that dumps status on SIGUSR1
process_main() {
    trap "dump_status" SIGUSR1
    
    dump_status() {
        {
            echo "PID: $$"
            echo "Time: $(date)"
            echo "Memory: $(ps -o rss= -p $$) KB"
            echo "CPU: $(ps -o %cpu= -p $$)%"
        } > "$status_file"
    }
    
    echo $$ > "$pid_file"
    
    while true; do
        sleep 1
    done
}

# Start process
process_main &

sleep 1

# Request status
pid=$(cat "$pid_file")
kill -SIGUSR1 $pid

sleep 1

# Read status
echo "=== Process Status ==="
cat "$status_file"

# Cleanup
kill $pid 2>/dev/null
rm "$pid_file" "$status_file"
```

---

### Challenge Exercise: Multi-Library System

**Description**: Create complete bootstrap, user, and manage scripts with IPC.

**Requirements**:
- bootstrap.sh starts N libraries with FIFOs
- user.sh sends requests and gets responses
- manage.sh queries status and stops libraries
- Use signals for status dumps

**Starter Code**:
```bash
#!/bin/bash
# bootstrap.sh

num_libraries=${1:-2}

# Create catalogs
for i in $(seq 1 $num_libraries); do
    echo "library_id=$i" > "catalog_$i.csv"
done

# Create FIFOs and start libraries
for i in $(seq 1 $num_libraries); do
    mkfifo "/tmp/lib_${i}_req.fifo" 2>/dev/null
    mkfifo "/tmp/lib_${i}_res.fifo" 2>/dev/null
    
    ./library.sh $i > "/tmp/lib_${i}.log" 2>&1 &
    echo "$!" > "/tmp/lib_${i}.pid"
done

echo "Started $num_libraries libraries"
wait
```

```bash
#!/bin/bash
# user.sh

library_id=$1
username=$2
operation=$3
book=$4

req_fifo="/tmp/lib_${library_id}_req.fifo"
res_fifo="/tmp/lib_${library_id}_res.fifo"

# Send request
echo "$username|$operation|$book" > "$req_fifo"

# Read response
timeout 5 cat < "$res_fifo"
```

```bash
#!/bin/bash
# manage.sh

operation=$1

case $operation in
    status)
        for i in {1..10}; do
            if [ -f "/tmp/lib_${i}.pid" ]; then
                pid=$(cat "/tmp/lib_${i}.pid")
                if kill -0 $pid 2>/dev/null; then
                    echo "Library $i: running (PID $pid)"
                fi
            fi
        done
        ;;
    stop)
        for i in {1..10}; do
            if [ -f "/tmp/lib_${i}.pid" ]; then
                pid=$(cat "/tmp/lib_${i}.pid")
                kill $pid 2>/dev/null
            fi
        done
        rm -f /tmp/lib_*.fifo /tmp/lib_*.pid
        ;;
esac
```

---

## Common Pitfalls

### ❌ Pitfall 1: Forgetting to Clean Up FIFOs

**Wrong**:
```bash
mkfifo "/tmp/lib.fifo"
# Script exits without removing FIFO
```

**Right**:
```bash
mkfifo "/tmp/lib.fifo"
trap "rm -f /tmp/lib.fifo" EXIT
```

---

### ❌ Pitfall 2: Not Waiting for Processes

**Wrong**:
```bash
./library 1 &
./library 2 &
echo "Done"  # Exits before libraries finish
```

**Right**:
```bash
./library 1 &
./library 2 &
wait
echo "Done"
```

---

### ❌ Pitfall 3: FIFO Deadlock

**Wrong**:
```bash
# Writer blocks because no reader
echo "message" > /tmp/fifo.fifo
```

**Right**:
```bash
# Reader in background first
cat < /tmp/fifo.fifo &
echo "message" > /tmp/fifo.fifo
```

---

### ❌ Pitfall 4: Not Handling Timeouts

**Wrong**:
```bash
# Waits forever if response never comes
response=$(cat < /tmp/response.fifo)
```

**Right**:
```bash
# Timeout after 5 seconds
response=$(timeout 5 cat < /tmp/response.fifo)
if [ $? -eq 124 ]; then
    echo "Timeout waiting for response"
fi
```

---

### ❌ Pitfall 5: Unused PIDs

**Wrong**:
```bash
./library 1 &
# PID is lost
```

**Right**:
```bash
./library 1 &
pid=$!
echo "Started with PID: $pid"
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **Background processes** | `&` runs in background, `wait` waits for completion |
| **Process management** | `ps`, `pgrep`, `kill` to manage processes |
| **Signals** | SIGTERM, SIGKILL, SIGUSR1 for inter-process signaling |
| **Named pipes** | `mkfifo` for persistent process communication |
| **PID management** | Capture and use `$!` and `$pid` |
| **Cleanup** | `trap` for graceful exit and resource cleanup |

### You Can Now

✅ Start and manage background processes  
✅ Send signals to processes  
✅ Create and use named pipes  
✅ Coordinate multiple processes  
✅ Build distributed systems  
✅ Handle process cleanup gracefully  

### For Your Library Project

**bootstrap.sh**:
- Start library processes in background
- Create FIFOs for communication
- Wait for all to finish

**user.sh**:
- Send requests via FIFO
- Wait for responses
- Handle timeouts

**manage.sh**:
- Query process status
- Send signals for status dumps
- Gracefully stop libraries

---

## Quick Reference

```bash
# Background processes
command &
pid=$!
wait $pid
wait  # Wait for all

# Process management
ps aux | grep process
pgrep -f "pattern"
pkill -f "pattern"

# Signals
kill $pid              # SIGTERM
kill -9 $pid          # SIGKILL
kill -SIGUSR1 $pid    # Custom signal
trap "cleanup" EXIT   # Handle cleanup

# Named pipes
mkfifo /tmp/fifo.fifo
echo "data" > /tmp/fifo.fifo
cat < /tmp/fifo.fifo
rm /tmp/fifo.fifo

# Timeouts
timeout 5 command
if [ $? -eq 124 ]; then echo "Timeout"; fi
```

---

**Ready to move on?** Go to [Topic 7: Error Handling](#) 🚀

**Need to review Topic 5?** Go back to [Topic 5: File Operations](05-file-operations.md)
