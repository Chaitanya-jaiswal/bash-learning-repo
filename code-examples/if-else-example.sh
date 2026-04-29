#!/bin/bash
# If-Else Example
# Demonstrates conditional statements

read -p "Enter your age: " age

if [ $age -lt 0 ] || [ $age -gt 120 ]; then
    echo "Invalid age!"
elif [ $age -lt 13 ]; then
    echo "You are a child"
elif [ $age -lt 18 ]; then
    echo "You are a teenager"
elif [ $age -lt 65 ]; then
    echo "You are an adult"
else
    echo "You are a senior"
fi

# Numeric comparison
num1=10
num2=20

if [ $num1 -eq $num2 ]; then
    echo "$num1 equals $num2"
elif [ $num1 -lt $num2 ]; then
    echo "$num1 is less than $num2"
else
    echo "$num1 is greater than $num2"
fi

# String comparison
read -p "Enter your name: " name

if [ "$name" = "Alice" ]; then
    echo "Hello Alice!"
elif [ "$name" = "Bob" ]; then
    echo "Hello Bob!"
else
    echo "Hello stranger!"
fi

# File tests
if [ -f "books.csv" ]; then
    echo "books.csv exists"
else
    echo "books.csv not found"
fi
