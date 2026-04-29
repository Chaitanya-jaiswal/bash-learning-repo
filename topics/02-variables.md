# Topic 2: Variables and User Input

**Status**: ✅ Ready to Learn  
**Duration**: 2-3 hours  
**Prerequisites**: [Topic 1: Introduction to Bash & Basic Syntax](01-intro-basics.md)  
**Next Topic**: [Topic 3: Control Flow (Coming Soon)](03-control-flow.md)

---

## Table of Contents

- [What Are Variables?](#what-are-variables)
- [Creating and Using Variables](#creating-and-using-variables)
- [Variable Naming Rules](#variable-naming-rules)
- [Command-Line Arguments](#command-line-arguments)
- [Reading User Input](#reading-user-input)
- [Variable Operations](#variable-operations)
- [Key Concepts](#key-concepts)
- [Practice Exercises](#practice-exercises)
- [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)

---

## What Are Variables?

A **variable** is a named container that holds a value. Think of it like a labeled box where you can store information and use it later.

### Real-World Example

Imagine your library project:
- You need to store a user's name: `alice`
- You need to store a book title: `"The Great Gatsby"`
- You need to store a library ID: `1`

Instead of typing these values repeatedly, you store them in **variables** and reference them by name.

### Why Use Variables?

| Reason | Example |
|--------|---------|
| **Reusability** | Use `$username` multiple times instead of typing "alice" repeatedly |
| **Easy Updates** | Change the value once, affects all uses |
| **Flexibility** | Accept different values each time script runs |
| **Clarity** | `$user_age` is clearer than just `25` |

---

## Creating and Using Variables

### Basic Syntax

```bash
# Create a variable (no spaces around =)
variable_name="value"

# Use the variable (with $)
echo $variable_name
# or
echo "${variable_name}"
```

### Important Rules

❌ **Wrong**: `variable_name = "value"` (spaces around =)  
✅ **Right**: `variable_name="value"` (no spaces)

❌ **Wrong**: `echo variable_name` (no $)  
✅ **Right**: `echo $variable_name` (with $)

### Simple Example

```bash
#!/bin/bash

# Create variables
name="Alice"
age=25
city="New York"

# Use them
echo "My name is $name"
echo "I am $age years old"
echo "I live in $city"
```

**Output**:
```
My name is Alice
I am 25 years old
I live in New York
```

---

## Variable Naming Rules

Variables must follow these rules:

| Rule | Valid Examples | Invalid Examples |
|------|----------------|------------------|
| Start with letter or underscore | `name`, `_id`, `user_name` | `1name`, `$name` |
| Only letters, numbers, underscores | `book_title_1`, `lib_id` | `book-title`, `lib.id` |
| Case-sensitive | `$Name` ≠ `$name` | - |
| No spaces | `user_name` | `user name` |
| No special characters | `title_v2` | `title@2`, `title*2` |

### Naming Best Practices

```bash
# Good: Clear and descriptive
user_name="Alice"
library_id=1
book_title="The Great Gatsby"

# Bad: Unclear or single letter
u="Alice"
l=1
t="The Great Gatsby"

# Bad: ALL_CAPS (usually reserved for constants)
USERNAME="Alice"  # OK for constants, not variables
```

---

## Command-Line Arguments

When you run a script with arguments, Bash automatically creates variables for them:

```bash
./script.sh arg1 arg2 arg3
```

These become:

| Variable | Contains | Example |
|----------|----------|---------|
| `$0` | Script name | `script.sh` |
| `$1` | First argument | `arg1` |
| `$2` | Second argument | `arg2` |
| `$3` | Third argument | `arg3` |
| `$#` | Total number of arguments | `3` |
| `$@` | All arguments as separate items | `arg1 arg2 arg3` |
| `$*` | All arguments as one string | `"arg1 arg2 arg3"` |

### Example 1: Simple Arguments

**Script**: `greet.sh`
```bash
#!/bin/bash

echo "Hello, $1!"
echo "You are $2 years old"
echo "Welcome to $3"
```

**Running it**:
```bash
./greet.sh Alice 25 "New York"
```

**Output**:
```
Hello, Alice!
You are 25 years old
Welcome to New York
```

### Example 2: Using $#

**Script**: `count_args.sh`
```bash
#!/bin/bash

echo "You provided $# arguments"
echo "Script name: $0"

if [ $# -gt 0 ]; then
    echo "First argument: $1"
fi
```

**Running it**:
```bash
./count_args.sh user book library
```

**Output**:
```
You provided 3 arguments
Script name: count_args.sh
First argument: user
```

### Example 3: Using $@

**Script**: `print_all.sh`
```bash
#!/bin/bash

echo "All arguments:"
for arg in $@; do
    echo "- $arg"
done
```

**Running it**:
```bash
./print_all.sh apple banana cherry
```

**Output**:
```
All arguments:
- apple
- banana
- cherry
```

---

## Reading User Input

The `read` command lets users type input while the script runs.

### Basic Syntax

```bash
read variable_name
```

### Simple Example

**Script**: `ask_name.sh`
```bash
#!/bin/bash

echo "What is your name?"
read name

echo "Hello, $name!"
```

**Running it**:
```bash
./ask_name.sh
```

**Interaction**:
```
What is your name?
Alice                    ← User types this
Hello, Alice!
```

### Reading Multiple Values

```bash
#!/bin/bash

echo "Enter your first and last name:"
read first_name last_name

echo "Welcome, $first_name $last_name!"
```

**Interaction**:
```
Enter your first and last name:
Alice Smith              ← User types this
Welcome, Alice Smith!
```

### With Prompt (-p flag)

The `-p` flag adds a prompt directly to the `read` command:

```bash
#!/bin/bash

read -p "Enter your username: " username
read -p "Enter your age: " age

echo "User: $username"
echo "Age: $age"
```

**Output**:
```
Enter your username: alice
Enter your age: 25
User: alice
Age: 25
```

### Combining Arguments and Input

**Script**: `user_interaction.sh`
```bash
#!/bin/bash

# Get name from command line
if [ $# -eq 0 ]; then
    read -p "Enter your name: " name
else
    name="$1"
fi

# Get age from user input
read -p "Enter your age: " age

# Display results
echo "Name: $name"
echo "Age: $age"
```

**Running it**:
```bash
# With argument
./user_interaction.sh Alice
# Then enters: 25

# Without argument
./user_interaction.sh
# Enters: Alice
# Then enters: 25
```

---

## Variable Operations

### String Concatenation

```bash
#!/bin/bash

first_name="John"
last_name="Doe"

# Concatenation in quotes
full_name="$first_name $last_name"
echo $full_name  # Output: John Doe

# Concatenation without spaces
greeting="Hello$first_name"
echo $greeting   # Output: HelloJohn
```

### Arithmetic

```bash
#!/bin/bash

# Method 1: Using $(( ))
num1=10
num2=5

sum=$(( num1 + num2 ))
echo "Sum: $sum"  # Output: Sum: 15

product=$(( num1 * num2 ))
echo "Product: $product"  # Output: Product: 50

# Method 2: Using let
let difference=num1-num2
echo "Difference: $difference"  # Output: Difference: 5
```

### String Length

```bash
#!/bin/bash

text="Hello"
length=${#text}
echo "Length: $length"  # Output: Length: 5
```

### Extracting Part of String

```bash
#!/bin/bash

text="Hello World"

# First 5 characters
echo ${text:0:5}   # Output: Hello

# From character 6 onwards
echo ${text:6}     # Output: World

# Last 5 characters
echo ${text: -5}   # Output: World
```

---

## Key Concepts

### Variable vs Value

| Concept | Example | Meaning |
|---------|---------|---------|
| **Variable** | `$name` | The container (with $) |
| **Value** | `name="Alice"` | What's stored (without $) |
| **Using** | `echo $name` | Always use $ to access |

### Quoting in Bash

| Quote Type | Example | Behavior |
|-----------|---------|----------|
| **Double Quotes** | `"$name"` | Variables expand |
| **Single Quotes** | `'$name'` | Variables DON'T expand |
| **No Quotes** | `$name` | Variables expand (careful with spaces) |

**Example**:
```bash
name="Alice"

echo "Hello $name"      # Output: Hello Alice
echo 'Hello $name'      # Output: Hello $name
echo Hello $name        # Output: Hello Alice
```

### Special Variables

| Variable | Meaning |
|----------|---------|
| `$0` | Script name |
| `$1, $2, $3...` | Arguments |
| `$#` | Number of arguments |
| `$?` | Exit status of last command (0=success) |
| `$$` | Process ID of current script |
| `$USER` | Current username |
| `$HOME` | Home directory path |
| `$PWD` | Current directory |

---

## Practice Exercises

### Exercise 2.1: Simple Variables

**Description**: Create a script that stores and displays personal information.

**Requirements**:
- Create at least 3 variables
- Use each variable at least once
- Include a comment for each variable

**Solution Template**:
```bash
#!/bin/bash

# Store your name
name="[Your Name]"

# Store your age
age=25

# Store your city
city="[Your City]"

# Display information
echo "Name: $name"
echo "Age: $age"
echo "City: $city"
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Simple Variables Exercise

# Store personal information
name="Alice"
age=25
city="New York"
occupation="Student"

# Display information
echo "=== Personal Information ==="
echo "Name: $name"
echo "Age: $age"
echo "City: $city"
echo "Occupation: $occupation"
```

</details>

---

### Exercise 2.2: Command-Line Arguments

**Description**: Create a script that greets someone using command-line arguments.

**Requirements**:
- Accept at least 2 arguments
- Display all arguments
- Show number of arguments provided
- Handle case where no arguments provided

**Solution Template**:
```bash
#!/bin/bash

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <name> <age>"
    exit 1
fi

# Store arguments
name="$1"
age="$2"

# Display
echo "Hello, $name!"
echo "You are $age years old"
echo "Total arguments provided: $#"
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Command-Line Arguments Exercise

# Check if we got arguments
if [ $# -lt 2 ]; then
    echo "ERROR: Need at least 2 arguments"
    echo "Usage: $0 <first_name> <last_name> [age]"
    exit 1
fi

# Store arguments
first_name="$1"
last_name="$2"
age="${3:-Unknown}"  # Default to "Unknown" if not provided

# Display welcome message
echo "========================================="
echo "Welcome to the User Info Script!"
echo "========================================="
echo "First Name: $first_name"
echo "Last Name: $last_name"
echo "Age: $age"
echo "Total arguments provided: $#"
echo "========================================="
```

</details>

---

### Exercise 2.3: Reading User Input

**Description**: Create an interactive script that asks user questions.

**Requirements**:
- Use `read` to get at least 2 inputs
- Use prompts (-p flag)
- Display the collected information
- Include comments

**Solution Template**:
```bash
#!/bin/bash

# Ask for username
read -p "Enter your username: " username

# Ask for email
read -p "Enter your email: " email

# Ask for age
read -p "Enter your age: " age

# Display information
echo ""
echo "=== User Information ==="
echo "Username: $username"
echo "Email: $email"
echo "Age: $age"
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Reading User Input Exercise

echo "=== Library User Registration ==="
echo ""

# Get user information
read -p "Enter your full name: " full_name
read -p "Enter your email: " email
read -p "Enter your library ID: " library_id
read -p "Enter your age: " age

# Display confirmation
echo ""
echo "=== Registration Confirmation ==="
echo "Name: $full_name"
echo "Email: $email"
echo "Library ID: $library_id"
echo "Age: $age"
echo ""
echo "Thank you for registering!"
```

</details>

---

### Exercise 2.4: Arguments + Input Combined

**Description**: Create a script that uses both command-line arguments AND user input.

**Requirements**:
- Accept at least 1 command-line argument
- Ask user for at least 2 inputs
- Combine both in output
- Handle missing arguments gracefully

**Solution Template**:
```bash
#!/bin/bash

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <library_name>"
    exit 1
fi

# Get library from argument
library="$1"

# Ask user for information
read -p "Enter username: " username
read -p "Enter book title: " book_title

# Display
echo ""
echo "User $username wants to borrow '$book_title' from $library library"
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Arguments + Input Combined Exercise

# Check if library name provided
if [ $# -lt 1 ]; then
    echo "ERROR: Library name required"
    echo "Usage: $0 <library_name>"
    exit 1
fi

# Get library from command line
library_name="$1"

echo "=== $library_name Library System ==="
echo ""

# Get user information
read -p "Enter your username: " username
read -p "Enter the book title: " book_title
read -p "Enter publication year: " year

# Display transaction
echo ""
echo "========== Transaction Details =========="
echo "Library: $library_name"
echo "User: $username"
echo "Book: $book_title ($year)"
echo "=========================================="
```

</details>

---

### Exercise 2.5: Variable Operations

**Description**: Create a script that performs calculations and string operations.

**Requirements**:
- Create at least 3 variables
- Perform arithmetic operations
- Perform string concatenation
- Display results

**Solution Template**:
```bash
#!/bin/bash

# Create number variables
num1=10
num2=5

# Perform arithmetic
sum=$(( num1 + num2 ))
product=$(( num1 * num2 ))

# Create string variables
first="Hello"
second="World"

# Concatenate strings
greeting="$first $second"

# Display results
echo "Numbers: $num1 and $num2"
echo "Sum: $sum"
echo "Product: $product"
echo "Greeting: $greeting"
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Variable Operations Exercise

# Create variables
book_count=50
copies_per_book=3
year=2026

# Perform arithmetic
total_copies=$(( book_count * copies_per_book ))
next_year=$(( year + 1 ))

# Create and combine strings
library_name="Central Library"
location="New York"
full_info="$library_name is located in $location"

# Calculate average (with floating point)
total_checkouts=150
average=$(( total_checkouts / book_count ))

# Display results
echo "=== Library Statistics ==="
echo "Library: $full_info"
echo "Year: $year"
echo "Books in catalog: $book_count"
echo "Copies per book: $copies_per_book"
echo "Total copies available: $total_copies"
echo "Average checkouts per book: $average"
echo "Next year: $next_year"
```

</details>

---

### Challenge Exercise: Library Reservation System

**Description**: Create a script for a simple library reservation system using variables and input.

**Requirements**:
- Accept library ID as argument
- Ask user for name, book title, author
- Store all information in variables
- Calculate a reservation ID (timestamp or random)
- Display a formatted reservation confirmation

**Bonus**:
- Validate that library ID is not empty
- Ask if user wants to place another reservation
- Display summary of all reservations (can use arrays from later topic)

**Starter Code**:
```bash
#!/bin/bash

# Get library ID from argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <library_id>"
    exit 1
fi

library_id="$1"

# Get user information
read -p "Enter your name: " user_name
read -p "Enter book title: " book_title
read -p "Enter author: " author

# Generate reservation ID (using date)
reservation_id=$(date +%s)

# Display confirmation
echo ""
echo "========== RESERVATION CONFIRMED =========="
echo "Reservation ID: $reservation_id"
echo "Library ID: $library_id"
echo "User: $user_name"
echo "Book: $book_title"
echo "Author: $author"
echo "=========================================="
```

---

## Common Pitfalls

### ❌ Pitfall 1: Spaces Around `=`

**Wrong**:
```bash
name = "Alice"   # Bash interprets 'name' as a command
```

**Error**:
```
command not found: name
```

**Right**:
```bash
name="Alice"     # No spaces around =
```

---

### ❌ Pitfall 2: Forgetting `$` When Using Variable

**Wrong**:
```bash
name="Alice"
echo "Hello, name"    # Prints literal "name", not "Alice"
```

**Output**:
```
Hello, name
```

**Right**:
```bash
name="Alice"
echo "Hello, $name"   # Prints "Hello, Alice"
```

**Output**:
```
Hello, Alice
```

---

### ❌ Pitfall 3: Not Quoting Arguments

**Problem**: Arguments with spaces get split

**Wrong**:
```bash
./script.sh Hello World   # Becomes $1="Hello" and $2="World"
```

**Right**:
```bash
./script.sh "Hello World" # Becomes $1="Hello World"
```

**In script**:
```bash
echo "$1"    # Use quotes to preserve spaces
```

---

### ❌ Pitfall 4: Single Quotes Don't Expand Variables

**Wrong**:
```bash
name="Alice"
echo 'Hello $name'   # Prints literal "Hello $name"
```

**Right**:
```bash
name="Alice"
echo "Hello $name"   # Prints "Hello Alice"
```

---

### ❌ Pitfall 5: $# vs Arguments

**Wrong**:
```bash
$#="John"   # Can't assign to $#
```

**Right**:
```bash
name="John"
echo $#     # Shows how many arguments were passed
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **Variables** | Named containers for values |
| **Creating** | `variable_name="value"` (no spaces around =) |
| **Using** | Always use `$variable_name` (with $) |
| **Arguments** | `$1`, `$2`, `$#`, `$@` |
| **User Input** | `read` and `read -p` commands |
| **Operations** | String concatenation and arithmetic |
| **Quoting** | Double quotes expand variables, single don't |

### You Can Now

✅ Create and use variables  
✅ Accept command-line arguments  
✅ Read user input interactively  
✅ Perform basic string and arithmetic operations  
✅ Combine static and dynamic data  

### Real Project Application

For your **Library System**, you'll use:
- `bootstrap.sh`: Store library IDs, book paths as variables
- `user.sh`: Accept username, operation as arguments; read book titles
- `manage.sh`: Accept library IDs as arguments; get user queries

### Next Steps

Once you've completed all exercises above, you're ready for:

**[Topic 3: Control Flow (if/else, loops)](03-control-flow.md)**

Where you'll learn:
- Conditional statements (if/else)
- Loops (for, while)
- Case statements
- Decision making in scripts

---

## Quick Reference

```bash
# Creating variables
name="Alice"
age=25

# Using variables
echo $name
echo "${name}"

# Command-line arguments
$0    # Script name
$1    # First argument
$#    # Number of arguments

# Reading input
read variable
read -p "Prompt: " variable

# Arithmetic
result=$(( 10 + 5 ))

# String concatenation
full="$first $last"

# Variable length
${#variable}
```

---

**Ready to move on?** Go to [Topic 3: Control Flow](#) 🚀

**Need to review Topic 1?** Go back to [Topic 1: Introduction to Bash](01-intro-basics.md)
