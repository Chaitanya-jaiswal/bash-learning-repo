#!/bin/bash
# While Loop Example
# Demonstrates looping while conditions are true

echo "=== While Loop Examples ==="
echo ""

# Simple counter
echo "--- Count from 1 to 5 ---"
counter=1
while [ $counter -le 5 ]; do
    echo "Count: $counter"
    counter=$(( counter + 1 ))
done

echo ""

# Interactive menu
echo "--- Interactive Menu ---"
while true; do
    echo ""
    echo "Menu:"
    echo "1. Add book"
    echo "2. Remove book"
    echo "3. Exit"
    
    read -p "Choose option: " choice
    
    if [ "$choice" = "3" ]; then
        echo "Exiting..."
        break
    fi
    
    case $choice in
        1)
            read -p "Enter book title: " title
            echo "Added: $title"
            ;;
        2)
            echo "Remove book functionality"
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done

echo ""
echo "Program ended"

# Another example: validation loop
echo ""
echo "--- Validation Loop ---"
valid=false

while [ "$valid" = "false" ]; do
    read -p "Enter a number between 1 and 10: " number
    
    if [ ! -z "$number" ] && [ "$number" -ge 1 ] && [ "$number" -le 10 ]; then
        echo "Valid! You entered: $number"
        valid=true
    else
        echo "Invalid input. Please enter a number between 1 and 10"
    fi
done
