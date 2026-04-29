#!/bin/bash
# Simple Variables Example
# Demonstrates how to create and use variables

# Create variables
name="Alice"
age=25
city="New York"
profession="Student"

# Display the variables
echo "=== Personal Information ==="
echo "Name: $name"
echo "Age: $age"
echo "City: $city"
echo "Profession: $profession"
echo ""

# String concatenation
full_info="$name is a $profession from $city"
echo "Summary: $full_info"
echo ""

# Using variables multiple times
echo "Hello, $name! You are $age years old."
echo "Welcome to $city, $name!"
