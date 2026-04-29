# Topic 3: Control Flow (if/else, loops)

**Status**: ✅ Ready to Learn  
**Duration**: 2-3 hours  
**Prerequisites**: [Topic 2: Variables and User Input](02-variables.md)  
**Next Topic**: [Topic 4: Functions (Coming Soon)](04-functions.md)

---

## Table of Contents

- [What Is Control Flow?](#what-is-control-flow)
- [Conditional Statements (if/else)](#conditional-statements)
- [Test Operators](#test-operators)
- [Logical Operators](#logical-operators)
- [Case Statements](#case-statements)
- [Loops: for](#loops-for)
- [Loops: while](#loops-while)
- [Loop Control (break, continue)](#loop-control)
- [Practice Exercises](#practice-exercises)
- [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)

---

## What Is Control Flow?

**Control flow** means deciding what code to run based on conditions. Instead of running every line of code in order, you can:

- **Skip** code if a condition is false
- **Repeat** code multiple times
- **Choose** between different code paths

### Real-World Example (Library)

```bash
if [ user_has_borrowed_book ]; then
    echo "Cannot borrow - already has a book"
else
    echo "Book borrowed successfully"
fi
```

---

## Conditional Statements

### Basic if Statement

```bash
if [ condition ]; then
    # Code runs if condition is TRUE
fi
```

### if-else Statement

```bash
if [ condition ]; then
    # Code runs if TRUE
else
    # Code runs if FALSE
fi
```

### if-elif-else Statement

```bash
if [ condition1 ]; then
    # Runs if condition1 is TRUE
elif [ condition2 ]; then
    # Runs if condition2 is TRUE (and condition1 was FALSE)
else
    # Runs if both are FALSE
fi
```

### Important: Spaces in Square Brackets

❌ **Wrong**: `if[condition]`  
✅ **Right**: `if [ condition ]` (spaces around condition)

---

## Test Operators

These test conditions and return TRUE or FALSE.

### Numeric Comparisons

| Operator | Meaning | Example |
|----------|---------|---------|
| `-eq` | Equal to | `[ $age -eq 25 ]` |
| `-ne` | Not equal to | `[ $age -ne 25 ]` |
| `-lt` | Less than | `[ $age -lt 18 ]` |
| `-le` | Less than or equal | `[ $age -le 18 ]` |
| `-gt` | Greater than | `[ $age -gt 18 ]` |
| `-ge` | Greater than or equal | `[ $age -ge 18 ]` |

### String Comparisons

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal to | `[ "$name" = "Alice" ]` |
| `!=` | Not equal to | `[ "$name" != "Bob" ]` |
| `-z` | String is empty | `[ -z "$name" ]` |
| `-n` | String is NOT empty | `[ -n "$name" ]` |

### File Tests

| Operator | Meaning | Example |
|----------|---------|---------|
| `-f` | File exists | `[ -f "file.txt" ]` |
| `-d` | Directory exists | `[ -d "mydir" ]` |
| `-e` | File/dir exists | `[ -e "something" ]` |
| `-r` | File readable | `[ -r "file.txt" ]` |
| `-w` | File writable | `[ -w "file.txt" ]` |
| `-x` | File executable | `[ -x "script.sh" ]` |

### Examples

```bash
#!/bin/bash

age=25

# Numeric test
if [ $age -gt 18 ]; then
    echo "You are an adult"
fi

# String test
name="Alice"
if [ "$name" = "Alice" ]; then
    echo "Hello, Alice!"
fi

# File test
if [ -f "books.csv" ]; then
    echo "File exists"
fi

# Empty string test
if [ -z "$username" ]; then
    echo "Username is empty!"
fi
```

---

## Logical Operators

Combine multiple conditions using logical operators.

| Operator | Meaning | Example |
|----------|---------|---------|
| `-a` or `&&` | AND (both must be true) | `[ $age -gt 18 -a $age -lt 65 ]` |
| `-o` or `\|\|` | OR (at least one true) | `[ $role = "admin" -o $role = "moderator" ]` |
| `!` | NOT (reverse condition) | `[ ! -f "file.txt" ]` |

### Examples

```bash
#!/bin/bash

age=25
name="Alice"

# AND - both conditions must be true
if [ $age -gt 18 ] && [ "$name" = "Alice" ]; then
    echo "Alice is an adult"
fi

# OR - at least one must be true
if [ $role = "admin" ] || [ $role = "manager" ]; then
    echo "You have admin access"
fi

# NOT - reverse the condition
if [ ! -z "$username" ]; then
    echo "Username is not empty"
fi

# Multiple conditions
if [ $age -ge 18 ] && [ $age -le 65 ] && [ "$status" = "active" ]; then
    echo "Valid working age"
fi
```

---

## Case Statements

Use `case` when you have many possible values to check.

### Syntax

```bash
case $variable in
    value1)
        # Code if variable equals value1
        ;;
    value2)
        # Code if variable equals value2
        ;;
    *)
        # Default case (like else)
        ;;
esac
```

### Example: Library Operations

```bash
#!/bin/bash

read -p "Choose operation (borrow/return/search/quit): " operation

case $operation in
    borrow)
        echo "Enter book title:"
        read book
        echo "Borrowing: $book"
        ;;
    return)
        echo "Returning book..."
        ;;
    search)
        echo "Searching library..."
        ;;
    quit)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid operation!"
        ;;
esac
```

### Pattern Matching in case

```bash
case $filename in
    *.txt)
        echo "Text file"
        ;;
    *.pdf)
        echo "PDF file"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac
```

---

## Loops: for

Repeat code a specific number of times or for each item in a list.

### for-in Loop (Iterate Over Values)

```bash
for item in list; do
    # Code runs for each item
    echo $item
done
```

### Example: List of Books

```bash
#!/bin/bash

# Loop through list of items
for book in "Alice in Wonderland" "1984" "The Great Gatsby"; do
    echo "Book: $book"
done
```

**Output**:
```
Book: Alice in Wonderland
Book: 1984
Book: The Great Gatsby
```

### for Loop with Numbers

```bash
#!/bin/bash

# Loop from 1 to 5
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# Or using range
for i in {1..5}; do
    echo "Number: $i"
done

# Using seq command
for i in $(seq 1 5); do
    echo "Number: $i"
done
```

### for Loop with Command-Line Arguments

```bash
#!/bin/bash

# Loop through all arguments
for arg in "$@"; do
    echo "Processing: $arg"
done

# Running:
# ./script.sh apple banana cherry
# Output:
# Processing: apple
# Processing: banana
# Processing: cherry
```

### for Loop with Arrays

```bash
#!/bin/bash

books=("1984" "Alice in Wonderland" "The Great Gatsby")

for book in "${books[@]}"; do
    echo "Title: $book"
done
```

### C-Style for Loop

```bash
#!/bin/bash

# Loop from 0 to 4
for ((i=0; i<5; i++)); do
    echo "Count: $i"
done
```

---

## Loops: while

Repeat code while a condition is TRUE.

### Syntax

```bash
while [ condition ]; do
    # Code runs while condition is TRUE
done
```

### Examples

```bash
#!/bin/bash

# Loop while counter < 5
counter=1
while [ $counter -le 5 ]; do
    echo "Count: $counter"
    counter=$(( counter + 1 ))
done
```

**Output**:
```
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
```

### Interactive Loop

```bash
#!/bin/bash

# Keep asking until user quits
while true; do
    read -p "Enter command (quit to exit): " cmd
    
    if [ "$cmd" = "quit" ]; then
        break
    fi
    
    echo "You entered: $cmd"
done

echo "Program ended"
```

### Reading File Line by Line

```bash
#!/bin/bash

# Read books.csv line by line
while IFS=',' read -r title author year; do
    echo "Book: $title by $author ($year)"
done < "books.csv"
```

---

## Loop Control

### break - Exit Loop Early

```bash
#!/bin/bash

for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "Stopping at 5"
        break  # Exit the loop
    fi
    echo "Number: $i"
done

echo "Loop ended"
```

**Output**:
```
Number: 1
Number: 2
Number: 3
Number: 4
Stopping at 5
Loop ended
```

### continue - Skip to Next Iteration

```bash
#!/bin/bash

for i in {1..5}; do
    if [ $i -eq 3 ]; then
        echo "Skipping 3"
        continue  # Skip this iteration
    fi
    echo "Number: $i"
done
```

**Output**:
```
Number: 1
Number: 2
Skipping 3
Number: 4
Number: 5
```

---

## Practice Exercises

### Exercise 3.1: Simple if-else

**Description**: Check if a user is an adult based on age.

**Requirements**:
- Accept age as argument
- Check if age >= 18
- Display appropriate message

**Solution**:
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <age>"
    exit 1
fi

age=$1

if [ $age -ge 18 ]; then
    echo "You are an adult"
else
    echo "You are a minor"
fi
```

---

### Exercise 3.2: Numeric Comparison

**Description**: Compare two numbers and display the result.

**Requirements**:
- Accept two numbers as arguments
- Compare them
- Display which is larger

**Solution**:
```bash
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <num1> <num2>"
    exit 1
fi

num1=$1
num2=$2

if [ $num1 -eq $num2 ]; then
    echo "$num1 equals $num2"
elif [ $num1 -gt $num2 ]; then
    echo "$num1 is greater than $num2"
else
    echo "$num2 is greater than $num1"
fi
```

---

### Exercise 3.3: Logical Operators

**Description**: Check if a book is available based on multiple conditions.

**Requirements**:
- Accept book status and availability as arguments
- Check multiple conditions with && and ||
- Display if book can be borrowed

**Solution**:
```bash
#!/bin/bash

read -p "Is book available? (yes/no): " available
read -p "Is user registered? (yes/no): " registered
read -p "Does user have book borrowed? (yes/no): " has_book

if [ "$available" = "yes" ] && [ "$registered" = "yes" ] && [ "$has_book" = "no" ]; then
    echo "You can borrow this book!"
else
    echo "You cannot borrow this book"
fi
```

---

### Exercise 3.4: Case Statement

**Description**: Create a menu for library operations.

**Requirements**:
- Display menu options
- Accept user choice
- Use case statement
- Handle each operation

**Solution**:
```bash
#!/bin/bash

echo "=== Library Menu ==="
echo "1. Borrow book"
echo "2. Return book"
echo "3. Search book"
echo "4. Exit"

read -p "Choose option (1-4): " choice

case $choice in
    1)
        read -p "Enter book title: " title
        echo "Borrowed: $title"
        ;;
    2)
        echo "Returning book..."
        ;;
    3)
        read -p "Search for: " query
        echo "Searching for: $query"
        ;;
    4)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option!"
        ;;
esac
```

---

### Exercise 3.5: for Loop

**Description**: List all books in catalog.

**Requirements**:
- Create list of books
- Loop through with for
- Display each book

**Solution**:
```bash
#!/bin/bash

books=("1984" "Alice in Wonderland" "The Great Gatsby" "Brave New World")

echo "=== Library Catalog ==="
counter=1

for book in "${books[@]}"; do
    echo "$counter. $book"
    counter=$(( counter + 1 ))
done
```

---

### Exercise 3.6: while Loop with User Input

**Description**: Repeatedly ask user for book titles until they quit.

**Requirements**:
- Use while loop
- Keep asking for input
- Exit on "quit"
- Show summary

**Solution**:
```bash
#!/bin/bash

count=0

while true; do
    read -p "Enter book title (or 'quit' to exit): " title
    
    if [ "$title" = "quit" ]; then
        break
    fi
    
    echo "Added: $title"
    count=$(( count + 1 ))
done

echo "Total books added: $count"
```

---

### Challenge Exercise: Library Search with Control Flow

**Description**: Create a system to search and borrow books.

**Requirements**:
- Display menu (case statement)
- Implement search (for loop through catalog)
- Implement borrow (check conditions with if/else)
- Repeat menu until quit

**Starter Code**:
```bash
#!/bin/bash

books=("1984" "Alice in Wonderland" "The Great Gatsby")
borrowed=()

while true; do
    echo ""
    echo "=== Library System ==="
    echo "1. Search book"
    echo "2. Borrow book"
    echo "3. View borrowed"
    echo "4. Quit"
    
    read -p "Choose: " choice
    
    case $choice in
        1)
            read -p "Search for: " query
            for book in "${books[@]}"; do
                if [[ "$book" == *"$query"* ]]; then
                    echo "Found: $book"
                fi
            done
            ;;
        2)
            read -p "Borrow which book: " book_to_borrow
            # Add logic to borrow
            ;;
        3)
            echo "Your borrowed books:"
            for book in "${borrowed[@]}"; do
                echo "- $book"
            done
            ;;
        4)
            echo "Goodbye!"
            break
            ;;
    esac
done
```

---

## Common Pitfalls

### ❌ Pitfall 1: Missing Spaces in [ ]

**Wrong**:
```bash
if[ $age -gt 18 ]; then
```

**Right**:
```bash
if [ $age -gt 18 ]; then
```

---

### ❌ Pitfall 2: Using = Instead of -eq for Numbers

**Wrong**:
```bash
if [ $age = 18 ]; then
```

**Right**:
```bash
if [ $age -eq 18 ]; then
```

---

### ❌ Pitfall 3: Missing Quotes on String Variables

**Wrong**:
```bash
if [ $name = Alice ]; then
```

**Right**:
```bash
if [ "$name" = "Alice" ]; then
```

---

### ❌ Pitfall 4: Missing ;; in case

**Wrong**:
```bash
case $choice in
    1)
        echo "One"
    2)
        echo "Two"
    ;;
esac
```

**Right**:
```bash
case $choice in
    1)
        echo "One"
        ;;
    2)
        echo "Two"
        ;;
esac
```

---

### ❌ Pitfall 5: Infinite while Loop

**Wrong**:
```bash
while true; do
    echo "Hello"
done
# Never exits!
```

**Right**:
```bash
while true; do
    read -p "Continue? (y/n): " ans
    if [ "$ans" = "n" ]; then
        break
    fi
done
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **if-else** | Make decisions based on conditions |
| **Test operators** | `-eq`, `-gt`, `-lt`, `=`, `!=`, `-f`, `-d` |
| **Logical operators** | `&&` (AND), `\|\|` (OR), `!` (NOT) |
| **case statement** | Choose between multiple options |
| **for loop** | Repeat for each item in a list |
| **while loop** | Repeat while condition is TRUE |
| **break/continue** | Control loop execution |

### You Can Now

✅ Make decisions with if/else/elif  
✅ Test conditions with operators  
✅ Use logical operators  
✅ Create menus with case  
✅ Loop through lists with for  
✅ Loop with conditions using while  
✅ Control loops with break/continue  

### Real Project Application

For your **Library System**:
- **bootstrap.sh**: Loop through books.csv, check if file exists
- **user.sh**: Check if user registered, book available (if/else)
- **library.c**: Loop through catalog (for/while)
- **manage.sh**: Menu system (case statement)

---

## Quick Reference

```bash
# if-else
if [ condition ]; then
    code
else
    code
fi

# Numeric tests
[ $a -eq $b ]    # Equal
[ $a -ne $b ]    # Not equal
[ $a -lt $b ]    # Less than
[ $a -gt $b ]    # Greater than

# String tests
[ "$a" = "$b" ]  # Equal
[ "$a" != "$b" ] # Not equal
[ -z "$a" ]      # Empty
[ -n "$a" ]      # Not empty

# Logical operators
[ $a -gt 0 ] && [ $b -lt 10 ]    # AND
[ $a -eq 1 ] || [ $a -eq 2 ]     # OR
[ ! -f "file" ]                   # NOT

# case statement
case $var in
    pattern1) code ;; 
    *) default ;;
esac

# for loop
for item in list; do
    code
done

# while loop
while [ condition ]; do
    code
done

# Loop control
break      # Exit loop
continue   # Skip to next iteration
```

---

**Ready to move on?** Go to [Topic 4: Functions](#) 🚀

**Need to review Topic 2?** Go back to [Topic 2: Variables and User Input](02-variables.md)
