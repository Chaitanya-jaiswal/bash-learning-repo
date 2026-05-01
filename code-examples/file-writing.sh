#!/bin/bash
# File Writing and Appending Example
# Demonstrates creating and modifying files

echo "=== File Writing and Appending ==="
echo ""

# Create a new file (overwrite if exists)
echo "=== Creating new file ==="
echo "User Registration File" > users.txt
echo "Created: $(date)" >> users.txt
echo "" >> users.txt

echo "Initial content:"
cat users.txt

# Append more data
echo "=== Appending data ==="
echo "alice,alice@example.com,$(date +%Y-%m-%d)" >> users.txt
echo "bob,bob@example.com,$(date +%Y-%m-%d)" >> users.txt
echo "charlie,charlie@example.com,$(date +%Y-%m-%d)" >> users.txt

echo "After appending:"
cat users.txt

# Write another file using here-document
echo ""
echo "=== Using here-document ==="
cat > config.txt << EOF
# Library Configuration
library_name=Central Library
max_books_per_user=3
rental_period_days=14
fine_per_day=0.50
EOF

echo "Config file:"
cat config.txt

# Create log file with timestamps
echo ""
echo "=== Creating transaction log ==="
log_file="transactions.log"

echo "$(date '+%Y-%m-%d %H:%M:%S') | System started" > "$log_file"
echo "$(date '+%Y-%m-%d %H:%M:%S') | alice registered" >> "$log_file"
echo "$(date '+%Y-%m-%d %H:%M:%S') | alice borrowed 1984" >> "$log_file"
echo "$(date '+%Y-%m-%d %H:%M:%S') | bob registered" >> "$log_file"

echo "Transaction log:"
cat "$log_file"

# Clean up
echo ""
echo "=== Cleaning up ==="
rm users.txt config.txt "$log_file"
echo "Test files removed"
