#!/bin/bash
# Error Handling Example
readonly SUCCESS=0
readonly ERR_FILE_NOT_FOUND=20

if [ $# -lt 1 ]; then
    echo "Usage: $0 <file>"
    exit 40
fi

file="$1"
if [ ! -f "$file" ]; then
    echo "Error: File not found: $file"
    exit $ERR_FILE_NOT_FOUND
fi

echo "Processing: $file"
