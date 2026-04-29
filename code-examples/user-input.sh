#!/bin/bash
# User Input Example
# Demonstrates using the read command

echo "=== Interactive User Input Example ==="
echo ""

# Simple read
read -p "What is your name? " name
echo "Hello, $name!"
echo ""

# Multiple values
read -p "Enter first and last name: " first_name last_name
echo "Welcome, $first_name $last_name!"
echo ""

# Multiple reads
read -p "Enter your age: " age
read -p "Enter your city: " city
echo ""

# Display collected information
echo "=== Information Summary ==="
echo "Name: $first_name $last_name"
echo "Age: $age"
echo "City: $city"
echo ""

# Calculate next age
next_age=$(( age + 1 ))
echo "Next year you will be $next_age years old."
