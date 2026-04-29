#!/bin/bash
# For Loop Example
# Demonstrates looping through lists

echo "=== For Loop Examples ==="
echo ""

# Loop through list of books
echo "--- Library Catalog ---"
books=("1984" "Alice in Wonderland" "The Great Gatsby" "Brave New World" "To Kill a Mockingbird")

count=1
for book in "${books[@]}"; do
    echo "$count. $book"
    count=$(( count + 1 ))
done

echo ""

# Loop through numbers
echo "--- Count from 1 to 5 ---"
for i in {1..5}; do
    echo "Number: $i"
done

echo ""

# Loop through command-line arguments
echo "--- Processing Arguments ---"
if [ $# -gt 0 ]; then
    for arg in "$@"; do
        echo "Processing: $arg"
    done
else
    echo "No arguments provided"
fi

echo ""

# C-style for loop
echo "--- C-style Loop (0 to 4) ---"
for ((i=0; i<5; i++)); do
    echo "Index: $i"
done

echo ""

# Loop with break
echo "--- Loop with Break ---"
for i in {1..10}; do
    if [ $i -eq 6 ]; then
        echo "Stopping at $i"
        break
    fi
    echo "Count: $i"
done

echo ""

# Loop with continue
echo "--- Loop with Continue (skip even numbers) ---"
for i in {1..5}; do
    if [ $(( i % 2 )) -eq 0 ]; then
        continue
    fi
    echo "Odd number: $i"
done
