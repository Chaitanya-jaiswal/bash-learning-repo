#!/bin/bash
# Basic Functions Example
# Demonstrates creating and calling functions

# Define a simple function
function welcome() {
    echo "=== Welcome to Library System ==="
    echo "Current time: $(date)"
    echo "================================"
}

# Call the function
welcome

echo ""

# Function with parameters
function greet() {
    local name=$1
    echo "Hello, $name!"
}

greet "Alice"
greet "Bob"
greet "Charlie"

echo ""

# Function that returns a value
function get_library_name() {
    echo "Central Library"
}

library_name=$(get_library_name)
echo "Library: $library_name"
