#!/bin/bash
# Combined Arguments and User Input Example
# Demonstrates using both command-line arguments and user input

echo "=== Library System Example ==="
echo ""

# Check if library ID was provided as argument
if [ $# -lt 1 ]; then
    echo "ERROR: Library ID required!"
    echo "Usage: $0 <library_id>"
    exit 1
fi

# Get library ID from argument
library_id="$1"
library_name="${2:-Central Library}"  # Default value if not provided

echo "Library ID: $library_id"
echo "Library Name: $library_name"
echo ""

# Get information from user input
read -p "Enter username: " username
read -p "Enter book title to borrow: " book_title
read -p "Enter author name: " author

# Display transaction details
echo ""
echo "========== TRANSACTION DETAILS =========="
echo "Library: $library_name (ID: $library_id)"
echo "User: $username"
echo "Book: $book_title"
echo "Author: $author"
echo "========================================="
