#!/bin/bash
# Named Pipes (FIFO) Example

echo "=== Named Pipes (FIFO) Example ==="
echo ""

fifo_dir="/tmp/ipc_demo_$$"
mkdir -p "$fifo_dir"

cleanup() {
    rm -rf "$fifo_dir"
}

trap cleanup EXIT

# Example 1: Simple FIFO
echo "--- Example 1: Simple FIFO ---"
fifo1="$fifo_dir/simple.fifo"
mkfifo "$fifo1"

{
    echo "Message 1"
    sleep 1
    echo "Message 2"
} > "$fifo1" &

echo "Reading from FIFO:"
while read line; do
    echo "  Received: $line"
done < "$fifo1"

wait

# Example 2: Request-Response Pattern
echo ""
echo "--- Example 2: Request-Response Pattern ---"

req_fifo="$fifo_dir/request.fifo"
res_fifo="$fifo_dir/response.fifo"
mkfifo "$req_fifo"
mkfifo "$res_fifo"

# Server
{
    echo "Server: Listening..."
    while read request; do
        [ "$request" = "QUIT" ] && break
        echo "Server: Got '$request'"
        echo "ACK: $request" > "$res_fifo"
    done
} < "$req_fifo" &

server_pid=$!

sleep 0.5

# Client sends requests
for req in "request1" "request2"; do
    echo "Client: Sending '$req'"
    echo "$req" > "$req_fifo"
    res=$(timeout 2 cat < "$res_fifo")
    echo "Client: Got '$res'"
done

echo "QUIT" > "$req_fifo"
wait $server_pid

echo ""
echo "=== FIFO Demo Complete ==="
