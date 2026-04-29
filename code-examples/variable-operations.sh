#!/bin/bash
# Variable Operations Example
# Demonstrates arithmetic and string operations

echo "=== Variable Operations ==="
echo ""

# Arithmetic
num1=10
num2=5

echo "Numbers: $num1 and $num2"

sum=$(( num1 + num2 ))
echo "Sum: $num1 + $num2 = $sum"

difference=$(( num1 - num2 ))
echo "Difference: $num1 - $num2 = $difference"

product=$(( num1 * num2 ))
echo "Product: $num1 * $num2 = $product"

quotient=$(( num1 / num2 ))
echo "Quotient: $num1 / $num2 = $quotient"

remainder=$(( num1 % num2 ))
echo "Remainder: $num1 % $num2 = $remainder"
echo ""

# String concatenation
greeting="Hello"
name="World"
message="$greeting, $name!"

echo "String concatenation:"
echo "$message"
echo ""

# String length
text="Bash Programming"
length=${#text}

echo "String: $text"
echo "Length: $length characters"
echo ""

# Extracting part of string
echo "Substrings:"
echo "First 4 characters: ${text:0:4}"
echo "From position 5: ${text:5}"
echo "Last 11 characters: ${text: -11}"
