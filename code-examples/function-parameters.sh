#!/bin/bash
# Function Parameters Example
# Demonstrates passing parameters and local variables

function add() {
    local a=$1
    local b=$2
    local result=$(( a + b ))
    echo $result
}

function subtract() {
    local a=$1
    local b=$2
    echo $(( a - b ))
}

function multiply() {
    local a=$1
    local b=$2
    echo $(( a * b ))
}

function divide() {
    local a=$1
    local b=$2
    
    if [ $b -eq 0 ]; then
        echo "ERROR: Cannot divide by zero"
        return 1
    fi
    
    echo $(( a / b ))
}

# Use the functions
echo "=== Math Functions ==="
echo "10 + 5 = $(add 10 5)"
echo "10 - 5 = $(subtract 10 5)"
echo "10 * 5 = $(multiply 10 5)"
echo "10 / 5 = $(divide 10 5)"

echo ""

# Function with multiple parameters
function add_book() {
    local title=$1
    local author=$2
    local year=$3
    
    echo "Adding book:"
    echo "  Title: $title"
    echo "  Author: $author"
    echo "  Year: $year"
}

add_book "1984" "George Orwell" 1949
add_book "Alice in Wonderland" "Lewis Carroll" 1865
