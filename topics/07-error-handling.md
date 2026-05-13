# Topic 7: Error Handling & Debugging

**Status**: ✅ Ready to Learn  
**Duration**: 2-3 hours  
**Prerequisites**: [Topic 6: Interprocess Communication](06-ipc.md)  
**Next**: Library System Project Implementation

---

## Table of Contents

- [Why Error Handling Matters](#why-error-handling-matters)
- [Exit Codes and Return Values](#exit-codes-and-return-values)
- [Error Checking](#error-checking)
- [Error Handling Strategies](#error-handling-strategies)
- [Trap and Cleanup](#trap-and-cleanup)
- [Debugging Techniques](#debugging-techniques)
- [Logging](#logging)
- [Production-Ready Patterns](#production-ready-patterns)
- [Common Pitfalls](#common-pitfalls)
- [Practice Exercises](#practice-exercises)
- [Summary](#summary)

---

## Why Error Handling Matters

For your **Library System Project**, errors WILL happen:
- User provides invalid input
- Files don't exist or can't be read
- Network/IPC communication fails
- Permission issues
- Race conditions in concurrent operations

Without proper error handling:
- ❌ Silent failures that corrupt data
- ❌ Inconsistent library state
- ❌ Books lost or duplicated
- ❌ Crashes that leave processes hanging
- ❌ No way to debug what went wrong

With proper error handling:
- ✅ Graceful degradation
- ✅ Consistent state
- ✅ Clear error messages
- ✅ Automatic cleanup
- ✅ Reproducible debugging

---

## Exit Codes and Return Values

### Understanding Exit Codes

Every command returns an **exit code** (0-255):
- **0** = Success
- **Non-zero** = Failure (1, 2, 127, 255, etc.)

```bash
#!/bin/bash

# Success
echo "Hello"
echo $?    # Output: 0

# Failure
cat /nonexistent/file.txt
echo $?    # Output: 1

# Command not found
/nonexistent/command
echo $?    # Output: 127
```

### Check Exit Code Immediately

```bash
#!/bin/bash

# Correct: check right after command
grep "search_term" file.txt
if [ $? -ne 0 ]; then
    echo "Search failed"
fi

# Better: use if directly
if grep "search_term" file.txt; then
    echo "Found"
else
    echo "Not found"
fi

# Best: use || and &&
grep "search_term" file.txt || echo "Not found"
```

### Common Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Misuse of shell built-in |
| 126 | Command invoked cannot execute |
| 127 | Command not found |
| 128+N | Fatal error signal N |
| 130 | Script terminated by Ctrl+C |

### Define Custom Exit Codes

For your Library System:

```bash
#!/bin/bash

# Define error codes
readonly SUCCESS=0
readonly ERR_USER_NOT_FOUND=10
readonly ERR_BOOK_NOT_FOUND=11
readonly ERR_BOOK_UNAVAILABLE=12
readonly ERR_USER_NOT_REGISTERED=13
readonly ERR_ALREADY_BORROWED=14
readonly ERR_FILE_NOT_FOUND=20
readonly ERR_IPC_FAILED=30
readonly ERR_INVALID_INPUT=40

# Use them
if [ ! -f "$catalog_file" ]; then
    echo "Error: Catalog file not found: $catalog_file"
    exit $ERR_FILE_NOT_FOUND
fi

if [ "$available" != "yes" ]; then
    echo "Error: Book is not available"
    exit $ERR_BOOK_UNAVAILABLE
fi

exit $SUCCESS
```

---

## Error Checking

### Check Command Success

```bash
#!/bin/bash

# Pattern 1: Check after each command
cd /tmp || exit 1
mkdir mydir || exit 1

# Pattern 2: Use set -e (exit on any error)
set -e
cd /tmp
mkdir mydir
# Script exits here if mkdir fails

# Pattern 3: Use set -o pipefail (exit if any pipe command fails)
set -o pipefail
cat file.txt | grep "search" | wc -l
# Exits if any part fails, not just the last command
```

### Validate Input

```bash
#!/bin/bash

# Check argument exists
if [ $# -lt 1 ]; then
    echo "Usage: $0 <username>"
    exit 40
fi

username="$1"

# Check not empty
if [ -z "$username" ]; then
    echo "Error: Username cannot be empty"
    exit 40
fi

# Check length
if [ ${#username} -gt 50 ]; then
    echo "Error: Username too long (max 50 chars)"
    exit 40
fi

# Check format (alphanumeric only)
if ! [[ "$username" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Error: Username must be alphanumeric"
    exit 40
fi
```

### Check File Operations

```bash
#!/bin/bash

file="$1"

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File not found: $file"
    exit 20
fi

# Check if readable
if [ ! -r "$file" ]; then
    echo "Error: File not readable: $file"
    exit 20
fi

# Check if writable
if [ ! -w "$file" ]; then
    echo "Error: File not writable: $file"
    exit 20
fi

# Safe read with error checking
while IFS=',' read -r title author year; do
    if [ -z "$title" ]; then
        echo "Error: Empty book title in $file"
        exit 20
    fi
done < "$file" || {
    echo "Error: Failed to read file: $file"
    exit 20
}
```

---

## Error Handling Strategies

### Strategy 1: Fail Fast (set -e)

Exit immediately on any error:

```bash
#!/bin/bash
set -e  # Exit on error
set -o pipefail  # Exit if pipe fails

# Any error here stops the script
cd /tmp
mkdir mydir
cp file.txt mydir/
ls mydir/

# If any command fails, script stops (cleanup with trap)
```

**Good for:** Linear scripts where one failure stops everything

**Bad for:** Scripts that need to attempt multiple operations

### Strategy 2: Check After Each Command

```bash
#!/bin/bash

# Attempt to borrow book
./library 1 borrow alice "1984" > /tmp/response.txt
status=$?

if [ $status -ne 0 ]; then
    echo "Error: Failed to borrow book (status: $status)"
    cat /tmp/response.txt
    exit 1
fi

echo "Book borrowed successfully"
```

**Good for:** Operations that might fail but should try alternatives

### Strategy 3: Try-Catch Pattern

```bash
#!/bin/bash

attempt_operation() {
    # Try something
    if ! grep "pattern" file.txt > /dev/null 2>&1; then
        return 1
    fi
    return 0
}

# Use it
if attempt_operation; then
    echo "Success"
else
    echo "Failed"
    # Try alternative
fi
```

### Strategy 4: Default Values and Fallback

```bash
#!/bin/bash

# Provide defaults
library_id="${1:-1}"
catalog_file="${2:-catalog_$library_id.csv}"

# Check main file, fallback to default
if [ ! -f "$catalog_file" ]; then
    catalog_file="default_catalog.csv"
    if [ ! -f "$catalog_file" ]; then
        echo "Error: No catalog file found"
        exit 20
    fi
fi
```

---

## Trap and Cleanup

### Basic Trap

```bash
#!/bin/bash

# Run cleanup on exit
trap cleanup EXIT

cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/temp_$$
    pkill -f "process_name"
}

# Main code
mkfifo /tmp/temp_$$
# ... rest of script
```

### Trap Multiple Signals

```bash
#!/bin/bash

cleanup() {
    echo "Caught signal, cleaning up..."
    rm -f /tmp/lib_*.fifo
    pkill -f "./library"
    exit 1
}

trap cleanup SIGINT SIGTERM

# Script that handles Ctrl+C gracefully
while true; do
    sleep 1
done
```

### Trap with Error Messages

```bash
#!/bin/bash

trap error_handler EXIT ERR

error_handler() {
    local line_num=$1
    echo "Error occurred at line $line_num"
    
    # Cleanup
    rm -f /tmp/temp_*
    
    # Kill background processes
    jobs -p | xargs kill 2>/dev/null
}

# Main code
if [ some_error ]; then
    return 1  # Triggers trap
fi
```

### Complete Trap Pattern for Library

```bash
#!/bin/bash

# Error codes
readonly SUCCESS=0
readonly ERR_GENERAL=1

# File handles
readonly LOG_FILE="/tmp/library_$$.log"
readonly PID_FILE="/tmp/library_$$.pid"
readonly FIFO_REQUEST="/tmp/lib_request.fifo"
readonly FIFO_RESPONSE="/tmp/lib_response.fifo"

# Cleanup function
cleanup() {
    local exit_code=$?
    
    echo "$(date): Cleanup started" >> "$LOG_FILE"
    
    # Remove FIFOs
    rm -f "$FIFO_REQUEST" "$FIFO_RESPONSE"
    
    # Kill child processes
    jobs -p | xargs kill 2>/dev/null
    
    # Remove PID file
    rm -f "$PID_FILE"
    
    echo "$(date): Cleanup complete (exit code: $exit_code)" >> "$LOG_FILE"
    
    exit $exit_code
}

# Set trap
trap cleanup EXIT

# Save PID
echo $$ > "$PID_FILE"

# Main code
echo "$(date): Library started" >> "$LOG_FILE"
# ... rest of script
```

---

## Debugging Techniques

### Technique 1: Debug Mode (set -x)

```bash
#!/bin/bash

# Enable debug output
set -x

# All commands printed before execution
echo "Hello"
num=$((5 + 3))
echo $num

# Output:
# + echo Hello
# Hello
# + num=$((5 + 3))
# + echo 8
# 8
```

Run with debug flag:
```bash
bash -x script.sh
```

### Technique 2: Selective Debug Output

```bash
#!/bin/bash

DEBUG=${DEBUG:-0}  # Set with DEBUG=1 script.sh

debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Use it
debug "Starting operation"
operation_result=$(perform_operation)
debug "Operation returned: $operation_result"

if [ -z "$operation_result" ]; then
    echo "Error: Operation failed"
    exit 1
fi
```

Run with:
```bash
DEBUG=1 ./script.sh
```

### Technique 3: Verbose Error Messages

```bash
#!/bin/bash

# Bad error message
grep "$search" file.txt || exit 1

# Good error message
if ! grep "$search" file.txt > /tmp/search_result.txt 2>&1; then
    echo "Error: Search failed"
    echo "  - File: $file"
    echo "  - Search term: '$search'"
    echo "  - Output: $(cat /tmp/search_result.txt)"
    exit 1
fi
```

### Technique 4: Stack Trace on Error

```bash
#!/bin/bash

error_report() {
    local line_num=$1
    echo "=== Error Report ==="
    echo "Script: $0"
    echo "Line: $line_num"
    echo "Command: $BASH_COMMAND"
    echo ""
    echo "Stack trace:"
    local frame=0
    while caller $frame 2>/dev/null; do
        ((frame++))
    done
}

trap 'error_report $LINENO' ERR
set -o errtrace

# Your code here
```

### Technique 5: Log All Output

```bash
#!/bin/bash

LOG_FILE="/tmp/script_$$.log"

# Redirect all output to log file AND terminal
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

# Now all echo and errors are logged
echo "This is logged"
some_command 2>&1  # Error also logged
```

---

## Logging

### Simple Logging Function

```bash
#!/bin/bash

log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message"
}

log "INFO" "Library system started"
log "DEBUG" "Processing user request: $user"
log "WARN" "Book not found in local catalog"
log "ERROR" "Failed to connect to library 1"
```

### Logging with Levels

```bash
#!/bin/bash

LOG_LEVEL=${LOG_LEVEL:-INFO}  # INFO, DEBUG, WARN, ERROR

log_debug() {
    [ "$LOG_LEVEL" = "DEBUG" ] && echo "[DEBUG] $*" || true
}

log_info() {
    echo "[INFO] $*"
}

log_warn() {
    echo "[WARN] $*" >&2
}

log_error() {
    echo "[ERROR] $*" >&2
}

# Use it
log_debug "Starting process"
log_info "Processing user: alice"
log_warn "Retrying connection"
log_error "Connection failed"
```

Run with:
```bash
LOG_LEVEL=DEBUG ./script.sh
```

### Logging to File

```bash
#!/bin/bash

LOG_FILE="/tmp/library_$$.log"

log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $*" | tee -a "$LOG_FILE"
}

log "System started"
log "Processing request"
log "Operation complete"

# View log
cat "$LOG_FILE"
```

---

## Production-Ready Patterns

### Pattern 1: Safe Script Template

```bash
#!/bin/bash

# Safe defaults
set -euo pipefail
IFS=$'\n\t'

# Script config
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_FILE="/tmp/${SCRIPT_NAME}_$$.log"

# Exit codes
readonly SUCCESS=0
readonly ERROR=1

# Cleanup
cleanup() {
    local exit_code=$?
    rm -f /tmp/temp_$$
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[ERROR] $*" >&2 | tee -a "$LOG_FILE"
}

# Main
main() {
    log "Script started"
    
    # Your code here
    
    log "Script completed"
    return $SUCCESS
}

# Run
main "$@"
```

### Pattern 2: Robust Function

```bash
#!/bin/bash

# Borrow book with full error handling
borrow_book() {
    local username="$1"
    local library_id="$2"
    local book_title="$3"
    
    # Validate inputs
    if [ -z "$username" ] || [ -z "$library_id" ] || [ -z "$book_title" ]; then
        log_error "Missing parameters: username=$username, library=$library_id, book=$book_title"
        return 40
    fi
    
    # Check preconditions
    if ! is_user_registered "$username" "$library_id"; then
        log_error "User not registered: $username in library $library_id"
        return 13
    fi
    
    # Try operation
    if ! send_request "$library_id" "borrow|$username|$book_title"; then
        log_error "Failed to send request to library $library_id"
        return 30
    fi
    
    # Get response
    local response
    if ! response=$(wait_response "$library_id" 5); then
        log_error "No response from library $library_id"
        return 30
    fi
    
    # Check result
    if [ "$response" != "OK" ]; then
        log_warn "Borrow request denied: $response"
        return 12
    fi
    
    log "Book borrowed: $username borrowed '$book_title' from library $library_id"
    return 0
}
```

### Pattern 3: Defensive Programming

```bash
#!/bin/bash

# Never trust external input
process_csv() {
    local file="$1"
    
    # Check file exists and is readable
    if [ ! -f "$file" ] || [ ! -r "$file" ]; then
        log_error "Cannot read file: $file"
        return 20
    fi
    
    # Check file is not empty
    if [ ! -s "$file" ]; then
        log_error "File is empty: $file"
        return 20
    fi
    
    # Process line by line
    local line_num=0
    while IFS=',' read -r field1 field2 field3; do
        ((line_num++))
        
        # Validate fields exist
        if [ -z "$field1" ] || [ -z "$field2" ]; then
            log_error "Invalid format at line $line_num: missing fields"
            continue  # Skip this line instead of crashing
        fi
        
        # Validate field length
        if [ ${#field1} -gt 100 ]; then
            log_warn "Field1 too long at line $line_num, truncating"
            field1="${field1:0:100}"
        fi
        
        # Process safely
        process_entry "$field1" "$field2" "$field3" || {
            log_error "Failed to process line $line_num"
            continue
        }
    done < "$file"
}
```

---

## Common Pitfalls

### ❌ Pitfall 1: Ignoring $?

**Wrong**:
```bash
command_that_might_fail
next_command  # Runs even if first failed!
```

**Right**:
```bash
command_that_might_fail || exit 1
next_command
```

---

### ❌ Pitfall 2: Not Cleaning Up on Error

**Wrong**:
```bash
mkfifo /tmp/fifo
# Script exits with error
# FIFO left behind!
```

**Right**:
```bash
mkfifo /tmp/fifo
trap "rm -f /tmp/fifo" EXIT
```

---

### ❌ Pitfall 3: Unquoted Variables

**Wrong**:
```bash
file=$1
if [ -f $file ]; then  # Fails if $file has spaces
    cat $file
fi
```

**Right**:
```bash
file="$1"
if [ -f "$file" ]; then
    cat "$file"
fi
```

---

### ❌ Pitfall 4: Catching Wrong Errors

**Wrong**:
```bash
set -e
command1 | command2  # Only last command's error caught
```

**Right**:
```bash
set -e
set -o pipefail
command1 | command2  # Any error in pipe caught
```

---

### ❌ Pitfall 5: Debug Output in Production

**Wrong**:
```bash
set -x  # Leaves debug output running in production
echo "Processing: $password"  # Exposes secrets!
```

**Right**:
```bash
if [ "${DEBUG:-0}" = "1" ]; then
    set -x
fi
echo "Processing: [REDACTED]"  # Protect secrets
```

---

## Practice Exercises

### Exercise 7.1: Basic Error Checking

**Description**: Write a script that validates user input and returns appropriate error codes.

**Requirements**:
- Accept username as argument
- Validate it's not empty
- Validate it's alphanumeric
- Validate it's not too long (max 50 chars)
- Return correct error codes

**Solution**:
```bash
#!/bin/bash

# Error codes
readonly ERR_INVALID_INPUT=40
readonly ERR_EMPTY=41
readonly ERR_TOO_LONG=42

validate_username() {
    local username="$1"
    
    # Check empty
    if [ -z "$username" ]; then
        echo "Error: Username cannot be empty"
        return $ERR_EMPTY
    fi
    
    # Check length
    if [ ${#username} -gt 50 ]; then
        echo "Error: Username too long (max 50 chars)"
        return $ERR_TOO_LONG
    fi
    
    # Check alphanumeric
    if ! [[ "$username" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Username must be alphanumeric"
        return $ERR_INVALID_INPUT
    fi
    
    echo "Valid username: $username"
    return 0
}

# Test it
validate_username "$1"
exit $?
```

---

### Exercise 7.2: Trap and Cleanup

**Description**: Create a script that cleans up resources on exit.

**Solution**:
```bash
#!/bin/bash

# Resources
readonly FIFO="/tmp/test_$$.fifo"
readonly LOG="/tmp/test_$$.log"

# Cleanup handler
cleanup() {
    local exit_code=$?
    echo "Cleaning up (exit code: $exit_code)"
    rm -f "$FIFO" "$LOG"
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Create resources
mkfifo "$FIFO"
echo "FIFO created: $FIFO" | tee "$LOG"

# Simulate work
sleep 2
echo "Work done" | tee -a "$LOG"

# Exit (trap runs cleanup)
```

---

### Exercise 7.3: Debug Mode

**Description**: Add debug capabilities to a script.

**Solution**:
```bash
#!/bin/bash

DEBUG=${DEBUG:-0}

debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "[DEBUG] $*" >&2
    fi
}

main() {
    debug "Script started with arguments: $@"
    
    for arg in "$@"; do
        debug "Processing: $arg"
        echo "Processing: $arg"
    done
    
    debug "Script completed"
}

main "$@"
```

Run with:
```bash
DEBUG=1 ./script.sh arg1 arg2
```

---

### Exercise 7.4: Logging Function

**Description**: Create a logging system with levels.

**Solution**:
```bash
#!/bin/bash

LOG_FILE="/tmp/app_$$.log"
LOG_LEVEL="INFO"  # Can be DEBUG, INFO, WARN, ERROR

log_debug() { [ "$LOG_LEVEL" = "DEBUG" ] && echo "[DEBUG] $*" | tee -a "$LOG_FILE"; }
log_info() { echo "[INFO] $*" | tee -a "$LOG_FILE"; }
log_warn() { echo "[WARN] $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[ERROR] $*" | tee -a "$LOG_FILE"; }

# Use it
log_info "Application started"
log_debug "Debug information"
log_warn "Warning message"
log_error "Error occurred"

echo "Log saved to: $LOG_FILE"
```

---

### Exercise 7.5: Safe CSV Processing

**Description**: Read a CSV file safely with error handling.

**Solution**:
```bash
#!/bin/bash

process_csv() {
    local file="$1"
    
    # Validate file
    if [ ! -f "$file" ] || [ ! -r "$file" ]; then
        echo "Error: Cannot read file: $file"
        return 20
    fi
    
    local line_num=0
    while IFS=',' read -r title author year || [ -n "$title" ]; do
        ((line_num++))
        
        # Skip empty lines
        if [ -z "$title" ]; then
            continue
        fi
        
        # Validate fields
        if [ -z "$author" ] || [ -z "$year" ]; then
            echo "Warning: Invalid entry at line $line_num: missing fields"
            continue
        fi
        
        # Validate year is numeric
        if ! [[ "$year" =~ ^[0-9]+$ ]]; then
            echo "Warning: Invalid year at line $line_num: $year"
            continue
        fi
        
        # Process valid entry
        echo "Book: $title by $author ($year)"
    done < "$file"
}

process_csv "$1"
```

---

### Challenge Exercise: Library Error Handler

**Description**: Create a library management script with comprehensive error handling.

**Requirements**:
- Define error codes
- Validate all inputs
- Check file operations
- Trap for cleanup
- Debug mode support
- Logging with levels

**Starter Code**:
```bash
#!/bin/bash

set -euo pipefail

# Error codes
readonly SUCCESS=0
readonly ERR_FILE_NOT_FOUND=20
readonly ERR_INVALID_INPUT=40
readonly ERR_OPERATION_FAILED=1

# Config
readonly CATALOG="${1:-books.csv}"
readonly DEBUG=${DEBUG:-0}
readonly LOG_FILE="/tmp/library_$$.log"

# Logging
log() { echo "[INFO] $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[ERROR] $*" >&2 | tee -a "$LOG_FILE"; }
debug() { [ "$DEBUG" -eq 1 ] && echo "[DEBUG] $*" >&2; }

# Cleanup
cleanup() {
    local exit_code=$?
    log "Cleanup started (exit code: $exit_code)"
    # Remove temp files, kill processes
    log "Cleanup complete"
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Main
main() {
    log "Library system started"
    
    # Check catalog file
    if [ ! -f "$CATALOG" ]; then
        log_error "Catalog not found: $CATALOG"
        return $ERR_FILE_NOT_FOUND
    fi
    
    debug "Catalog loaded: $CATALOG"
    
    # Process catalog
    local count=0
    while IFS=',' read -r title author year; do
        [ -z "$title" ] && continue
        ((count++))
        debug "Loaded book: $title"
    done < "$CATALOG"
    
    log "Loaded $count books from catalog"
    return $SUCCESS
}

main "$@"
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **Exit codes** | 0=success, non-zero=failure, check with `$?` |
| **Error checking** | `set -e`, `set -o pipefail`, `||`, `&&` |
| **Input validation** | Always validate user input, file operations, format |
| **Trap handlers** | Cleanup resources on exit, use `trap cleanup EXIT` |
| **Debugging** | `set -x`, debug functions, verbose error messages |
| **Logging** | Log important events, use levels, write to files |
| **Production patterns** | Safe defaults, proper cleanup, error reporting |

### You Can Now

✅ Define and use custom error codes  
✅ Check for errors and handle gracefully  
✅ Validate all user input and file operations  
✅ Clean up resources on exit  
✅ Debug scripts effectively  
✅ Log operations for debugging and audit  
✅ Write production-ready Bash scripts  

### For Your Library Project

Apply these patterns to:
- **bootstrap.sh**: Validate inputs, cleanup FIFOs on exit
- **user.sh**: Check operation success, provide error codes
- **library.c**: Handle IPC failures, validate requests
- **manage.sh**: Check process status, handle missing libraries

---

## Quick Reference

```bash
# Exit codes
echo "Test" || exit 1        # Exit on failure
command && next_command      # Run only if success
$?                          # Last exit code

# Error handling
set -e                      # Exit on error
set -o pipefail             # Exit if pipe fails
set -u                      # Error on undefined variable

# Input validation
[ -z "$var" ]               # Check empty
[[ "$var" =~ ^[a-z]+$ ]]    # Check format
[ -f "$file" ]              # Check file exists

# Trap
trap cleanup EXIT           # Run on exit
trap cleanup INT TERM       # Run on signals

# Debugging
set -x                      # Debug output
bash -x script.sh           # Run with debug
echo "[DEBUG] $var"         # Debug message

# Logging
echo "[INFO] message" | tee -a log.txt
echo "[ERROR] message" >&2
```

---

**You're ready for the Library System project! 🎉**

Topics 1-7 complete. Time to build! 🚀

