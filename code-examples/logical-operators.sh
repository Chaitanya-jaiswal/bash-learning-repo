#!/bin/bash
# Logical Operators Example
# Demonstrates AND (&&), OR (||), and NOT (!)

echo "=== Logical Operators Example ==="
echo ""

read -p "Enter your age: " age
read -p "Are you a student? (yes/no): " student_status

# AND operator (both conditions must be true)
if [ $age -ge 18 ] && [ "$student_status" = "yes" ]; then
    echo "You are an adult student"
fi

# OR operator (at least one must be true)
if [ $age -lt 18 ] || [ $age -gt 65 ]; then
    echo "You might need special assistance"
fi

# NOT operator (reverse condition)
if [ ! -z "$age" ]; then
    echo "Age was provided"
fi

# Multiple conditions
echo ""
echo "Book availability check:"

read -p "Is book available? (yes/no): " available
read -p "Is user registered? (yes/no): " registered
read -p "Already borrowed a book? (yes/no): " already_borrowed

if [ "$available" = "yes" ] && [ "$registered" = "yes" ] && [ "$already_borrowed" = "no" ]; then
    echo "✓ You can borrow this book!"
else
    echo "✗ You cannot borrow this book"
    
    # Explain why
    if [ "$available" != "yes" ]; then
        echo "  - Book is not available"
    fi
    
    if [ "$registered" != "yes" ]; then
        echo "  - You are not registered"
    fi
    
    if [ "$already_borrowed" = "yes" ]; then
        echo "  - You already have a borrowed book"
    fi
fi
