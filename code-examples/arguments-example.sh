#!/bin/bash
# Command-Line Arguments Example
# Demonstrates using $0, $1, $2, $#, and $@

echo "=== Command-Line Arguments ==="
echo ""

# Show script name
echo "Script name: $0"
echo ""

# Show number of arguments
echo "Number of arguments: $#"
echo ""

# Show arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided!"
    echo "Usage: $0 <arg1> <arg2> <arg3>"
else
    echo "Arguments provided:"
    echo "First argument: $1"
    
    if [ $# -ge 2 ]; then
        echo "Second argument: $2"
    fi
    
    if [ $# -ge 3 ]; then
        echo "Third argument: $3"
    fi
    
    echo ""
    echo "All arguments together:"
    echo "$@"
    
    echo ""
    echo "Each argument on its own line:"
    for arg in "$@"; do
        echo "  - $arg"
    done
fi
