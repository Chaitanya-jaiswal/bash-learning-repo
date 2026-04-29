#!/bin/bash
# Case Statement Example
# Demonstrates selecting between multiple options

echo "=== Library Menu System ==="
echo ""
echo "1. Search for a book"
echo "2. Borrow a book"
echo "3. Return a book"
echo "4. View my books"
echo "5. Exit"
echo ""

read -p "Choose option (1-5): " choice

case $choice in
    1)
        echo ""
        echo "--- Search Book ---"
        read -p "Enter book title or author: " query
        echo "Searching for: $query"
        echo "Results would appear here"
        ;;
    2)
        echo ""
        echo "--- Borrow Book ---"
        read -p "Enter book title: " book_title
        read -p "Enter your username: " username
        echo "Book '$book_title' borrowed by $username"
        ;;
    3)
        echo ""
        echo "--- Return Book ---"
        read -p "Enter book title: " book_title
        echo "Book '$book_title' has been returned"
        ;;
    4)
        echo ""
        echo "--- Your Books ---"
        echo "You have borrowed:"
        echo "  1. Alice in Wonderland"
        echo "  2. 1984"
        ;;
    5)
        echo "Thank you for using the library!"
        exit 0
        ;;
    *)
        echo "Invalid option! Please choose 1-5"
        ;;
esac

echo ""
echo "Operation completed"

# Another example: File type checker
echo ""
echo "=== File Type Checker ==="
read -p "Enter filename: " filename

case $filename in
    *.txt)
        echo "$filename is a text file"
        ;;
    *.pdf)
        echo "$filename is a PDF file"
        ;;
    *.csv)
        echo "$filename is a CSV file"
        ;;
    *.sh)
        echo "$filename is a bash script"
        ;;
    *)
        echo "$filename is of unknown type"
        ;;
esac
