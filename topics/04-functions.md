# Topic 4: Functions & Modular Code

**Status**: ✅ Ready to Learn  
**Duration**: 2-3 hours  
**Prerequisites**: [Topic 3: Control Flow](03-control-flow.md)  
**Next Topic**: [Topic 5: File Operations (Coming Soon)](05-file-operations.md)

---

## Table of Contents

- [What Are Functions?](#what-are-functions)
- [Creating Functions](#creating-functions)
- [Function Parameters](#function-parameters)
- [Return Values](#return-values)
- [Local vs Global Variables](#local-vs-global-variables)
- [Function Best Practices](#function-best-practices)
- [Practical Examples](#practical-examples)
- [Practice Exercises](#practice-exercises)
- [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)

---

## What Are Functions?

A **function** is a reusable block of code that performs a specific task. Instead of writing the same code multiple times, you write it once in a function and call it whenever needed.

### Real-World Example (Library)

```bash
# Without functions - repetitive
validate_user "alice"
validate_user "bob"
validate_user "charlie"

# With functions - cleaner
function validate_user() {
    local username=$1
    if [ -z "$username" ]; then
        echo "ERROR: Username required"
        return 1
    fi
    echo "User $username is valid"
    return 0
}

validate_user "alice"
validate_user "bob"
validate_user "charlie"
```

### Why Use Functions?

| Reason | Benefit |
|--------|---------|
| **Reusability** | Write once, use many times |
| **Maintainability** | Fix bug in one place = fixed everywhere |
| **Readability** | Clear what code does by function name |
| **Organization** | Break large scripts into smaller pieces |
| **Testing** | Test each function independently |

---

## Creating Functions

### Basic Syntax (Method 1)

```bash
function function_name() {
    # Code here
}
```

### Basic Syntax (Method 2)

```bash
function_name() {
    # Code here
}
```

### Simple Example

```bash
#!/bin/bash

# Define a function
function greet() {
    echo "Hello, World!"
}

# Call the function
greet
greet
greet
```

**Output**:
```
Hello, World!
Hello, World!
Hello, World!
```

### Function with Echo Output

```bash
#!/bin/bash

function welcome() {
    echo "=== Welcome to Library System ==="
    echo "Current time: $(date)"
    echo "================================"
}

welcome
```

---

## Function Parameters

Functions can accept parameters just like scripts do!

### Passing Parameters

```bash
#!/bin/bash

function greet() {
    local name=$1
    local age=$2
    
    echo "Hello, $name!"
    echo "You are $age years old"
}

# Call with parameters
greet "Alice" 25
greet "Bob" 30
```

**Output**:
```
Hello, Alice!
You are 25 years old
Hello, Bob!
You are 30 years old
```

### Parameters Variables

Inside a function:

| Variable | Meaning |
|----------|---------|
| `$1`, `$2`, `$3...` | Parameters passed to function |
| `$#` | Number of parameters |
| `$@` | All parameters as separate items |
| `$*` | All parameters as one string |

### Example with Multiple Parameters

```bash
#!/bin/bash

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
```

---

## Return Values

Functions can **return values** (success/failure codes).

### Basic Return

```bash
#!/bin/bash

function check_file() {
    if [ -f "$1" ]; then
        echo "File exists"
        return 0  # Success
    else
        echo "File not found"
        return 1  # Failure
    fi
}

# Use the function
check_file "books.csv"
if [ $? -eq 0 ]; then
    echo "Check passed"
else
    echo "Check failed"
fi
```

### Capturing Output

```bash
#!/bin/bash

function get_library_name() {
    echo "Central Library"
}

# Capture the output
library=$(get_library_name)
echo "Current library: $library"
```

### Calculation Example

```bash
#!/bin/bash

function calculate_fine() {
    local days=$1
    local rate=$2
    
    local fine=$(( days * rate ))
    echo $fine
}

# Use the output
days_late=5
daily_rate=2
fine=$(calculate_fine $days_late $daily_rate)
echo "Fine: \$$fine"
```

---

## Local vs Global Variables

### Global Variables

```bash
#!/bin/bash

# Global variable - accessible everywhere
library="Central Library"

function show_library() {
    echo "Library: $library"
}

show_library  # Output: Library: Central Library
```

### Local Variables

```bash
#!/bin/bash

function create_user() {
    local username=$1      # Local - only in this function
    local email="user@example.com"  # Local
    
    echo "User: $username, Email: $email"
}

create_user "alice"
echo "Username: $username"  # Empty! It's local to the function
```

### Best Practice - Use Local

```bash
#!/bin/bash

# GOOD: Use local variables
function process_book() {
    local title=$1
    local author=$2
    local year=$3
    
    echo "Processing $title by $author ($year)"
}

# BAD: Using global variables (pollutes namespace)
function bad_process() {
    title=$1
    author=$2
    year=$3
}
```

---

## Function Best Practices

### 1. Use Descriptive Names

```bash
# Good
function is_user_registered() { ... }
function borrow_book() { ... }
function validate_age() { ... }

# Bad
function check() { ... }
function do_something() { ... }
function func1() { ... }
```

### 2. Add Comments

```bash
#!/bin/bash

# Purpose: Check if a book is available
# Parameters: $1 = book title
# Returns: 0 if available, 1 if not
function is_book_available() {
    local book=$1
    
    if [ -f "books.csv" ]; then
        grep -q "^$book," books.csv
        return $?
    fi
    
    return 1
}
```

### 3. Use Local Variables

```bash
function calculate_total() {
    local price=$1
    local quantity=$2
    local tax_rate=$3
    
    local subtotal=$(( price * quantity ))
    local tax=$(( subtotal * tax_rate ))
    local total=$(( subtotal + tax ))
    
    echo $total
}
```

### 4. Always Return Status Code

```bash
function register_user() {
    local username=$1
    
    if [ -z "$username" ]; then
        echo "ERROR: Username required"
        return 1  # Return failure
    fi
    
    # Add user to file
    echo "$username" >> users.txt
    return 0  # Return success
}
```

---

## Practical Examples

### Example 1: Simple Math Functions

```bash
#!/bin/bash

function add() {
    echo $(( $1 + $2 ))
}

function subtract() {
    echo $(( $1 - $2 ))
}

function multiply() {
    echo $(( $1 * $2 ))
}

function divide() {
    if [ $2 -eq 0 ]; then
        echo "ERROR: Cannot divide by zero"
        return 1
    fi
    echo $(( $1 / $2 ))
}

# Use them
echo "10 + 5 = $(add 10 5)"
echo "10 - 5 = $(subtract 10 5)"
echo "10 * 5 = $(multiply 10 5)"
echo "10 / 5 = $(divide 10 5)"
```

### Example 2: Library Operations

```bash
#!/bin/bash

function is_registered() {
    local username=$1
    if grep -q "^$username$" users.txt 2>/dev/null; then
        return 0
    fi
    return 1
}

function can_borrow() {
    local username=$1
    
    if ! is_registered "$username"; then
        echo "ERROR: User not registered"
        return 1
    fi
    
    # Check if user already has a book
    if grep -q "^$username," borrowed.txt 2>/dev/null; then
        echo "ERROR: User already has a borrowed book"
        return 1
    fi
    
    echo "User can borrow"
    return 0
}

function borrow_book() {
    local username=$1
    local book=$2
    
    if ! can_borrow "$username"; then
        return 1
    fi
    
    echo "$username,$book,$(date +%Y-%m-%d)" >> borrowed.txt
    echo "Book '$book' borrowed by $username"
    return 0
}

# Use it
borrow_book "alice" "1984"
```

### Example 3: Menu System with Functions

```bash
#!/bin/bash

function show_menu() {
    echo ""
    echo "=== Library Menu ==="
    echo "1. Search books"
    echo "2. Borrow book"
    echo "3. Return book"
    echo "4. Exit"
    echo ""
}

function search_books() {
    echo "=== Search Books ==="
    read -p "Search for: " query
    echo "Results for '$query'"
    echo "- Found book 1"
    echo "- Found book 2"
}

function borrow_book() {
    echo "=== Borrow Book ==="
    read -p "Book title: " title
    read -p "Your username: " user
    echo "✓ Borrowed '$title' for $user"
}

function return_book() {
    echo "=== Return Book ==="
    read -p "Book title: " title
    echo "✓ Returned '$title'"
}

# Main program
while true; do
    show_menu
    read -p "Choose option: " choice
    
    case $choice in
        1) search_books ;;
        2) borrow_book ;;
        3) return_book ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
```

---

## Practice Exercises

### Exercise 4.1: Simple Functions

**Description**: Create functions for basic operations.

**Requirements**:
- Create 3 functions (greet, add, multiply)
- Each function performs one task
- Call each function multiple times

**Solution**:
```bash
#!/bin/bash

function greet() {
    local name=$1
    echo "Hello, $name!"
}

function add() {
    local a=$1
    local b=$2
    local result=$(( a + b ))
    echo $result
}

function multiply() {
    local a=$1
    local b=$2
    local result=$(( a * b ))
    echo $result
}

# Call the functions
greet "Alice"
greet "Bob"

echo "5 + 3 = $(add 5 3)"
echo "5 * 3 = $(multiply 5 3)"
```

---

### Exercise 4.2: Validation Functions

**Description**: Create functions to validate input.

**Requirements**:
- Check if user is valid (not empty)
- Check if number is in range
- Check if file exists

**Solution**:
```bash
#!/bin/bash

function is_valid_username() {
    local username=$1
    
    if [ -z "$username" ]; then
        echo "ERROR: Username cannot be empty"
        return 1
    fi
    
    if [ ${#username} -lt 3 ]; then
        echo "ERROR: Username must be at least 3 characters"
        return 1
    fi
    
    echo "Username is valid"
    return 0
}

function is_in_range() {
    local number=$1
    local min=$2
    local max=$3
    
    if [ $number -ge $min ] && [ $number -le $max ]; then
        return 0
    fi
    return 1
}

function file_exists() {
    local filename=$1
    
    if [ -f "$filename" ]; then
        echo "File '$filename' exists"
        return 0
    else
        echo "File '$filename' not found"
        return 1
    fi
}

# Test them
is_valid_username "alice"
is_valid_username "ab"
is_valid_username ""

if is_in_range 15 10 20; then
    echo "15 is between 10 and 20"
fi

file_exists "books.csv"
```

---

### Exercise 4.3: Library Functions

**Description**: Create functions for library operations.

**Requirements**:
- Register user (add to file)
- Check if user exists
- List all users
- Handle file operations

**Solution**:
```bash
#!/bin/bash

USERS_FILE="users.txt"

function register_user() {
    local username=$1
    
    if [ -z "$username" ]; then
        echo "ERROR: Username required"
        return 1
    fi
    
    if user_exists "$username"; then
        echo "ERROR: User already exists"
        return 1
    fi
    
    echo "$username" >> "$USERS_FILE"
    echo "✓ User '$username' registered"
    return 0
}

function user_exists() {
    local username=$1
    grep -q "^$username$" "$USERS_FILE" 2>/dev/null
    return $?
}

function list_users() {
    if [ ! -f "$USERS_FILE" ]; then
        echo "No users registered yet"
        return 1
    fi
    
    echo "=== Registered Users ==="
    local count=0
    while IFS= read -r user; do
        count=$(( count + 1 ))
        echo "$count. $user"
    done < "$USERS_FILE"
    
    echo "Total: $count users"
    return 0
}

function delete_user() {
    local username=$1
    
    if ! user_exists "$username"; then
        echo "ERROR: User not found"
        return 1
    fi
    
    grep -v "^$username$" "$USERS_FILE" > "$USERS_FILE.tmp"
    mv "$USERS_FILE.tmp" "$USERS_FILE"
    echo "✓ User '$username' deleted"
    return 0
}

# Test them
register_user "alice"
register_user "bob"
register_user "charlie"

list_users

user_exists "alice" && echo "Alice exists"
user_exists "unknown" || echo "Unknown user not found"

delete_user "bob"
list_users
```

---

### Exercise 4.4: Error Handling in Functions

**Description**: Create functions with proper error handling.

**Requirements**:
- Return proper error codes
- Validate all inputs
- Display helpful error messages

**Solution**:
```bash
#!/bin/bash

function divide() {
    local dividend=$1
    local divisor=$2
    
    # Validate input
    if [ -z "$dividend" ] || [ -z "$divisor" ]; then
        echo "ERROR: Both numbers required"
        return 1
    fi
    
    # Check for division by zero
    if [ "$divisor" -eq 0 ]; then
        echo "ERROR: Cannot divide by zero"
        return 2
    fi
    
    # Perform calculation
    local result=$(( dividend / divisor ))
    echo $result
    return 0
}

function safe_divide() {
    local result
    result=$(divide "$1" "$2")
    local status=$?
    
    case $status in
        0)
            echo "Result: $result"
            ;;
        1)
            echo "Invalid input provided"
            ;;
        2)
            echo "Invalid operation: division by zero"
            ;;
        *)
            echo "Unknown error"
            ;;
    esac
    
    return $status
}

# Test it
safe_divide 10 2    # Success
safe_divide 10 0    # Error: division by zero
safe_divide         # Error: no arguments
```

---

### Challenge Exercise: Complete Library System

**Description**: Build a modular library system with multiple functions.

**Requirements**:
- Separate functions for each operation
- User registration and validation
- Book borrowing with checks
- File persistence
- Menu system

**Starter Code**:
```bash
#!/bin/bash

USERS_FILE="users.txt"
BORROWED_FILE="borrowed.txt"

# Utility functions
function show_menu() {
    echo ""
    echo "=== Library System ==="
    echo "1. Register user"
    echo "2. Borrow book"
    echo "3. Return book"
    echo "4. List borrowed"
    echo "5. Exit"
}

function is_registered() {
    local username=$1
    grep -q "^$username$" "$USERS_FILE" 2>/dev/null
}

function register_user() {
    read -p "Enter username: " username
    
    if [ -z "$username" ]; then
        echo "ERROR: Username required"
        return 1
    fi
    
    if is_registered "$username"; then
        echo "ERROR: User already exists"
        return 1
    fi
    
    echo "$username" >> "$USERS_FILE"
    echo "✓ Registered: $username"
}

function borrow_book() {
    read -p "Enter username: " username
    read -p "Enter book title: " book
    
    if ! is_registered "$username"; then
        echo "ERROR: User not registered"
        return 1
    fi
    
    echo "$username|$book|$(date)" >> "$BORROWED_FILE"
    echo "✓ Borrowed '$book'"
}

function list_borrowed() {
    if [ ! -f "$BORROWED_FILE" ]; then
        echo "No borrowed books"
        return
    fi
    
    echo "=== Borrowed Books ==="
    while IFS='|' read -r user book date; do
        echo "$user borrowed '$book' on $date"
    done < "$BORROWED_FILE"
}

# Main program
while true; do
    show_menu
    read -p "Choose: " choice
    
    case $choice in
        1) register_user ;;
        2) borrow_book ;;
        3) echo "Return function coming..." ;;
        4) list_borrowed ;;
        5) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
```

---

## Common Pitfalls

### ❌ Pitfall 1: Forgetting to Define Before Calling

**Wrong**:
```bash
#!/bin/bash

greet "Alice"  # Called before definition

function greet() {
    echo "Hello, $1"
}
```

**Right**:
```bash
#!/bin/bash

function greet() {
    echo "Hello, $1"
}

greet "Alice"  # Called after definition
```

---

### ❌ Pitfall 2: Not Using Local Variables

**Wrong**:
```bash
function add() {
    a=$1
    b=$2
    result=$(( a + b ))
    echo $result
}

# These variables pollute global scope!
```

**Right**:
```bash
function add() {
    local a=$1
    local b=$2
    local result=$(( a + b ))
    echo $result
}
```

---

### ❌ Pitfall 3: Forgetting Return Status

**Wrong**:
```bash
function check_file() {
    [ -f "$1" ]
    # No explicit return
}

if check_file "books.csv"; then
    echo "File exists"
fi
```

**Right**:
```bash
function check_file() {
    [ -f "$1" ]
    return $?  # Explicit return
}

if check_file "books.csv"; then
    echo "File exists"
fi
```

---

### ❌ Pitfall 4: Mixing Output and Return Values

**Wrong**:
```bash
function get_count() {
    echo "Processing..."
    echo "5"  # Hard to know which is the real value
}

count=$(get_count)  # Gets "Processing..." too!
```

**Right**:
```bash
function get_count() {
    echo "Processing..." >&2  # Send to stderr
    echo "5"  # Only this goes to stdout
}

count=$(get_count)  # Gets only "5"
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **Functions** | Reusable blocks of code |
| **Definition** | `function name() { ... }` |
| **Parameters** | `$1`, `$2`, `$#`, `$@` |
| **Local variables** | Use `local` keyword |
| **Return values** | Use `return 0` (success) or `return 1` (failure) |
| **Output capture** | Use `variable=$(function_name)` |
| **Best practices** | Comments, descriptive names, error handling |

### You Can Now

✅ Create and call functions  
✅ Pass parameters to functions  
✅ Capture function output  
✅ Handle return values  
✅ Use local variables  
✅ Build modular scripts  
✅ Create reusable libraries  

### Real Project Application

For your **Library System**:
- **bootstrap.sh**: Functions to parse CSV, create catalogs
- **user.sh**: Functions to validate, borrow, return books
- **manage.sh**: Functions to display status, check processes
- **library.c**: Can call these functions from C

---

## Quick Reference

```bash
# Define function
function function_name() {
    local var=$1
    echo "Doing something"
    return 0
}

# Call function
function_name "argument"

# Capture output
result=$(function_name)

# Check return status
if function_name "arg"; then
    echo "Success"
else
    echo "Failed"
fi

# Use return code
function_name
status=$?
```

---

**Ready to move on?** Go to [Topic 5: File Operations](#) 🚀

**Need to review Topic 3?** Go back to [Topic 3: Control Flow](03-control-flow.md)
