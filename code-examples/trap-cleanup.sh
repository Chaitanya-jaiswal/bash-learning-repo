#!/bin/bash
readonly FIFO="/tmp/library_$$.fifo"
readonly LOG="/tmp/library_$$.log"

cleanup() {
    local exit_code=$?
    rm -f "$FIFO" "$LOG"
    exit $exit_code
}

trap cleanup EXIT INT TERM
echo "Script started" | tee "$LOG"
mkfifo "$FIFO"
