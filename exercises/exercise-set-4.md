# Exercise Set 4: Functions & Modular Code

**Topic**: Functions & Modular Code  
**Difficulty**: ⭐⭐⭐ (Intermediate)  
**Time**: 60-90 minutes  
**Prerequisites**: Complete [Topic 3](../topics/03-control-flow.md) and read [Topic 4](../topics/04-functions.md)

---

## Instructions

1. **Create a new directory**:
   ```bash
   mkdir -p ~/bash-exercises/set-4
   cd ~/bash-exercises/set-4
   ```

2. **For each exercise**:
   - Read the description
   - Write your script with functions
   - Test each function
   - Compare with solution

3. **Test all functions** with different inputs!

---

## Exercise 4.1: Math Functions

**Description**: Create functions for basic math operations.

**Requirements**:
- Create functions: add, subtract, multiply, divide
- Each function takes 2 parameters
- Return the result
- Handle division by zero

**Test cases**:
```bash
./exercise-4-1.sh
# Output results of operations
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Math Functions

function add() {
    local a=$1
    local b=$2
    local result=$(( a + b ))
    echo $result
}

function subtract() {
    local a=$1
    local b=$2
    echo $(( a - b ))
}

function multiply() {
    local a=$1
    local b=$2
    echo $(( a * b ))
}

function divide() {
    local a=$1
    local b=$2
    
    if [ $b -eq 0 ]; then
        echo "ERROR: Cannot divide by zero"
        return 1
    fi
    
    echo $(( a / b ))
}

# Test the functions
echo "=== Math Functions ==="
echo "10 + 5 = $(add 10 5)"
echo "10 - 5 = $(subtract 10 5)"
echo "10 * 5 = $(multiply 10 5)"
echo "10 / 5 = $(divide 10 5)"

# Test error case
echo "10 / 0 = $(divide 10 0)"
```

</details>

---

## Exercise 4.2: String Functions

**Description**: Create utility functions for string operations.

**Requirements**:
- Function to convert to uppercase
- Function to count characters
- Function to reverse string
- Function to check if string is empty

**Solution**:
```bash
#!/bin/bash
# String Functions

function string_length() {
    local str=$1
    echo ${#str}
}

function is_empty() {
    local str=$1
    
    if [ -z "$str" ]; then
        return 0  # Is empty
    else
        return 1  # Not empty
    fi
}

function to_uppercase() {
    local str=$1
    echo "${str^^}"  # Bash 4+
}

function to_lowercase() {
    local str=$1
    echo "${str,,}"  # Bash 4+
}

# Test
echo "=== String Functions ==="
echo "Length of 'Hello': $(string_length 'Hello')"
echo "Uppercase 'hello': $(to_uppercase 'hello')"
echo "Lowercase 'HELLO': $(to_lowercase 'HELLO')"

if is_empty ""; then
    echo "String is empty"
fi

if ! is_empty "Hello"; then
    echo "String is not empty"
fi
```

---

## Exercise 4.3: Validation Functions

**Description**: Create functions to validate different types of input.

**Requirements**:
- Validate username (not empty, min length 3)
- Validate age (numeric, 0-120)
- Validate email (simple check)
- Return proper status codes

**Solution**:
```bash
#!/bin/bash
# Validation Functions

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
    
    return 0
}

function is_valid_age() {
    local age=$1
    
    if ! [[ "$age" =~ ^[0-9]+$ ]]; then
        echo "ERROR: Age must be a number"
        return 1
    fi
    
    if [ $age -lt 0 ] || [ $age -gt 120 ]; then
        echo "ERROR: Age must be between 0 and 120"
        return 1
    fi
    
    return 0
}

function is_valid_email() {
    local email=$1
    
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    fi
    
    echo "ERROR: Invalid email format"
    return 1
}

# Test
echo "=== Validation Functions ==="

echo "Testing 'alice' as username:"
if is_valid_username "alice"; then
    echo "✓ Valid"
fi

echo ""
echo "Testing 'ab' as username:"
if ! is_valid_username "ab"; then
    echo "✓ Correctly rejected"
fi

echo ""
echo "Testing 25 as age:"
if is_valid_age 25; then
    echo "✓ Valid"
fi

echo ""
echo "Testing 'user@example.com' as email:"
if is_valid_email "user@example.com"; then
    echo "✓ Valid"
fi
```

---

## Exercise 4.4: File Operations Functions

**Description**: Create functions to work with files.

**Requirements**:
- Function to check if file exists
- Function to count lines in file
- Function to create file with header
- Function to append data to file

**Solution**:
```bash
#!/bin/bash
# File Operations Functions

function file_exists() {
    local filename=$1
    
    if [ -f "$filename" ]; then
        return 0
    fi
    return 1
}

function count_lines() {
    local filename=$1
    
    if ! file_exists "$filename"; then
        echo "ERROR: File not found"
        return 1
    fi
    
    wc -l < "$filename"
}

function create_file_with_header() {
    local filename=$1
    local header=$2
    
    if file_exists "$filename"; then
        echo "ERROR: File already exists"
        return 1
    fi
    
    echo "$header" > "$filename"
    echo "✓ File '$filename' created with header"
    return 0
}

function append_to_file() {
    local filename=$1
    local data=$2
    
    if ! file_exists "$filename"; then
        echo "ERROR: File not found"
        return 1
    fi
    
    echo "$data" >> "$filename"
    echo "✓ Data appended to '$filename'"
    return 0
}

# Test
echo "=== File Operations ==="

create_file_with_header "test.txt" "Title"
append_to_file "test.txt" "Line 1"
append_to_file "test.txt" "Line 2"

if file_exists "test.txt"; then
    echo "File exists"
    echo "Lines: $(count_lines 'test.txt')"
fi

# Cleanup
rm -f test.txt
```

---

## Exercise 4.5: Library User Management

**Description**: Create functions to manage library users.

**Requirements**:
- Register user (check if exists first)
- List all users
- Delete user
- Check if user exists
- Get user count

**Solution**:
```bash
#!/bin/bash
# Library User Management Functions

USERS_FILE="library_users.txt"

function ensure_file() {
    if [ ! -f "$USERS_FILE" ]; then
        touch "$USERS_FILE"
    fi
}

function user_exists() {
    local username=$1
    ensure_file
    grep -q "^$username$" "$USERS_FILE"
    return $?
}

function register_user() {
    local username=$1
    
    if [ -z "$username" ]; then
        echo "ERROR: Username required"
        return 1
    fi
    
    ensure_file
    
    if user_exists "$username"; then
        echo "ERROR: User already exists"
        return 1
    fi
    
    echo "$username" >> "$USERS_FILE"
    echo "✓ User registered: $username"
    return 0
}

function list_users() {
    ensure_file
    
    if [ ! -s "$USERS_FILE" ]; then
        echo "No users registered"
        return 1
    fi
    
    echo "=== Library Users ==="
    local count=0
    while IFS= read -r user; do
        count=$(( count + 1 ))
        echo "$count. $user"
    done < "$USERS_FILE"
}

function delete_user() {
    local username=$1
    
    ensure_file
    
    if ! user_exists "$username"; then
        echo "ERROR: User not found"
        return 1
    fi
    
    grep -v "^$username$" "$USERS_FILE" > "$USERS_FILE.tmp"
    mv "$USERS_FILE.tmp" "$USERS_FILE"
    echo "✓ User deleted: $username"
    return 0
}

function get_user_count() {
    ensure_file
    
    if [ -s "$USERS_FILE" ]; then
        wc -l < "$USERS_FILE"
    else
        echo 0
    fi
}

# Test functions
echo "=== Library User Management ==="
register_user "alice"
register_user "bob"
register_user "charlie"

list_users

echo ""
echo "Total users: $(get_user_count)"

delete_user "bob"

echo ""
list_users

# Cleanup
rm -f "$USERS_FILE" "$USERS_FILE.tmp"
```

---

## Challenge Exercise: Modular Library System

**Description**: Build a complete library system with multiple functions and file operations.

**Requirements**:
- Separate functions for each operation
- User management (register, list, delete)
- Book management (add, search, borrow, return)
- Data persistence (file operations)
- Error handling in all functions
- Interactive menu system

**Starter Code**:
```bash
#!/bin/bash

USERS_FILE="users.txt"
BOOKS_FILE="books.txt"
BORROWED_FILE="borrowed.txt"

# User Management Functions
function register_user() {
    local username=$1
    [ -z "$username" ] && return 1
    echo "$username" >> "$USERS_FILE"
    echo "✓ User registered: $username"
}

function user_exists() {
    grep -q "^$1$" "$USERS_FILE" 2>/dev/null
}

# Book Management Functions
function add_book() {
    local title=$1
    local author=$2
    [ -z "$title" ] && return 1
    echo "$title|$author" >> "$BOOKS_FILE"
    echo "✓ Book added: $title"
}

function search_book() {
    local query=$1
    [ ! -f "$BOOKS_FILE" ] && return 1
    grep -i "$query" "$BOOKS_FILE"
}

# Borrow Functions
function borrow_book() {
    local username=$1
    local book=$2
    
    [ ! user_exists "$username" ] && return 1
    echo "$username|$book|$(date +%Y-%m-%d)" >> "$BORROWED_FILE"
    echo "✓ Book borrowed: $book by $username"
}

# Menu
function show_menu() {
    echo ""
    echo "=== Library System ==="
    echo "1. Register user"
    echo "2. Add book"
    echo "3. Search book"
    echo "4. Borrow book"
    echo "5. Exit"
}

# Main
while true; do
    show_menu
    read -p "Choose: " choice
    
    case $choice in
        1) read -p "Username: " u; register_user "$u" ;;
        2) read -p "Title: " t; read -p "Author: " a; add_book "$t" "$a" ;;
        3) read -p "Search: " q; search_book "$q" ;;
        4) read -p "Username: " u; read -p "Book: " b; borrow_book "$u" "$b" ;;
        5) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid" ;;
    esac
done
```

---

## Completion Checklist

- [ ] Exercise 4.1: Math Functions ✓
- [ ] Exercise 4.2: String Functions ✓
- [ ] Exercise 4.3: Validation Functions ✓
- [ ] Exercise 4.4: File Operations ✓
- [ ] Exercise 4.5: Library Management ✓
- [ ] Challenge Exercise (Optional) ✓

---

## Key Concepts to Master

1. **Function Definition**: Proper syntax and structure
2. **Parameters**: Using `$1`, `$2`, etc. correctly
3. **Local Variables**: Using `local` keyword
4. **Return Values**: Proper error codes (0 = success, 1 = failure)
5. **Output Capture**: Using `variable=$(function_name)`
6. **Error Handling**: Checking return codes with `$?`

---

## Next Steps

Once completed:
1. Review solutions
2. Combine with previous topics (loops + functions, conditionals + functions)
3. Create your own utility functions
4. Move to **Topic 5: File Operations**

---

**Difficulty**: ⭐⭐⭐ (Intermediate)

**Time**: 60-90 minutes

**When Ready**: [Go to Topic 5 →](../topics/05-file-operations.md)
