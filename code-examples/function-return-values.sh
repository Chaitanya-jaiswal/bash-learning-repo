#!/bin/bash
# Function Return Values Example
# Demonstrates return codes and status checking

function check_file() {
    local filename=$1
    
    if [ -f "$filename" ]; then
        echo "File '$filename' exists"
        return 0  # Success
    else
        echo "File '$filename' not found"
        return 1  # Failure
    fi
}

function is_valid_number() {
    local num=$1
    
    if [[ "$num" =~ ^[0-9]+$ ]]; then
        return 0  # Is a number
    else
        return 1  # Not a number
    fi
}

function is_registered() {
    local username=$1
    
    if [ -z "$username" ]; then
        echo "ERROR: Username cannot be empty"
        return 1
    fi
    
    echo "User '$username' is registered"
    return 0
}

# Test check_file
echo "=== File Check ==="
check_file "books.csv"
if [ $? -eq 0 ]; then
    echo "-> File check passed"
else
    echo "-> File check failed"
fi

echo ""

# Test is_valid_number
echo "=== Number Validation ==="
is_valid_number "123"
if [ $? -eq 0 ]; then
    echo "-> '123' is a valid number"
fi

is_valid_number "abc"
if [ $? -ne 0 ]; then
    echo "-> 'abc' is not a valid number"
fi

echo ""

# Test is_registered with proper output capture
echo "=== User Check ==="
is_registered "alice"
status=$?
if [ $status -eq 0 ]; then
    echo "-> User registration check passed"
fi
