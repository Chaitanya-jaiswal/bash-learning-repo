# Exercise Set 7: Debugging & Error Handling

**Topic**: Debugging & Error Handling  
**Difficulty**: ⭐⭐⭐ (Intermediate)  
**Time**: 60-90 minutes  
**Prerequisites**: Complete [Topic 6](../topics/06-ipc.md) and read [Topic 7](../topics/07-debugging.md)

---

## Instructions

1. **Create a new directory**:
   ```bash
   mkdir -p ~/bash-exercises/set-7
   cd ~/bash-exercises/set-7
   ```

2. **For each exercise**:
   - Read the description
   - Write your script
   - Test it thoroughly with edge cases
   - Compare with solution

3. **Test edge cases** - this is critical for debugging!

---

## Exercise 7.1: Define Error Codes

**Description**: Create a constants file with error codes and use it in a script.

**Requirements**:
- Create `error_codes.sh` file with error code definitions
- Create a script that uses these error codes
- Test different error scenarios
- Return appropriate codes

**Test cases**:
```bash
./library_search.sh                    # No args
./library_search.sh 999 "Invalid"      # Invalid library
./library_search.sh 1 "1984"           # Valid search
```

<details>
<summary>✅ Click to reveal solution</summary>

**error_codes.sh**:
```bash
#!/bin/bash
# Define error codes for library system

readonly SUCCESS=0
readonly INVALID_INPUT=1
readonly FILE_NOT_FOUND=2
readonly BOOK_NOT_FOUND=10
readonly BOOK_UNAVAILABLE=11
readonly USER_NOT_REGISTERED=12
readonly LIBRARY_UNREACHABLE=20
readonly IPC_TIMEOUT=30
readonly UNKNOWN_ERROR=99
```

**library_search.sh**:
```bash
#!/bin/bash

source error_codes.sh

# Validate input
if [ $# -lt 2 ]; then
    echo "Usage: $0 <library_id> <book_title>"
    exit $INVALID_INPUT
fi

library_id="$1"
book_title="$2"
catalog="catalog_${library_id}.csv"

# Validate library ID
if ! [[ "$library_id" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Invalid library ID"
    exit $INVALID_INPUT
fi

# Check catalog exists
if [ ! -f "$catalog" ]; then
    echo "ERROR: Catalog not found for library $library_id"
    exit $FILE_NOT_FOUND
fi

# Search for book
if grep -q "^$book_title," "$catalog"; then
    echo "Book found: $book_title"
    exit $SUCCESS
else
    echo "Book not found: $book_title"
    exit $BOOK_NOT_FOUND
fi
```

</details>

---

## Exercise 7.2: Input Validation

**Description**: Create a script that validates all input before processing.

**Requirements**:
- Validate username is not empty and alphanumeric
- Validate library ID is numeric
- Validate operation is one of: register, borrow, return, search
- Return appropriate error codes
- Show helpful error messages

**Test cases**:
```bash
./validate.sh "" 1 register          # Empty username
./validate.sh "alice" abc borrow     # Invalid library ID
./validate.sh "alice" 1 invalid      # Invalid operation
./validate.sh "alice" 1 register     # Valid
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash

source error_codes.sh

# Validation functions
validate_username() {
    local username="$1"
    
    if [ -z "$username" ]; then
        echo "ERROR: Username cannot be empty"
        return 1
    fi
    
    if ! [[ "$username" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "ERROR: Username must contain only letters, numbers, and underscore"
        return 1
    fi
    
    if [ ${#username} -lt 3 ]; then
        echo "ERROR: Username must be at least 3 characters"
        return 1
    fi
    
    return 0
}

validate_library_id() {
    local lib_id="$1"
    
    if [ -z "$lib_id" ]; then
        echo "ERROR: Library ID cannot be empty"
        return 1
    fi
    
    if ! [[ "$lib_id" =~ ^[0-9]+$ ]]; then
        echo "ERROR: Library ID must be numeric"
        return 1
    fi
    
    if [ "$lib_id" -lt 1 ] || [ "$lib_id" -gt 100 ]; then
        echo "ERROR: Library ID must be between 1 and 100"
        return 1
    fi
    
    return 0
}

validate_operation() {
    local op="$1"
    
    case "$op" in
        register|borrow|return|search)
            return 0
            ;;
        *)
            echo "ERROR: Invalid operation: $op"
            echo "Valid operations: register, borrow, return, search"
            return 1
            ;;
    esac
}

# Main validation
if [ $# -lt 3 ]; then
    echo "Usage: $0 <username> <library_id> <operation>"
    exit $INVALID_INPUT
fi

username="$1"
library_id="$2"
operation="$3"

# Validate all inputs
validate_username "$username" || exit $INVALID_INPUT
validate_library_id "$library_id" || exit $INVALID_INPUT
validate_operation "$operation" || exit $INVALID_INPUT

echo "✓ All inputs valid"
echo "  Username: $username"
echo "  Library: $library_id"
echo "  Operation: $operation"

exit $SUCCESS
```

</details>

---

## Exercise 7.3: Debug Mode Practice

**Description**: Enable debug mode and understand execution flow.

**Requirements**:
- Create a script with variables and operations
- Run with `bash -x` to see execution
- Add conditional debug output
- Identify issues using debug output

**Script to debug**:
```bash
#!/bin/bash

name="$1"
age="$2"

if [ $age > 18 ]; then
    echo "$name is adult"
fi

books_borrowed=$(grep "^$name," borrowed.txt | wc -l)
echo "$name borrowed $books_borrowed books"
```

**Test**:
```bash
bash -x script.sh Alice 25
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash

# Corrected script with debug capability
set -u  # Error on undefined variables

# Optional: debug function
debug() {
    [ "$DEBUG" = "1" ] && echo "DEBUG: $@" >&2
}

debug "Starting script"

# Validate input
if [ $# -lt 2 ]; then
    echo "Usage: $0 <name> <age>"
    exit 1
fi

name="$1"
age="$2"

debug "Name: $name, Age: $age"

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Age must be numeric"
    exit 1
fi

debug "Age validated: $age"

# Use -gt instead of >
if [ "$age" -gt 18 ]; then
    echo "$name is adult"
else
    echo "$name is minor"
fi

# Check if file exists
if [ -f borrowed.txt ]; then
    books_borrowed=$(grep "^$name," borrowed.txt | wc -l)
    debug "Books borrowed by $name: $books_borrowed"
    echo "$name borrowed $books_borrowed books"
else
    debug "borrowed.txt not found"
    echo "No borrowing record found"
fi
```

**Test**:
```bash
bash -x script.sh Alice 25
# Shows all executed commands

# Or with debug function
DEBUG=1 ./script.sh Alice 25
```

</details>

---

## Exercise 7.4: Logging Implementation

**Description**: Add comprehensive logging to a script.

**Requirements**:
- Create logging functions (log_info, log_error, log_debug)
- Log all important operations
- Include timestamps
- Write to log file and console
- Support different log levels

**Deliverable**:
```bash
log_info "User alice registered"
log_error "Book not found: 1984"
log_debug "Checking file permissions"
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash

# Logging setup
readonly LOG_FILE="/tmp/library.log"
readonly LOG_LEVEL="${LOG_LEVEL:-2}"  # 1=error, 2=info, 3=debug

# Log levels
readonly LOG_ERROR=1
readonly LOG_INFO=2
readonly LOG_DEBUG=3

log() {
    local level=$1
    shift
    local message="$@"
    
    # Check if we should log this level
    if [ $level -gt $LOG_LEVEL ]; then
        return
    fi
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local level_name
    
    case $level in
        $LOG_ERROR)  level_name="ERROR" ;;
        $LOG_INFO)   level_name="INFO"  ;;
        $LOG_DEBUG)  level_name="DEBUG" ;;
        *)           level_name="UNKNOWN" ;;
    esac
    
    local log_msg="[$timestamp] [$level_name] $message"
    
    # Write to file
    echo "$log_msg" >> "$LOG_FILE"
    
    # Write to console (errors to stderr)
    if [ $level -eq $LOG_ERROR ]; then
        echo "$log_msg" >&2
    else
        echo "$log_msg"
    fi
}

log_error() {
    log $LOG_ERROR "$@"
}

log_info() {
    log $LOG_INFO "$@"
}

log_debug() {
    log $LOG_DEBUG "$@"
}

# Usage example
main() {
    log_info "Library system starting"
    
    if [ ! -f "catalog.csv" ]; then
        log_error "Catalog file not found"
        return 1
    fi
    
    log_debug "Catalog loaded successfully"
    log_info "System ready"
}

# Set log level
export LOG_LEVEL=3
main
```

</details>

---

## Exercise 7.5: Trap and Cleanup

**Description**: Implement robust cleanup using trap.

**Requirements**:
- Create temporary files
- Use trap to ensure cleanup
- Handle multiple signals (EXIT, INT, TERM)
- Test cleanup happens even with Ctrl+C
- Display cleanup status

**Test**:
```bash
./script.sh
# Wait a moment
# Press Ctrl+C to test cleanup
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash

# Cleanup setup
trap cleanup EXIT INT TERM

# Global variables for tracking
temp_files=()
temp_fifos=()
child_pids=()

cleanup() {
    local exit_code=$?
    echo ""
    echo "=== Cleanup in progress ==="
    
    # Kill child processes
    for pid in "${child_pids[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Killing process $pid"
            kill "$pid" 2>/dev/null
        fi
    done
    
    # Remove temporary files
    for file in "${temp_files[@]}"; do
        if [ -f "$file" ]; then
            echo "Removing file: $file"
            rm -f "$file"
        fi
    done
    
    # Remove FIFOs
    for fifo in "${temp_fifos[@]}"; do
        if [ -p "$fifo" ]; then
            echo "Removing FIFO: $fifo"
            rm -f "$fifo"
        fi
    done
    
    echo "=== Cleanup complete ==="
    exit $exit_code
}

# Create tracked temporary files
create_temp_file() {
    local temp_file="/tmp/temp_$$_$RANDOM"
    touch "$temp_file"
    temp_files+=("$temp_file")
    echo "$temp_file"
}

# Create tracked FIFO
create_temp_fifo() {
    local temp_fifo="/tmp/fifo_$$_$RANDOM"
    mkfifo "$temp_fifo"
    temp_fifos+=("$temp_fifo")
    echo "$temp_fifo"
}

# Track background process
track_pid() {
    local pid=$1
    child_pids+=("$pid")
}

# Main execution
main() {
    echo "Creating temporary resources..."
    
    # Create temp files
    file1=$(create_temp_file)
    file2=$(create_temp_file)
    echo "Created: $file1"
    echo "Created: $file2"
    
    # Create FIFO
    fifo=$(create_temp_fifo)
    echo "Created FIFO: $fifo"
    
    # Start background process
    (
        echo "Background process starting"
        sleep 10
        echo "Background process done"
    ) &
    track_pid $!
    
    echo ""
    echo "System running. Press Ctrl+C to stop..."
    sleep 30
    
    echo "All operations complete"
}

main
```

</details>

---

## Exercise 7.6: Error Handling in Functions

**Description**: Implement error handling patterns in functions.

**Requirements**:
- Create functions that return error codes
- Use || to handle failures
- Chain operations with error checking
- Return meaningful error codes

**Deliverable**:
```bash
register_user "alice" || {
    echo "Registration failed with code: $?"
}
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash

source error_codes.sh

# Check if file exists and is readable
check_catalog() {
    local catalog="$1"
    
    if [ -z "$catalog" ]; then
        return $INVALID_INPUT
    fi
    
    if [ ! -f "$catalog" ]; then
        return $FILE_NOT_FOUND
    fi
    
    if [ ! -r "$catalog" ]; then
        return 1  # Permission denied
    fi
    
    return $SUCCESS
}

# Register user in file
register_user() {
    local username="$1"
    local users_file="$2"
    
    if [ -z "$username" ] || [ -z "$users_file" ]; then
        return $INVALID_INPUT
    fi
    
    # Check if already registered
    if grep -q "^$username$" "$users_file" 2>/dev/null; then
        return 1  # Already exists
    fi
    
    # Append user
    echo "$username" >> "$users_file" || return 1
    return $SUCCESS
}

# Borrow book with error handling
borrow_book() {
    local username="$1"
    local book="$2"
    local catalog="$3"
    local borrowed_file="$4"
    
    # Check inputs
    if [ -z "$username" ] || [ -z "$book" ] || \
       [ -z "$catalog" ] || [ -z "$borrowed_file" ]; then
        return $INVALID_INPUT
    fi
    
    # Check catalog exists
    check_catalog "$catalog" || return $?
    
    # Check if user registered
    if ! grep -q "^$username$" users.txt 2>/dev/null; then
        return $USER_NOT_REGISTERED
    fi
    
    # Check if user already has book
    if grep -q "^$username," "$borrowed_file" 2>/dev/null; then
        return $USER_ALREADY_HAS_BOOK
    fi
    
    # Check if book exists
    if ! grep -q "^$book," "$catalog" 2>/dev/null; then
        return $BOOK_NOT_FOUND
    fi
    
    # Record borrow
    echo "$username,$book,$(date '+%Y-%m-%d')" >> "$borrowed_file" || return 1
    return $SUCCESS
}

# Usage with error handling
main() {
    # Create test files
    echo "catalog test" > catalog.csv
    > users.txt
    > borrowed.txt
    
    # Test 1: Register user
    if register_user "alice" users.txt; then
        echo "✓ User registered"
    else
        code=$?
        echo "✗ Registration failed: $code"
    fi
    
    # Test 2: Check catalog
    if check_catalog "catalog.csv"; then
        echo "✓ Catalog valid"
    else
        code=$?
        echo "✗ Catalog error: $code"
    fi
    
    # Test 3: Borrow book
    if borrow_book "alice" "1984" "catalog.csv" "borrowed.txt"; then
        echo "✓ Book borrowed"
    else
        code=$?
        echo "✗ Borrow failed: $code"
    fi
    
    # Cleanup
    rm -f catalog.csv users.txt borrowed.txt
}

main
```

</details>

---

## Challenge Exercise: Complete Library Error Handling

**Description**: Create a complete library system with comprehensive error handling.

**Requirements**:
1. Define all error codes
2. Implement validation in all scripts
3. Add logging to track operations
4. Use trap for cleanup
5. Create test suite
6. Handle concurrent access

**Deliverable**:
```bash
# bootstrap.sh
./bootstrap.sh 3 books.csv

# Check status
./manage.sh status

# User operations with error handling
./user.sh alice 1 register
./user.sh alice 1 borrow "1984"

# Test concurrent access
./user.sh bob 1 register &
./user.sh charlie 1 register &
wait
```

**Checklist**:
- [ ] error_codes.sh defined
- [ ] bootstrap.sh validates inputs and starts libraries
- [ ] user.sh validates all operations
- [ ] manage.sh provides status and cleanup
- [ ] All scripts have logging
- [ ] All scripts cleanup on exit
- [ ] Test suite for edge cases
- [ ] Concurrent operations tested

---

## Completion Checklist

- [ ] Exercise 7.1: Error Codes ✓
- [ ] Exercise 7.2: Input Validation ✓
- [ ] Exercise 7.3: Debug Mode ✓
- [ ] Exercise 7.4: Logging ✓
- [ ] Exercise 7.5: Trap & Cleanup ✓
- [ ] Exercise 7.6: Error Handling Functions ✓
- [ ] Challenge Exercise ✓

---

## Next Steps

Once completed:
1. Review solutions thoroughly
2. Integrate patterns into your library project
3. Test with edge cases
4. Monitor logs for issues
5. Ready for implementation!

---

**Difficulty**: ⭐⭐⭐ (Intermediate - Critical for Production Code)

**Time**: 60-90 minutes

**Ready for**: Library System Implementation 🚀
