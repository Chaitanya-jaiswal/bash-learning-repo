# Exercise Set 6: Interprocess Communication (IPC)

**Topic**: IPC (Signals, Background Processes, FIFOs)  
**Difficulty**: ⭐⭐⭐⭐ (Advanced)  
**Time**: 90-120 minutes  
**Prerequisites**: Complete [Topic 5](../topics/05-file-operations.md) and read [Topic 6](../topics/06-ipc.md)

---

## Instructions

1. **Create a new directory**:
   ```bash
   mkdir -p ~/bash-exercises/set-6
   cd ~/bash-exercises/set-6
   ```

2. **For each exercise**:
   - Read the description
   - Write your scripts
   - Test with multiple processes
   - Handle cleanup properly

3. **Important**: Always clean up temporary files and processes!

---

## Exercise 6.1: Start and Wait for Background Processes

**Description**: Create a script that starts multiple background processes and manages them.

**Requirements**:
- Accept number of processes as argument
- Start N background processes
- Track each PID
- Wait for all to complete
- Display completion status

**Solution**:
```bash
#!/bin/bash

num_processes=${1:-3}

if [ $num_processes -le 0 ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

pids=()

echo "Starting $num_processes background processes..."

for i in $(seq 1 $num_processes); do
    (
        duration=$((RANDOM % 5 + 1))
        echo "Process $i: Starting (will run for ${duration}s)"
        sleep $duration
        echo "Process $i: Completed"
    ) &
    
    pids+=($!)
    echo "Process $i started with PID: $!"
done

echo ""
echo "Waiting for all processes..."
for pid in "${pids[@]}"; do
    wait $pid
    status=$?
    echo "Process $pid exited with status: $status"
done

echo "All processes completed"
```

**Test**:
```bash
./exercise-6-1.sh 3
```

---

## Exercise 6.2: Signal Handling

**Description**: Create a process that handles signals gracefully.

**Requirements**:
- Handle SIGTERM and SIGINT
- Clean up resources on exit
- Log signal received
- Show status before exit

**Solution**:
```bash
#!/bin/bash

work_file="/tmp/exercise_6_2_$$.work"

# Setup cleanup
cleanup() {
    echo ""
    echo "[$(date '+%H:%M:%S')] Received signal, cleaning up..."
    
    # Remove work files
    rm -f "$work_file"
    
    # Kill any child processes
    jobs -p | xargs kill 2>/dev/null
    
    echo "[$(date '+%H:%M:%S')] Cleanup complete, exiting"
    exit 0
}

# Register handlers
trap cleanup SIGTERM SIGINT

# Track work
echo "Process started (PID: $$)"
echo "Press Ctrl+C to stop" 
echo ""

count=0
while true; do
    count=$((count + 1))
    echo "[$(date '+%H:%M:%S')] Working... (iteration $count)"
    echo "Work item $count" >> "$work_file"
    sleep 1
done
```

**Test**:
```bash
./exercise-6-2.sh
# Press Ctrl+C after a few seconds
```

---

## Exercise 6.3: Create and Use FIFO

**Description**: Create a FIFO and communicate between two processes.

**Requirements**:
- Create named pipe
- One process writes requests
- Another reads and responds
- Handle cleanup

**Solution**:
```bash
#!/bin/bash

fifo="/tmp/exercise_6_3.fifo"

# Cleanup
cleanup() {
    rm -f "$fifo"
}

trap cleanup EXIT

# Create FIFO
mkfifo "$fifo"
echo "Created FIFO: $fifo"

# Reader process (background)
{
    echo "Reader: Waiting for messages..."
    while read message; do
        echo "Reader: Got '$message'"
        if [ "$message" = "QUIT" ]; then
            break
        fi
    done
} < "$fifo" &

reader_pid=$!

# Writer process
sleep 1
for msg in "Hello" "Test" "Message" "QUIT"; do
    echo "Writer: Sending '$msg'"
    echo "$msg" > "$fifo"
    sleep 0.5
done

wait $reader_pid
echo "Communication complete"
```

---

## Exercise 6.4: Request-Response with FIFO

**Description**: Simulate client-server with FIFOs (like user.sh and library).

**Requirements**:
- Server listens on request FIFO
- Client sends requests
- Server sends responses
- Multiple requests/responses

**Solution**:
```bash
#!/bin/bash

work_dir="/tmp/exercise_6_4_$$"
mkdir -p "$work_dir"

req_fifo="$work_dir/request.fifo"
res_fifo="$work_dir/response.fifo"

cleanup() {
    rm -rf "$work_dir"
}

trap cleanup EXIT

mkfifo "$req_fifo"
mkfifo "$res_fifo"

# Server
{
    echo "Server: Ready"
    while read request; do
        if [ "$request" = "STOP" ]; then
            break
        fi
        
        # Process request
        echo "Server: Processing '$request'"
        response="ACK:$request"
        
        # Send response
        echo "$response" > "$res_fifo"
    done
    echo "Server: Stopped"
} < "$req_fifo" &

server_pid=$!

# Client
sleep 0.5
for req in "request1" "request2" "request3"; do
    echo "Client: Sending '$req'"
    echo "$req" > "$req_fifo"
    
    # Wait for response
    res=$(timeout 2 cat < "$res_fifo")
    echo "Client: Received '$res'"
    sleep 0.5
done

# Stop server
echo "Client: Stopping server"
echo "STOP" > "$req_fifo"

wait $server_pid
echo "Done"
```

---

## Exercise 6.5: Process Pool Management

**Description**: Create a pool of background workers managed by coordinator.

**Requirements**:
- Start N worker processes
- Track all PIDs
- Monitor and report status
- Graceful shutdown

**Solution**:
```bash
#!/bin/bash

num_workers=${1:-3}
status_file="/tmp/exercise_6_5_status.txt"

worker_process() {
    local id=$1
    local pid=$$
    
    echo "$id:$pid:running" >> "$status_file"
    
    for i in {1..5}; do
        echo "Worker $id: Task $i"
        sleep 1
    done
    
    echo "$id:$pid:done" >> "$status_file"
}

# Setup
rm -f "$status_file"

# Start workers
pids=()
for w in $(seq 1 $num_workers); do
    worker_process $w &
    pids+=($!)
    echo "Started worker $w (PID: $!)"
done

# Monitor workers
echo ""
echo "Monitoring workers..."
sleep 3

echo ""
echo "Worker status:"
if [ -f "$status_file" ]; then
    cat "$status_file"
fi

# Wait for all
wait
echo ""
echo "All workers completed"

# Cleanup
rm -f "$status_file"
```

---

## Challenge Exercise: Mini Library System with IPC

**Description**: Create bootstrap, user, and library scripts with FIFO communication.

**Requirements**:
- bootstrap.sh: Start 2 library processes with FIFOs
- library.sh: Service listening on FIFO, handle requests
- user.sh: Send borrow/search requests to library
- manage.sh: Stop all libraries gracefully

**File: bootstrap.sh**:
```bash
#!/bin/bash

num_libs=2
work_dir="/tmp/mini_library_$$"
mkdir -p "$work_dir"

# Create catalogs
cat > "$work_dir/catalog_1.csv" << EOF
1984,Orwell,1949
Alice,Carroll,1865
EOF

cat > "$work_dir/catalog_2.csv" << EOF
Gatsby,Fitzgerald,1925
Brave,Huxley,1932
EOF

# Create FIFOs and start libraries
for i in $(seq 1 $num_libs); do
    mkfifo "$work_dir/lib_${i}_req.fifo" 2>/dev/null
    mkfifo "$work_dir/lib_${i}_res.fifo" 2>/dev/null
    
    ./library.sh $i "$work_dir/catalog_${i}.csv" \
        "$work_dir/lib_${i}_req.fifo" \
        "$work_dir/lib_${i}_res.fifo" &
    
    echo "Started library $i (PID: $!)"
done

echo ""
echo "Libraries running. Press Ctrl+C to stop."

# Cleanup on exit
trap "pkill -P $$; rm -rf $work_dir" EXIT

wait
```

**File: library.sh**:
```bash
#!/bin/bash

lib_id=$1
catalog=$2
req_fifo=$3
res_fifo=$4

echo "Library $lib_id: Started"

while read request; do
    action=$(echo "$request" | cut -d'|' -f1)
    book=$(echo "$request" | cut -d'|' -f2)
    
    if [ "$action" = "search" ]; then
        if grep -q "^$book," "$catalog" 2>/dev/null; then
            echo "FOUND" > "$res_fifo"
        else
            echo "NOT_FOUND" > "$res_fifo"
        fi
    elif [ "$action" = "quit" ]; then
        break
    fi
done < "$req_fifo"

echo "Library $lib_id: Stopped"
```

**File: user.sh**:
```bash
#!/bin/bash

lib_id=$1
action=$2
book=$3

work_dir=$(dirname $(ls -t /tmp/mini_library_*/lib_${lib_id}_req.fifo 2>/dev/null | head -1))

if [ -z "$work_dir" ]; then
    echo "Error: Library not found"
    exit 1
fi

req_fifo="$work_dir/lib_${lib_id}_req.fifo"
res_fifo="$work_dir/lib_${lib_id}_res.fifo"

# Send request
echo "$action|$book" > "$req_fifo"

# Get response
timeout 2 cat < "$res_fifo"
```

**Usage**:
```bash
./bootstrap.sh  # Start libraries

# In another terminal:
./user.sh 1 search "1984"     # FOUND
./user.sh 1 search "NonExistent"  # NOT_FOUND
./user.sh 2 search "Gatsby"   # FOUND
```

---

## Completion Checklist

- [ ] Exercise 6.1: Background Processes ✓
- [ ] Exercise 6.2: Signal Handling ✓
- [ ] Exercise 6.3: Create FIFO ✓
- [ ] Exercise 6.4: Request-Response ✓
- [ ] Exercise 6.5: Process Pool ✓
- [ ] Challenge: Mini Library System ✓

---

## Testing Tips

```bash
# Test background processes
./exercise-6-1.sh 5

# Test signal handling
./exercise-6-2.sh
# Send signals: Ctrl+C, or from another terminal: kill -TERM <pid>

# Test FIFOs
./exercise-6-3.sh
./exercise-6-4.sh

# Monitor processes
ps aux | grep exercise

# Check FIFOs
ls -la /tmp/*.fifo
```

---

## Next Steps

Once completed:
1. Review solutions
2. Understand FIFO communication pattern
3. Apply to your library project
4. Move to **Topic 7: Error Handling**

---

**Difficulty**: ⭐⭐⭐⭐ (Advanced - Process management)

**Time**: 90-120 minutes

**When Ready**: [Go to Topic 7 →](../topics/07-error-handling.md)
